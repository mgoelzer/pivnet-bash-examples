###########################################################################
#
# curl examples
#
###########################################################################


#
# This gets 1.5.0.0 AWS PDF
#
curl -i -H "Accept: application/json" -H "Content-Type: application/json" \
  -H "Authorization: Token xxxxxxxxxxxxxxxx" \
  -XGET "https://network.pivotal.io/api/v2/products/pivotal-cf/product_files/2097"


#
# This works to create a new product file on Piv Net
#
curl -i -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -H "Authorization: Token $PIVNET_TOKEN" \
  -XPOST -d "@post_data" \
  "$URL_PREFIX/api/v2/products/$PRODUCT_SLUG/product_files"

#
# This does the same thing but without the separate file
#
curl -i -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -H "Authorization: Token $PIVNET_TOKEN" \
  -XPOST -d '
{
  "product_file": {
    "aws_object_key": "product_files/Pivotal-CF/OpsManager1.5.0.0onAWSFulfillmentInstructions.pdf",
    "description": "AWS PDF",
    "docs_url": null,
    "file_type": "Software",
    "file_version": "1.5.0.0",
    "included_files": [

    ],
    "md5": "123456789",
    "name": "Bananas - Product File 9",
    "platforms": [

    ],
    "released_at": "2015/07/10",
    "size": 3,
    "system_requirements": [

    ],
    "_links": {
      "self": {
        "href": "https://network.pivotal.io/api/v2/products/pivotal-cf/product_files/130"
      }
    }
  }
}' \
  "$URL_PREFIX/api/v2/products/$PRODUCT_SLUG/product_files"
