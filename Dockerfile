FROM blazemeter/taurus
LABEL maintainer="Sebastian Delgado (Twitter @netman_uy)"

# Create Stress test directory
WORKDIR /data/nt_stress

# Copying code into container
COPY nt_stress_taurus.yml /data/nt_stress/
COPY load-test.sh /data/nt_stress/
COPY bzt-configs/unique_codes.csv /data/nt_stress/bzt-configs/unique_codes.csv
COPY bzt-configs/locustfile.py /data/nt_stress/bzt-configs/locustfile.py

# Add permission
RUN chmod 755 /data/nt_stress/load-test.sh

# Expose port
EXPOSE 8089

# Run stress test
ENTRYPOINT ["sh", "-c","./load-test.sh"]