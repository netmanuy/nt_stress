# Set a uuid for the resultsxml file name in S3
UUID=$(cat /proc/sys/kernel/random/uuid)

#echo "S3_BUCKET:: ${S3_BUCKET}"
#echo "TEST_ID:: ${TEST_ID}"
echo "NT stress version 0.1 with Locust"
echo "UUID ${UUID}"

echo "Running test"
locust -f bzt-configs/locustfile.py