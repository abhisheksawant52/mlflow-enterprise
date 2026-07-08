"""mlflow-enterprise: client and CLI helpers for an enterprise MLflow deployment.

This package provides a thin, typed wrapper over the MLflow tracking client and a
`mlflowctl` command line interface for common lifecycle operations against a
tracking server backed by RDS Postgres and an S3 artifact store.
"""

from __future__ import annotations

__all__ = ["__version__", "get_settings", "MLflowEnterpriseClient"]

__version__ = "0.1.0"


def __getattr__(name: str):  # pragma: no cover - simple lazy re-export
    if name == "get_settings":
        from mlflow_enterprise.config import get_settings

        return get_settings
    if name == "MLflowEnterpriseClient":
        from mlflow_enterprise.client import MLflowEnterpriseClient

        return MLflowEnterpriseClient
    raise AttributeError(f"module {__name__!r} has no attribute {name!r}")
