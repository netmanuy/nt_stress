import re, random, time, csv,os,sys
from locust import HttpUser, task, between

class NTstressTestCase(HttpUser):
    wait_time = between(0.0, 0.0)

    @task
    def test_case(self):

        # Characters to pickup for random string
        characters_string = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

        # Example URL: https://www.google.com/myendpoint/name=<name from csv>&uid=<random string uuid>&points=<1 to 4>

        # Targus container and Locust container
        unique_data_source = open("bzt-configs/unique_codes.csv", "r")
        
        # Load test
        for temporal_unique in unique_data_source:

            # Generate url with \n at the end 
            unique_code = temporal_unique.rstrip("\n")

            # Generate random string from 40 lenght
            random_uid = ''
            for i in range(0, 40):
                random_uid += random.choice(characters_string)

            # Generate dim28 value
            points_value = random.randint(0,4)

            # Generate full URL
            full_url="/myendpoint?name=" + unique_code + "&uid=" + random_uid + "&points=" + str(points_value)

            # Debug mode
            #print(full_url)

            # Call URL
            self.client.get(full_url)