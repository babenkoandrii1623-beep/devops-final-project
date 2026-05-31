# GitOps configuration

This folder contains declarative GitOps resources for Argo CD.

- `argocd/application.yaml` creates the Argo CD Application.
- The application deploys the Helm chart from `helm/lab-microservices`.
- Lab 7 uses `helm/lab-microservices/values-lab07.yaml`.

For the easiest local lab run, the GitHub repository should be public so Argo CD can read the chart without extra repository credentials.
