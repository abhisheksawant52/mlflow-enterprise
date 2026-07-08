"""``mlflowctl`` command line interface.

A small Click application that wraps :class:`~mlflow_enterprise.client.MLflowEnterpriseClient`
for operators who want to inspect configuration, register models and promote them
between lifecycle stages without writing Python.
"""

from __future__ import annotations

import json

import click

from mlflow_enterprise import __version__
from mlflow_enterprise.client import VALID_STAGES
from mlflow_enterprise.config import get_settings


@click.group(help="Enterprise MLflow control CLI.")
@click.version_option(__version__, prog_name="mlflowctl")
def cli() -> None:
    """Top-level command group."""


@cli.command("config")
def show_config() -> None:
    """Print the effective (non-secret) configuration as JSON."""
    settings = get_settings()
    payload = {
        "tracking_uri": settings.tracking_uri,
        "registry_uri": settings.effective_registry_uri,
        "experiment_name": settings.experiment_name,
        "artifact_location": settings.artifact_location,
        "request_timeout_seconds": settings.request_timeout_seconds,
    }
    click.echo(json.dumps(payload, indent=2))


@cli.command("register")
@click.option("--model-uri", required=True, help="Source model URI (runs:/... or s3://...).")
@click.option("--name", required=True, help="Registered model name.")
def register(model_uri: str, name: str) -> None:
    """Register a model artifact into the registry."""
    from mlflow_enterprise.client import MLflowEnterpriseClient

    client = MLflowEnterpriseClient()
    version = client.register_model(model_uri=model_uri, name=name)
    click.echo(f"Registered {name} version {version.version}")


@cli.command("promote")
@click.option("--name", required=True, help="Registered model name.")
@click.option("--version", required=True, help="Model version to promote.")
@click.option(
    "--stage",
    required=True,
    type=click.Choice(VALID_STAGES),
    help="Target lifecycle stage.",
)
def promote(name: str, version: str, stage: str) -> None:
    """Promote a registered model version to a lifecycle stage."""
    from mlflow_enterprise.client import MLflowEnterpriseClient

    client = MLflowEnterpriseClient()
    updated = client.promote_model(name=name, version=version, stage=stage)
    click.echo(f"{name} v{updated.version} -> {updated.current_stage}")


def main() -> None:
    """Console-script entry point."""
    cli()


if __name__ == "__main__":  # pragma: no cover
    main()
