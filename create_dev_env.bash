#!/bin/bash
set -e
tox --workdir ~/.tox -e dev -v
~/.tox/dev/bin/python -m pip install flake8 black