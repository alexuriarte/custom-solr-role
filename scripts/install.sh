#!/bin/bash
set -o errexit

apt-get update -y
apt-get install -y solr-tomcat
