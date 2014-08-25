#!/bin/bash
# Load test configuration and data for Solr


# Deploy a Solr configuration
# Script parameters:
# - (Global) SOLR_CONFIG_RESOURCE: where the Solr config should be found
#            (no trailing slash) this should be accessible via curl and
#            contain the following files:
#                - schema.xml
#                - solrconfig.xml
#                - stopwords.txt

# Crash eagerly, exit on non-existent variables
set -o errexit
set -o nounset


# Set defaults

: ${TOMCAT_WEBROOT:="/var/lib/tomcat6/webapps/ROOT"}
: ${SOLR_CONF:="/etc/solr/conf"}
: ${SOLR_CONFIG_RESOURCE:=""}

apt-get -y install curl

CURL_OPTS="--fail --remote-name --location --sslv3"

if [ -z "$SOLR_CONFIG_RESOURCE" ];
then
        echo You did not set the SOLR_CONFIG_RESOURCE Global Variable >&2
        exit 1
fi

# Retrieve configuration files
echo "Deploying Solr config from $SOLR_CONFIG_RESOURCE to $SOLR_CONF"
cd $SOLR_CONF
curl $CURL_OPTS "$SOLR_CONFIG_RESOURCE/schema.xml"
curl $CURL_OPTS "$SOLR_CONFIG_RESOURCE/solrconfig.xml"
curl $CURL_OPTS "$SOLR_CONFIG_RESOURCE/stopwords.txt"
echo "Loaded Solr config"

# Restart Solr with new config
service tomcat6 restart
echo "Reloaded Solr"
