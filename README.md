# kubernetes-cicd

# 🚀 GCP GitOps & Kubernetes CI/CD Pipeline

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Google Cloud](https://img.shields.io/badge/GoogleCloud-%234285F4.svg?style=for-the-badge&logo=google-cloud&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)

Automated Infrastructure as Code (IaC) and Application Deployment on Google Cloud Platform using Terraform and GitHub Actions.

## Architecture Overview

This repository manages the complete lifecycle of a cloud environment and its workloads in GCP (`developer-sandbox-489120`). 

* **Network & Compute:** VPCs, Subnets, and a Google Kubernetes Engine (GKE) Cluster.
* **Temporary Resources:** Bastion Host / Jumpbox for internal routing tests.
* **Workloads:** Deployment of the "Bookinfo" microservices suite (`productpage`, `details`, `reviews`, `ratings`).

### Authentication Flow (Keyless Auth)

```mermaid
sequenceDiagram
    participant GitHub as GitHub Actions
    participant OIDC as GCP Identity Pool
    participant IAM as GCP IAM (Principal)
    participant TF as Terraform
    participant GKE as Google Kubernetes Engine

    GitHub->>OIDC: 1. Request Auth (OIDC Token)
    OIDC-->>GitHub: 2. Validate Token (Match repo & environment)
    GitHub->>IAM: 3. Assume Direct Principal Role (No Service Account)
    IAM-->>TF: 4. Grant Editor / Admin Permissions
    TF->>GKE: 5. Execute Plan / Apply (Infra & K8s Apps)

Security: Workload Identity Federation
To adhere to zero-trust principles and avoid long-lived Service Account JSON keys, this project relies on Workload Identity Federation.

Authentication is achieved by binding GCP IAM roles directly to the GitHub Principal.

GCP Setup Commands
If recreating this setup, the Identity Pool and OIDC provider must be configured as follows:


# 1. Create Identity Pool
gcloud iam workload-identity-pools create "github-identity-pool" \
  --project="developer-sandbox-489120" \
  --location="global" \
  --display-name="GitHub Actions Pool"

# 2. Create OIDC Provider
gcloud iam workload-identity-pools providers create-oidc "github" \
  --project="developer-sandbox-489120" \
  --location="global" \
  --workload-identity-pool="github-identity-pool" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" \
  --issuer-uri="[https://token.actions.githubusercontent.com](https://token.actions.githubusercontent.com)"

# 3. Grant IAM Roles Directly to the Principal (Production Environment)
gcloud projects add-iam-policy-binding "developer-sandbox-489120" \
  --role="roles/editor" \
  --member="principal://[iam.googleapis.com/projects/697350290405/locations/global/workloadIdentityPools/github-identity-pool/subject/repo:luisalclo/kubernetes-cicd:environment:production](https://iam.googleapis.com/projects/697350290405/locations/global/workloadIdentityPools/github-identity-pool/subject/repo:luisalclo/kubernetes-cicd:environment:production)"

Markdown
# GCP GitOps & Kubernetes CI/CD Pipeline

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Google Cloud](https://img.shields.io/badge/GoogleCloud-%234285F4.svg?style=for-the-badge&logo=google-cloud&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)

Automated Infrastructure as Code (IaC) and Application Deployment on Google Cloud Platform using Terraform and GitHub Actions.

## Architecture Overview

This repository manages the complete lifecycle of a cloud environment and its workloads in GCP (`developer-sandbox-489120`). 

* **Network & Compute:** VPCs, Subnets, and a Google Kubernetes Engine (GKE) Cluster.
* **Temporary Resources:** Bastion Host / Jumpbox for internal routing tests.
* **Workloads:** Deployment of the "Bookinfo" microservices suite (`productpage`, `details`, `reviews`, `ratings`).

### Authentication Flow (Keyless Auth)

```mermaid
sequenceDiagram
    participant GitHub as GitHub Actions
    participant OIDC as GCP Identity Pool
    participant IAM as GCP IAM (Principal)
    participant TF as Terraform
    participant GKE as Google Kubernetes Engine

    GitHub->>OIDC: 1. Request Auth (OIDC Token)
    OIDC-->>GitHub: 2. Validate Token (Match repo & environment)
    GitHub->>IAM: 3. Assume Direct Principal Role (No Service Account)
    IAM-->>TF: 4. Grant Editor / Admin Permissions
    TF->>GKE: 5. Execute Plan / Apply (Infra & K8s Apps)


Security: Workload Identity Federation
To adhere to zero-trust principles and avoid long-lived Service Account JSON keys, this project relies on Workload Identity Federation.

Authentication is achieved by binding GCP IAM roles directly to the GitHub Principal.

GCP Setup Commands
If recreating this setup, the Identity Pool and OIDC provider must be configured as follows:


# 1. Create Identity Pool
gcloud iam workload-identity-pools create "github-identity-pool" \
  --project="developer-sandbox-489120" \
  --location="global" \
  --display-name="GitHub Actions Pool"

# 2. Create OIDC Provider
gcloud iam workload-identity-pools providers create-oidc "github" \
  --project="developer-sandbox-489120" \
  --location="global" \
  --workload-identity-pool="github-identity-pool" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" \
  --issuer-uri="[https://token.actions.githubusercontent.com](https://token.actions.githubusercontent.com)"

# 3. Grant IAM Roles Directly to the Principal (Production Environment)
gcloud projects add-iam-policy-binding "developer-sandbox-489120" \
  --role="roles/editor" \
  --member="principal://[iam.googleapis.com/projects/697350290405/locations/global/workloadIdentityPools/github-identity-pool/subject/repo:luisalclo/kubernetes-cicd:environment:production](https://iam.googleapis.com/projects/697350290405/locations/global/workloadIdentityPools/github-identity-pool/subject/repo:luisalclo/kubernetes-cicd:environment:production)"

Repository Structure
The Terraform codebase is decoupled into two lifecycles using GCS remote backends:

Plaintext
.
├── .github/workflows/
│   ├── deploy-infra.yml      # Manages VPC, Subnets, GKE, Jumpbox
│   └── deploy-k8s-apps.yml   # Manages Kubernetes Deployments & Services
├── environments/gcp-env-demo/
│   ├── infrastructure/       # Base IaC
│   └── k8s-apps/             # K8s Manifests via TF Provider
└── modules/                  # Reusable Terraform Modules

CI/CD Pipelines
Pipelines trigger on push to main (filtered by paths) or manually via workflow_dispatch.

Critical Implementation Detail:
Because the GCP IAM binding is strictly hardcoded to the production identity, the GitHub Actions jobs must declare environment: 'production'. Additionally, no service_account parameter is used in the google-github-actions/auth@v2 step.

<details>
<summary><b>Click to view the base Workflow YAML</b></summary>

YAML
jobs:
  terraform-deploy:
    runs-on: 'ubuntu-latest'
    environment: 'production' # CRITICAL: Must match GCP IAM Principal

    permissions:
      contents: 'read'
      id-token: 'write'

    steps:
      - uses: 'actions/checkout@v4' 

      - id: 'auth'
        name: 'Authenticate to Google Cloud'
        uses: 'google-github-actions/auth@v2'
        with:
          workload_identity_provider: 'projects/697350290405/locations/global/workloadIdentityPools/github-identity-pool/providers/github'
          project_id: 'developer-sandbox-489120'
          # NOTE: No service_account parameter required (Direct Principal Auth)
</details>

Incident Report & Troubleshooting
Issue: 403 Forbidden and 404 Not Found errors during Terraform initialization via GitHub Actions.
Root Cause:

Identity Mismatch: The workflow attempted to authenticate using environment: 'demo', but GCP's strict IAM policy only whitelisted the environment:production token.

Impersonation Failure: The workflow attempted to impersonate a standard Service Account, but roles were bound directly to the Identity Pool's Principal.
Resolution: Aligned the GitHub Workflow environment to production and removed the Service Account impersonation step, achieving seamless keyless authentication and successfully executing infrastructure modifications (e.g., automated Jumpbox teardown).
