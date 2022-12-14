#!/bin/bash

# prompt the user for an IP address
read -p "Enter the IP address: " ip

# run nmap with the specified flags and save the output to a file
nmap -sC -sV $ip -oA quickscan &

# store the PID of the nmap process
pid=$!

# loop until the nmap process is complete
while kill -0 $pid 2> /dev/null; do
  # update the user on the progress of the scan every 5 seconds
  echo "Scanning... please wait"
  sleep 10
done

# check if port 80, 443, 8000, or 8080 is open
if nmap $ip -p 80,443,8000,8080 | grep "open" > /dev/null; then
  # if any of those ports are open, ask the user if they want to run HTTP enumeration
  read -p "Do you want to run HTTP enumeration (y/n)? " choice
  if [ "$choice" = "y" ]; then
    # if the user says yes, run nmap with the specified flags and save the output to a file
    nmap -sV --script=http-enum $ip -p 80,443,8000,8080 -oA http-enum &

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
