---
layout: post
title: "Deploing Metabase on ECS using fargate launch type"
date: 2025-08-5 01:35:10 +0100
permalink: /projects/ecs-metabase
author: Abdullah Bello
---

Deploying Metabase on Amazon ECS using fargate launch type.

## Tech Stack

- Amazon ECS
- Fargate
- Metabase


![EC2 Server Screenshot](/assets/img/adding_users_to%20_group.png)

## Project Description


1. Deploy Metabase on Amazon ECS using fargate launch type
2. Connect it to postgreSQL database hosted on amazon RDS
3. Use official docker image from docker hub
4. Configure env variables needed for db connectivity
5. Ensure both VPC and RDS are in the same VPC to allow communication.
6. The RDS security group should allow inbound traffic on port 5432 from the ECS task.

## Project Deliverables

Screenshot showing 

- SS showing RDS Postgresql instance details
- The ECS task definition and Running service
- The security group rules allowing traffic from ECS to RDS on port 5432
- The Metabase setup screen confirming successful connection to the database