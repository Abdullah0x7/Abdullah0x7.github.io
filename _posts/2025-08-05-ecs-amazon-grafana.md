---
title:  Deploying Grafana on Amazon ECS using Fargate
description: A walkthrough of how I deployed a Grafana using Amazon ECS with fargate.
author: Abdullah
date: 2025-08-05 01:35:10 +0100
categories: [Tutorial]
tags: [networking, tutorial, ECS, fargate]
pin: false
math: true
mermaid: true
---

> *I was tasked with deploying Grafana on the cloud using Amazon ECS and Fargate. It was my first time doing this, so I learned a lot. If you’re also starting out, this post is for you.*

## What is Grafana?

**Grafana is an open-source platform that helps you visualize data from different sources like AWS CloudWatch, Prometheus, MySQL, and more.**

It's mostly used for monitoring, and it runs on **port 3000** by default.


## Tech Stack

* **AWS ECS (Elastic Container Service)** to manage the container
* **Fargate** so I didn’t need to manage servers manually
* **Docker Hub** as the image source
* **Security Groups** to allow external access


## Project Description

1. Deploy **Grafana** using **Amazon ECS with Fargate**
2. Use the **official Docker image**: `grafana/grafana`
3. Create a task definition that exposes port **3000** and run it on a public subnet
4. Ensure security group allows inbound traffic on port 3000
5. Once the service/task is running, open a http://<PUBLIC-IP>:3000 in your browser


## Step-by-Step: How I Did It

Here’s exactly how I went from zero to Grafana running in the cloud.

### Step 1: Create the ECS Cluster

1. Open the AWS Console and search for **ECS**
2. Click on **Clusters** → **Create Cluster**
3. Under Cluster configuration:
   * Gave it a name: `csn-cluster-demo`
4. Under Infrastructure:
   * Selected **AWS Fargate (Serverless)**
5. Left the other options as-is, then clicked **Create**

> *![ECS cluster overview](/assets/img/cluster-demo-overview.png)*

---

### Step 2: Create a Task Definition

This is where I told AWS how to run the Grafana container.

1. In ECS, go to **Task Definitions** → **Create new Task Definition**

2. Choose:

   * **Launch type**: `Fargate`
   * **OS/ Architecture**: `Linux/x86_64`
   * **Task definition name**: `csn-td-demo`
   * **CPU**: 1 vCPU
   * **Memory**: 3gb
> *![Task Definition Infrastructure Requirements](/assets/img/td-infrastructure-requirements.png)*

3. Add a container:

   * **Container name**: `grafana`
   * **Image URI**: `grafana/grafana:latest`
   * **Port mapping**: `3000`
> *![Task Definition Container](/assets/img/td-container.png)*
   * **Left the other options as-is** 

4. Click **Create**

> *![Insert screenshot: Container settings + success message](/assets/img/td-creation-success-overview.png)*

---

### Step 3: Create a Service to Run the Task

This part was a bit confusing at first, but here’s what I did:

1. Go to the **csn-cluster-demo** cluster created in step 1
2. Click **Create** under the **Services** tab
3. Choose:

   * **Launch type**: Fargate
   * **Task Definition**: `csn-td-demo`
   * **Task Definition Revision**: `1`
4. Under **Environments**:
    * Selected `launch type`
5. Under **Deployment Config**
    * Leave default settings
6. Under **Networking**:

   * Selected my default VPC
   * Chose a **public subnet**
   * Enabled **Auto-assign public IP**
   * Created a **new security group** that allowed:
    >  *![Networking config security group rule](/assets/img/cs-networking1.png)*
   
   * Inbound traffic on **TCP port 3000** from `0.0.0.0/0`

    > *![Networking config inbound rules](/assets/img/cs-networking2.png)*

7. Left the rest as default and clicked **Create**

    > *![Service deployed](/assets/img/cs-deployed-succesfull.png)*

---

### Step 4: Access Grafana in the Browser

After a few minutes, the service status changed to `RUNNING`.

Here’s how I accessed Grafana:

1. In the **Tasks** tab of my service, I clicked the task
2. Scrolled down to find the **Public IP**
3. Opened my browser and visited:
http://<PUBLIC-IP>:3000
> *![Ip address page](/assets/img/CSN-Week-5.png)*

And boom, the **Grafana login page appeared**!

---

### Default Login

| Field    | Value   |
| -------- | ------- |
| Username | `admin` |
| Password | `admin` |

You’ll be asked to change it after the first login.

> *![Grafana Dashboard](/assets/img/CSN-WEEK-5-grafana-login.png)*

* Dashboard

> *![Grafana login](/assets/img/CSN-WEEK-5-Grafana-login-page.png)*

---

## What I Learned

* **ECS + Fargate** let you deploy containers *without* managing servers
* **Security groups** are crucial, if I had forgotten to open port 3000, Grafana wouldn’t load
* **Docker Hub images** can be pulled directly, no need to build your own container if one already exists
* Cloud deployment is less scary once you walk through it step by step

---

## Final Thoughts

This was a confidence booster. I got to:

* Use AWS services I hadn’t touched before
* Work with containers in the cloud
* Deploy a real app (Grafana) from scratch

If you're just starting out too, I hope this post helps you get unstuck.

And if something doesn’t make sense, that’s okay, it didn’t for me either until I tried it myself.