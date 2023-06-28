
#!/bin/bash
sudo yum update -y
cd ~
git clone https://gitlab.pnnl.gov/perf-lab/bigflowtools/datalife.git
cd datalife 
bash artifacts_sc23/scripts/install_env_dep.sh
wait

cd /home/cc/datalife/evaluation_scripts/performance/1000genome_plot/1000genome_perf_number
bash perf-test.sh

