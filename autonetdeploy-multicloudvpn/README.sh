# Preparing your Google Cloud working environment
# In this section, you will clone the tutorial code and verify your Google Cloud region and zone.

# Clone the tutorial code
# In the Google Cloud Console, open a new Cloud Shell window and clone the tutorial code from GitHub:
git clone https://github.com/GoogleCloudPlatform/autonetdeploy-multicloudvpn.git

# Navigate to the tutorial directory:
cd autonetdeploy-multicloudvpn

# Verify the Google Cloud region and zone
# Certain cloud resources in this lab, including Compute Engine instances, VPN gateways, and Cloud Router, require you to explicitly declare the intended placement region or zone, or both. For more details, see Regions and Zones for Google Cloud.

# This lab requires only a single region for each provider. To optimize the connection between the two clouds, choose regions near each other. The following table lists the values set in the tutorial files terraform/gcp_variables.tf and terraform/aws_variables.tf.

# Field name	Google Cloud values	AWS values
# Region Name	us-west1	US West (us-west-1)
# Location	The Dalles, Oregon, USA	Northern California

# Preparing for AWS use
# In this section, you will verify your AWS region. For details about AWS regions, see Regions and Availability Zones for AWS.
# Sign in to the AWS Management Console (Click the Open AWS Console button on the left, and log in with the provided username and password).
# Navigate to the EC2 Dashboard (Services > Compute > EC2). Select the Northern California region (us-west-1) using the pulldown menu in the top right. In the EC2 Dashboard and the VPC Dashboard, you can review the resources deployed later in the lab.

# Creating access credentials
# In this section, you will create access credentials for Google Cloud and AWS and point your templates at these access credentials.

# Download Compute Engine default service account credentials
# In Cloud Shell, which is a Linux environment, gcloud manages credentials files under the ~/.config/gcloud directory. To set up your Compute Engine default service account credentials, follow these steps:

# In the Google Cloud Console, in the Navigation Menu Navigation menu , click IAM & Admin > Service Accounts.
# Click the Compute Engine default service account , click on three vetical dots under Actions and select Manage keys, and click ADD KEY > Create new key.
# Verify JSON is selected as the key type and click Create, which downloads your credentials as a file named [PROJECT_ID]-[UNIQUE_ID].json. Click CLOSE.

# Click Check my progress to verify the objective.
# Create service key for default service account

# In your Cloud Shell terminal, verify you are still in the autonetdeploy-multicloudvpn folder.
# To upload your downloaded JSON file from your local machine into the Cloud Shell environment, click More more and click Upload then choose your downloaded file and click Upload.
# Navigate to the JSON file you downloaded and click Open to upload. The file is placed in the home (~) directory.
# Use the ./gcp_set_credentials.sh script provided to create the ~/.config/gcloud/credentials_autonetdeploy.json file. This script also creates terraform/terraform.tfvars with a reference to the new credentials.
# Replace [PROJECT_ID]-[UNIQUE_ID] with the actual file name of your downloaded JSON key.
./gcp_set_credentials.sh ~/[PROJECT_ID]-[UNIQUE_ID].json

# Output (Do not copy):

# Created ~/.config/gcloud/credentials_autonetdeploy.json from ~/[PROJECT_ID]-[UNIQUE_ID].json.
# Updated gcp_credentials_file_path in ~/autonetdeploy-startup/terraform/terraform.tfvars.
# Create AWS access credentials
# In this section, you will set up your Qwiklabs-generated AWS access credentials to use with Terraform. Note that the method used in here differs from that of a production or personal environment due to lab constraints. If you would like to see how this is done outside of a lab environment, you can check out the steps here.
# Run the following commands to create your credentials directory and file:
export username=`whoami`
mkdir /home/$username/.aws/
touch /home/$username/.aws/credentials_autonetdeploy

# Run the following command to edit the credentials file. This is where you will put your Qwiklabs generated AWS Access and Secret keys.
# nano /home/$username/.aws/credentials_autonetdeploy
# On the first line, paste the following:
[default]

# On the next line, add the following code. Replace <Your AWS Access Key> with your AWS Access Key from the Qwiklabs connection details panel.
aws_access_key_id=<Your AWS Access Key>
# On the next line, add the following code. Replace <Your AWS Secret Key> with your AWS Secret Key from the Qwiklabs connection details panel.
aws_secret_access_key=<Your AWS Secret Key>

# To save the file, use CTRL+X to exit, then type Y to save the changes, and hit Enter.
# Run the following to inspect your security credentials file:
cat /home/$username/.aws/credentials_autonetdeploy

# Your file should resemble the following:
[default]
aws_access_key_id=AKIA3INBXVI72ZO2Z4F4
aws_secret_access_key=bvQ+aMscVps34Q5ZZnazUGB2+kneKFr73P33iZIo

# Once your file is correctly formatted, use the following command to set a Terraform environment variable to the correct AWS credentials file path:
export TF_VAR_aws_credentials_file_path=/home/$username/.aws/credentials_autonetdeploy

# Note: a different way to do this would be to update the terraform/terraform.tfvars file to reference the AWS credentials file path.
# Setting your project
# In this section, you point your deployment templates at your project. Google Cloud offers several ways to designate the Google Cloud project to be used by the automation tools. For simplicity, instead of pulling the Project ID from the environment, the Google Cloud project is explicitly identified by a string variable in the template files.

# Set your Google Cloud Project ID by using the following commands:
export PROJECT_ID=$(gcloud config get-value project)
gcloud config set project $PROJECT_ID

# Use the provided script to update the project value in your configuration files for Terraform.
./gcp_set_project.sh

# Review the updated file to verify that your project-id value has been inserted into terraform/terraform.tfvars. You can either use the cat command or the Cloud Shell Editor to verify the file.
# Run the one-time terraform init command to install the Terraform providers for this deployment.
cd terraform
terraform init

# Run the Terraform plan command to verify your credentials.
terraform plan

# Output (Do not copy):
Refreshing Terraform state in-memory prior to plan...
...
 +google_compute_instance.gcp-vm
...
Plan: 34 to add, 0 to change, 0 to destroy.

# Using SSH keys for connecting to VM instances
# In Google Cloud, the Cloud Console and gcloud tool work behind the scenes to manage SSH keys for you. Use the ssh command to communicate with your Compute Engine instances without generating or uploading any key files.

# However, for your multi-cloud exercises, you do need a public/private key pair to connect with VM instances in Amazon Elastic Compute Cloud (EC2).

# Generate a key pair
# In Cloud Shell, use ssh-keygen to generate a new key pair:
ssh-keygen -t rsa -f ~/.ssh/vm-ssh-key -C $username

# When asked for passphrase, press Enter twice to leave it blank.
# Restrict access to your private key. This is a best practice.
chmod 400 ~/.ssh/vm-ssh-key

# Import the public key to Google Cloud
# In this section, you will import and register your key.
# In Cloud Shell, register your public key with Google Cloud:
# gcloud compute config-ssh --ssh-key-file=~/.ssh/vm-ssh-key

# You can ignore the warning No host aliases were added... because the command also attempts to update Compute Engine VM instances, but no instances have been created yet.
# In the Cloud Console, navigate to the Compute Engine > Metadata page.
# Click SSH Keys. Verify your SSH Key exists.
# Under the Key Section, copy the SSH Key value. You will use this in the next section.

# Import the public key to AWS
# You can reuse the public key file generated with Google Cloud.

# In the AWS Management Console, navigate to Services > Compute > EC2.
# Verify that you are in the US-West (N. California) us-west-1 region.
# In EC2 Dashboard, under the Network & Security group on the left, click Key Pairs.

# Click Actions > Import Key Pair.
# For the name, enter: vm-ssh-key.

# Paste the contents of your Google Cloud public key (Compute Engine > Metadata > SSH Keys) into the Public key contents box.
# Verify that the contents are of the expected form: ssh-rsa [KEY_DATA] [USERNAME].
# Click Import Key Pair.

# You can now see the AWS entry for the vm-ssh-key value. You can reference this key in configuration settings, which enables you to use the ssh command for access.
# When you use the ssh command to connect to AWS instances, AWS behaves differently from Google Cloud. For AWS, you must provide a generic username supported by the AMI provider. In this tutorial, the AMI provider expects ubuntu as the user.
# You now have an environment in which you can easily deploy resources to the cloud using automated tools. Use this environment to complete the rest of the lab.
# Examining Terraform configuration files
# In Terraform, a deployment configuration is defined by a directory of files. Although these files can be JSON files, it's better to use the Terraform configuration file (.tf file) syntax, which is easier to read and maintain. This lab provides a set of files that illustrate one way of cleanly organizing your resources. This set is a functional deployment and requires no edits to run.

# Filename	Purpose
# main.tf	Defines your providers, and specifies which clouds to deploy in this configuration. Also reads your credentials, project name, and selected regions.
# gcp_variables.tf, aws_variables.tf	Declares variables used to parameterize and customize the deployment—for example, gcp_region and gcp_instance_type.
# gcp_compute.tf, aws_compute.tf	Defines the compute resources used in your deployment—for example, google_compute_instance.
# vm_userdata.sh	Specifies the script to run when starting up VM instances. Automatically sets up the iperf3 test tool and some wrapper scripts.
# gcp_networking.tf, aws_networking.tf	Defines networking resources, including google_compute_network, google_compute_subnetwork, google_compute_address, google_compute_vpn_gateway, and google_compute_vpn_tunnel.
# gcp_security.tf, aws_security.tf	Defines resources for allowing test traffic in the GCP or AWS environment, including google_compute_firewall rules and aws_security_group resources.
# gcp_outputs.tf, aws_outputs.tf	Defines variables to be output upon completion of the deployment—for example, the external_ip and internal_ip of the deployed VM instance.
# terraform.tfstate	[OUTPUT] Specifies the file used by Terraform to store the client-side resource state after checking with the cloud. For more details, see Managing GCP Projects with Terraform.
# run_graph.sh	Shell script for generating a PNG file from Terraform that shows resource dependencies. You can see the output of this script in images/gcpawsvpn_plan_graph.png.
# Deploying VPC networks, VM instances, VPN gateways, and IPsec tunnels
# Constructing connections between multiple clouds is complex. You can deploy many resources in parallel in both environments, but when you are building IPsec tunnels, you need to order interdependencies carefully. For this reason, establishing a stable deployment configuration in code is a helpful way to scale your deployment knowledge. The following figure summarizes the steps required to create this deployment configuration across multiple providers.


# Deploy with Terraform
# Terraform uses the terraform.tfstate file to capture the resource state. To view the current resource state in a readable form, you can run terraform show.
# In Cloud Shell, navigate to the terraform directory:
cd ~/autonetdeploy-multicloudvpn/terraform

# Use the Terraform validate command to validate the syntax of your configuration files. This validation check is simpler than those performed as part of the plan and apply commands in subsequent steps. The validate command does not authenticate with any providers.
terraform validate

# If you don't see an error message, you have completed an initial validation of your file syntax and basic semantics. If you do see an error message, validation failed.
# Use the Terraform plan command to review the deployment without instantiating resources in the cloud. The plan command requires successful authentication with all providers specified in the configuration.
terraform plan

# The plan command returns an output listing of resources to be added, removed, or updated. The last line of the plan output shows a count of resources to be added, changed, or destroyed:
Refreshing Terraform state in-memory prior to plan...
...
Plan: 34 to add, 0 to change, 0 to destroy.

# Use the Terraform apply command to create a deployment:
terraform apply

# The apply command creates a deployment with backing resources in the cloud. In around four minutes, apply creates 30+ resources for you, including GCP and AWS VPC networks, VM instances, VPN gateways, and IPsec tunnels. The output of the apply command includes details of the resources deployed and the output variables defined by the configuration.
# Type yes then enter to approve.
# Click Check my progress to verify the objective.
# Deploy with Terraform
# Your deployments can emit output variables to aid your workflow. In this tutorial, the assigned internal and external IP addresses of VM instances have been identified as output variables by the gcp_outputs.tf and aws_outputs.tf files. These addresses are printed automatically when the apply step completes. If, later in your workflow, you want to redisplay the output variable values, use the output command.
terraform output

# The output variables defined by this configuration include the internal and external IP addresses for your VM instances. To use the ssh command for network validation, you need the external IP addresses to connect to the VM instances.
aws_instance_external_ip = [AWS_EXTERNAL_IP]
aws_instance_internal_ip = 172.16.0.100
gcp_instance_external_ip = [GCP_EXTERNAL_IP]
gcp_instance_internal_ip = 10.240.0.100

# Use the Terraform show command to inspect the deployed resources and verify the current state.
terraform show

# To review your instances, use gcloud compute instances list, or use the Cloud Console, on the VM instances panel.
gcloud compute instances list

# Output (Do not copy):

NAME             ZONE        MACHINE_TYPE  PREEMPTIBLE  INTERNAL_IP    EXTERNAL_IP    STATUS
gcp-vm-us-west1  us-west1-a  n1-highmem-4               10.240.0.100   [EXTERNAL IP]  RUNNING

# Verify that your Google Cloud VM instance is functioning by using the ssh command to connect to it:
ssh -i ~/.ssh/vm-ssh-key [GCP_EXTERNAL_IP]

# You will get a message asking to confirm the authenticity of the host. Type yes.
# Run the ping and curl commands in your ssh session:
ping -c 5 google.com
curl ifconfig.co/ip

# Run simple network performance checks from the Google Cloud VM instance. Use pre-installed scripts to run a test on each network interface, both external and internal.
# Over external IPs:
/tmp/run_iperf_to_ext.sh

# This script runs a 30-second performance test that produces summary data about network performance.
# Resulting output:
...
[SUM]   ... sender
[SUM]   ... receiver
...

# Over VPN (internal IPs):
/tmp/run_iperf_to_int.sh

# This script runs a 30-second performance test that produces summary data about network performance.
# Resulting output:
...
[SUM]   ... sender
[SUM]   ... receiver
...

# Once the output has been displayed once, please exit iperf.
# When you complete the checks from the Google Cloud VM instance, enter the following command:
exit

# To verify that your AWS VM instance is functioning, use the ssh command to connect to it:
ssh -i ~/.ssh/vm-ssh-key ubuntu@[AWS_EXTERNAL_IP]

# You will get a message asking to confirm the authenticity of the host. Type yes.
# Run the ping and curl commands in your ssh session:
ping -c 5 google.com
curl ifconfig.co/ip

# Run simple network performance checks from the AWS VM instance. Use pre-installed scripts to run a test on each network interface, both external and internal.
# Over external IPs:
/tmp/run_iperf_to_ext.sh

# This script runs a 30-second performance test that produces summary data about network performance.
# Resulting output:
...
[SUM]   ... sender
[SUM]   ... receiver
...

# Over VPN (internal IPs):
/tmp/run_iperf_to_int.sh

# This script runs a 30-second performance test that produces summary data about network performance.
# Output (Do not copy):
...
[SUM]   ... sender
[SUM]   ... receiver
...

# Once the output has been displayed once, please exit iperf.
# When you complete the checks from the AWS VM instance, enter the following command:
exit

# You have successfully deployed a secure, private, site-to-site connection between Google Cloud and AWS using VPN! You can optionally destroy your infrastructure using the terraform destroy command, explore the resources you created, or end your lab here.