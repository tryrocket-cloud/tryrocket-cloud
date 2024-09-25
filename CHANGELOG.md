# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - Talos K8s Cluster with ArgoCD/Flux

### Added
- Transitioned from K3s to **Talos OS** for Kubernetes cluster management, bringing enhanced security and stability.
- Set up two Optiplex 3080 nodes cluster with **Talos Linux**.

### Improved
- Reduced manual intervention and improved reliability with the introduction of **Talos** over K3s.
  
### Removed
- **K3s** as the Kubernetes management tool, fully replaced by **Talos Linux**.

---

## [v3.5.2] - Introduced Intercolo.com as Second Offsite Backup Location

### Added
- **Intercolo.com as Offsite Backup Location**:
  - Integrated **Intercolo.com** as a secondary offsite backup location for enhanced data redundancy and disaster recovery.
  - Configured Velero to sync backups to both the primary storage (IONOS Object Storage) and the new offsite location at Intercolo.com.
  - Implemented automated replication of critical backups to Intercolo.com, ensuring geographically distributed storage for greater resiliency.

- **Enhanced Backup Strategy**:
  - Developed a multi-location backup strategy by adding Intercolo.com, which complements the existing primary backup stored in IONOS Object Storage.
  - Velero is now configured to use **multiple backup targets**, providing a fail-safe option in the event of a failure or unavailability of the primary backup storage.
  
### Improved
- **Disaster Recovery**:
  - Strengthened disaster recovery capabilities by introducing a geographically distinct offsite backup in **Intercolo.com**. This ensures that backups are available even in the event of a regional failure or catastrophic event affecting the primary site.
  - Increased recovery options by diversifying storage locations, allowing for faster restores from the most accessible or available backup location.

- **Data Redundancy**:
  - Improved data redundancy by automatically replicating all important backups to Intercolo.com, ensuring there is always an offsite copy of the cluster's critical data.
  - Reduced risk of data loss by ensuring backups are stored in multiple, independent locations.

### Notes
- Intercolo.com has been integrated as a secondary offsite backup location in addition to IONOS Object Storage. This multi-location backup strategy greatly improves disaster recovery readiness and ensures compliance with data redundancy best practices.
- All backups are now replicated across both locations, providing additional layers of protection and recovery options.

---

## [v3.5.1] - Introduced Terraform for IONOS Object Storage and Backups with Kopia and Restic

### Added
- **Terraform for IONOS Object Storage**:
  - Integrated **Terraform** to automate the provisioning and management of **IONOS.com Object Storage**.
  - Created Terraform configurations to define and deploy object storage resources for storing backups, improving infrastructure as code (IaC) practices.
  - Established a scalable and cost-effective storage solution for long-term data retention by leveraging IONOS Object Storage.

- **Kopia Backup**:
  - Deployed **Kopia**, an efficient open-source backup solution, to create the first full backup of critical data.
  - Configured Kopia to store encrypted backups in IONOS Object Storage, ensuring secure and reliable backup management.
  - Set up regular scheduled backups with Kopia, ensuring automatic and consistent data protection.

- **Restic Backup**:
  - Implemented **Restic** as an additional backup solution to create encrypted and deduplicated backups.
  - Configured Restic to target IONOS Object Storage for offsite backups, ensuring redundancy and data safety.
  - Enabled automated snapshots using Restic to improve disaster recovery options and facilitate rapid data restoration when needed.

### Improved
- **Backup Automation**:
  - Automated the creation and management of object storage using **Terraform**, eliminating manual processes and improving infrastructure consistency.
  - Set up an automated, dual-backup strategy with **Kopia** and **Restic**, ensuring redundancy and multiple layers of data protection.
  
- **Data Security**:
  - Backups are encrypted at rest using both Kopia and Restic, ensuring the confidentiality and integrity of the backed-up data.
  - The use of IONOS Object Storage provides scalable and secure offsite storage for critical backups, further enhancing the overall disaster recovery strategy.

- **Infrastructure as Code (IaC)**:
  - Improved overall infrastructure management by adopting **Terraform** for object storage, ensuring reproducibility, versioning, and ease of maintenance for cloud infrastructure resources.

### Notes
- This release introduces an automated, secure, and scalable backup solution using both **Kopia** and **Restic**.
- The integration of **Terraform** for IONOS Object Storage ensures that infrastructure can be managed efficiently as code, providing a foundation for future expansions and improvements to backup strategies.

---

## [v3.5.0] - Introduced Velero as Main Backup Solution with CSI Snapshots

### Added
- **Velero Backup Solution**:
  - Deployed **Velero** as the primary backup and restore solution for the Kubernetes cluster.
  - Configured Velero to perform scheduled and on-demand backups of both Kubernetes resources and persistent volumes.
  - Integrated **CSI (Container Storage Interface) snapshots** with Velero to support backup of persistent volumes using storage snapshots, ensuring consistent and reliable data protection.

- **CSI Snapshot Integration**:
  - Enabled **CSI snapshots** for the backup of persistent volumes, allowing for efficient, storage-level backups without downtime.
  - Configured Velero to use CSI snapshots for faster and more reliable recovery of persistent data in the event of node failure, corruption, or data loss.
  - Verified compatibility with **Longhorn** for persistent storage, enabling CSI snapshots to be stored and restored from the Longhorn volumes.

- **Disaster Recovery**:
  - Enhanced the disaster recovery plan with Velero by enabling cluster-wide resource backups, including namespaces, config maps, secrets, services, and persistent volume data.
  - Automated recovery workflows for the entire cluster using Velero, ensuring minimal downtime in the case of a failure or disaster scenario.

### Improved
- **Backup Automation**:
  - Improved cluster backup automation by integrating Velero's backup schedules with Kubernetes CronJobs to create regular snapshots of the entire cluster.
  - Automated retention policies for backups, ensuring old snapshots are pruned to save storage space while keeping critical backups available for recovery.

- **Data Protection**:
  - Increased data protection reliability by using **CSI snapshots** for near-instantaneous volume backups and restores.
  - Velero now ensures both Kubernetes cluster configurations and persistent data are regularly backed up and easily recoverable.

- **Storage Efficiency**:
  - CSI snapshots significantly reduce the time and storage overhead required for backups, offering efficient, incremental snapshots without impacting running workloads.

### Notes
- **Velero** is now the primary tool for managing the backup, restoration, and disaster recovery of the Kubernetes cluster, leveraging the power of **CSI snapshots** to protect persistent volumes.
- This release provides enhanced data resilience and backup automation, enabling faster and more reliable recovery options for both cluster resources and persistent data.

---

## [v3.4.0] - Introduced Vaultwarden, Homer, Davis, and Gitea Applications

### Added
- **Vaultwarden**:
  - Deployed **Vaultwarden**, a lightweight self-hosted password manager compatible with Bitwarden clients.
  - Enabled secure storage of passwords, notes, and other sensitive information, accessible through the Vaultwarden web UI or mobile apps.
  - Configured Vaultwarden to use **HashiCorp Vault** for securely managing encryption keys and storing sensitive credentials.

- **Homer**:
  - Set up **Homer**, a customizable home dashboard for easy access to services and applications.
  - Created a user-friendly interface to provide centralized access to all self-hosted services, including Gitea, Vaultwarden, and Davis.
  - Custom dashboards provide links to important services and external resources, enhancing usability for managing your self-hosted environment.

- **Davis**:

- **Gitea**:
  - Deployed **Gitea**, a lightweight, self-hosted Git service for version control.
  - Configured Gitea for managing repositories, including code, infrastructure-as-code, and configuration files for the self-hosted services.
  - Integrated Gitea with **CI/CD pipelines** to automate deployments and updates for all critical services.
  - Used Gitea as the core repository for managing the **GitOps**-based deployment approach using **ArgoCD** and **Flux**.

### Improved
- **Centralized Access**:
  - Enhanced user experience with **Homer**, centralizing access to all applications and services in one dashboard, making it easier to manage and monitor the infrastructure.

- **Security**:
  - Improved password and credential management with **Vaultwarden**, providing a secure and private way to store sensitive information.
  - Integrated Vaultwarden with **HashiCorp Vault** for better encryption and key management.

- **Version Control**:
  - Streamlined development and deployment workflows with **Gitea**, enabling a self-hosted Git solution with integrated CI/CD.
  - Improved the efficiency of managing infrastructure configurations, application code, and deployments through version control.

### Notes
- This release focuses on enhancing the overall functionality and manageability of the environment by introducing key applications for password management, version control, monitoring, and centralized access.
- These applications contribute to improved security, usability, and system performance monitoring.

---

## [v3.3.0] - Introduced External Secrets Operator, Cert-Manager, and HashiCorp Vault

### Added
- **External Secrets Operator**:
  - Implemented **External Secrets Operator** to manage secrets in Kubernetes by integrating external secret management systems like **HashiCorp Vault**.
  - Simplified secret management by syncing secrets from HashiCorp Vault directly into Kubernetes, reducing the need for hard-coded secrets.
  - Automated the lifecycle of secrets, enabling seamless updates and rotation of secrets in production environments.

- **Cert-Manager**:
  - Integrated **Cert-Manager** to automate the management of **TLS certificates** for Kubernetes services.
  - Configured Cert-Manager to issue and renew certificates from external sources like Let's Encrypt, improving the security of communication between services.
  - Used Cert-Manager for automating certificate provisioning for ingress controllers and internal service communication, ensuring services have valid and up-to-date TLS certificates.

- **HashiCorp Vault**:
  - Introduced **HashiCorp Vault** as the centralized secret management solution.
  - Configured Vault to securely store and manage sensitive data, such as API keys, database credentials, and TLS certificates.
  - Set up Vault policies and authentication mechanisms to manage access control for secrets, integrating it with **Kubernetes** via the **External Secrets Operator** for secret injection.
  - Enabled secure access to secrets across environments, with a focus on automating secret rotation and ensuring compliance with security best practices.

### Improved
- **Security**:
  - Improved the overall security posture by externalizing sensitive data management through **HashiCorp Vault**.
  - Automated the issuance and renewal of TLS certificates with **Cert-Manager**, reducing manual overhead and minimizing risks of expired certificates.
  - Enhanced secret management workflows with **External Secrets Operator**, allowing for safer secret injection without the need for manual updates or insecure storage methods in Kubernetes.

- **Scalability**:
  - Reduced the complexity of managing secrets across multiple environments, making it easier to scale the deployment of services that rely on dynamic or sensitive configurations.

- **Automation**:
  - Leveraged **Cert-Manager** and **External Secrets Operator** to automate key processes, such as certificate management and secret injection, enhancing overall system reliability and reducing manual intervention.

### Notes
- This release focuses on security enhancements, particularly around secrets management and TLS certificate automation, laying a foundation for safer, more scalable deployments.

---

## [3.2.0] - K3s Cluster with ArgoCD
### Added
- Introduced **ArgoCD** for continuous deployment using GitOps principles, fully automating application delivery.

### Improved
- Moved from manual orchestration to **ArgoCD**, significantly reducing manual intervention for deployments and updates.

---

## [3.1.0] - K3s Cluster with ArgoCD

### Added
- Integrated **Longhorn** for distributed storage management across the K3s cluster.

---

## [3.0.0] - K3s Cluster with ArgoCD

### Added
- Set up a **K3s** cluster using **3080 and M700** nodes for running containerized workloads.
- Introduced **ArgoCD** for continuous deployment using GitOps principles, fully automating application delivery.
- Switched from **Podman** and **Quadlets** to a **K3s** cluster for better orchestration of services.
- Transitioned from simple CI/CD processes to more advanced workflows managed via **ArgoCD**.
- Integrated **Longhorn** for distributed storage management across the K3s cluster.

### Improved
- Moved from manual orchestration to **ArgoCD**, significantly reducing manual intervention for deployments and updates.
- Enhanced resource allocation and clustering with the addition of the **3080** for more intensive workloads.
- Reduced system complexity by standardizing container orchestration under **K3s**.

### Removed
- **Podman** and **Quadlets** as the primary container management tools in favor of K3s.

---

## [2.0.0] - Podman, Quadlets, Ansible, Gitea, CI/CD
### Added
- Expanded infrastructure to include **Raspberry Pi 4**, **M700**, and **3080**, introducing multi-node support.
- Replaced Docker with **Podman** as the primary container runtime for better systemd integration.
- Implemented **Quadlets** for systemd-based container management and orchestration.
- Introduced **Ansible** for configuration management and automation, simplifying the deployment process across nodes.
- Deployed a **Gitea** instance to host repositories, centralizing code and configurations.
- Set up basic **CI/CD** pipelines with Gitea to automate testing and deployment processes.

### Improved
- Automated infrastructure setup and maintenance using **Ansible**, reducing manual intervention for node configuration.
- Introduced a basic **CI/CD** workflow, laying the foundation for automated updates and deployment.

### Removed
- **Manual Docker Compose** workflows, transitioning to more structured automation with Podman, Quadlets, and Ansible.

---

## [1.0.0] - Initial Setup: Raspberry Pi 4 with Docker Compose
### Added
- Deployed infrastructure using **Raspberry Pi 4** with **Docker Compose** for service orchestration.
- Managed containerized applications manually using **Portainer**, providing a simple interface for managing services.
- Set up a **Gitea** repository for code management, storing all Docker Compose files and configurations.
  
### Improved
- Manual deployment and orchestration of services via **Portainer**.
  
### Notes
- Version 1.0 focused on simple container management and manual deployments, laying the groundwork for future automation and scaling.

[unreleased]: https://github.com/olivierlacan/keep-a-changelog/compare/v1.1.1...HEAD
[1.1.1]: https://github.com/olivierlacan/keep-a-changelog/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/olivierlacan/keep-a-changelog/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.3.0...v1.0.0
[0.3.0]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.0.8...v0.1.0
[0.0.8]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.0.7...v0.0.8
[0.0.7]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.0.6...v0.0.7
[0.0.6]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.0.5...v0.0.6
[0.0.5]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/olivierlacan/keep-a-changelog/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/olivierlacan/keep-a-changelog/releases/tag/v0.0.1