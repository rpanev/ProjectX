### Deployment
# Step 1: Deploy backend
make deploy-backend

# Step 2: Build AMI
make deploy-packer

# Step 3: Deploy infrastructure
make deploy-infra 


### Install Session Manager Plugin
## Rocky Linux ; AlmaLinux ; RHEL ; 
# Download
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "session-manager-plugin.rpm"

# Install
sudo dnf install -y session-manager-plugin.rpm

# Verify
session-manager-plugin

## MacOS
# Download
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" -o "sessionmanager-bundle.zip"

# Extract
unzip sessionmanager-bundle.zip

# Install
sudo ./sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin

# Verify
session-manager-plugin

## Check instance
# Connect to instance
aws ssm start-session --target i-ID

# Check nginx service
sudo systemctl status nginx

# Check fry-config service
sudo systemctl status fry-config

# Check if services are enabled
sudo systemctl is-enabled nginx
sudo systemctl is-enabled fry-config

# View logs
sudo journalctl -u nginx -n 50
sudo journalctl -u fry-config -n 50