#!/bin/bash

# prompt the user for a name for the folder to create
echo "Enter a name for the folder to create: "
read folder_name

# create the folder
mkdir $folder_name

# move into the new folder
cd $folder_name

# prompt the user for the target IP address
echo "Enter the IP address of the target to scan: "
read target_ip

# run the nmap scan with the -sC and -sV options
nmap -sC -sV $target_ip > quickscan.txt

# ask the user if they want to run a directory enumeration
echo "Do you want to run a directory enumeration with gobuster (y/n)? "
read run_enum

# if the user wants to run a directory enumeration, prompt for the URL and run gobuster
if [ $run_enum == "y" ]
then
  echo "Enter the URL to enumerate: "
  read target_url

  gobuster dir -u $target_url -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt > directoryenum.txt
fi

# if the user does not want to run a directory enumeration, close the script
if [ $run_enum == "n" ]
then
  exit
fi
