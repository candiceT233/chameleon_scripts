#!/bin/bash
sudo yum update -y
cd ~
git clone https://gitlab.pnnl.gov/perf-lab/bigflowtools/datalife.git
cd datalife/artifacts_sc23/scripts
bash install_env_dep.sh
wait
bash run.sh # generate stats

cd /home/cc/datalife/evaluation_scripts/performance/1000genome_plot/1000genome_perf_number
bash hierarchy-perf-test.sh
