# lab-ansible

Automate the running scripts. Everything is based on Docker here!
To develop use Devcontainer. use a docker image containing ansible installation.

# Temporary docs must move to lab-scala give it to chatgpt to and say to fix this like a ansible documentation

Manage multiple servers with a great documentation for your infrastructure.
Prevent human mistakes.
Write code once for the installation and deployed multiple times with with stable statuses.
What is ansible: is a tool that provides: IT automation, consistent configuration management, automate the deployment.
Pull configuration: You have an agent to connect your tools to the slave servers.
Push configuration: is agent less and server pushes configuration to the nodes or slave servers.
Ansible is push type configuration management tool.
Ansible architecture:

* a local machine: contains all of the instructions and control power
* Nodes

Module is a collection of configuration code files.
These configuration code files are called playbooks.
The inventory file is a document that groups the nodes under specific labels.

**Test if you could add multiple environment for ansible inventory for example dev, qa, staging, prod, local, private or personal or customizable.**

Playbooks: the core of ansible is the playbook. this is where you create instructions to define the architecture of your hardware. and it has the instructions
in a YAML file.

start yaml file with `---` to start the script you could have multiple `-name: <playbook description>` in the a file.
within each playbook we define which hosts will be affected with the `hosts: <name of a group of hosts in the inventory file>`.
and then within each of the group servers called hosts we have a `tasks:` each task has its own name (If we could put it dynamically would be beneficial) and
you could find the most of them in ansible modules website.

```ansible
remote_user: root 
become: true # means it will run as root
```

Syntax check:

```shell
ansible-playbook sample-playbook.yml --syntax-check
```

Inventory file:

[nodes-group-name]
machine 1 ansible_ssh_user=root ansible_ssh_pass=password
machine 2
machine 3

[another-group-name]
machine 2
machine 4

We could add ssh pass and username for each machine mentioned above.

Ansible tower: Extra product by redhat. Ansible itself is a command line tool however Ansible Tower is a framework for ansible.
it provides a GUI which reduces the dependency of command prompt window.

Hootsuite: Is a social media management and helps to manage all social media pushes and analysis the result. They assist businesses
in campaigning across social media platforms.
It uses the Ansible.

Playbook example

```yml
---
- name: httpd installation
  hosts: custom_hosts
  user: pi
  become: yes
  become_user: root
  tasks:
    - name: Name of the underlying task
      become: yes
      apt_key:
      url: <apt key url.key>
      state: present

    - name: apt install
      become: yes
      apt:
      pkg: <package name>
      update_cache: yes
```

another example:

```yaml
- name: Transmission
  hosts: plex

  tasks:
  - name: Install transmission and a firewall
    become: yes
    apt:
      pkg:
        - transmission-daemon
        - ufw
      update_cache: yes
      state: present
  
  - name: Temporary stop transmission
    become: yes
    systemd:
      state: stopped
      name: transmission-daemon  
  
  - name: Change transmission username
    become: yes
    command: >
      sed -i -e 's/"rpc-username": ".\+"/"rpc-username": "{{ transmission_username }}"/g' /etc/transmission-daemon/settings.json 
  
  - name: Change transmission password
    become: yes
    command: >
      sed -i -e 's/"rpc-password": ".\+"/"rpc-password": "{{ transmission_password }}"/g' /etc/transmission-daemon/settings.json  

  - name: Change transmission whitelist
    become: yes
    command: >
      sed -i -e 's/"rpc-whitelist": ".\+"/"rpc-whitelist": "{{ transmission_white_list }}"/g' /etc/transmission-daemon/settings.json
  
  - name: Change transmission download dirrectory
    become: yes
    command: >
      sed -i -e 's/"download-dir": ".\+"/"download-dir": "\/mnt\/{{ usb_volume_label }}\/downloads"/g' /etc/transmission-daemon/settings.json
  
  - name: Create a download directory
    file:
      path: /mnt/{{ usb_volume_label }}/downloads
      state: directory

  - name: Allow access to peer listening port
    become: yes
    ufw:
      rule: allow
      port: '51413'
      proto: tcp

  - name: Start transmission
    become: yes
    systemd:
      state: started
      name: transmission-daemon

```

```yaml
---

- name: Plex
  hosts: plex

  tasks:
  - name: Install apt-transport-https
    become: yes
    apt:
      name: apt-transport-https
      update_cache: yes
      state: present
  
  - name: Add key
    become: yes
    apt_key:
      url: "https://downloads.plex.tv/plex-keys/PlexSign.key"
      state: present
  
  - name: Create plex list
    become: yes
    copy:
      dest: "/etc/apt/sources.list.d/plexmediaserver.list"
      content: |
        deb https://downloads.plex.tv/repo/deb public main

  - name: Install plex
    become: yes
    apt:
      name: plexmediaserver
      update_cache: yes
      state: present

  - name: Set pi hostname
    become: yes
    hostname:
      name: "{{ host_name }}"
  
  - name: Reboot
    become: yes
    reboot:
```

```yaml
- name: Replace email password
  lineinfile:
    path: /etc/msmtprc
    regexp: '^password'
    line: password {{ansible var like email.password}}
    state: present

- name: Replace block in file
  blockinfile:
    path: /etc/msmtprc
    block: |
      x = 5
      y = {{vars.y}}
```

```yaml
- name: Import playbook x
  import_playbook: x-playbook.yml
- name: Import playbook y
  import_playbook: y-playbook.yml

```
