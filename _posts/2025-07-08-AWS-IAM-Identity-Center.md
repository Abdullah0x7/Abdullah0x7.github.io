---
title:  AWS IAM Identity Center
description: Secure Access Management with Groups, Users, and Read-Only Permissions
date:   2025-07-08 01:35:10 +0100
categories: [Cloud Computing]
author: Abdullah
tags: [Cloud-Computing, AWS, IAM]
pin: false
math: true
mermaid: true
---

> Learn how to securely manage AWS access using IAM Identity Center with a real-world example: setting up group-based read-only permissions for users.

---

## What Is IAM?

IAM (Identity and Access Management) helps you securely control access to AWS services and resources. IAM Identity Center (formerly AWS SSO) extends this by managing permissions across multiple AWS accounts using groups, users, and permission sets.

For this tutorial, we're using a customized IAM Identity Center instance called **Tutorial-Demo** with a branded portal URL:
`https://tutorial-demo.awsapps.com/start`

This makes access clean and easy to remember.

To understand IAM more easily, let’s use an **airport security analogy**:

* **Users** are like passengers.
* **Groups** are like types of travelers (economy, business, staff).
* **Policies** are the boarding passes and access badges.
* **Roles** are like temporary gate passes for specific zones (like maintenance access).
* The **IAM Identity Center** acts like the main control center deciding who enters which zone and with what kind of access.

---

## Core IAM Building Blocks

* **Users** – individual identities that represent humans or applications.
* **Groups** – collections of users that share the same permissions.
* **Roles** – AWS identities with specific permissions that can be assumed temporarily.
* **Policies** – Documents that define allowed or denied actions.

---

## Users & Groups

We want to:

* Create two groups: `Alpha-Team` and `Beta-Team`
* Create a user: `Ayomide`, and add him to both groups

### Step 1: Create Groups

* Go to **IAM Identity Center > Users & Groups > Groups**
* Click **Create group**
* Create `Alpha-Team` and `Beta-Team`
/
> ![Group Creation](/assets/img/Alpha-Team.png)

### Step 2: Create User "Ayomide"
* Go to **Users > Add user**
* Fill in user details (e.g., username: `Ayomide`)
* Add Ayomide to both `Alpha-Team` and `Beta-Team`

> ![user creation with group selection](/assets/img/adding_users_to%20_group.png)

---

## Roles

In IAM Identity Center, permission sets are used in place of traditional IAM roles to define what users can do once they assume access into AWS accounts. You create permission sets to serve the same function.

Think of roles like a **temporary gate pass at an airport**, it gives access only while you need it and only to specific parts of the terminal.

---

## Policies

Policies are like **boarding passes or ID badges**. They specify what a person is allowed to do, just like a badge might say, "Can enter Lounge A" or "Can access Gate 5 only."

Here’s an example:

### Step 3: Create a Read-Only Permission Set

* Go to **Permission Sets > Create permission set**
* Choose **Predefined permission set** and set **ReadOnlyAccess**:

> ![ReadOnlyAccess Policy](/assets/img/readonly.png)

This policy allows the user to view but not create, delete, or modify any AWS resources perfect for read-only roles.

---

## IAM Best Practices

* ✅ Assign permissions to **groups**, not individual users
* ✅ Use **least privilege** principles (start with read-only access)
* ✅ Brand your IAM Identity Center instance and portal URL for easier access
* ✅ Test access by logging in as the user from another browser or incognito window

---

## Hands-On: Creating a User, Role, and Policy

### Step 4: Assign Permission Set to Group

* Go to **AWS Accounts > Assign users or groups**
* Choose your account > Select **Groups > Alpha-Team**
* Attach the `ReadOnlyAccess` permission set

> ![permission set attached to Alpha-Team](/assets/img/permission_to_group_alpha.png)

### Step 5: Test Access with Ayomide

* Open a new browser (incognito)
* Go to `https://tutorial-demo.awsapps.com/start`
* Log in as `Ayomide`, complete password setup
* Search for **S3** and try creating a bucket

> You should see an error like:
> ❌ *"To create a bucket, the s3\:CreateBucket permission is required."*

> ![S3 error message](/assets/img/bucket_failed.png)

This confirms that the read-only permissions are applied correctly.

---

## Conclusion

With IAM Identity Center, you’ve set up scalable, secure access by:

* Using **groups** to control access
* Applying **read-only permissions** with predefined sets
* Confirming access behavior with live user testing

**_One important takeaway:_** **A user's permissions are only as strong as the groups that have actual permission sets attached.** In our example:

* Ayomide belongs to both `Alpha-Team` and `Beta-Team`
* Only `Alpha-Team` has the `ReadOnlyAccess` permission set
* Since `Beta-Team` has no permission set assigned, **it doesn't add any additional access or override anything**

This means:

> 🚫 No permission set = no AWS access from that group
> ✅ The effective permissions Ayomide has come solely from `Alpha-Team`

This reinforces the best practice of assigning permissions at the **group level** and helps ensure that access is **intentional, scoped, and traceable**.


