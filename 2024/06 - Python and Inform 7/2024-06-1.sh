#!/bin/bash

set -e

python 2024-06-1.py > 2024-06-1.ni
/usr/lib/inform7-ide/inform7 -internal /usr/share/inform7-ide/ 2024-06-1.ni -format=Inform6/32d -debug -release -no-index
/usr/lib/inform7-ide/inform6 -E2wSDG 2024-06-1.i6 2024-06-1.ulx
