#!/bin/bash

#Author: DALQUINT - denny.alquinta@oracle.com
#Purpose: This script triggers plugin instrospection. Make sure to always have updated the latest terraform plugin automatically downloaded after executing terraform init
#Copyright (c) 2021, Oracle and/or its affiliates. All rights reserved.

export TF_VAR_tenancy_ocid="ocid1.tenancy.oc1..aaaaaaaaabc4esylkbw3jkbquuluuq4iftuuwnfc2yg2fguo4s7j43exv6pq"
export TF_VAR_user_ocid="ocid1.user.oc1..aaaaaaaazwzvytqwy23ojocvnmaqqn4u2hf3zylpefj5ur3cqmus5cmiso6q"
export TF_VAR_fingerprint="81:0e:bb:e1:75:b4:b7:2c:04:c2:97:e9:a0:aa:4d:36"
export TF_VAR_private_key_path="/home/opc/.ssh/OCI_KEYS/API/auto_api_key.pem"
export TF_VAR_region="us-ashburn-1"
export OUT_DIR="/home/opc/Instrospection"
export COMPARTMENT_OCID="ocid1.compartment.oc1..aaaaaaaabmzf6qa7s2gc4t2svhddjeasst4r5e3h6ifldprh3jvjf3vlqlqq"

./terraform-provider-oci_v4.15.0_x4 -command=export -output_path=$OUT_DIR -compartment_id=$COMPARTMENT_OCI

