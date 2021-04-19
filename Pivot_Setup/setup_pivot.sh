echo "[0/10] setting up .bashrc "
sudo tee -a /home/opc/.bashrc > /dev/null <<'EOF'
export PATH="/home/opc/Terraform":${PATH}
alias ocibe="cd /home/opc/REPOS/OCIBE"
alias ocife="cd /home/opc/REPOS/OCIFE"
EOF



echo "[1/10] Customizing Wandisco repository and enabling epel repo "
sudo tee -a /etc/yum.repos.d/wandisco-git.repo  > /dev/null <<'EOF'
[wandisco-git]
name=Wandisco GIT Repository
baseurl=http://opensource.wandisco.com/rhel/7/git/$basearch/
enabled=1
gpgcheck=1
gpgkey=http://opensource.wandisco.com/RPM-GPG-KEY-WANdisco
EOF
sudo rpm --import http://opensource.wandisco.com/RPM-GPG-KEY-WANdisco

sudo sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/oracle-epel-ol7.repo
echo -e "[1/10] Done.\n\n"

#Utilitary Install

echo "[2/10] Installing basic packages (git, ansible, python, etc.)"
sudo yum -y install go 
sudo yum -y install git
sudo yum -y install ansible
sudo yum -y install java
sudo yum -y install python3

#
# Extra tools (PIP & OCI plugins)
#
sudo runuser -l opc -c 'curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py'
sudo runuser -l opc -c 'python get-pip.py'
sudo runuser -l opc -c 'pip install "pywinrm>=0.2.2"'
sudo runuser -l opc -c 'pip install oci'
echo -e "[2/10] Done.\n\n"

echo "[3/10] Update OS"
sudo yum -y update
echo -e "[3/10] Done.\n\n"

echo "[4/10] Install Terraform"
mkdir -p /home/opc/Terraform
sudo runuser -l opc -c 'wget https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip -P /home/opc/Terraform'
sudo runuser -l opc -c 'unzip /home/opc/Terraform/terraform_0.14.7_linux_amd64.zip -d /home/opc/Terraform'
echo -e "[4/10] Done.\n\n"

echo "[5/10] Initializing AWS credentials"
sudo mkdir -p /home/opc/.aws
sudo tee -a /home/opc/.aws/credentials > /dev/null <<'EOF'
[default]
aws_access_key_id=
aws_secret_access_key=
EOF
sudo chown opc:opc -R /home/opc/.aws
sudo chmod 0600  /home/opc/.aws/credentials
echo -e "[5/10] Done.\n\n"

echo "[6/10] Create hosting directories"

mkdir -p /home/opc/REPOS/OCIFE
mkdir -p /home/opc/REPOS/OCIBE
mkdir -p /home/opc/Terraform
mkdir -p /home/opc/.ssh/OCI_KEYS/API
mkdir -p /home/opc/.ssh/OCI_KEYS/SSH
echo -e "[6/10] Done.\n\n"

echo "[7/10] Create API Keys"
cd /home/opc/.ssh/OCI_KEYS/API
openssl genrsa -out ./auto_api_key.pem 2048
chmod go-rwx ./auto_api_key.pem
openssl rsa -pubout -in ./auto_api_key.pem -out ./auto_api_key_public.pem
openssl rsa -pubout -outform DER -in ./auto_api_key.pem | openssl md5 -c
echo -e "[7/10] Done.\n\n"

echo "[8/10] Create SSH Keys"
cd /home/opc/.ssh/OCI_KEYS/SSH
ssh-keygen -t rsa -N "" -b 2048 -C "autossh" -f ./auto_ssh_id_rsa
cp auto_ssh_id_rsa ../../id_rsa
echo -e "[8/10] Done.\n\n"

echo "[9/10] Disabling epel repo"
sudo sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/oracle-epel-ol7.repo
echo -e "[9/10] Done.\n\n"

echo "[10/10] Installing K9s"
curl -sS https://webinstall.dev/k9s | bash
echo -e "[10/10] Done.\n\n"
