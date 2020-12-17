# Terraform OCI Flex Load Balancer 

## Project description

In this repository I have documented my hands-on experience with Terrafrom for the purpose of OCI Flex Load Balancer deployment (new OCI feature released and documented [_here_](https://docs.cloud.oracle.com/en-us/iaas/releasenotes/changes/d6a1811f-349a-45a5-b457-ace95a46a87d/) and now supported by OCI Terraform Provider v4.7.0). This set of HCL based Terraform files can customized according to any requirements.  

## Topology Diagram 

With the usage of this example HCL code you can build topology documented by diagram below. 

![](terraform-oci-flex-lb.jpg)

## How to use code 

### STEP 1.

Clone the repo from GitHub.com service by executing the command as follows and then go to terraform-oci-flex-lb directory:

```
[opc@terraform-server ~]$ git clone https://github.com/mlinxfeld/terraform-oci-flex-lb.git
Cloning into 'terraform-oci-flex-lb'...
remote: Enumerating objects: 45, done.
remote: Counting objects: 100% (45/45), done.
remote: Compressing objects: 100% (31/31), done.
remote: Total 45 (delta 19), reused 40 (delta 14), pack-reused 0
Unpacking objects: 100% (45/45), done.

[opc@terraform-server ~]$ cd terraform-oci-flex-lb/

[opc@terraform-server terraform-oci-flex-lb]$ ls -latr
total 1044
drwxr-xr-x  11 opc  opc      352 17 gru 09:49 .git
-rw-r--r--   1 opc  opc  1173714 17 gru 09:50 terraform-oci-flex-lb.jpg
-rwxr-xr-x   1 opc  opc     1384 17 gru 09:50 bastionserver.tf
-rw-r--r--   1 opc  opc      185 17 gru 09:50 compartment.tf
-rw-r--r--   1 opc  opc      442 17 gru 09:50 dhcp_options.tf
-rw-r--r--   1 opc  opc     1315 17 gru 09:50 httpd_on_webserver1.tf
-rw-r--r--   1 opc  opc     1321 17 gru 09:50 httpd_on_webserver2.tf
-rw-r--r--   1 opc  opc      250 17 gru 09:50 internet_gateway.tf
-rw-r--r--   1 opc  opc      235 17 gru 09:50 natgateway.tf
-rw-r--r--   1 opc  opc      238 17 gru 09:50 provider.tf
-rw-r--r--   1 opc  opc      431 17 gru 09:50 route1.tf
-rw-r--r--   1 opc  opc      422 17 gru 09:50 route2.tf
-rw-r--r--   1 opc  opc      516 17 gru 09:50 security_group.tf
-rw-r--r--   1 opc  opc     1555 17 gru 09:50 security_group_rule.tf
-rw-r--r--   1 opc  opc      559 17 gru 09:50 subnet1.tf
-rw-r--r--   1 opc  opc      503 17 gru 09:50 subnet2.tf
-rw-r--r--   1 opc  opc      513 17 gru 09:50 subnet3.tf
-rw-r--r--   1 opc  opc      635 17 gru 09:50 variables.tf
-rw-r--r--   1 opc  opc      513 17 gru 09:50 vcn.tf
-rwxr-xr-x   1 opc  opc     1355 17 gru 09:50 webserver1.tf
-rwxr-xr-x   1 opc  opc     1355 17 gru 09:50 webserver2.tf
-rw-r--r--   1 opc  opc     2377 17 gru 09:57 loadbalancer1.tf
-rw-r--r--@  1 opc  opc     6999 17 gru 09:58 README.md
drwxr-xr-x  25 opc  opc      800 17 gru 09:58 .

```

### STEP 2.

Within web browser go to URL: https://www.terraform.io/downloads.html. Find your platform and download the latest version of your terraform runtime. Add directory of terraform binary into PATH and check terraform version:

```
[opc@terraform-server terraform-oci-flex-lb]$ export PATH=$PATH:/home/opc/terraform

[opc@terraform-server terraform-oci-flex-lb]$ terraform --version

Terraform v0.12.16

Your version of Terraform is out of date! The latest version
is 0.12.17. You can update by downloading from https://www.terraform.io/downloads.html
```

### STEP 3. 
Next create environment file with TF_VARs:

```
[opc@terraform-server terraform-oci-flex-lb]$ vi setup_oci_tf_vars.sh
export TF_VAR_user_ocid="ocid1.user.oc1..aaaaaaaaob4qbf2(...)uunizjie4his4vgh3jx5jxa"
export TF_VAR_tenancy_ocid="ocid1.tenancy.oc1..aaaaaaaas(...)krj2s3gdbz7d2heqzzxn7pe64ksbia"
export TF_VAR_compartment_ocid="ocid1.tenancy.oc1..aaaaaaaasbktyckn(...)ldkrj2s3gdbz7d2heqzzxn7pe64ksbia"
export TF_VAR_fingerprint="00:f9:d1:41:bb:57(...)82:47:e6:00"
export TF_VAR_private_key_path="/tmp/oci_api_key.pem"
export TF_VAR_region="eu-frankfurt-1"
export TF_VAR_private_key_oci="/tmp/id_rsa"
export TF_VAR_public_key_oci="/tmp/id_rsa.pub"

[opc@terraform-server terraform-oci-flex-lb]$ source setup_oci_tf_vars.sh
```

### STEP 4.
Run *terraform init* with upgrade option just to download the lastest neccesary providers:

```
[opc@terraform-server terraform-oci-flex-lb]$ terraform init -upgrade

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/oci versions matching ">= 4.7.0"...
- Finding latest version of hashicorp/null...
- Installing hashicorp/oci v4.7.0...
- Installed hashicorp/oci v4.7.0 (signed by HashiCorp)
- Installing hashicorp/null v3.0.0...
- Installed hashicorp/null v3.0.0 (signed by HashiCorp)

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, we recommend adding version constraints in a required_providers block
in your configuration, with the constraint strings suggested below.

* hashicorp/null: version = "~> 3.0.0"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### STEP 5.
Run *terraform apply* to provision the content of this code (type **yes** to confirm the the apply phase):

```
[opc@terraform-server terraform-oci-flex-lb]$ terraform apply 

data.oci_core_images.OSImageLocal: Refreshing state...
data.oci_identity_availability_domains.ADs: Refreshing state...

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # data.oci_core_vnic.FoggyKitchenBastionServer_VNIC1 will be read during apply
  # (config refers to values not yet known)
 <= data "oci_core_vnic" "FoggyKitchenBastionServer_VNIC1"  {
      + availability_domain    = (known after apply)
      + compartment_id         = (known after apply)

(...)

  # oci_load_balancer_listener.FoggyKitchenFlexPublicLoadBalancerListener will be created
  + resource "oci_load_balancer_listener" "FoggyKitchenFlexPublicLoadBalancerListener" {
      + default_backend_set_name = "FoggyKitchenFlexPublicLBBackendset"
      + hostname_names           = (known after apply)
      + id                       = (known after apply)
      + load_balancer_id         = (known after apply)
      + name                     = "FoggyKitchenFlexPublicLoadBalancerListener"
      + path_route_set_name      = (known after apply)
      + port                     = 80
      + protocol                 = "HTTP"
      + rule_set_names           = (known after apply)
      + state                    = (known after apply)

      + connection_configuration {
          + backend_tcp_proxy_protocol_version = (known after apply)
          + idle_timeout_in_seconds            = (known after apply)
        }
    }

Plan: 27 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.


(...)
oci_load_balancer_backend.FoggyKitchenFlexPublicLoadBalancerBackend1: Still creating... [1m40s elapsed]
oci_load_balancer_backend.FoggyKitchenFlexPublicLoadBalancerBackend1: Creation complete after 1m44s [id=loadBalancers/ocid1.loadbalancer.oc1.iad.aaaaaaaakwlpakwhgolzbztt5df6wsgwc7umso7paii36t7dw2bsecgz7vba/backendSets/FoggyKitchenFlexLBBackendset/backends/10.0.1.3:80]

Apply complete! Resources: 27 added, 0 changed, 0 destroyed.

Outputs:

FoggyKitchenBastionServer_PublicIP = [
  "150.136.64.117",
]
FoggyKitchenFlexPublicLoadBalancer_Public_IP = [
  [
    "193.122.204.3",
  ],
]
FoggyKitchenWebserver1_PrivateIP = [
  "10.0.1.3",
]
FoggyKitchenWebserver2_PrivateIP = [
  "10.0.1.2",
]
(...)

```

### STEP 6.
After testing the environment you can remove the whole OCI infra. You should just run *terraform destroy* (type **yes** for confirmation of the destroy phase):

```
[opc@terraform-server terraform-oci-flex-lb]$ terraform destroy

data.oci_identity_availability_domains.ADs: Refreshing state... [id=IdentityAvailabilityDomainsDataSource-3269541301]
oci_identity_compartment.FoggyKitchenCompartment: Refreshing state... [id=ocid1.compartment.oc1..aaaaaaaayxvhhjidfxsq35muvshgxv62ac2mn6mi2yo2xqzsq53jgkuozfwq]
data.oci_core_images.OSImageLocal: Refreshing state... [id=CoreImagesDataSource-3030678454]
oci_core_virtual_network.FoggyKitchenVCN: Refreshing state... [id=ocid1.vcn.oc1.iad.amaaaaaanlc5nbyatfsremzrq5agy2b5v7deja54rmtrqfbv2p5wc6s3prrq]
oci_core_network_security_group.FoggyKitchenWebSecurityGroup: Refreshing state... [id=ocid1.networksecuritygroup.oc1.iad.aaaaaaaalkzj5i2btyqde3jafj4o5zxbrr6v3bdt5rw5gqtcgyff3xq2xcma]
oci_core_internet_gateway.FoggyKitchenInternetGateway: Refreshing state... [id=ocid1.internetgateway.oc1.iad.aaaaaaaawwzbcubzr6dac2xcsraauglsvaokqcpov54qnw7or4qeey46eyta]
oci_core_network_security_group.FoggyKitchenSSHSecurityGroup: Refreshing state... [id=ocid1.networksecuritygroup.oc1.iad.aaaaaaaa2sg4voivred6m24eqrnr26e62fpykuslpttcfo2tdmfq5pdlgqwq]
(...)

  # oci_load_balancer_listener.FoggyKitchenFlexPublicLoadBalancerListener will be destroyed
  - resource "oci_load_balancer_listener" "FoggyKitchenFlexPublicLoadBalancerListener" {
      - default_backend_set_name = "FoggyKitchenFlexLBBackendset" -> null
      - hostname_names           = [] -> null
      - id                       = "loadBalancers/ocid1.loadbalancer.oc1.iad.aaaaaaaakwlpakwhgolzbztt5df6wsgwc7umso7paii36t7dw2bsecgz7vba/listeners/FoggyKitchenFlexLBListener" -> null
      - load_balancer_id         = "ocid1.loadbalancer.oc1.iad.aaaaaaaakwlpakwhgolzbztt5df6wsgwc7umso7paii36t7dw2bsecgz7vba" -> null
      - name                     = "FoggyKitchenFlexLBListener" -> null
      - port                     = 80 -> null
      - protocol                 = "HTTP" -> null
      - rule_set_names           = [] -> null
      - state                    = "SUCCEEDED" -> null

      - connection_configuration {
          - backend_tcp_proxy_protocol_version = 0 -> null
          - idle_timeout_in_seconds            = "60" -> null
        }
    }

Plan: 0 to add, 0 to change, 27 to destroy.

Changes to Outputs:
  - FoggyKitchenBastionServer_PublicIP           = [
      - "150.136.64.117",
    ] -> null
  - FoggyKitchenFlexPublicLoadBalancer_Public_IP = [
      - [
          - "193.122.204.3",
        ],
    ] -> null
  - FoggyKitchenWebserver1_PrivateIP             = [
      - "10.0.1.3",
    ] -> null
  - FoggyKitchenWebserver2_PrivateIP             = [
      - "10.0.1.2",
    ] -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

(...)

oci_core_nat_gateway.FoggyKitchenNATGateway: Destroying... [id=ocid1.natgateway.oc1.iad.aaaaaaaadabtkqy4t3psmn64jwmdmnh73htb4ntjkuunjjh7spgj26iiempq]
oci_core_nat_gateway.FoggyKitchenNATGateway: Destruction complete after 2s
oci_core_virtual_network.FoggyKitchenVCN: Destroying... [id=ocid1.vcn.oc1.iad.amaaaaaanlc5nbyatfsremzrq5agy2b5v7deja54rmtrqfbv2p5wc6s3prrq]
oci_core_virtual_network.FoggyKitchenVCN: Destruction complete after 1s
oci_identity_compartment.FoggyKitchenCompartment: Destroying... [id=ocid1.compartment.oc1..aaaaaaaayxvhhjidfxsq35muvshgxv62ac2mn6mi2yo2xqzsq53jgkuozfwq]
oci_identity_compartment.FoggyKitchenCompartment: Destruction complete after 0s

Destroy complete! Resources: 27 destroyed.
```
