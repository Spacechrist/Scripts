#Simple python script to test the security of a web application's authentication system:
import argparse
import requests

# Create an ArgumentParser object to parse the command-line arguments
parser = argparse.ArgumentParser()

# Add arguments for the login URL
parser.add_argument("-u", "--url", help="The URL of the login page")

# Parse the command-line arguments
args = parser.parse_args()

# Set the URL of the login page to the value specified by the -u/--url argument
login_url = args.url

# Set the common admin username and passwords to test, 
common_admin_usernames = ["name1", "name2"] 
common_admin_passwords = ["pw1", "pw2", "pw3"]

# Loop through the common admin usernames and passwords
for username in common_admin_usernames:
  for password in common_admin_passwords:
    # Set the login credentials
    login_data = {"username": username, "password": password}

    # Send a POST request to the login URL with the login credentials
    response = requests.post(login_url, data=login_data)

    # If the response contains the string "login success", the authentication was successful
    if "success" in response.text:
      print(f"Authentication successful with username '{username}' and password '{password}'")
    else:
      print(f"Authentication failed with username '{username}' and password '{password}'")