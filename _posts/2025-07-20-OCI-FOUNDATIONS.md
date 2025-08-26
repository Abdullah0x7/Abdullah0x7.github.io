---
title:  My Journey into Oracle Cloud Infrastructure
description: A Personal Foundations Journal
date:   2025-07-20 01:35:10 +0100
categories: [Cloud-Computing]
author: Abdullah
tags: [Cloud-Computing, OCI]
pin: false
math: true
mermaid: true
---

A few weeks ago, I set out on a mission, not just to earn a certification, but to truly understand the Oracle Cloud. I wanted working knowledge: what to click, what matters, what breaks, and why security, identity, networking, and cost governance all have to line up if you want a real cloud environment that survives contact with production.

Fast forward to today, and I’m officially certified in **OCI Foundations 2025 (1Z0-1085-25).** But this blog post isn’t just about celebrating a milestone. It blends what I studied, what I asked, what instructors emphasized, and what finally made concepts “click.” I’ve written it to be readable months from now when I need a refresher, and clear enough for any technically curious reader who is comfortable with basic IT concepts but new to OCI.

---

# 1. OCI Fundamentals: Architecture, Tenancies, and Compartments

### 1.1 The Big Picture

Oracle Cloud Infrastructure is built around a **global footprint of Regions**, each containing one or more **Availability Domains (ADs)**. ADs are isolated data centers engineered to reduce blast radius. Inside regions you build **Virtual Cloud Networks**, deploy compute, store data, and consume platform services.

Beneath every OCI environment is a **tenancy**, your master cloud account and administrative boundary. Everything you create lives *somewhere inside* this tenancy, and policy inheritance starts here.

### 1.2 Compartments: Operational Boundaries You Control

A **compartment** is a logical container for OCI resources: compute instances, VCNs, buckets, block volumes, databases, and more. Oracle gives you a **root compartment** when the tenancy is created, but best practice is to create additional compartments aligned to:
- Environments (Dev, Test, Prod)
- Business units or cost centers
- Regulatory or geographic boundaries
- Resource type ownership (Network, Security, Platform)

**Key behaviors:**
- Every resource resides in exactly one compartment at a time (though you can move many resource types after creation).
- Compartments are **global constructs**, they appear in all regions you enable, but the *resources inside them* are typically **regional** (for example, a compute instance exists in one region).
- Policies reference compartments to scope permissions and governance.
- You can nest compartments up to six levels deep to mirror org structure.
- Budgets and **compartment quotas** help prevent over‑consumption.

> *Field Note:* Early on I asked whether compartments were “global resources.” The answer that helped me: *The folder is global; the files inside are wherever you created them.*

---

# 2. Identity and Access Management (IAM)

If compartments are *where* things live, IAM is *who* can touch them and *what* they are allowed to do.

### 2.1 AuthN vs. AuthZ

**Authentication (AuthN)** answers: Who are you? Username/password, API signing keys (RSA key pairs), auth tokens for services that don’t support native signing. Multi‑factor authentication (MFA) is a strongly recommended best practice for privileged accounts.

**Authorization (AuthZ)** answers: What are you allowed to do? In OCI, authorization is policy‑driven.

### 2.2 Policy Language 

Policy statements follow this general structure:

```
Allow <subject> to <verb> <resource-type> in <location> [where <conditions>]
```

**Subject** can be a *group* (collection of users) or a *dynamic group* (collection of resources matched by rule). You almost never write policies directly to an individual user.

**Verb (Action)** determines access scope:
- `inspect`  → metadata only
- `read`     → inspect + read data
- `use`      → read + work with resource, limited changes
- `manage`   → full administrative control

**Resource Type** may be granular (`instance`), broader (`instance-family`), or universal (`all-resources`).

**Location** scopes the policy: `in compartment Dev`, `in tenancy`, etc.

**Conditions** add fine‑grain rules: by request operation, by tag, by time, and more.

> *Field Note:* I once asked whether the **action verb** was really a formal component of an OCI policy or just documentation shorthand. It absolutely matters, it defines the permission depth. Choosing `use` instead of `manage` can prevent a late‑night outage.

### 2.3 Dynamic Groups: Permissions for Machines

Sometimes it’s not a human who needs access, it’s a compute instance, function, or resource. **Dynamic Groups** let you define membership rules (by OCID, by tag pattern, by compartment) and then grant those non‑human principals controlled access. This is how an instance can read from Object Storage or write logs without embedding keys in code.

---

# 3. Networking

Networking in OCI feels familiar if you’ve worked with virtual networks elsewhere, but a few distinctions matter for security and design clarity.

### 3.1 Virtual Cloud Network (VCN)

A **VCN** is your private, software‑defined network inside OCI. You choose the CIDR, create **subnets** (regional or AD‑specific), and attach gateways.

### 3.2 Route Tables

Each subnet is associated with a **route table**. A route rule says: “For traffic destined to this CIDR, send it to this target.” Targets include the Internet Gateway (public egress), NAT Gateway (private outbound access), Service Gateway (private access to Oracle services), or a Dynamic Routing Gateway (DRG) to reach on‑premises networks.

> *Field Note:* I asked "What is the primary purpose of route tables?" the short answer that stuck was: **They tell packets the next hop when leaving a subnet.**

### 3.3 Security Lists and NSGs

Security boundaries exist at two layers:

**Security Lists**
- Attached to subnets
- Apply to all VNICs in that subnet
- **Stateful**: if inbound is allowed, return outbound is implicitly allowed, and vice versa
- Good for broad, environment‑level rules

**Network Security Groups (NSGs)**
- Attached directly to VNICs / specific resources
- Also **stateful**
- Provide fine‑grained, application‑tier, or workload‑specific control
- Cleaner than creating extra subnets just to segment traffic

> *Field Note:* I originally wondered if NSGs controlled traffic between subnets. They do not. NSGs scope traffic to the instances you explicitly place in the group.

### 3.4 Load Balancing Options

OCI offers multiple balancing modes depending on your protocol and performance needs:
- **Layer 7 Load Balancer** for HTTP/HTTPS with SSL termination, host/path routing.
- **Network Load Balancer (Layer 4)** for ultra‑low latency TCP/UDP traffic passthrough, no TLS inspection.

Balancing methods include round robin, weighted distribution, least connections, and IP hash for session affinity.

---

# 4. Compute Services: Flexible Capacity, Multiple Execution Models

### 4.1 Compute Instances and Shapes

When you launch a VM, you choose a **shape** that defines CPU architecture, OCPUs, memory, and network bandwidth. OCI’s **flexible shapes** let you set custom OCPU and memory amounts within supported ranges, great for cost optimization when you don’t need the full fixed shape.

> *Memory Jog:* I asked if shape and size were customizable during creation of a flexible shape instance. The answer is simply Yes.

### 4.2 Scaling Approaches

Scaling comes in two flavors:
- **Vertical (Scale Up)**: Resize to a larger shape (more CPU, more memory). Like upgrading a laptop.
- **Horizontal (Scale Out)**: Add more instances to share load. Like adding more workers to a queue.

OCI **Instance Pools** plus **Auto Scaling** policies let you define when to add or remove instances based on metrics (CPU utilization, custom metrics, or schedule‑based triggers).

### 4.3 Containers and Functions

If virtual machines are too heavy and you prefer orchestration, OCI provides:
- **Oracle Kubernetes Engine (OKE):** a managed Kubernetes control plane. You manage worker nodes (or use managed node pools), deploy pods, handle services.
- **Oracle Functions:** serverless Functions as a Service built on the open‑source Fn Project. Event‑driven, auto‑scaling, ideal for lightweight API glue, automation, and background tasks.

---

# 5. Storage: Matching Data to Use Case

OCI gives you multiple storage classes. Choosing the right one saves cost and improves performance.

### 5.1 Block Volume

Attach a **Block Volume** to a compute instance and treat it like a disk. Use it for boot volumes, databases, application data, or log partitions.

Characteristics:
- Persistent and durable
- Encrypted at rest by default (Oracle‑managed keys; optionally customer‑managed via Vault)
- Resize online
- Back up and clone quickly
- Select performance tiers (Balanced, Higher, Ultra) depending on IOPS and throughput needs

> *Clarification I Needed:* “Shared file system designed for high performance” does **not** describe Block Volume. That belongs to File Storage.

### 5.2 File Storage Service (FSS)

A managed, elastic, **shared file system** accessed over **NFS v3 or v4.1**. Mount the same file system across many compute instances for shared content, user directories, web tiers, or lift‑and‑shift enterprise apps that expect POSIX or NFS semantics.

### 5.3 Object Storage

Highly durable object store for unstructured data: backups, logs, media, archives, data lakes.

Tiers include:
- **Standard Storage(Hot Tier)** for hot data
- **Infrequent Access Storage(Cool Tier)** for data accessed occasionally but requiring immediate retrieval.
- **Archive Storage(Cold Tier)** for long‑term cold storage (restore required before access)

### 5.4 Storage and Compute Association

Only **Block Volumes** (and local NVMe on certain shapes) are *directly attached* to compute instances. **Object Storage** is accessed over the network via APIs/CLI/SDK, it’s not an attachable disk.

---

# 6. Database Services: From Autonomous to Custom

OCI is deeply database‑centric. You can run databases every way from fully managed and self‑tuning to manually administered engine builds.

### 6.1 Autonomous Database

Self‑driving, self‑patching, self‑securing Oracle Database in the cloud. Available in workload‑optimized deployment types (transaction processing, data warehouse, JSON). Elastic scaling, automatic indexing, built‑in high availability.

### 6.2 MySQL Database Service (with HeatWave Option)

Managed MySQL with patching, backups, and optional in‑memory analytics acceleration.

### 6.3 Dedicated Region

If latency, compliance, or data gravity prevent full public cloud adoption, Oracle will bring managed infrastructure closer to you:
- **OCI Dedicated Region**: A full Oracle Cloud region deployed inside your facility, ideal for strict regulatory or data‑sovereignty requirements.

> *Certification Flashcard:* When I asked which OCI offering lets you run cloud services in your own data center while meeting compliance mandates, the answer that matters for exams and architecture reviews is **OCI Dedicated Region**.

---

# 7. Security: Responsibility, Controls, Detection, Protection

Security is layered across platform, identity, network, data, and workload posture. Understanding who does what is foundational.

### 7.1 Shared Responsibility Model

**Oracle** secures the *cloud infrastructure*: data center facilities, physical hardware, underlying virtualization, and core regional networking.

**You** secure what you deploy *in* the cloud: customer data, application code, guest operating systems, IAM policies, network access rules, key and secret management, and regulatory controls.

> *Exam Reminder:* Questions that ask “Who secures customer data, applications, and access control?” always point to **the customer**.

### 7.2 OCI Vault

Centralized **encryption key and secret management**:
- Create software‑ or HSM‑protected keys (Master Encryption Keys, or MEKs)
- Store credentials as **Secrets** (passwords, API tokens, SSH keys)
- Integrate with OCI services for envelope encryption or customer‑managed keys

> *Recall:* Vault components include the **Vault** container, **MEKs**, and **Secrets**. **Database Backups** are not a Vault component; they live with database services (though keys can protect them).

### 7.3 Cloud Guard and WAF: Different Jobs

**Cloud Guard** continuously evaluates your tenancy for risky configurations, suspicious behavior, and policy drift. It raises **Problems**, detects via **Detectors**, and can take action through **Responders**. You specify **Targets** (tenancy or compartments) to scope monitoring.

**OCI Web Application Firewall (WAF)** protects at the application edge, inspecting HTTP/S traffic and blocking threats like SQL injection, cross‑site scripting, and other OWASP Top 10 patterns.

> *Don’t Mix Them Up:* Cloud Guard will not block SQLi or XSS. That’s WAF territory.

### 7.4 Notifications and Alerts

Security and operations rely on timely alerts. OCI **Monitoring** + **Alarms** + **Notifications** form the alert pipeline:
- Define an **Alarm** on a metric or state (for example, CPU > 80%, bucket public flag changed).
- Publish to a **Notifications Topic**.
- Subscribe endpoints: **Email** and **SMS** are natively supported; HTTPS endpoints can integrate with incident systems. “Push” or “pager” are not built‑in delivery types.

---

# 8. Cost Management and Governance

Good architecture is pointless if it bankrupts you. OCI provides controls to plan, cap, and analyze spend.

### 8.1 Service Limits

Every tenancy begins with default **Service Limits** per region and resource type (for example, max number of compute cores). These are enforced by Oracle at the platform layer. You can request increases.

### 8.2 Compartment Quotas

While service limits cap the *total* you can consume, **Compartment Quotas** let you subdivide that capacity across teams. For example: allow up to 3 VM.Standard.E4.Flex instances in the Dev compartment, 10 in Prod. Quotas are defined in human‑readable statements similar to IAM policies.

> *Clarification That Helped Me:* Quotas are configured in the tenancy but **applied per compartment**. They do not automatically enforce a global shared pool unless you design them that way.

### 8.3 Budgets and Spending Alerts

Associate a **budget** with a compartment, set a threshold, and receive notifications when you approach or exceed it. Combine with tagging to attribute cost to projects or environments.

### 8.4 Egress Awareness

Data **egress** (outbound transfer), to the public internet, other regions, or on‑prem networks can drive cost. Inbound transfer is typically free. Remember: *egress = outbound* when reading billing charts.

---

# 9. Quick Reference Callouts

**Stateful Rules**
Both Security Lists and NSGs in OCI are stateful; return traffic is auto‑allowed. You don’t need symmetric rules unless you want to restrict initiation directionally.

**Object vs. Block Association**
Block Volumes attach to instances. Object Storage is accessed over APIs; it is not an attachable disk.

**Scaling Memory Hook**
Flexible shapes let you set CPU and memory independently within limits — a cost saver for dev/test.

**Cloud Guard ≠ WAF**
Posture vs. edge protection. Use both.

**Compartments Travel; Resources Don’t**
The compartment hierarchy is visible tenancy‑wide across regions; the resources you place in them remain where you launched them.

---

## Closing

Cloud isn’t magic, it’s disciplined use of shared infrastructure. OCI gives you that infrastructure with performance headroom, integrated database strengths, and serious governance tools. The sooner you internalize tenancies, compartments, IAM verbs, network boundaries, and the cost knobs, the sooner you can build confidently.

If you’re on your own OCI journey, I hope this journal saves you time, prevents a few mistakes, and helps you move from theory to practice faster than I did.

**See you in the cloud.**