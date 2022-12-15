#!/bin/bash

# prompt user for a name
read -p "Enter a name for a folder to save the output in : " folder

# create a folder with the specified name
mkdir $folder

#prompt user for a initial domain
read -p "Enter a domain name: " domain

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

# ask the user if they want to run HTTP enumeration
read -p "Do you want to run HTTP enumeration (y/n)? " choice

# handle the user's choice
case $choice in
  y)
    # if the user says yes, run nmap with the specified flags and save the output to a file
    nmap -sV --script=http-enum $ip -p 80,443,8000,8080 -oA $folder/http-enum &

    # store the PID of the nmap process
    nmap_pid=$!

    # loop until the nmap process is complete
    while kill -0 $nmap_pid 2> /dev/null; do
      # update the user on the progress of the scan every 5 seconds
      echo "Scanning... please wait"
      sleep 10
    done
    ;;
  n)
    # if the user says no, do nothing
    ;;
  *)
    # if the user enters an invalid choice, display an error message and exit
    echo "Invalid choice. Exiting script."
    exit 1
    ;;
esac

# ask user if it wants to collect passive OSINT  
read -p "Do you want to perform passive enumeration on the $domain  ? (y/n) " answer
if [ $answer == "y" ]; then
  echo "Performing passive domain OSINT gathering on $domain"
  amass enum -passive -d $domain > $folder/passive_osint
fi

# ask user if it wants to collect active OSINT  
read -p "Do you want to perform active enumeration on the $domain  ? (y/n) " answer
if [ $answer == "y" ]; then
  echo "Performing active domain enumeration on $domain. This may take a few seconds..."
  amass enum -active -d $domain > $folder/active_osint
fi


# ask user if it wants to brute-force subdomains?
read -p "Do you want to brute-force subdomains? (y/n) " answer

# if user answers "y"
if [ $answer == "y" ]; then
  echo "Running brute-force on domain $domain. This may take a few seconds..."
  amass enum -active -brute -w /usr/share/wordlists/API_superlist -d $domain -dir $folder
fi

# prompt user and ask "Do you want to perform a intel address scan?"
read -p "Do you want to perform a intel address scan? (y/n) " answer

# if user answers "y", ask if user wants to use the previous IP address or if it will provide a new one.
if [ $answer == "y" ]; then
  read -p "Use previous IP address or (p)rovide a (n)ew one? (p/n) " choice

  # if previous IP address, run amass intel -addr use $ip
  if [ $choice == "p" ]; then
    echo "Running intel address scan using on IP address $ip. This may take a few seconds..."
    amass intel -addr $ip > $folder/intel_address_scan
  fi

  # if user provides a new IP, run amass intel -addr $newip.
  if [ $choice == "n" ]; then
    read -p "Enter the IP address: " newip
    echo "Running intel address scan using on IP address $newip. This may take a few seconds..."
    amass intel -addr $newip > $folder/intel_address_scan
  fi
fi

#cleaning the window
echo "Cleaning the window..."
sleep 3
clear 

echo "You can find the results inside $folder"
sleep 5
exit
### add gobuster