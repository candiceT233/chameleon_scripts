
#!/usr/bin/env bash

# Exit immediately if any command fails
set -o errexit

# Check if all required arguments are provided
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <instance_name>"
    exit 1
fi


instance_name="$1"

# floating ip info file
fip_info="$instance_name-fip.log"

fip_to_instance () {
    openstack floating ip create public | tee $fip_info
    echo " Floating IP information saved to $fip_info"

    # floating_ip_address=$(grep -oP "(?<=floating_ip_address \| )\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" "$fip_info")
    floating_ip_address=$(grep -oE 'floating_ip_address \| ([0-9]{1,3}\.){3}[0-9]{1,3}' "$fip_info" | awk '{print $NF}')
    echo "IP Address: $floating_ip_address"

    openstack server add floating ip "$instance_name" "$floating_ip_address"
    echo "Now you can ssh into the instance using the following command:"
    echo "ssh -i /path/to/ssh_key cc@$floating_ip_address"
}

fip_to_instance

# Display a message to the user
echo -e "\e[1;33mPlease make sure to clean up your floating ip after tests:\e[0m"
echo "openstack server remove floating ip $floating_ip_address"
echo "openstack floating ip delete $floating_ip_address"