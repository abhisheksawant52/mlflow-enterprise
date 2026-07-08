"""Tests for configuration and package metadata (no network required)."""

from __future__ import annotations

import mlflow_enterprise
from mlflow_enterprise.config import Settings, get_settings


def test_version_is_exposed() -> None:
    assert isinstance(mlflow_enterprise.__version__, str)
    assert mlflow_enterprise.__version__.count(".") == 2


def test_default_tracking_uri_and_port() -> None:
    settings = Settings()
    assert settings.tracking_uri.endswith(":5000")


def test_registry_uri_falls_back_to_tracking_uri() -> None:
    settings = Settings(tracking_uri="http://mlflow.internal:5000", registry_uri=None)
    assert settings.effective_registry_uri == "http://mlflow.internal:5000"


def test_env_prefix_override(monkeypatch) -> None:
    monkeypatch.setenv("MLFLOW_ENT_EXPERIMENT_NAME", "fraud-detection")
    get_settings.cache_clear()
    try:
        assert get_settings().experiment_name == "fraud-detection"
    finally:
        get_settings.cache_clear()
