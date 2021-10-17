glcoud auth list # List active account
gcloud config list # List project id

# First, ensure you are using a sufficient version of Terraform by downloading 0.13.0.
wget https://releases.hashicorp.com/terraform/0.13.0/terraform_0.13.0_linux_amd64.zip

# Unzip the downloaded executable:
unzip terraform_0.13.0_linux_amd64.zip 

# Move the executable into your local bin folder:
sudo mv terraform /usr/local/bin/

# Run this command to ensure your Terraform version is 0.13.0:
terraform -v

terraform init

# Run the terraform apply command, which is used to apply the changes required to reach the desired state of the configuration.
terraform apply

# Review Terraform's actions and inspect the resources which will be created.
# When ready, type yes to begin Terraform actions.
# On completion, you should see similar output:
# Example Output (do not copy):
# Apply complete! Resources: 7 added, 0 changed, 0 destroyed.
# Outputs:
# cluster_name = tf-gke-k8s
# cluster_region = us-west1
# cluster_zone = us-west1-b
# load-balancer-ip = 35.233.177.223
# network = https://www.googleapis.com/compute/beta/projects/qwiklabs-gcp-5438ad3a5e852e4a/global/networks/tf-gke-k8s
# subnetwork_name = tf-gke-k8s