
<a id="home"></a>
##  📦  "ComfyUI Linux Portable" +  '*ComfyUI Manager*' para Linux com Miniconda

<hr>

### Considerações iniciais

Aqui você poderá baixar um instalador para uma versão portátil do ComfyUI para Linux AMD64, ou instalar manualmente.
 *(ainda estou atualizando o instalador para multiplataforma como linux/arm64)*
 
Nesta instalação estarei usando **Miniconda**, porque oferece o melhor custo-benefício entre portabilidade e funcionalidade.
Mais informações sobre o porque de usar veja em >> **[Miniconda vs Outras Opções para ComfyUI Portable](Minicons-justificativa.md)**
 
Também tem, na descrição abaixo, uma versão em testes mutliplataforma no DockerHub.

<hr>

<h5> 🐋 Docker multiplataforma </h5>

> **Você pode experimentar  essa versão Docker multiplataforma, ainda não foi testada com Workflows mais complexos.**
> *Quando tiver feitos mais testes atualizo aqui...*
> **Os testes por enquanto foram feitos em um servidor Aways Free da Oracle, com processador ARM 4 nucleos e 24 de RAM 'sem GPU'.
> No teste foi usado o workflow padrão com o model '*v1-5-pruned-emaonly-fp16.safetensors*' em CPU, levou 5min para carregar e gerar a imagem e com o Custom-Nodes do [>Gemini_Flash_2.0_Exp<](https://github.com/ShmuelRonen/ComfyUI-Gemini_Flash_2.0_Exp?tab=readme-ov-file) em CPU** 
> *<small>(neste caso não faz tanta diferençajá que quem paga a conta é a Google)</small>*,  **foi em 6s.**
>
>> **A descrição mais detalahada e YAML para o docker Compose no Overview do link no DockerHub**:
> **Link para acessar a imagem Docker no DockerHub >> https://hub.docker.com/r/vladimirpezzole/comfyui-multipla-clean**


<hr><hr>

## 🧰 Instalação Automatica
### Baixe diretamente a versão com instalador do *(recomendado)*, ou instale [manualmente](#instalacao-manual).

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

#### [>> 💻 Instalação das Dependências de GPU <<](#instalacao-gpu)

<hr>

###  ** 🚀  Inicialização**

***Obsservação: os scripts descritos abaixo estão usando a porta `8190`, para evitar conflito com qualquer outra instalação do ComfyUI existente como o 'Plugin do Krita AI Diffusion', que utilizam por padrão a porta `8188`, mas poderá alterar conforme necessidade como descrito em [>> Scripts de Inicialização Personalizados <<](#script-iniciar)**.

**Para incializar execute o scrip `run-auto.sh`, ele fará automaticamente o acesso seguro ao ambiente conda e na sequencia podera fazer a escolha entre usar GPU NVIDEA, AMD ou CPU:**

```bash
./run-auto.sh
```
...**torne executável , caso não esteja**
```bash
chmod +x run-auto.sh 
```

**Também pode utilizar o scrip 'run' mais adequado ao seu uso.**
```bash
./run.sh #básico conecta com acesso a rede pelo IP do host na porta 8190
./run-lowvram.sh # para GPUs com porca VRAM
./run-cpu.sh # acesso sem uso de GPU
```

** mais informações ou se preferir criar seu inicializador personalizado, veja:**

##### [>> 💾 Scripts de Inicialização Personalizados <<](#script-iniciar)


####**Para 🚀 acessar o ComfyUI pelo Navegador utlize qualquer dos endereços abaixo**
```bash
http://localhost:8190/          # Endereço local na própria máquina
http://0.0.0.0:8190/            # Endereço genérico para acesso local e externo (todas interfaces de rede)
http://<IP-LOCAL-REDE>:8190/    # IP local na rede (ex: 192.168.1.100) - acessível por outros dispositivos na mesma rede
```

<hr>
<hr>

<a id="instalacao-manual"></a>
## 🧰 Instalação Manual
[>> Voltar](#home)

### ⚙️ Caso prefira ou tiver algum problema🛠️ 🙈😬 pode instalar  Manualmente👍:

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

#### 3. Instale o Python embutido com Miniconda pra gerenciar amb
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
[>> Voltar](#home)

>##### **IMPORTANTE!: sempre tenha certeza de estar dentro do ambiente 'conda' em que o 'ComfyUI Portable' foi instalado para fazer qualquer ação via terminal.**
>#####**Mais detalhes >> [ Verificação de ambiente](#adicionais-plugin)**

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

<a id="script-iniciar"></a>
## 🚀 Scripts de Inicialização Personalizados
[>> Voltar](#home)

>##### **IMPORTANTE!: sempre tenha certeza de estar dentro do ambiente 'conda' em que o 'ComfyUI Portable' foi instalado para fazer qualquer ação via terminal.**
>#####**Mais detalhes >> [ Verificação de ambiente](#adicionais-plugin)**

### 📝 Como criar seu script básico para inicializar seu ComfyUI:
**Abra seu editor de texto de preferência.**
**Ex.:**
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

<a id="adicionais-plugin"></a>
## 💡 Dicas Adicionais para resolver alguns problemas:
[>> Voltar](#home)

#### **1. Verificação de ambiente:**
>#### **IMPORTANTE!: sempre tenha certeza de estar dentro do ambiente 'conda' em que o 'ComfyUI Portable' foi instalado para fazer qualquer ação via terminal.**


**Para isso execute:**
```bash
source ./python_embeded/bin/activate
```
**Para testar:**
```bash
$ conda env list
```
**Isso mostrará uma lista de todos os ambientes disponíveis no seu sistema, incluindo o ambiente base. 
O ambiente atual será marcado com um asterisco (*).**

```bash
# conda environments:
#
base                  * /<caminha-da-instalacao>/ComfyUI-Linux-Portable/python_embeded/envs/comfy_env
                       /home/outros-ambientes/envs/   #outros ambientes se houver
                       /media/outros-amvbiente/envs/  #outros ambientes se houver
```



**O nome do ambiente atual geralmente é exibido entre parênteses no início do prompt, por exemplo:**

`(comfy_env) usuario@computador:~$` ou `(meu_ambiente) usuario@computador:~$`.xxxx
<br>



<hr>
### **2. Para plugins adicionais:**

**Alguns plugin ou custom-nodes precisaram de algumas instalações adicionais.**
Exemplos:
```bash
# Para nodes de visão computacional e modelos CLIP:
pip install timm==0.6.12 transformers==4.36.0 # Biblioteca para modelos vision transformers e NLP

# Para compatibilidade com alguns nodes de processamento de imagem:
pip install numpy==2.1.0 # Requisito específico para alguns plugins de upscaling

# Para nodes que usam OpenCV avançado:
pip install opencv-python-headless==4.8.0 # Processamento de imagem sem dependências GUI

# Para plugins de animação e interpolação:
pip install numba==0.58.1 # Aceleração JIT para processamento de vídeo

# Para nodes de áudio (text-to-speech):
pip install torchaudio==2.0.2 # Processamento de áudio com PyTorch
```

#### **3. Para atualizar:**
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
