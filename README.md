# 🚀 GCP Cloud Infrastructure & DevSecOps GKE Pipeline

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Google Cloud](https://img.shields.io/badge/GoogleCloud-%234285F4.svg?style=for-the-badge&logo=google-cloud&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Security](https://img.shields.io/badge/security-GCP_Container_Analysis-blue?style=for-the-badge)

A comprehensive automated solution for **GCP Infrastructure provisioning** and **Cloud-Native GKE Workload delivery**. This project serves as a **production-ready blueprint** for organizations looking to modernize multi-service workloads using a secure, end-to-end DevSecOps pipeline on Google Cloud Platform.

---

## 🏗️ Architecture Design & Philosophy

This project implements a **Modern Cloud-Native Architecture** based on the principle of **Separation of Concerns**. We decouple the lifecycle of foundational cloud resources from the agile delivery of microservices.

### 1. The Foundational Layer (Infrastructure as Code)
Managed via **Terraform**, this layer handles the "slow-moving" parts of the environment.
*   **VPC Networking:** A custom-built network with optimized subnets. We transitioned from a multi-subnet design to a lean, single-subnet architecture dedicated to GKE nodes to reduce management overhead.
*   **GKE Standard Cluster:** A production-grade Kubernetes cluster (`gke-demo-standard`) with private nodes and master authorized networks.
*   **Artifact Registry:** A single, centralized private Docker repository (`bookinfo-repo`) that stores all microservice images, facilitating central security audits and access control.
*   **Zero-Trust Auth:** We use **Workload Identity Federation (WIF)**. GitHub Actions authenticates to GCP using OIDC tokens, eliminating the need for permanent, vulnerable Service Account JSON keys.

### 2. The Agile Layer (Native Kubernetes Delivery)
We moved away from managing Kubernetes resources inside Terraform. Instead, we use **Native YAML manifests orchestrated by Kustomize**.
*   **Developer-First Experience:** Developers use standard Kubernetes syntax.
*   **Kustomize Orchestration:** Kustomize acts as a template engine that "renders" the final YAMLs. It handles dynamic image tag injection (GitHub SHA) so that Kubernetes always runs the exact version of the code that was just built.
*   **Granular Deployments:** Each microservice (`productpage`, `details`, `reviews`, `ratings`) has its own independent deployment lifecycle.

---

## 🔐 The DevSecOps Lifecycle (Step-by-Step)

Our system follows a strict security-first workflow for every commit made to the repository.

1.  **Code Commit:** A developer pushes code to a microservice folder (e.g., `src/bookinfo/productpage/`).
2.  **Path-Based Triggering:** GitHub Actions detects the change and triggers **only** the relevant pipeline (`deploy-productpage.yml`).
3.  **Infrastructure Discovery:** The pipeline initializes Terraform in **read-only mode** to fetch live outputs (Cluster Name, Registry URL). This ensures the app always deploys to the correct infrastructure without hardcoded values.
4.  **Native Build:** The Docker image is built from the official Istio source code.
5.  **Push to Registry:** The image is pushed to the private GCP Artifact Registry.
6.  **GCP Container Analysis (The Gatekeeper):**
    *   The pipeline triggers an **On-Demand Scan** via Google Cloud SDK.
    *   It queries the scan results for `CRITICAL` vulnerabilities.
    *   If any are found, the pipeline **breaks immediately (Exit 1)**, preventing the deployment of insecure code.
7.  **Dynamic Mutation:** Kustomize replaces the `latest` image placeholder with the unique `GitHub SHA` tag.
8.  **Atomic Deployment:**
    *   The pipeline first ensures the `bookinfo` **Namespace** exists (`00-namespace.yaml`).
    *   Then, it applies the rendered YAMLs using a label filter (`kubectl apply -l app=... -f -`). This prevents parallel pipelines from overwriting each other's resources.

---

## 📁 Repository Map & File Relationships

Understanding how the files connect is key to operating the system.

### 🏢 Infrastructure Components (`environments/gcp-env-demo/infrastructure/`)
*   `deploy-infra.tf`: The master orchestrator. It calls the VPC, GKE, and Artifact Registry modules. It also enables the **Container Analysis APIs** and sets up IAM permissions for GitHub.
*   `gen-infra-outputs.tf`: **The Bridge.** It exports the `artifact_registry_url` and `gke_cluster_name`. These values are consumed by the GitHub Actions pipelines.
*   `infra.auto.tfvars`: The configuration file. Change the cluster name or node counts here.

### 🚢 Application Manifests (`environments/gcp-env-demo/k8s-manifests/`)
*   `kustomization.yaml`: The entry point. It lists all resources and defines the `images` placeholders.
*   `00-namespace.yaml`: Defines the isolated environment `bookinfo`.
*   `01-productpage.yaml` to `04-ratings.yaml`: Native Kubernetes Deployments and Services. Each one is labeled (e.g., `app: productpage`) to allow the pipeline to target them specifically.

### ⚙️ CI/CD Workflows (`.github/workflows/`)
*   `shared-k8s-app-pipeline.yml`: **The Master Template.** Contains 100% of the build/scan/deploy logic. It is a Reusable Workflow used by all services.
*   `deploy-<service>.yml`: Lightweight "Caller" files. They only contain the triggers (Path Filtering) and call the Master Template with the specific service name.
*   `nuke-destroy-envs.yaml`: The emergency shutdown button. It performs a structured destruction of all resources and cleans up Terraform state files in GCS.

---

## 🛠️ GCP Integration Requirements

To deploy this architecture from scratch, ensure your GCP project has the following configured:

### 1. Workload Identity Federation
The GCP Identity Pool must be bound to your GitHub repository. The principal format used by our pipelines is:
`principal://iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/github-identity-pool/subject/repo:YOUR_USER/kubernetes-cicd:environment:production`

### 2. Enabled Services (Handled by Terraform)
The `deploy-infra.tf` file will attempt to enable:
*   `containeranalysis.googleapis.com`
*   `ondemandscanning.googleapis.com`
*   `artifactregistry.googleapis.com`

---

## ⚠️ Important: State Management & Drift

*   **Infrastructure Drift:** Terraform detects if someone changes the VPC or GKE settings in the GCP Console. We implemented a `lifecycle` rule to ignore `resource_manager_tags`, preventing annoying "ghost" warnings.
*   **Application Drift:** Kubernetes manifests do not have a state lock. If you manually change a service via `kubectl edit`, the change will persist **until the next pipeline run**. During the next deployment, GitHub Actions will use `kubectl apply` to overwrite any manual changes and restore the state defined in Git. **Git is the Single Source of Truth.**

---

## 🚀 Getting Started

### Phase 1: Import Source Code
Run the utility script to fetch the official Bookinfo source code into your repository:
```bash
./scripts/fetch_bookinfo.sh
```

### Phase 2: Deploy Infrastructure
1. Go to GitHub Actions -> **Deploy Infra (Terraform)**.
2. Click **Run workflow** and check the **Run Terraform Apply?** box.

### Phase 3: Deploy Applications
Simply push any change to the `src/bookinfo/` directory. GitHub will automatically build, scan, and deploy the affected microservices.

---
*Developed as a modernized Cloud-Native reference for GCP, GKE, and DevSecOps.*
