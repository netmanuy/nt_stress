import re, random, time, csv,os,sys
from locust import HttpUser, task, between

class NTstressTestCase(HttpUser):
    #wait_time = between(0.0, 0.0)
    wait_time = between(0.1, 3)

    # Example URL: https://www.google.com/myendpoint/name=<name from csv>&uid=<random string uuid>&points=<1 to 4>

    @task
    def test_case(self):

        # Failure URL. if we detect a redirect to this URL we will consider this as a failure
        failure_url = "http://wpc.79a8.edgecastcdn.net/8079A8/origin/images/liveclicker/test_probe.gif"

        # Characters to pickup for random string
        characters_string = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

        # Targus and Locust folder to read the random names/code from a file
        unique_data_source = open("bzt-configs/unique_codes.csv", "r")
        
        # Load test
        for temporal_unique in unique_data_source:

            # Generate url with \n at the end 
            unique_code = temporal_unique.rstrip("\n")

            # Generate a random string 40 characters of length to be used on random_uid parameter
            random_uid = ''
            for i in range(0, 40):
                random_uid += random.choice(characters_string)

            # Generate random number value between 0 and 4 to be used on points parameter
            points_value = random.randint(0,4)

            # Generate your full URL endpoint with paramenters
            full_url="/myendpoint?name=" + unique_code + "&uid=" + random_uid + "&points=" + str(points_value)

            # Debug mode
            #print(full_url)

            # Catch if the response redirect to a particular url and we consider this url as failure
            with self.client.get(full_url, catch_response=True) as response:   
                print(response.url)
                if response.url == failure_url:
                    response.failure('ERROR: failure url detected')