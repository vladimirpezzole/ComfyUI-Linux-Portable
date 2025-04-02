#!/bin/bash
export PYTHONPATH="$PWD"
source ./python_embeded/bin/activate
python ComfyUI/main.py --port 8190 --listen
