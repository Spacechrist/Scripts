#!/bin/bash

# prompt user for a name
read -p "Enter a name for a folder to save the output in : " folder

# create a folder with the specified name
mkdir $folder


# prompt the user for an IP address
read -p "Enter the IP address: " ip

# run nmap with the specified flags and save the output to a file
nmap -sC -sV $ip -oA $folder/quickscan &

# store the PID of the nmap process
pid=$!

# loop until the nmap process is complete
while kill -0 $pid 2> /dev/null; do
  # update the user on the progress of the scan every 5 seconds
  echo "Scanning... please wait"
  sleep 10
done

#cleaning the window
echo "Cleaning the window..."
sleep 3
clear 

# check if port 80, 443, 8000, or 8080 is open
if nmap $ip -p 80,443,8000,8080 | grep "open" > /dev/null; then
  # if any of those ports are open, ask the user if they want to run HTTP enumeration
  read -p "Do you want to run HTTP enumeration (y/n)? " choice
  if [ "$choice" = "y" ]; then
    # if the user says yes, run nmap with the specified flags and save the output to a file
    nmap -sV --script=http-enum $ip -p 80,443,8000,8080 -oA $folder/http-enum &

    # store the PID of the nmap process
    pid=$!

    # loop until the nmap process is complete
    while kill -0 $pid 2> /dev/null; do
      # update the user on the progress of the scan every 5 seconds
      echo "Scanning... please wait"
      sleep 10
    done
  fi
fi

#cleaning the window
echo "Cleaning the window..."
sleep 3
clear 

# ask user if it wants to collect OSINT using Amass
read -p "Do you want to perform active OSINT using Amass? (y/n) " answer

# if user answers "y", ask for domain name and run amass enum
if [ $answer == "y" ]
then
  read -p "Enter domain name: " domain
  echo "Collecting active OSINT using Amass on domain $domain. This may take a few seconds..."
  amass enum -active -d $domain | grep api > $folder/active_osint
fi

#cleaning the window
echo "Cleaning the window..."
sleep 3
clear 

echo "You can find everything inside $folder"
sleep 10
exit

