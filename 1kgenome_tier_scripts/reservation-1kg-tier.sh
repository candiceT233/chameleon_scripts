#!/usr/bin/env bash

# Exit immediately if any command fails
set -o errexit

# Display a message to ensure account is configured to UTC time
echo -e "\e[1;33mMake sure your chameleon account is configured to UTC time.\e[0m"

# Check if OS_USERNAME or OS_PROJECT_ID environment variables are not set
if [[ -z "$OS_USERNAME" || -z "$OS_PROJECT_ID" ]]; then
    echo "The OS_USERNAME or OS_PROJECT_ID environment variable is not set."
    echo "Please provide the path of the CHI-221071-openrc.sh file:"
    read -rp "OpenStack RC file path: " OPENSTACK_RC_FILE

    if [[ -z "$OPENSTACK_RC_FILE" ]]; then
        echo "Please refer to the documentation on how to download your OpenStack RC script:"
        echo "https://chameleoncloud.readthedocs.io/en/latest/technical/cli.html#the-openstack-rc-script"
        exit 1
    fi

    source "$OPENSTACK_RC_FILE"
else
    echo "User $OS_USERNAME with Project ID $OS_PROJECT_ID has been configured for project access."
fi

# Check if lease name is provided as an argument
if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <lease_name> <lease_hours(number)>"
    echo "Please provide a lease name as an argument."
    exit 1
fi

# Assign the lease name from the argument
lease_name="$1"
lease_hours="$2"

if [[ "$OSTYPE" == *darwin* ]]; then
    # Get the current UTC time and add 1
    current_time=$(date -u +"%Y-%m-%d %H:%M")
    start_time=$(date -u -v+1M +'%Y-%m-%d %H:%M')
    end_time=$(date -u -v+"$lease_hours"H +'%Y-%m-%d %H:%M')
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Get the current UTC time and add 1 minutes
    current_time=$(date -u +'%Y-%m-%d %H:%M')
    start_time=$(date -u -d '+1 minutes' +'%Y-%m-%d %H:%M')
    end_time=$(date -u -d "+$lease_hours hours" +'%Y-%m-%d %H:%M')
else
    echo "Please hardcode the current UTC time, \"start_time\" and \"end_time\" in script."
    echo "Time format: \"YYYY-MM-DD HH:MM\""
fi

# Display the current UTC time, start time, and end time
echo "Current UTC time: $current_time"
echo "Lease start time: $start_time"
echo "Lease end time: $end_time"
echo ""


echo "Creating lease [$lease_name] that runs for [$lease_hours] hours..."
set -x


# Run the openstack command with the provided lease name
openstack reservation lease create \
  --reservation min=1,max=1,resource_type=physical:host,resource_properties='["=", "$uid", "21945871-35b6-4d74-9af7-af4c9cd86b70"]' \
  --start-date "$start_time" \
  --end-date "$end_time" \
  "$lease_name" | tee "$lease_name-creation.log"

openstack reservation lease show -f json $lease_name | tee "$lease_name.json"