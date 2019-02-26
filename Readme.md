Create High availability Amazon VPC with multiple VPC subnets in different AWS availability zones.

Amazon Resources Creating Using Terraform :
- Creating AWS VPC with 10.0.0.0/16 CIDR.
- Creating Multiple AWS VPC Subnets.
- Creating AWS VPC Internet Gate Way and attach it to AWS VPC.
- Creating public and private AWS VPC Route Tables.
- Creating AWS VPC NAT Gateway.
- Associating AWS VPC Subnets with VPC route tables.

Notes :
1. Edit file ./input/variable.tfvars, replace text with your AWS key
```
  aws_access_key = "XXXXXXXXXXXXXX"
  aws_secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXX"
```

2. terraform init

3. terraform plan -var-file ./input/variable.tfvars

4. terraform apply -var-file ./input/variable.tfvars

5. Finish


Run the following command to destroy the Terraform-managed infrastructure :
```
terraform destroy -var-file ./input/variable.tfvars
```
