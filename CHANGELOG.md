# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-07-08

### Added
- Terraform root module provisioning the MLflow backing infrastructure on AWS:
  S3 artifact store (`modules/artifact-store`), RDS Postgres backend store
  (`modules/backend-db`), and an EKS namespace hook.
- `dev` and `prod` environment tfvars and S3 backend configurations.
- Helm chart (`helm/mlflow`) deploying the MLflow tracking server on port 5000
  with deployment, service, ingress, HPA, service account, and config map.
- Python `mlflow_enterprise` package with pydantic-settings configuration and a
  typed client wrapper (log experiment, register model, promote model stage).
- `mlflowctl` Click CLI and a multi-stage Dockerfile for the helper image.
- Open-source hygiene: LICENSE, CONTRIBUTING, SECURITY, CODE_OF_CONDUCT,
  issue/PR templates, CODEOWNERS, dependabot, pre-commit hooks, and CI.

[0.1.0]: https://github.com/abhisheksawant52/mlflow-enterprise/releases/tag/v0.1.0
