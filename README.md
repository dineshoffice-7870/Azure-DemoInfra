#Azure Infrastructure (D365 Landing Zone)

This repository contains the Infrastructure as Code (IaC) written in **Azure Bicep** and automated via **GitHub Actions** to deploy the multi-subscription landing zone for the ** modern application stack.

---

## 🏗️ Architecture Overview

The network infrastructure implements a secure dual-zone (DMZ & Internal) Hub-and-Spoke topology in alignment with the Australian Government Information Security Manual (ISM) guidelines:

* **External VNet (DMZ):** Houses ingress services including Application Gateway WAF v2, Public Message Queues, and Public API Workloads.
* **Internal VNet:** Houses core application workloads (APIM, Function Apps, App Services, Private Endpoints, and Management VMs).
* **Hub Routing:** All egress traffic is forced via Route Tables (UDRs) through the central Azure Firewall (`10.100.1.68`) located in the core connectivity subscription.
* **Micro-segmentation:** Network Security Groups (NSGs) are assigned to individual subnets to restrict East-West traffic.

---

## 📁 Repository Structure

```text
.
├── .github/
│   └── workflows/
│       ├── deploy-dev-infra.yml        # Continuous Deployment for Dev / Non-Prod
│       └── deploy-prod-infra.yml       # Manual Deployment Pipeline for Production
└── infra/
    ├── main.bicep                      # Subscription Orchestrator Bicep Template
    ├── main.dev.bicepparam             # Non-Prod Parameter Values (CIDRs, Tags, RGs)
    ├── main.prod.bicepparam            # Prod Parameter Values (CIDRs, Tags, RGs)
    └── modules/
        ├── resource-group.bicep        # Module: Subscription-scoped Resource Groups
        ├── nsg-rt.bicep                # Module: NSGs & Custom Route Tables (UDRs)
        └── network.bicep               # Module: VNets & Subnet Binding
