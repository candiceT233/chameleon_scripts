openstack server create \
--image CC-CentOS8 \
--flavor baremetal \
--key-name <key_name> \
--nic net-id=<sharednet1_id> \
--hint reservation=<reservation_id> \
my-instance