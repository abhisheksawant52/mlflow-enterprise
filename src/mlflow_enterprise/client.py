"""Thin, typed wrapper over the MLflow tracking client.

The :class:`MLflowEnterpriseClient` centralises connection configuration and
exposes the handful of high-level operations the platform team cares about:
logging an experiment run, registering a model, and promoting a registered model
to a lifecycle stage.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import TYPE_CHECKING, Any

from mlflow_enterprise.config import Settings, get_settings

if TYPE_CHECKING:  # pragma: no cover - import only for type checking
    from mlflow.entities import Run
    from mlflow.entities.model_registry import ModelVersion


# Valid lifecycle stages recognised by the MLflow model registry.
VALID_STAGES: tuple[str, ...] = ("None", "Staging", "Production", "Archived")


@dataclass(slots=True)
class RunResult:
    """Lightweight summary of a logged run."""

    run_id: str
    experiment_id: str
    artifact_uri: str


class MLflowEnterpriseClient:
    """High-level client for the enterprise MLflow deployment.

    Parameters
    ----------
    settings:
        Optional pre-built :class:`~mlflow_enterprise.config.Settings`. When
        omitted the process-wide cached settings are used.
    """

    def __init__(self, settings: Settings | None = None) -> None:
        self._settings = settings or get_settings()
        # Imported lazily so that the package can be imported without the (heavy)
        # mlflow dependency being installed, e.g. in constrained CI lint jobs.
        import mlflow
        from mlflow.tracking import MlflowClient

        mlflow.set_tracking_uri(self._settings.tracking_uri)
        mlflow.set_registry_uri(self._settings.effective_registry_uri)
        self._mlflow = mlflow
        self._client = MlflowClient(
            tracking_uri=self._settings.tracking_uri,
            registry_uri=self._settings.effective_registry_uri,
        )

    @property
    def settings(self) -> Settings:
        """Return the settings backing this client."""
        return self._settings

    def log_experiment(
        self,
        params: dict[str, Any],
        metrics: dict[str, float],
        experiment_name: str | None = None,
        tags: dict[str, str] | None = None,
    ) -> RunResult:
        """Log a single run of parameters and metrics to an experiment.

        Parameters
        ----------
        params:
            Hyper-parameters to record for the run.
        metrics:
            Scalar metrics to record for the run.
        experiment_name:
            Target experiment. Defaults to the configured experiment name.
        tags:
            Optional key/value tags attached to the run.

        Returns
        -------
        RunResult
            Identifiers and artifact URI of the created run.
        """
        name = experiment_name or self._settings.experiment_name
        self._mlflow.set_experiment(name)
        with self._mlflow.start_run(tags=tags) as run:
            if params:
                self._mlflow.log_params(params)
            if metrics:
                self._mlflow.log_metrics(metrics)
            info = run.info
            return RunResult(
                run_id=info.run_id,
                experiment_id=info.experiment_id,
                artifact_uri=info.artifact_uri,
            )

    def register_model(
        self,
        model_uri: str,
        name: str,
        await_registration_for: int = 300,
    ) -> "ModelVersion":
        """Register a model artifact into the model registry.

        Parameters
        ----------
        model_uri:
            Source URI, e.g. ``runs:/<run_id>/model`` or an ``s3://`` path.
        name:
            Registered model name. Created automatically if it does not exist.
        await_registration_for:
            Seconds to wait for the model version to become ``READY``.

        Returns
        -------
        mlflow.entities.model_registry.ModelVersion
            The newly created model version.
        """
        return self._mlflow.register_model(
            model_uri=model_uri,
            name=name,
            await_registration_for=await_registration_for,
        )

    def promote_model(
        self,
        name: str,
        version: int | str,
        stage: str,
        archive_existing: bool = True,
    ) -> "ModelVersion":
        """Transition a registered model version to a lifecycle stage.

        Parameters
        ----------
        name:
            Registered model name.
        version:
            Model version to transition.
        stage:
            Target stage; one of :data:`VALID_STAGES`.
        archive_existing:
            When ``True`` archive any versions currently in the target stage.

        Returns
        -------
        mlflow.entities.model_registry.ModelVersion
            The updated model version.

        Raises
        ------
        ValueError
            If ``stage`` is not a recognised MLflow stage.
        """
        if stage not in VALID_STAGES:
            raise ValueError(
                f"invalid stage {stage!r}; expected one of {', '.join(VALID_STAGES)}"
            )
        return self._client.transition_model_version_stage(
            name=name,
            version=str(version),
            stage=stage,
            archive_existing_versions=archive_existing,
        )

    def get_run(self, run_id: str) -> "Run":
        """Fetch a run by id."""
        return self._client.get_run(run_id)
