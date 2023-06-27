#!/usr/bin/env bash

# Exit immediately if any command fails
set -o errexit

# Check if all required arguments are provided
if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <lease_name> <key_name> <instance_name> <optional: floating_ip>"
    exit 1
fi

lease_name="$1"
key_name="$2"
instance_name="$3"
FLOATING_IP_ADDRESS="$4" #optional

net_id="$(openstack network list -f value | head -n 1 | awk '{print $1}')" # sharednet1
echo "sharednet1 Net-ID: $net_id"

# Get the string output of the lease show command
lease_data="$(openstack reservation lease show -f value -c reservations "$lease_name")"
# echo "Lease data:"
# echo "$lease_data"
# Extract the lease_id and network_id using jq
content=$(echo "$lease_data" | jq -s '.[0]')
reservation_id=$(echo "$content" | jq -r '.id')
network_id=$(echo "$content" | jq -r '.network_id')

# Check if the lease_id is empty
if [[ -z "$reservation_id" ]]; then
    echo "Failed to retrieve reserveation ID for '$lease_name'."
    exit 1
fi
echo "Reserveation ID: $reservation_id"

if [[ -n $network_id ]]; then
    echo "Network ID: $network_id"
fi

exe_script=./my_cmd.sh
chmod u+x $exe_script

# openstack port create --network $net_id $lease_name | tee "$lease_name-port.log"
# openstack port show -f value $lease_name 


    # --nic net-id=$my_net_id,v4-fixed-ip="10.52.0.231" \
    # --network "sharednet1" \

sharednet1_id="1a03cf65-8fd6-4fce-94fd-bbaabe68a8e1"
# reservation_id="ae8a7c18-c510-4688-a426-14feefab85c8"
set -x 

openstack server create \
    --image CC-CentOS7 \
    --flavor baremetal \
    --key-name "$key_name" \
    --nic net-id=$sharednet1_id \
    --hint reservation="$reservation_id" \
    --user-data "$exe_script" \
    "$instance_name" | tee "$instance_name-instance.log"