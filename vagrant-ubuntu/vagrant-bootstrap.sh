#!/usr/bin/env bash

apt-get update
apt-get install -y r-base
apt-get install -y git

sh /vagrant/vagrant-run-galaxy.sh

