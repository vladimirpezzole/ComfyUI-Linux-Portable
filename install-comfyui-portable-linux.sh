#!/bin/bash

# Cores para mensagens
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para verificar se o comando anterior foi bem sucedido
check_success() {
  if [ $? -ne 0 ]; then
    echo -e "${RED}Erro no comando anterior!${NC}"
    exit 1
  fi
}

echo -e "${GREEN}=== Instalação Portable do ComfyUI para Linux ===${NC}"

# 1. Instalar ComfyUI
echo -e "${YELLOW}[1/5] Verificando ComfyUI...${NC}"
if [ ! -d "ComfyUI" ]; then
  git clone https://github.com/comfyanonymous/ComfyUI.git
  check_success
else
  echo -e "${YELLOW}Diretório ComfyUI já existe. Pulando a clonagem.${NC}"
fi

# 2. Instalar ComfyUI-Manager
echo -e "${YELLOW}[2/5] Verificando ComfyUI-Manager...${NC}"
if [ ! -d "ComfyUI/custom_nodes/ComfyUI-Manager" ]; then
  cd ComfyUI/custom_nodes/ || exit
  git clone https://github.com/Comfy-Org/ComfyUI-Manager.git
  check_success
  cd ../..
else
  echo -e "${YELLOW}ComfyUI-Manager já existe. Pulando a instalação.${NC}"
fi

# 3. Instalar Miniconda
echo -e "${YELLOW}[3/5] Verificando Miniconda...${NC}"
if [ ! -f "./python_embeded/bin/conda" ]; then
  [ ! -f "Miniconda3-latest-Linux-x86_64.sh" ] && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
  check_success
  bash Miniconda3-latest-Linux-x86_64.sh -b -p ./python_embeded
  check_success
  rm Miniconda3-latest-Linux-x86_64.sh
else
  echo -e "${YELLOW}Miniconda já instalado. Pulando a instalação.${NC}"
fi

# 4. Instalar requirements
echo -e "${YELLOW}[4/5] Instalando dependências...${NC}"
./python_embeded/bin/pip install -r ComfyUI/requirements.txt
check_success

# 5. Conclusão
echo -e "${GREEN}[5/5] Instalação concluída com sucesso!${NC}"
echo -e "\nPróximos passos:"
echo -e "1. Configure sua GPU:"
echo -e "   - Para NVIDIA: instale CUDA e torch com suporte a GPU"
echo -e "   - Para AMD/Intel: configure ROCm ou oneAPI"
echo -e "2. Inicie o ComfyUI:"
echo -e "   $ ./python_embeded/bin/python ComfyUI/main.py"
echo -e "\nLembre-se de colocar seus modelos em:"
echo -e "   - ComfyUI/models/checkpoints/"
echo -e "   - ComfyUI/models/loras/"
echo -e "   - ComfyUI/models/controlnet/"

# Tornar o script executável (se não estiver)
chmod +x "$0"
