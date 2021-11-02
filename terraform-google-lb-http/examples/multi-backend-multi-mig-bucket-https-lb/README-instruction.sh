# Run the command:

terraform init

# Run the terraform plan command. Make sure to replace <PROJECT_ID> with your Qwiklabs provided Project ID:

terraform plan -out=tfplan -var 'project=<PROJECT_ID>'

# Apply the Terraform plan:

terraform apply tfplan

# Example Output (your's will differ):

# ...
# Apply complete! Resources: 42 added, 0 changed, 0 destroyed.
# ...
# Outputs:
# asset-url = https://34.96.112.153/assets/gcp-logo.svg
# group1_region = us-west1
# group2_region = us-central1
# group3_region = us-east1
# load-balancer-ip = 34.96.112.153
# Verify the resources created by Terraform:
# In the Navigation menu navigate to Network services > Load Balancing.
# Wait until you see the green checkmark in the Backends column.
# Click on ml-bk-ml-mig-bkt-s-lb load balancer and check the details.

# Run the following to get the external URL:

EXTERNAL_IP=$(terraform output | grep load-balancer-ip | cut -d = -f2 | xargs echo -n)

echo https://${EXTERNAL_IP}

# Click on the EXTERNAL_IP link that is returned to open the load balancer URL in a new browser tab.
# Note: If you don't get the expected output in the browser, make sure your load balancer details panel is the same as an above screenshot and wait for few minutes.
# You should see the Google Cloud logo and instance details from the group closest to your geographical region.