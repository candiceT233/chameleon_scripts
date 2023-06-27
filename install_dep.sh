#!/usr/bin/env bash

# Check Python version
# python_version=$(python -c "import sys; print('.'.join(map(str, sys.version_info[:3])))")
python_version=$(python3 -c "import sys; print('.'.join(map(str, sys.version_info[:3])))")
required_version="3.4"

if python -c "import sys; exit(not sys.version_info >= (3, 4))"; then
    echo "Python version $python_version is compatible. Proceeding with installation..."
else
    echo "Error: Python version $python_version is not compatible. Please install Python $required_version or higher."
    exit 1
fi

# Install dependencies
python3 -m pip install python-openstackclient
python3 -m pip install git+https://github.com/ChameleonCloud/python-blazarclient.git@chameleoncloud/xena
python3 -m pip install python-neutronclient