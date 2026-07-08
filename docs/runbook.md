# Operations Runbook

Operational procedures for the enterprise MLflow deployment.

## Components

| Component        | Where                              | Managed by            |
| ---------------- | ---------------------------------- | --------------------- |
| Tracking server  | EKS namespace `mlflow`             | Helm chart `helm/mlflow` |
| Backend store    | RDS Postgres (`db.*` instance)     | Terraform `modules/backend-db` |
| Artifact store   | S3 bucket                          | Terraform `modules/artifact-store` |

## Provisioning infrastructure

```bash
cd terraform
terraform init -backend-config=environments/dev/backend.hcl
terraform plan  -var-file=environments/dev/terraform.tfvars
terraform apply -var-file=environments/dev/terraform.tfvars
```

Capture the outputs `db_endpoint`, `artifact_uri`, and `mlflow_namespace`; they
feed the Helm values below.

## Deploying the tracking server

1. Create the backend-store password secret (never templated in plaintext):

   ```bash
   kubectl -n mlflow create secret generic mlflow-backend-store \
     --from-literal=password="$DB_PASSWORD"
   ```

2. Install/upgrade the chart:

   ```bash
   helm upgrade --install mlflow helm/mlflow -n mlflow \
     --set backendStore.host=$DB_ENDPOINT \
     --set artifactStore.defaultArtifactRoot=$ARTIFACT_URI
   ```

## Health checks

- Liveness/readiness probes hit `GET /health` on port 5000.
- `mlflowctl config` prints the effective client configuration.
- `kubectl -n mlflow get pods,hpa,ingress` shows deployment state.

## Common incidents

| Symptom                        | Likely cause                         | Action |
| ------------------------------ | ------------------------------------ | ------ |
| Pods `CrashLoopBackOff`        | Bad backend store URI / secret       | Verify `mlflow-backend-store` secret and RDS security group ingress. |
| Artifacts fail to upload       | Missing S3 IAM permissions           | Confirm IRSA role has the `artifact-store` access policy attached. |
| UI unreachable                 | Ingress / TLS misconfiguration       | Check ingress host and `mlflow-tls` secret. |
| DB connections exhausted       | Under-provisioned instance           | Scale `db_instance_class`; enable `db_multi_az` in prod. |

## Backups & DR

- RDS automated backups retain 7 days (`backup_retention_period`); deletion
  protection is enabled.
- The artifact S3 bucket is versioned with KMS encryption and a 90-day
  non-current version expiration lifecycle rule.
