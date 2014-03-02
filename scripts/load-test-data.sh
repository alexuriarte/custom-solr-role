#!/bin/bash
# Load test configuration and data for Solr

# Crash eagerly
set -o errexit
set -o nounset

#TODO: Add support for more distributions
install_curl () {
  apt-get -y install curl || echo "You need to install curl first"
}
command -v curl 2>&1 > /dev/null || install_pgrep


# Default to Scalr provided values
# Gracefully fall back if they are not available

: ${SCALR_INTERNAL_IP:=""}
: ${SOLR_HOST:="$SCALR_INTERNAL_IP"}
: ${SOLR_PORT:="8080"}
: ${EXAMPLE_DATA:="https://raw.github.com/scalr-tutorials/custom-solr-role/master/resources/example-data/us-cities.xml"}

SOLR_URL=http://$SOLR_HOST:$SOLR_PORT/solr/update
TMP_FILE=/tmp/$$-solr-test.xml

CURL_OPTS="--fail"


echo Starting upload script
echo
echo SOLR_HOST   :   $SOLR_HOST
echo SOLR_PORT   :   $SOLR_PORT
echo SOLR_URL    :   $SOLR_URL

if [ -z "$SOLR_HOST" ] || [ -z "$SOLR_PORT" ];
then
        echo You did not set the SOLR_HOST and / or SOLR_PORT environment vars >&2
        exit 1
fi

# Retrieve and load test data

echo "Downloading Solr data form: $EXAMPLE_DATA"
cd $HOME
curl $CURL_OPTS "$EXAMPLE_DATA" > $TMP_FILE

cat $TMP_FILE

echo "Uploading Solr data from: $TMP_FILE"
echo

curl $CURL_OPTS "$SOLR_URL?commit=true" --data-binary @$TMP_FILE -H 'Content-type:application/xml' 

# Load the data
echo "Uploaded Solr data"

# Clear the temporary file
rm $TMP_FILE
