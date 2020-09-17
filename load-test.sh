# Set a uuid in the future we can use this as random filename for reports
UUID=$(cat /proc/sys/kernel/random/uuid)

# Simple debug message
echo "NT stress version 0.2 with Taurus & Locust"
echo "UUID ${UUID}"

# Debug message
echo "Running test"

# Running the test using Locust
locust -f bzt-configs/locustfile.py

# Running the test using Taurus
#bzt nt_stress_taurus.yml -o modules.console.disable=true