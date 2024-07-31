# websockets
we want to create a flow that provisions VMs (foe example rhel/centos), deploys and tests different web apps that communicate using different protocols.
to do so we will provision a local VM as a lab using Vagrant, and deploy on it the web apps using Docker.

for now, we will compare between the following protocols:
1. http
2. https
3. websocket - full-duplex communication channels over a single TCP connection.
4. secure websocket (WSS) - websocket over TLS.

we can check the protocols in action by snifing and inspecting the packets using wireshark.

here is a diagram of our project:
![testing-protocols diagram](docs/websockets-diagram.drawio.png "testing-protocols diagram")

## folder structure
```
web-sockets/
├── apps/                               # contains all the web apps and the docker compose that deploys them
│   ├── http-web-app/                   # the http web app folder
│   │   ├── main.py
│   │   ├── Dockerfile
│   │   └── requirements.txt
│   ├── https-web-app/
│   ├── websockets-web-app/
│   ├── wss-web-app/
│   └── docker-compose.yaml             # docker compose file that deploys all the web apps in this folder
├── docs/
├── provision/                          # contains scripts and stuff relateed to the provisioning of the VM
│   ├── deploy-webapps-pb.yaml
│   ├── initial-provision-centos.sh
│   └── initial-provision-rhel.sh
├── pyproject.toml                      # poetry file
├── Vagrantfile                         # Vagrant's VM configuration
├── README.md
├── .gitignore
├── .vagrant                            # Vagrant's folder containing the VM's information and state
└── .venv                               # python virtual environment used for ansible and its dependencies
```

## requirements
1. Vagrant
```bash
sudo apt install -y vagrant

### make sure it works and installed the correct version
vagrant --version
```
2. Vagrant plugins: vagrant-vbguest, vagrant-disksize
```bash
vagrant plugin install vagrant-vbguest vagrant-disksize
```
3. Virtual Box
```bash
sudo apt install -y virtualbox
```
4. virtualization support enabled in your BIOS
```bash
# check if the virtualization is enabled
sudo lscpu | grep Virtualization

# output should look like this:
Virtualization:                  VT-x
# if not, go to the BIOS settings and enable it.
```
5. Python

## Usage
1. clone the repo and setup the RHEL 8 VM.
```bash
git clone
cd ./web-sockets/
vagrant init
```
2. create a python venv and install dependencies (for ansible).
```bash
py -m venv .venv
.\.venv\Scripts\Activate.ps1    # for windows
pip install poetry
poetry init
```
3. provision the VM (for me the initial provision usually takes 14 min).
```bash
vagrant up
```
4. after the provisioning finished and the web apps are deployed, we can browse to them from the host.
```bash
# for example, getting the flask web app in port 3000
curl http://localhost:3000
```
5. fore better inspection at the VM itself and troubleshooting the web apps, you can ssh into the VM.
```bash
vagrant ssh
```
```bash
# look at the docker containers status
docker ps -a

# see the logs of the containers
docker compose logs
```
6. when you finish with the VM, make sure to stop and delete it.
```bash
vagrant destroy
```

## usful commands
* to see the status of all the Vagrant VMs:
```bash
vagrant global-status
```

## problems I went through, and some solutions
1. when trying to install docker on rhel 8, the docker-ce repo is missing some dependencies. 
the error im getting:
```
Error:
    websockets-vm:  Problem 1: cannot install the best candidate for the job
    websockets-vm:   - nothing provides libcgroup needed by docker-ce-3:27.1.1-1.el8.x86_64
    websockets-vm:   - nothing provides container-selinux >= 2:2.74 needed by docker-ce-3:27.1.1-1.el8.x86_64
    websockets-vm:  Problem 2: cannot install the best candidate for the job
    websockets-vm:   - nothing provides container-selinux needed by containerd.io-1.7.19-3.1.el8.x86_64
    websockets-vm: (try to add '--skip-broken' to skip uninstallable packages or '--nobest' to use not only best candidate packages)
```
in this example, Im missing libcgroup which is deprecated in RHEL 7.7.

solution: moved to centos

---

2. microsoft policiy restricts running python virtual environments in vscode.

solution: 
to enable it:
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
to revert it:
```
Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope CurrentUser
```

---

3. after installing ansible in the python venv, running it outputs the following error:
```
Traceback (most recent call last):
  File "<frozen runpy>", line 198, in _run_module_as_main
  File "<frozen runpy>", line 88, in _run_code
  File "...\.venv\Scripts\ansible.exe\__main__.py", line 4, in <module>
  File "...\.venv\Lib\site-packages\ansible\cli\__init__.py", line 40, in <module>
    check_blocking_io()
  File "...\.venv\Lib\site-packages\ansible\cli\__init__.py", line 32, in check_blocking_io
    if not os.get_blocking(fd):
           ^^^^^^^^^^^^^^^^^^^
OSError: [WinError 1] Incorrect function
```
it seems to be because Windows without WSL is not natively supported as a control node in ansible.

solution:
install wsl

---

4. app1:
```
ImportError: cannot import name 'url_quote' from 'werkzeug.urls' (/usr/local/lib/python3.9/site-packages/werkzeug/urls.py)
```
Flask 3+ isn't compatible with Werkzeug 2. But the latest versions of each are compatible with each other.
specifiying an earlier version for the Werkzeug module (for example 2.2.0) doesnt work, nor changing the flask version as well.


## notes and todo list
1. add WebRTC, gRPC, SSE(?), socket.io protocols
2. generate certificates with lets encrypt
3. deploy servicemesh and inspect the traffic of the web apps from the host
