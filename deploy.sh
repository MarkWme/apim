#!/bin/bash
set -x
#
# APIM deployment
#
location=westeurope
#
# Choose random name for resources
#
name=apim-$(cat /dev/urandom | base64 | tr -dc '[:lower:]' | fold -w ${1:-5} | head -n 1)

#
# Calculate next available network address space
#
number=$(az network vnet list --query "[].addressSpace.addressPrefixes" -o tsv | cut -d . -f 2 | sort | tail -n 1)
if [[ -z $number ]]
then
    number=0
fi
networkNumber=$(expr $number + 1)
#
# Set network and subnet prefixes
#
virtualNetwork=10.${networkNumber}.0.0/16
apimSubnet=10.${networkNumber}.0.0/23

az group create -n $name -l $location -o table

az deployment group create \
    -n $name-$RANDOM \
    -g $name \
    -f ./main.bicep \
    --parameters \
        name=$name \
        publisherEmail='mark.whitby@microsoft.com' \
        publisherName='Azure API Management Test' \
        virtualNetworkCidr=$virtualNetwork \
        apimSubnetCidr=$apimSubnet \
    -o table
