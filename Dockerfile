# syntax=docker/dockerfile:1

# ---- Builder stage -------------------------------------------------------
FROM python:3.12-slim AS builder

WORKDIR /build

ENV PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

COPY pyproject.toml requirements.txt README.md ./
COPY src ./src

RUN python -m pip install --upgrade pip build \
    && python -m build --wheel --outdir /dist

# ---- Runtime stage -------------------------------------------------------
FROM python:3.12-slim AS runtime

LABEL org.opencontainers.image.title="mlflowctl" \
      org.opencontainers.image.description="Enterprise MLflow control CLI helper" \
      org.opencontainers.image.source="https://github.com/abhisheksawant52/mlflow-enterprise"

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# Create an unprivileged user to run the CLI.
RUN groupadd --system mlflow && useradd --system --gid mlflow --home /home/mlflow --create-home mlflow

COPY --from=builder /dist/*.whl /tmp/
RUN python -m pip install --upgrade pip \
    && python -m pip install /tmp/*.whl \
    && rm -f /tmp/*.whl

USER mlflow
WORKDIR /home/mlflow

# Lightweight liveness check: the CLI must be importable and runnable.
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD ["mlflowctl", "config"]

ENTRYPOINT ["mlflowctl"]
CMD ["--help"]
