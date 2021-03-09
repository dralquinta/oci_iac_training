#!/bin/bash

#Author: DALQUINT - denny.alquinta@oracle.com
#Purpose: This script triggers plugin instrospection. Make sure to always have updated the latest terraform plugin automatically downloaded after executing terraform init
#Copyright (c) 2021, Oracle and/or its affiliates. All rights reserved.

export TF_VAR_tenancy_ocid="ocid1.tenancy.oc1..FOOBAR"
export TF_VAR_user_ocid="ocid1.user.oc1..FOOBAR"
export TF_VAR_fingerprint="API:KEY:FINGERPRINT"
export TF_VAR_private_key_path="/home/opc/.ssh/OCI_KEYS/API/auto_api_key.pem"
export TF_VAR_region="us-ashburn-1"
export OUT_DIR="/home/opc/Instrospection"
export COMPARTMENT_OCID="ocid1.compartment.oc1..FOOBAR

./terraform-provider-oci_v4.15.0_x4 -command=export -output_path=$OUT_DIR -compartment_id=$COMPARTMENT_OCI

