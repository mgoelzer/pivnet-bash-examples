#!/bin/bash

#
# Parameters (change these each time)
#
RELEASE_VERSION=1.5.5.0
# You could add "-RC5" or whatever to the end of the variable below:
RELEASE_VERSION_IN_FILENAMES=$RELEASE_VERSION
RELEASE_DATE="2015/09/01"
# Choices:  openstack, vsphere, vcd, aws
PLATFORM_CHOICE=openstack
# Set to 1 if you just want to run the pivnet product creation part (no S3 upload)
SKIP_UPLOAD_TO_PIVNET_S3=0

#
# Program configuration based on desired IaaS release
#
if [ "$PLATFORM_CHOICE" == "openstack" ]; then
	FILENAME=pcf-openstack-${RELEASE_VERSION_IN_FILENAMES}.raw
	PIVNET_HUMAN_FILENAME="Pivotal Cloud Foundry Ops Manager for OpenStack (Beta)"
	SYSTEM_REQUIREMENTS="OpenStack IceHouse or Juno with patch https://bugs.launchpad.net/nova/+bug/1396854"
	FILE_INCLUDES="Raw OpenStack Image"
elif [ "$PLATFORM_CHOICE" == "aws" ]; then
	FILENAME=OpsManager${RELEASE_VERSION_IN_FILENAMES}onAWSFulfillmentInstructions.pdf
	PIVNET_HUMAN_FILENAME="Pivotal Cloud Foundry Ops Manager for AWS"
	SYSTEM_REQUIREMENTS=""
	FILE_INCLUDES=""
elif [ "$PLATFORM_CHOICE" == "vsphere" ]; then
	FILENAME=pcf-vsphere-${RELEASE_VERSION_IN_FILENAMES}.ova
	PIVNET_HUMAN_FILENAME="Pivotal Cloud Foundry Ops Manager vSphere"
	SYSTEM_REQUIREMENTS="vSphere 5.1, 5.5, and 6.0"
	FILE_INCLUDES=""
elif [ "$PLATFORM_CHOICE" == "vcd" ]; then
	FILENAME=pcf-vcd-${RELEASE_VERSION_IN_FILENAMES}.tar
	PIVNET_HUMAN_FILENAME="Pivotal Cloud Foundry Ops Manager for vCloud Air & vCD"
	#SYSTEM_REQUIREMENTS="vCD 5.1, 5.2 or 5.6 (vCloud Air). Will not function on vCD API 6.0+"
	SYSTEM_REQUIREMENTS="vCD 5.1, 5.2 or 5.6 (vCloud Air). Works with vCD API 6.0+"
	FILE_INCLUDES=""
else
	echo "aborting:  must pick a valid platform"
	exit 1
fi

#
# Constants (don't change)
#
PIVNET_TOKEN=xxxxxxxxxxxxxxxxxxxxx
URL_PREFIX="https://network.pivotal.io"
PRODUCT_SLUG="ops-manager"


##
##  Step 1:  Copy local file to PivNet bucket
##
if [ ! -f "$FILENAME" ]; then
  echo "aborting:  your file must be called $FILENAME in current directory"
  exit 1
fi
echo "Starting for $PLATFORM_CHOICE with filename $FILENAME"
MD5SUM=`md5sum $FILENAME | sed -e 's/\([a-z0-9]*\).*/\1/'`
echo "MD5:  $MD5SUM"
FILE_SIZE=`stat --printf=%s $FILENAME`

if [ ! $SKIP_UPLOAD_TO_PIVNET_S3 -eq 1 ]; then
	echo "Starting upload to Piv Net S3 bucket"
	s3cmd --config ~/.s3cfg-pivnet --mime-type=binary/octet-stream put $FILENAME s3://pivotalnetwork/product_files/Pivotal-CF/$FILENAME
else
	echo "Skipping upload to Piv Net S3 bucket"
fi

##
##  Step 2: Create product file entry on piv net linked to file we just uploaded
##
curl -i -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -H "Authorization: Token $PIVNET_TOKEN" \
  -XPOST -d '
{
  "product_file": {
    "name": "'"$PIVNET_HUMAN_FILENAME"'",
    "aws_object_key": "product_files/Pivotal-CF/'$FILENAME'",
    "description": "",
    "docs_url": null,
    "file_type": "Software",
    "file_version": "'$RELEASE_VERSION'",
    "included_files": [
	"'"$FILE_INCLUDES"'"
    ],
    "md5": "'$MD5SUM'",
    "platforms": [

    ],
    "released_at": "'$RELEASE_DATE'",
    "size": '$FILE_SIZE',
    "system_requirements": [
	"'"$SYSTEM_REQUIREMENTS"'"
    ],
    "_links": {
      "self": {
        "href": "https://network.pivotal.io/api/v2/products/ops-manager/product_files/130"
      }
    }
  }
}' \
  "$URL_PREFIX/api/v2/products/$PRODUCT_SLUG/product_files"

exit




