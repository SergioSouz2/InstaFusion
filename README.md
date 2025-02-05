# InstaFusion

# Script de Instalação e Configuração de Ferramentas de Desenvolvimento

Este script automatiza a instalação e configuração de várias ferramentas de desenvolvimento, como **Git, Zsh, Docker, NVM (Node Version Manager), Visual Studio Code (VS Code)**, além de ajustar permissões e configurações para otimizar o ambiente de desenvolvimento.


## Requisitos
- ### **Sistemas suportados:**
    - Debian/Ubuntu (com apt-get)
    - macOS (com brew)
- ### **Ferramentas:**
    - Git
    - Zsh
    - Oh My Zsh (com o tema Spaceship)
    - Docker
    - NVM (Node Version Manager) e instalação do Node.js LTS
    - Visual Studio Code

## Funcionalidades
Este script realiza as seguintes funções:

### Instalação de Pacotes

O script verifica o sistema operacional e utiliza o gerenciador de pacotes adequado para instalar os pacotes requisitados:

- **apt-get** (Debian/Ubuntu)
- **brew** (macOS)
    
    

 


### Instalar Git

- Instala o Git, um sistema de controle de versões amplamente utilizado.

### Instalar Zsh

Instala o Zsh, um shell de linha de comando avançado e interativo.

### Instalar Oh My Zsh

- Instala o Oh My Zsh, um framework popular para gerenciamento de configurações do Zsh.

- Configura o tema Spaceship e os plugins Zinit (para autocompletar e sintaxe destacada) automaticamente.

### Instalar Docker

- Instala o Docker e seus componentes essenciais, como o Docker Compose.

- Após a instalação, o script executa um teste simples para verificar se o Docker foi instalado corretamente.

- O script ajusta as permissões para que o usuário possa executar comandos do Docker sem precisar de sudo, adicionando o usuário ao grupo docker e configurando as permissões do arquivo do Docker socket.

### Instalar NVM e Node.js LTS

- Instala o NVM (Node Version Manager), uma ferramenta para gerenciar múltiplas versões do Node.js.

- O script instala automaticamente a versão LTS (Long Term Support) do Node.js.


### Instalar Visual Studio Code (VS Code)

- O script instala o Visual Studio Code em sistemas Debian/Ubuntu ou macOS.


## Como Usar

### Clonando o Repositório
- Clone este repositório ou baixe o arquivo do script.

```shell 
    git clone https://github.com/SergioSouz2/InstaFusion.git
    cd InstaFusion 
```

### Tornando o Script Executável
Dê permissão de execução ao script.

``` shell
    chmod +x install.sh
```


### Executando o Script
Execute o script para iniciar o processo de instalação.

``` shell
    ./install.sh
```

### Menu de Opções

Após rodar o script, você verá um menu interativo com as seguintes opções:

- 1 Instalar Git
- 2 Instalar Zsh
- 3 Instalar Oh My Zsh
- 4 Instalar Docker
- 5 Instalar NVM e Node.js LTS
- 6 Instalar Visual Studio Code
- 0 Sair

Escolha a opção desejada digitando o número correspondente.

## Exemplo de Saída


```bash
Escolha uma opção:

1. Instalar Git
2. Instalar Zsh
3. Instalar Oh My Zsh
4. Instalar Docker
5. Instalar NVM e Node.js LTS
6. Ajustar permissões do Docker
7. Instalar Visual Studio Code
8. Sair
Digite sua opção: 7
Instalando Visual Studio Code...
Visual Studio Code instalado com sucesso.

Pacotes instalados com sucesso:
- Visual Studio Code

```


# Notas
**Permissões do Docker:** Após a instalação do Docker, você precisará sair e voltar para sua sessão ou executar newgrp docker para que as alterações de permissão tenham efeito.

**Zsh e Oh My Zsh:** O script configura automaticamente o tema **Spaceship** e instala plugins úteis, mas você pode personalizar seu arquivo ~/.zshrc conforme necessário.