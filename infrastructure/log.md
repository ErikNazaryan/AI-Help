eriknazaryan@Eriks-MacBook-Pro infrastructure % terraform apply
aws_vpc.genesis_vpc: Refreshing state... [id=vpc-0539212df901c5a52]
aws_internet_gateway.igw: Refreshing state... [id=igw-01021234aa677c5b1]
aws_subnet.public_subnet: Refreshing state... [id=subnet-0a2585f79b46ad276]
aws_subnet.private_subnet_2: Refreshing state... [id=subnet-01873af4fcd5eda92]
aws_route_table.private_rt: Refreshing state... [id=rtb-01b240f4e08a7278b]
aws_subnet.private_subnet: Refreshing state... [id=subnet-0443f9c97f393a2d0]
aws_security_group.app_sg: Refreshing state... [id=sg-0ed02bf9e660af35e]
aws_route_table.public_rt: Refreshing state... [id=rtb-04fe0a8b691a36500]
aws_security_group.db_sg: Refreshing state... [id=sg-0bcbe2c2a77d6156c]
aws_route_table_association.private_assoc_2: Refreshing state... [id=rtbassoc-06dfe40ede8529570]
aws_route_table_association.private_assoc_1: Refreshing state... [id=rtbassoc-0a21b1bf348d22812]
aws_db_subnet_group.genesis_db_subnet_group: Refreshing state... [id=genesis-db-subnet-group]
aws_route_table_association.public_assoc: Refreshing state... [id=rtbassoc-0126a9eb8e9e21dad]
aws_db_instance.genesis_db: Refreshing state... [id=db-5V4KVRNNFJVGZXVE267BAYATHQ]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with
the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.app_server will be created
  + resource "aws_instance" "app_server" {
      + ami                                  = "ami-0fe8bec493a81c7da"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + enable_primary_ipv6                  = (known after apply)
      + force_destroy                        = false
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t3.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_group_id                   = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + region                               = "eu-north-1"
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = "subnet-0a2585f79b46ad276"
      + tags                                 = {
          + "Name" = "Genesis-App-Server"
        }
      + tags_all                             = {
          + "Name" = "Genesis-App-Server"
        }
      + tenancy                              = (known after apply)
      + user_data                            = (sensitive value)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = [
          + "sg-0ed02bf9e660af35e",
        ]

      + capacity_reservation_specification (known after apply)

      + cpu_options (known after apply)

      + ebs_block_device (known after apply)

      + enclave_options (known after apply)

      + ephemeral_block_device (known after apply)

      + instance_market_options (known after apply)

      + maintenance_options (known after apply)

      + metadata_options (known after apply)

      + network_interface (known after apply)

      + primary_network_interface (known after apply)

      + private_dns_name_options (known after apply)

      + root_block_device (known after apply)

      + secondary_network_interface (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_instance.app_server: Creating...
aws_instance.app_server: Still creating... [00m10s elapsed]
aws_instance.app_server: Creation complete after 14s [id=i-0628e5bd6e06bb2fd]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
eriknazaryan@Eriks-MacBook-Pro infrastructure % 