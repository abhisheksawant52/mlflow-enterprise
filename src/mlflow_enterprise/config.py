"""Application configuration.

Settings are loaded from environment variables (prefixed with ``MLFLOW_ENT_``) or
an optional ``.env`` file using :mod:`pydantic-settings`. See ``.env.example`` for
the full list of supported variables.
"""

from __future__ import annotations

from functools import lru_cache

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Runtime configuration for the MLflow enterprise client and CLI."""

    model_config = SettingsConfigDict(
        env_prefix="MLFLOW_ENT_",
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    tracking_uri: str = Field(
        default="http://localhost:5000",
        description="URI of the MLflow tracking server (default port 5000).",
    )
    registry_uri: str | None = Field(
        default=None,
        description="Model registry URI. Falls back to the tracking URI when unset.",
    )
    experiment_name: str = Field(
        default="Default",
        description="Default experiment used when none is supplied explicitly.",
    )
    artifact_location: str | None = Field(
        default=None,
        description="S3 URI for the artifact store, e.g. s3://mlflow-artifacts/.",
    )
    request_timeout_seconds: int = Field(
        default=30,
        ge=1,
        description="Timeout applied to tracking server HTTP requests.",
    )

    @property
    def effective_registry_uri(self) -> str:
        """Return the registry URI, defaulting to the tracking URI when unset."""
        return self.registry_uri or self.tracking_uri


@lru_cache(maxsize=1)
def get_settings() -> Settings:
    """Return a cached :class:`Settings` instance."""
    return Settings()
