# web sockets
we want to deploy and test web apps that communicate using secure websockets.
to do so we will setup a lab - rhel8\centos8 VM on which we deploy 2 web apps that will communicate with each other.

few things before we start:
* websocket - a communication protocol providing full-duplex communication channels over a single TCP connection.
* secure websockets - WebSockets over TLS.

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
6. 

## Usage
1. clone the repo and setup the RHEL 8 VM.
```
git clone
cd ./web-sockets/
vagrant init

py -m venv .venv
.\.venv\Scripts\Activate.ps1    # for windows
pip install poetry
poetry init
```

2. ssh into the VM
```
vagrant up
vagrant ssh
```


---

when trying to install docker on rhel 8, the docker-ce repo is missing some dependencies. 
the error im getting:
```
Error:
    web-sockets-vm:  Problem 1: cannot install the best candidate for the job
    web-sockets-vm:   - nothing provides libcgroup needed by docker-ce-3:27.1.1-1.el8.x86_64
    web-sockets-vm:   - nothing provides container-selinux >= 2:2.74 needed by docker-ce-3:27.1.1-1.el8.x86_64
    web-sockets-vm:  Problem 2: cannot install the best candidate for the job
    web-sockets-vm:   - nothing provides container-selinux needed by containerd.io-1.7.19-3.1.el8.x86_64
    web-sockets-vm: (try to add '--skip-broken' to skip uninstallable packages or '--nobest' to use not only best candidate packages)
```
in this example, Im missing libcgroup which is deprecated in RHEL 7.7.

solution: moved to centos

---

microsoft policiy restricts running python virtual environments in vscode.

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

after installing ansible in the python venv, running it outputs the following error:
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
app1:
```
ImportError: cannot import name 'url_quote' from 'werkzeug.urls' (/usr/local/lib/python3.9/site-packages/werkzeug/urls.py)
```
Flask 3+ isn't compatible with Werkzeug 2. But the latest versions of each are compatible with each other.
