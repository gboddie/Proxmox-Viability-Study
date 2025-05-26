# Proxmox-Viability-Study

This project explores the potential of Proxmox Virtual Environment as a robust platform for deploying and managing virtual machines (VMs) in scalable and automated workflows. The study involved integrating Proxmox with modern infrastructure automation tools to streamline VM provisioning and configuration.

## Key Achievements
Proxmox Configuration with Terraform

Deployed and managed Ubuntu, Red Hat, Windows 11, and Windows Server VMs.

Automated provisioning with dynamic IPs via DHCP and pre-installed databases (MySQL and MSSQL) tailored to class-specific requirements.

Packer for Golden Images

Transitioned from manual post-deployment setup to a Packer-based workflow.

Created consistent "golden images" with pre-configured software, enabling efficient and repeatable VM cloning.

Ansible Integration for Post-Provisioning

Configured Windows VMs using Ansible over WinRM for post-creation setup.

Automated database updates and other critical configurations seamlessly.

Enhanced Automation Workflows

Combined Terraform, Packer, and Ansible for an end-to-end infrastructure automation pipeline.

## Insights and Outcomes
Scalability and Efficiency: Showcased Proxmox’s capabilities in managing multiple VM types with varying configurations.

Automation-Driven Workflows: Highlighted the synergy between Proxmox and automation tools for reducing setup time and errors.

Flexibility: Enabled tailored environments for specific use cases, including education and development.

## Repository Structure

/terraform: Terraform configurations for VM provisioning.

/packer: Packer templates for creating golden images.

/ansible: Ansible playbooks for post-provisioning setup.

/Heimdall: Steps to setup a heimdall dashboard.
