.DEFAULT_GOAL := help
.PHONY: help install lint format test build clean tf-fmt tf-validate helm-lint docker-build

TERRAFORM_DIR ?= terraform
CHART_DIR ?= helm/mlflow
IMAGE ?= mlflowctl:local

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-14s\033[0m %s\n", $$1, $$2}'

install: ## Install the Python package with dev dependencies
	python -m pip install --upgrade pip
	pip install -e ".[dev]"

lint: ## Run ruff and black in check mode
	ruff check src tests
	black --check src tests

format: ## Auto-format the codebase
	ruff check --fix src tests
	black src tests

test: ## Run the test suite
	pytest

build: ## Build Python distribution artifacts
	python -m pip install --upgrade build
	python -m build

tf-fmt: ## Check Terraform formatting
	terraform -chdir=$(TERRAFORM_DIR) fmt -check -recursive

tf-validate: ## Validate Terraform (no backend)
	terraform -chdir=$(TERRAFORM_DIR) init -backend=false
	terraform -chdir=$(TERRAFORM_DIR) validate

helm-lint: ## Lint the Helm chart
	helm lint $(CHART_DIR)

docker-build: ## Build the CLI helper image
	docker build -t $(IMAGE) .

clean: ## Remove build and cache artifacts
	rm -rf build dist *.egg-info src/*.egg-info .pytest_cache .ruff_cache
	find . -type d -name __pycache__ -prune -exec rm -rf {} +
