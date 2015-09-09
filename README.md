# pivnet-bash-examples

These are some example scripts from the Ops Manager team showing how we use bash to interface with Pivotal Network.

###`pivnet-curl-examples.sh` and `post_data`
These two files show several examples of interacting with PivNet, including two ways of creating a product.  The first product creation example in `pivnet-curl-examples.sh` uses an external JSON file called `post_data.json`; the second exaple shows how you can include all the JSON in a single, very long command line so that no external JSON file is required.

###`pivnet-curl-examples.sh`
This is a sanitized version of our actual release script.  We release for four different IaaS'es, so there is conditional logic at the top.  The curl commands come next; they show (1) how we actually get these artifacts into the PivNet S3 bucket, and then (2) how we create the product entry on PivNet and link it to the S3 object we just created.  (Note that creation of the release is done manually before running this script.)

Author:  mgoelzer@pivotal.io

