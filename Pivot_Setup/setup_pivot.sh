echo "[0/10] setting up .bashrc "
sudo tee -a /home/opc/.bashrc > /dev/null <<'EOF'
export PATH="/home/opc/Terraform":${PATH}
alias ocibe="cd /home/opc/REPOS/OCIBE"
alias ocife="cd /home/opc/REPOS/OCIFE"
EOF



echo "[1/10] Customizing Wandisco repository and enabling kubernetes, epel repo "
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

sudo tee -a /etc/yum.repos.d/kubernetes.repo  > /dev/null <<'EOF'
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF


echo -e "[1/10] Done.\n\n"

#Utilitary Install

echo "[2/10] Installing basic packages (git, ansible, python, go, kubectl, etc.)"
sudo yum -y install go 
sudo yum -y install git
sudo yum -y install ansible
sudo yum -y install java
sudo yum -y install python3
sudo yum -y install kubectl
sudo yum -y install docker
sudo usermod -a -G docker $USER
sudo usermod -a -G docker $USER
sudo systemctl enable docker.service 
sudo systemctl start docker.service 
sudo chmod 666 /var/run/docker.sock

#
# Extra tools (PIP & OCI plugins)
#
sudo runuser -l opc -c 'curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py'
sudo runuser -l opc -c 'python get-pip.py'
sudo runuser -l opc -c 'pip install "pywinrm>=0.2.2"'
sudo runuser -l opc -c 'pip install oci'
sudo runuser -l opc -c 'pip3 install kubernetes'
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

echo "[11/10] Installing OCI-CLI"
sudo runuser -l opc -c 'mkdir -p /home/opc/oci_cli'
sudo runuser -l opc -c 'wget https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh'
sudo runuser -l opc -c 'chmod +x install.sh'
sudo runuser -l opc -c '/home/opc/install.sh --install-dir /home/opc/oci_cli/lib/oracle-cli --exec-dir /home/opc/oci_cli/bin --accept-all-defaults'
sudo runuser -l opc -c 'cp -rl /home/opc/bin /home/opc/oci_cli'
sudo runuser -l opc -c 'rm -r /home/opc/bin'
sudo runuser -l opc -c 'mkdir -p /home/opc/.oci'
sudo runuser -l opc -c 'chmod 600 /home/opc/.oci'
sudo runuser -l opc -c 'touch /home/opc/.oci/config'
sudo runuser -l opc -c 'oci setup repair-file-permissions --file /home/opc/.oci/config'
echo -e "[11/10] Done.\n\n"

echo "[12/10] Disabling firewall"
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl mask --now firewalld
echo "[12/10] Done"


