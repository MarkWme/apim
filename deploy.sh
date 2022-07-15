#!/bin/bash
#
# APIM deployment
#
location=westeurope
#
# Choose random name for resources
#
name=apim-$(cat /dev/urandom | base64 | tr -dc '[:lower:]' | fold -w ${1:-5} | head -n 1)

az group create -n $name -l $location -o table

az deployment group create \
    -n $name-$RANDOM \
    -g $name \
    -f ./main.bicep \
    --parameters \
        apiManagementServiceName=$name \
        publisherEmail='mark.whitby@microsoft.com' \
        publisherName='Azure API Management Test' \
    -o table
