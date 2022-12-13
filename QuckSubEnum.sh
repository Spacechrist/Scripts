#!/bin/bash

echo "Enter the domain name: "
read domain

# Use wfuzz to enumerate the subdomains of the specified domain and only return http response 200
wfuzz -c -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -u $domain/FUZZ -H "Host: FUZZ.$domain" --sc 200
