#!/bin/bash

keypair_file="$1"
floating_ip="$2"

if [ $# -ne 2 ]; then
    echo "Usage: $0 <keypair_file_path> <floating_ip>"
    exit 1
fi

ssh -i "$keypair_file" cc@"$floating_ip" << EOF
    cd ~
    git clone https://gitlab.pnnl.gov/perf-lab/bigflowtools/datalife.git
    cd datalife/artifacts_sc23/scripts
    bash install_env_dep.sh
    wait
    bash run.sh # generate stats

    cd /home/cc/datalife/evaluation_scripts/performance/1000genome_plot/1000genome_perf_number
    bash hierarchy-perf-test.sh
EOF