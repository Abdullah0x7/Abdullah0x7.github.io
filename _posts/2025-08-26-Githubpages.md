---
title: How I Deployed a Custom Domain for My GitHub Pages with AWS Route 53 & CloudFront Functions for seamless redirects.
description: A step-by-step guide on integrating GitHub Pages with a custom domain using AWS Route 53 and CloudFront Functions for seamless redirects.
author: Abdullah
date: 2025-08-26 00:10:00 +0100
categories: [Tutorial]
tags: [AWS, Route53, CloudFront, GitHub Pages, DNS]
pin: false
math: false
mermaid: false
---

Recently, I decided to give my GitHub Pages site a proper home with a custom domain: **`abdullahbello.name.ng`**, using **AWS Route 53 and CloudFront Functions** for a **clean redirect from `www` to the root domain**. Here’s everything I did, step by step.

---

## Why This Setup?

Using a custom domain makes your site look professional, but there are a few challenges:
- Proper **DNS configuration** for GitHub Pages.
- Handling **ACM SSL/TLS certificates** for HTTPS.
- Clean redirect from **`www` to root domain** without breaking anything.

GitHub provides basic guidance, but I wanted more control and flexibility using AWS services.

---

### Step 1: Buy the Domain & Delegate DNS to Route 53

I purchased **`abdullahbello.name.ng`** from **GO54** (my domain registrar).
However, I didn’t use their DNS management features. Instead, I delegated DNS to **AWS Route 53** for full control.

Here’s how I did it:

* In **Route 53**, I created a **Public Hosted Zone** for `abdullahbello.name.ng`.
* AWS provided **4 NS (Name Server) records**.
* Then, I logged in to GO54 and **replaced their default nameservers** with these **AWS nameservers**.

This way, all future DNS configurations are managed entirely in **Route 53**.


---

## Step 2: Add DNS Records for GitHub Pages
GitHub Pages requires:
- **A records** for the root domain (`abdullahbello.name.ng`)
- **CNAME record** for `www`

Here’s what I added in **Route 53**:

| Name                       | Type   | Value                                      |
|---------------------------|--------|-------------------------------------------|
| abdullahbello.name.ng    | A      | `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153` |
| www.abdullahbello.name.ng | CNAME  | `abdullah0x7.github.io`                  |

The value for `abdullah0x7.github.io` will be later edited to that of cloudfront distribution after setting it up as you can see in the image below.
*![Route 53 Hosted Zone page with NS records and SOA record.](/assets/img/hostedzone.png)*

---

## Step 3: Set Up SSL with AWS Certificate Manager (ACM)
To make the site **HTTPS-enabled**, I requested a **public certificate** in ACM for:
- `abdullahbello.name.ng`
- `www.abdullahbello.name.ng`

After ACM issued the certificate (DNS validation via Route 53 is easy), it was ready to use.

*![Screenshot idea: ACM certificate showing “Issued” status](/assets/img/sslcert.png)*

---

## Step 4: Handle `www` Redirect to Root Domain
Here’s the tricky part:  
GitHub **does not handle `www` → root redirect automatically** when using a custom domain. So I used **CloudFront + a CloudFront Function** to handle this.

### How I Did It:
1. **Create a CloudFront Distribution**:
   - Origin: `abdullahbello.name.ng` (GitHub Pages)
   - Attach the **ACM certificate**
   - Enable **Redirect HTTP → HTTPS**

2. **Add a CloudFront Function for Redirect**:
   - Go to **CloudFront > Functions** → Create a function
   - Paste this code:

```javascript

function handler(event) {
    var request = event.request;
    var host = request.headers.host.value;

    if (host === 'www.abdullahbello.name.ng') {
        return {
            statusCode: 301,
            statusDescription: 'Moved Permanently',
            headers: {
                location: { value: 'https://abdullahbello.name.ng' + request.uri }
            }
        };
    }

    return request;
}
```

* Attach it to **Viewer Request** on your distribution.

**How This Works**

* `event.request` → Captures the incoming request.
* `request.headers.host.value` → Reads the **host header** (domain being requested).
* **Condition check**: If the host is `www.abdullahbello.name.ng`:

  * Return a **301 redirect** response.
  * `location` → Tells the browser to go to `https://abdullahbello.name.ng` while preserving the path (`request.uri`).
* If the request is for the root domain, we **let it pass through unchanged**.

---

This is extremely lightweight and runs at the **edge**, meaning:

* **No servers needed**.
* **Instant execution**.
* **Virtually zero cost** (free for first 1M requests per month).


---

## Step 5: Test Everything

* `abdullahbello.name.ng` → Loads GitHub Pages site
* `www.abdullahbello.name.ng` → Redirects to root domain
* HTTPS works on both

At this point, everything was working smoothly!

---

## Key Takeaways

* **Route 53** gives full DNS control.
* **CloudFront Functions** make clean redirects simple without spinning up Lambda.
* **ACM** + **CloudFront** = free managed SSL.
* You don’t need to deploy extra servers for this.