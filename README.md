# LFCE - Study enviroment

I'm studying for the LFCE exam and need some VMs to practice, so why not take advantage of this need and improve my skills with other tools like Terraform and git?

The goal is to provide a simple setup for four CentOS VMs. You can use this to create these VMs in a local KVM host.

<br />

# Usage


**KVM**

Use the ssh-keygen command to create you own key pair, use the name "lfce.key" for the private key:
```bash
$ cd kvm
$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/centos/.ssh/id_rsa): ./lfce.key
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in ./lfce.key
Your public key has been saved in ./lfce.key.pub
```

<br />

Copy the content of the "lfce.key.pub" file to "ssh_authorized_keys" (line 62) inside the file "kvm/lfce.yaml" 

<br />

Download the latest CentOS Image:
```bash
./download-image.py
```

Run the following commands to initialize terraform and create everything:
```bash
terraform init
terraform plan
terraform apply
```

You might face a "Permission Denied" issue. The workaround is setting `security_driver = "none"` in `/etc/libvirt/qemu.conf` but followed by `sudo systemctl restart libvirtd`. More details [here](https://github.com/dmacvicar/terraform-provider-libvirt/issues/546#issuecomment-840127487).

<br />
<br />


# References

 * [kubic-terraform-kvm] (https://github.com/kubic-project/kubic-terraform-kvm)