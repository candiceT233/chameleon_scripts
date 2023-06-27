#!/usr/bin/env bash

# Exit immediately if any command fails
set -o errexit

# Display a message to ensure account is configured to UTC time
echo -e "\e[1;33mThis scripts create a new key pair if it does not exist in your account.\e[0m"


# Check if all required arguments are provided
if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <lease_name> <keypair_name> <instance_name> <optional: floating_ip>"
    # echo "CLI INFO: create your key pair first using 'openstack keypair create <key_name>'"
    # echo "GUI INFO: https://chameleoncloud.readthedocs.io/en/latest/technical/gui.html#key-pairs"
    exit 1
fi

lease_name="$1"
key_name="$2"
instance_name="$3"
floating_ip_address="$4" #optional
image_name="CC-CentOS7"

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
lease_data="$(openstack reservation lease show -f value -c reservations "$lease_name")"
content=$(echo "$lease_data" | jq -s '.[0]')
reservation_id=$(echo "$content" | jq -r '.id')

# Check if the lease_id is empty
if [[ -z "$reservation_id" ]]; then
    echo "Failed to retrieve reserveation ID for '$lease_name'."
    exit 1
fi
echo "Reserveation ID: $reservation_id"

# prepare the script to be executed on the instance
starting_commands="
#!/bin/bash
sudo yum update -y
cd ~
git clone https://gitlab.pnnl.gov/perf-lab/bigflowtools/datalife.git
cd datalife 
bash artifacts_sc23/scripts/install_env_dep.sh
wait

cd /home/cc/datalife/evaluation_scripts/performance/1000genome_plot/1000genome_perf_number
bash 1kgenome_1node_parallel_tierd.sh SHM &> tee SHM-PERF-TEST.log
"
echo "$starting_commands" > my_cmd.sh
exe_script=my_cmd.sh
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
    echo "Your instance is starting now, usually 10 minutes."
    echo "Then ssh into the instance using the following command:"
    echo "ssh -i /path/to/$key_name.pem cc@$floating_ip_address"
fi