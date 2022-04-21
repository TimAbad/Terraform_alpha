#!/bin/sh
apt update && apt install ansible -y
git clone https://github.com/TimAbad/dashboard.git
ansible-playbook -i localhost dashboard/deploy_app_test.yml
