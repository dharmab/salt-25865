#!/bin/sh

mkdir -p /srv/salt/{'base','dev','test'}
cp /vagrant/top.sls /srv/salt/base/top.sls
yum -y install epel-release
yum -y install git python-pygit2
