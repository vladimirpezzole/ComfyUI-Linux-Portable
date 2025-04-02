#!/bin/bash
export PYTHONPATH="$PWD"
source ./python_embeded/bin/activate
python ComfyUI/main.py --port 8190 --listen --lowvram #Porta 8190, acesso via rede, baixa memoria
