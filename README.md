# pivnet-bash-examples

These are some example scripts from the Ops Manager team showing how we use bash to interface with Pivotal Network.

###pivnet-curl-examples.sh and post_data
These two files show several examples of creating a file on PivNet.  The first example `pivnet-curl-examples.sh` uses an external JSON file called post_data.json; the second exaple shows how you can include all the JSON in a single, very long command line.

###pivnet-curl-examples.sh
This is a sanitized version of our actual release script.  Our full release process uses about 6 different scripts, but this is the only one that interacts with PivNet.

Author:  mgoelzer@pivotal.io

