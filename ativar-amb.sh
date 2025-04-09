#!/bin/bash

# =============================================
# ATIVAÇÃO DO AMBIENTE COMFY_ENV
#
# USO CORRETO:
#   source ativar-ambiente.source
#
# NÃO USE ./ativar-ambiente.source (não funcionará)
# =============================================

# Configurações
CONDA_ENV="comfy_env"
ENV_PATH="./python_embeded/envs/${CONDA_ENV}"

# Cores para mensagens
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verifica se o ambiente existe
if [ ! -d "$ENV_PATH" ]; then
    echo -e "${RED}ERRO: Ambiente Conda não encontrado em:${NC}" >&2
    echo -e "${YELLOW}  $ENV_PATH${NC}" >&2
    return 1 2>/dev/null || exit 1
fi

# Ativação do Conda
if ! source "./python_embeded/bin/activate"; then
    echo -e "${RED}ERRO: Falha ao carregar o Conda embarcado${NC}" >&2
    return 1 2>/dev/null || exit 1
fi

# Ativação do ambiente
if ! conda activate "$ENV_PATH"; then
    echo -e "${RED}ERRO: Falha ao ativar o ambiente '${CONDA_ENV}'${NC}" >&2
    echo -e "${YELLOW}Verifique se:" >&2
    echo -e "1. O ambiente existe em '$ENV_PATH'" >&2
    echo -e "2. O Conda está configurado corretamente${NC}" >&2
    return 1 2>/dev/null || exit 1
fi

# Confirmação
echo -e "\n✅ ${GREEN}Ambiente ativado com sucesso: ${CONDA_ENV}${NC}\n"
echo -e "\nPara sair do ambiente digite: ${GREEN}exit${NC}\n"
echo
