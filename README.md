# terraform-ansible-aws-magento-poc

## Scenario
A startup is considering launching an e-commerce store using AWS.

The company's CTO would like to validate whether the new store is a viable product for the market.

Since the product is a proof of concept, it is required to fully deployed in two hours, so the Development team can finish the store still on the same day. The POC will be presented on the next day's meeting.

Due to the short deadline, automation is the best alternative for this project.
<br><br>

## Tools of choice
- Terraform for deploying the infrastructure
- Ansible for managing server and deploying the application
<br><br>

## E-commerce Stack
Magento | PHP | MySQL | Redis
<br><br>

## Cloud Architecture
<figure>
  <img src="./AWS-TF-Ansible-Magento.png" alt="Cloud Architecture">
  <figcaption>Cloud Architecture for the POC</figcaption>
</figure>

## Points of Observation
Secure CI/CD will be implemented after Vault is implemented

### Security
- All sensitive data is encrypted using `ansible-vault`
  - The code can be safely updated to a repository

### Production
- If POC is approved, e-commerce will be then dockerized into multiple containers, autoscalable, load balanced and multi-AZ.

### PDF
- <a href="https://www.linkedin.com/posts/ashtorres_prova-de-conceito-de-e-commerce-na-aws-usando-activity-6813980305540571137-fKZw" target="_blank">Here.</a>

### TODO
- Change from EIP to ELB
- Full SSL/TLS cert creation and validation.
- Implementation of Vault for centralized keys management








