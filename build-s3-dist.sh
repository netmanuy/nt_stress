#!/bin/bash


# Check to see if input has been provided:
if [ -z "$1" ]; then
    echo "Please provide the source bucket  name, if the bucket not exist we will try to create the bucket"
    echo "For example: ./build-s3-dist.sh <my bucket>"
    exit 1
fi

# Read bucket name
BUCKET_NAME="${1}"

# Check if the bucket already exist
BUCKET_EXISTS=$(aws s3api head-bucket --bucket ${BUCKET_NAME} 2>&1 || true)
if [ -z "$BUCKET_EXISTS" ]; then

    # Print message
    echo "This bucket already exist, we are trying to upload the code here."

    # Enabling versioning 
    aws s3api put-bucket-versioning --bucket ${BUCKET_NAME} --versioning-configuration Status=Enabled
else
    # Print message
    echo "Creating new bucket to upload the code."

    # Create bucket
    aws s3api create-bucket --bucket ${BUCKET_NAME}

    # Wait until bucket exist and set versioning
    aws s3api wait bucket-exists --bucket my-bucket

    # Enable versioning
    aws s3api put-bucket-versioning --bucket ${BUCKET_NAME} --versioning-configuration Status=Enabled
fi

# Get reference for all important folders
template_dir="$PWD"
build_dist_dir="$template_dir/regional-s3-assets"

echo "------------------------------------------------------------------------------"
echo "Rebuild distribution"
echo "------------------------------------------------------------------------------"
rm -rf $build_dist_dir
mkdir -p $build_dist_dir

[ -e $build_dist_dir ] && rm -r $build_dist_dir
mkdir -p $build_dist_dir

echo "------------------------------------------------------------------------------"
echo "Creating container deployment package"
echo "------------------------------------------------------------------------------"
zip -q -r9 regional-s3-assets/container.zip *

echo "------------------------------------------------------------------------------"
echo "Upload S3 Packaging Complete"
echo "------------------------------------------------------------------------------"
aws s3 cp ./regional-s3-assets/ s3://${BUCKET_NAME}/ --recursive --acl bucket-owner-full-control