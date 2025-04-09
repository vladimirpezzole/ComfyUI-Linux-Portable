#!/bin/bash

# Configurações
CONDA_ENV="comfy_env"
PORT="8190"

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# --- Interface de Seleção ---
clear
echo -e "${YELLOW}==================================================${NC}"
echo -e "${YELLOW}  SELECIONE O MODO DE EXECUÇÃO                   ${NC}"
echo -e "${YELLOW}==================================================${NC}"
echo -e "1. NVIDIA (GPU)"
echo -e "2. AMD (GPU)"
echo -e "3. CPU (Sem aceleração)"
echo -e "ESC para sair"
echo -e "${YELLOW}==================================================${NC}"

while true; do
    read -n 1 -p "Escolha uma opção (1/2/3/ESC): " choice
    echo
    
    case $choice in
        $'\x1b') # ESC key
            echo -e "${RED}Operação cancelada pelo usuário.${NC}"
            exit 0
            ;;
        1)
            echo -e "${GREEN}Selecionado: Modo NVIDIA${NC}"
            args="--gpu-only"
            break
            ;;
        2)
            echo -e "${GREEN}Selecionado: Modo AMD${NC}"
            args="--amd"
            break
            ;;
        3)
            echo -e "${GREEN}Selecionado: Modo CPU${NC}"
            args="--cpu"
            break
            ;;
        *)
            echo -e "${RED}Opção inválida! Tente novamente.${NC}"
            ;;
    esac
done

# --- Inicialização do Ambiente ---
echo -e "${GREEN}=== Iniciando ComfyUI ===${NC}"
echo -e "Porta: ${PORT}"
echo -e "Acesso via rede: http://$(hostname -I | awk '{print $1}'):${PORT}"

# Ativação segura do ambiente
source "./python_embeded/bin/activate"
conda activate "./python_embeded/envs/${CONDA_ENV}" || {
    echo -e "${RED}Erro ao ativar ambiente Conda!${NC}"
    exit 1
}

# Verificação do ambiente ativo
ACTIVE_ENV=$(conda env list | grep '*' | awk '{print $1}')
# Confirmação
echo -e "\n✅ ${GREEN}Ambiente ativado com sucesso: ${ACTIVE_ENV}${NC}\n"

# --- Execução ---
echo -e "${GREEN}Iniciando servidor...${NC}"
exec python ComfyUI/main.py --port $PORT --listen $args
