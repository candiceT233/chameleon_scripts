
#!/usr/bin/env bash

# Exit immediately if any command fails
set -o errexit

# Check if all required arguments are provided
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <instance_name>"
    echo "Commands for using floating ip: allocate or attach"
    exit 1
fi


instance_name="$1"

# floating ip info file
fip_info="$instance_name-fip.log"

fip_to_instance () {
    openstack floating ip create public | tee $fip_info
    echo " Floating IP information saved to $fip_info"

    floating_ip_address=$(grep -oP "(?<=floating_ip_address \| )\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" "$fip_info")
    # echo floating_ip_address: $floating_ip_address

    openstack server add floating ip "$instance_name" "$floating_ip_address"

}



fip_to_instance