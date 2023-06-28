# Tests on Chameleon Cloud
Two options to run tests. One option reserves the most available compute nodes available, 2nd option reserve the storage_hierarchy nodes.

# Prepare to use chameleon with CLI
## CLI authentication
Follow instructions to [update your password](https://chameleoncloud.readthedocs.io/en/latest/technical/cli.html#cli-authentication) for CLI use.
## Openstack RC file
Pelase be ready to use the chameleon CLI tool with your openstack RC file. Instructions to download: [The OpenStack RC Script](https://chameleoncloud.readthedocs.io/en/latest/technical/cli.html#the-openstack-rc-script)
Replace "your_rc_file" with your own file name.
```
bash install_dep.sh
source your_rc_file.sh
```

# OPT 1: Running tests on general compute nodes
Reserving general compute node what runs performance tests comparing /dev/shm (tmpfs) and it's HDD/SSD.
*** We recommend you to reserve for at least 3 hours. ***\
1. Reserving chammeleon nodes:
```
cd compute_node_scripts
./reservation-1kg.sh <lease_name> <lease_hours> <node note_type>
```
Example: `./reservation-1kg.sh my-lease 4 my-test compute_skylake`\
Enter your lease name, the how many hours (in number) you want the lease, and the node type. \
The available note_types are: `compute_skylake compute_haswell_ib compute_haswell compute_cascadelake compute_cascadelake_r`

2. Starting the baremetal instance:
A ssh keypair will be created if it does not exist in your account. \
Here the floating_ip is optional, you can enter if you have one ready to be used.
```
./bm_instance-1kg.sh <lease_name> <keypair_name> <instance_name> <optional: floating_ip>
```
Example: `./bm_instance-1kg.sh my-lease my_ssh my-test 129.114.108.165`\
If you provided floating_ip on step 2, skip step 3.

3. Accessing the instance:
If you do not have a floating_ip ready, please run below afster you created a instance:
```
./floating_ip_to_insatnce.sh <instance_name>
```

4. Run tests:
Provide keypair and floating ip to kick start the tests inside the instance. \
Make sure to provide the whole file path.
```
./run_test_in_instance.sh <keypair_file_path> <floating_ip>
```

5. View results:
Once you enter the instance with ssh:
```
cat /home/cc/datalife/evaluation_scripts/performance/1000genome_plot/1000genome_perf_number/perf_test_sum.log
```
This will show the time taken for each test to run, usually in below format:
```
SHM performance :
All done (msec): 1357605

HDD performance :
All done (msec): 1603820
```

# OPT 2: Running tests on storage hierarchy node
Reserving storage hierarchy node what runs performance tests comparing /dev/shm (tmpfs), HDD, SSD, and NVME drives.
*** We recommend you to reserve for at least 6 hours. ***\
1. Reserving chammeleon nodes:
```
cd compute_node_scripts
./reservation-1kg.sh <lease_name> <lease_hours> <node note_type>
```
Enter your lease name, the how many hours (in number) you want the lease, and the node type. \
Please note that this type of node is very limited and may be unavailable.

2. Starting the baremetal instance:
A ssh keypair will be created if it does not exist in your account. \
Here the floating_ip is optional, you can enter if you have one ready to be used.
```
./bm_instance-1kg.sh <lease_name> <keypair_name> <instance_name> <optional: floating_ip>
```
If you provided floating_ip on step 2, skip step 3.

3. Accessing the instance:
If you do not have a floating_ip ready, please run below afster you created a instance:
```
./floating_ip_to_insatnce.sh <instance_name>
```

4. Run tests:
Provide keypair and floating ip to kick start the tests inside the instance. \
Make sure to provide the whole file path.
```
./run_test_in_instance.sh <keypair_file_path> <floating_ip>
```

5. View results:
Once you enter the instance with ssh:
```
cat /home/cc/datalife/evaluation_scripts/performance/1000genome_plot/1000genome_perf_number/hierarchy_perf_test_sum.log
```
This will show the time taken for each test to run, usually in below format:
```
SHM performance :
All done (msec): 1357605

HDD performance :
All done (msec): 1603820

SSD performance :
All done (msec): 1357605

NVME performance :
All done (msec): 1357605
```