"""Tests for the mlflowctl CLI surface (no network required)."""

from __future__ import annotations

from click.testing import CliRunner

from mlflow_enterprise.cli import cli
from mlflow_enterprise.client import VALID_STAGES


def test_cli_help_lists_commands() -> None:
    result = CliRunner().invoke(cli, ["--help"])
    assert result.exit_code == 0
    for command in ("config", "register", "promote"):
        assert command in result.output


def test_config_command_outputs_json() -> None:
    result = CliRunner().invoke(cli, ["config"])
    assert result.exit_code == 0
    assert '"tracking_uri"' in result.output


def test_valid_stages_are_known() -> None:
    assert "Production" in VALID_STAGES
    assert "Staging" in VALID_STAGES
