#!/usr/bin/env bash

# Exit immediately if any command fails
set -o errexit

# Display a message
echo -e "\e[1;33mThis scripts create a new key pair if it does not exist in your account.\e[0m"


# Check if all required arguments are provided
if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <lease_name> <keypair_name> <instance_name> <optional: floating_ip>"
    exit 1
fi

lease_name="$1"
key_name="$2"
instance_name="$3"
floating_ip_address="$4" #optional
image_name="1kg-tiered-06262023"

# create key pair if not eixst in your account
if ! openstack keypair show "$key_name" >/dev/null 2>&1; then
    # Create the keypair
    openstack keypair create "$key_name" | tee "$key_name.pem"
    chmod 700 "$key_name.pem"
else
    echo "Key pair '$key_name' already exists."
fi


net_id="$(openstack network list -f value | head -n 1 | awk '{print $1}')" # sharednet1
echo "sharednet1 Net-ID: $net_id"

# Get the string output of the lease show command
lease_data="$(openstack reservation lease show -c reservations "$lease_name")"
echo "Lease data: $lease_data"
reservation_id=$(echo "$lease_data" | awk -F'"' '/"id":/{print $4}')

# Check if the lease_id is empty
if [[ -z "$reservation_id" ]]; then
    echo "Failed to retrieve reserveation ID for '$lease_name'."
    exit 1
fi
echo "Reserveation ID: $reservation_id"

# prepare the initial command to be executed on the instance
starting_commands="
#!/bin/bash
sudo yum update -y
"
echo "$starting_commands" > my_cmd.sh
exe_script=./my_cmd.sh
chmod u+x $exe_script


sharednet1_id="1a03cf65-8fd6-4fce-94fd-bbaabe68a8e1"
# reservation_id="ae8a7c18-c510-4688-a426-14feefab85c8"
set -x 

openstack server create \
    --image $image_name \
    --flavor baremetal \
    --key-name "$key_name" \
    --nic net-id=$sharednet1_id \
    --hint reservation="$reservation_id" \
    --user-data "$exe_script" \
    "$instance_name" | tee "$instance_name-instance.log"
set +x

sleep 3 # wait for the instance to be created

# Check if floating IP is available and assign it to the instance
if [[ -n $floating_ip_address ]]; then
    openstack server add floating ip "$instance_name" "$floating_ip_address"
    echo "Your instance is starting now, usually takes about 10 minutes."
    echo "Then ssh into the instance using the following command:"
    echo "ssh -i /path/to/$key_name.pem cc@$floating_ip_address"
fi