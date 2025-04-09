#!/bin/bash

# Configurações
CONDA_ENV="comfy_env"  # Nome do ambiente conda
export PYTHONPATH="$PWD"

# Ativação do ambiente (em uma linha)
source "./python_embeded/bin/activate" && conda activate "./python_embeded/envs/${CONDA_ENV}" || { echo "Erro ao ativar ambiente Conda!"; exit 1; }

# Inicialização do ComfyUI >> Porta 8190, acesso via rede, baixa memoria
python ComfyUI/main.py --port 8190 --listen --lowvram 
