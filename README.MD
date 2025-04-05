
##  📦  "ComfyUI Linux Portable" para Linux

<hr>

### Considerações iniciais

Aqui você poderá baixar um instalador para uma versão portátil do ComfyUI para Linux AMD64, ou instalar manualmente.
 *(ainda estou atualizando o instalador para multiplataforma como linux/arm64)*
 
Também tem, na descrição abaixo, uma versão em testes mutliplataforma no DockerHub.

<hr>

<h5> 🐋 Docker multiplataforma </h5>

> **Você pode experimentar  essa versão Docker multiplataforma, ainda não foi testada com Workflows mais complexos.**
> *Quando tiver feitos mais testes atualizo aqui...*
> **Os testes por enquanto foram feitos em um servidor Aways Free da Oracle, com processador ARM 4 nucleos e 24 de RAM 'sem GPU'.
> No teste foi usado o workflow padrão com o model '*v1-5-pruned-emaonly-fp16.safetensors*' em CPU, levou 5min para carregar e gerar a imagem e com o Custom-Nodes do Gemini em CPU** 
> *<small>(neste caso não faz tanta diferençajá que quem paga a conta é a Google)</small>*,  **foi em 6s.**
> **Link para acessar a imagem Docker no DockerHub >> https://hub.docker.com/r/vladimirpezzole/comfyui-multipla-clean**

<hr><hr>

### Baixe diretamente a versão com instalador do '*ComfyUI Linux Portable*' com  '*ComfyUI Manager*' *(recomendado)*...

```bash
git clone https://github.com/vladimirpezzole/ComfyUI-Linux-Portable.git
```

**Execute o Script:**
```bash
./install-comfyui-portable-linux.sh
```
**Caso dê erro torne o script executável (se não estiver)**
```bash
chmod +x install-comfyui-portable-linux.sh
./install-comfyui-portable-linux.sh
```
**Após o final siga as instruções e instale as dependências:**
<h5> [>> 💻 **Instalação das Dependências de GPU** <<](#instalacao-gpu) </h5>



<hr>
<hr>

### ⚙️ ...caso der algum problema 🙈😬 ou se preferir instale Manualmente👍:

#### 1. Prepare a estrutura e clone o ComfyUI
```bash
mkdir ComfyUI_Linux_Portable
cd ComfyUI_Linux_Portable
git clone https://github.com/comfyanonymous/ComfyUI.git
```

#### 2. Instale o ComfyUI Manager
```bash
cd ComfyUI/custom_nodes/
git clone https://github.com/Comfy-Org/ComfyUI-Manager.git
cd ../..  # Volte para a pasta ComfyUI_Linux_Portable
```

#### 3. Configure o Python embutido
```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p ./python_embeded
rm Miniconda3-latest-Linux-x86_64.sh  # Remove o instalador após uso
```

#### 4. Ative o ambiente e instale dependências
```bash
source ./python_embeded/bin/activate
pip install -r ComfyUI/requirements.txt
```

<hr>

***

<a id="instalacao-gpu"></a>
## 💻 Instalação das Dependências de GPU

**Certifique-se de estar no ambiente Conda:**
```bash
source ./python_embeded/bin/activate
```

#### 🔵 **NVIDIA**
```bash
conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia
```

#### 🔴 **AMD**
```bash
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.0
```

#### 🟡 **Mac ARM Silicon**
```bash
conda install pytorch-nightly::pytorch torchvision torchaudio -c pytorch-nightly
```

<hr>

***

## 🚀 Scripts de Inicialização Personalizados

### 📝 Como criar seu script:

```bash
nano run.sh
```

### ⚙️ Parâmetros disponíveis:

| Parâmetro       | Exemplo          | Descrição                                                                 |
|-----------------|------------------|---------------------------------------------------------------------------|
| `--port NUM`    | `--port 8190`    | Altera a porta padrão (útil para evitar conflitos com outros serviços)    |
| `--listen`      | `--listen`       | Habilita acesso via rede (permite conexões remotas por IP)                |
| `--lowvram`     | `--lowvram`      | Modo otimizado para GPUs com memória limitada (<=4GB VRAM)               |
| `--cpu`         | `--cpu`          | Força a execução usando apenas CPU (ignora GPU)                          |
| `--dont-upcast` | `--dont-upcast`  | Desativa upcasting de precisão (pode ajudar em GPUs antigas)              |

### 💻 Exemplos Práticos:

**1. Configuração para NVIDIA com 4GB VRAM:**
```bash
#!/bin/bash
export PYTHONPATH="$PWD"
source ./python_embeded/bin/activate
python ComfyUI/main.py --port 8190 --listen --lowvram
```

**2. Configuração para CPU:**
```bash
#!/bin/bash
export PYTHONPATH="$PWD"
source ./python_embeded/bin/activate
python ComfyUI/main.py --port 8188 --cpu
```

**3. Configuração avançada (GPU dedicada + rede):**
```bash
#!/bin/bash
export PYTHONPATH="$PWD"
source ./python_embeded/bin/activate
python ComfyUI/main.py --port 8200 --listen --dont-upcast
```

### 🔒 Tornando executável:
```bash
chmod +x run.sh  # Dá permissão de execução
./run.sh         # Inicia o ComfyUI
```

💡 **Dica:** Você pode criar múltiplos scripts (ex: `run-gpu.sh`, `run-cpu.sh`) para diferentes configurações!


### 🗂 Estrutura de Pastas Final
```
ComfyUI_Linux_Portable/
├── ComfyUI/              # Arquivos principais
├── python_embeded/       # Ambiente Python
├── run.sh                # Script de inicialização
└── install-comfyui-portable-linux.sh # Script de instalação
```

## 🔄 Comparação com Windows Portable
| Feature          | Windows           | Linux (esta versão) |
|------------------|-------------------|---------------------|
| Python           | Embebido          | Miniconda           |
| Atualização      | GitHub Releases   | git pull            |
| Modelos          | models/           | ComfyUI/models/     |


<br><hr>

## 💡 Dicas Adicionais:
1. Para plugins adicionais:
```bash
source ./python_embeded/bin/activate
pip install timm==0.6.12 transformers==4.36.0
```

2. Para atualizar:
```bash
cd ComfyUI
git pull
pip install --upgrade -r requirements.txt
```

<hr>

***Fontes Oficiais:***  
📌 [www.comfy.org](https://www.comfy.org/download)  
📌 [Comfy-ui.org](https://comfy-ui.org/download)

📌 [ComfyUI GitHub](https://github.com/comfyanonymous/ComfyUI)  
📌 [ComfyUI Manager](https://github.com/Comfy-Org/ComfyUI-Manager)

******
