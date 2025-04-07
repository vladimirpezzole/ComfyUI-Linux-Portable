#!/bin/bash
set -euo pipefail

# Configurações
LOG_FILE="install.log"
PYTHON_VERSION="3.10"
CONDA_ENV="comfy_env"

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- Verificação de comandos essenciais ---
check_command() {
    command -v "$1" >/dev/null 2>&1 || {
        echo -e "${RED}Erro: $1 não encontrado. Instale-o primeiro.${NC}"
        exit 1
    }
}

check_command wget
check_command git
check_command unzip

# --- Verificação de execução por double-click ---
if [ ! -t 0 ]; then
    if ! command -v x-terminal-emulator &> /dev/null; then
        echo -e "${RED}Erro: Nenhum emulador de terminal encontrado!${NC}"
        exit 1
    fi
    x-terminal-emulator -e "$0"
    exit 0
fi

# --- Função de tratamento de erros ---
check_success() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}Falha na etapa: $1${NC}"
        echo "Verifique o log: $LOG_FILE"
        exit 1
    fi
}

# --- Confirmação de instalação ---
clear
echo -e "${YELLOW}==================================================${NC}"
echo -e "${YELLOW}  INSTALAÇÃO DO COMFYUI + MINICONDA PORTÁTIL      ${NC}"
echo -e "${YELLOW}==================================================${NC}"
echo -e "\nEste script irá:"
echo -e "1. Instalar/Atualizar o ComfyUI"
echo -e "2. Instalar o Miniconda localmente"
echo -e "3. Configurar um ambiente Python dedicado\n"

read -t 30 -p "Deseja continuar com a instalação? (S/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]] && [ -n "$REPLY" ]; then
    echo -e "${RED}Instalação cancelada pelo usuário.${NC}"
    exit 0
fi

# --- Início da instalação ---
exec > >(tee -a "$LOG_FILE") 2>&1
trap 'echo -e "${RED}\nInstalação interrompida!${NC}"; exit' SIGINT

echo -e "${GREEN}=== Iniciando instalação ===${NC}"

# 1. ComfyUI
echo -e "${YELLOW}[1/5] Atualizando ComfyUI...${NC}"
if [ -d "ComfyUI" ]; then
  (cd ComfyUI && git pull) || check_success "git-pull ComfyUI"
else
  git clone https://github.com/comfyanonymous/ComfyUI.git || check_success "git-clone ComfyUI"
fi

# 2. ComfyUI-Manager
echo -e "${YELLOW}[2/5] Configurando ComfyUI-Manager...${NC}"
if [ -d "ComfyUI/custom_nodes/ComfyUI-Manager" ]; then
  (cd ComfyUI/custom_nodes/ComfyUI-Manager && git pull) || check_success "manager-update"
else
  (cd ComfyUI/custom_nodes/ && git clone https://github.com/Comfy-Org/ComfyUI-Manager.git) || check_success "manager-install"
fi

# 3. Miniconda
echo -e "${YELLOW}[3/5] Instalando Miniconda...${NC}"
if [ ! -f "./python_embeded/bin/conda" ]; then
  if [ ! -f "Miniconda3-latest-Linux-x86_64.sh" ]; then
    wget --tries=3 --retry-connrefused https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh || check_success "download Miniconda"
  fi
  bash Miniconda3-latest-Linux-x86_64.sh -b -p ./python_embeded || check_success "instalação Miniconda"
  ./python_embeded/bin/conda create -n "$CONDA_ENV" python="$PYTHON_VERSION" -y || check_success "criação de ambiente"
fi

# 4. Dependências
echo -e "${YELLOW}[4/5] Instalando dependências...${NC}"
./python_embeded/bin/conda run -n "$CONDA_ENV" pip install --no-cache-dir -r ComfyUI/requirements.txt || check_success "instalação de dependências"

# 5. Verificação final
echo -e "${YELLOW}[5/5] Verificando instalação...${NC}"
if [ ! -f "./python_embeded/bin/python" ]; then
    echo -e "${RED}Erro: Python embedded não encontrado!${NC}"
    exit 1
fi

# --- Conclusão ---
echo -e "${GREEN}==================================================${NC}"
echo -e "${GREEN} Instalação concluída com sucesso! ${NC}"
echo -e "${GREEN}==================================================${NC}"
echo -e "\nPróximos passos:"
echo -e "1. Configure sua GPU:"
echo -e "   - NVIDIA: Instale CUDA e torch com suporte a GPU"
echo -e "   - AMD/Intel: Configure ROCm ou oneAPI"
echo -e "2. Inicie o ComfyUI:"
echo -e "   $ ./python_embeded/bin/python ComfyUI/main.py"
echo -e "\nDiretórios importantes:"
echo -e "   Modelos: ComfyUI/models/checkpoints/"
echo -e "   Configurações: ComfyUI/configs/"
echo -e "   Custom Nodes: ComfyUI/custom_nodes/"

# Garantir permissões de execução
chmod +x "$0"
chmod +x ComfyUI/*.sh 2>/dev/null || true

echo -e "\n${GREEN}Script finalizado. Verifique o log em $LOG_FILE${NC}"
