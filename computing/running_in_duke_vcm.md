
1. Request a new VM from Duke's [Virtual Computing Manager](https://oit.duke.edu/help/articles/vcm-how-use-virtual-computing-manager).  Your VM should be based on "Ubuntu 16.04"

2. SSH to your new VM, and do all the following on the VM

3. Run the following commands to install Docker
```
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install -y --no-install-recommends    apt-transport-https     ca-certificates     curl     software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
sudo apt-get update
sudo apt-get install -y --no-install-recommends docker-ce
```

4. Run the following to confirm that Docker is working `sudo docker run hello-world` It should print this:
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

5. Run the following to allow you to run docker without sudo:
``` 
sudo groupadd docker
sudo gpasswd -a $USER docker
newgrp docker
```

6. Now run the following to be sure that worked (note that we are not using 'sudo' here) `docker run hello-world`

7. Run the following to get the script that will download course material and the jupyter image
```
curl -O https://gitlab.oit.duke.edu/HTS2018/HTS2018-notebooks/raw/master/reproducibility/prep_local_jupyter.sh
```

8. Run `bash prep_local_jupyter.sh hts2018`  to download course material and the jupyter image, and run it. Follow the printed instructions for accessing the Jupyter instance running on your VM.

9. You will probably get one of the following warnings, depending on your browser, it is safe to ignore this
	- *Chrome*: "Your connection is not private"
	  1. Click *ADVANCED*
	  2. Click *Proceed to XXXXXXX (unsafe)*, where XXXXXXX is the URL of your VM
	- *Safari*: "This Connection Is Not Private"
	  1. Click *Show Details*
	  2. Click *visit this website*
	  3. Click *Visit Website*
	- *Firefox*: "Your connection is not secure"
	  1. Click *ADVANCED*
	  2. Click *Add Exception*
	  3. Uncheck the box next to *Permanently store this exception*
	  4. Click *Confirm Security Exception*
