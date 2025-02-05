#!/bin/bash
# Obtendo a versão a partir da última tag do Git (caso tenha)
VERSION=$(git describe --tags --abbrev=0 2>/dev/null)

# Se não houver tags, utiliza o hash do commit mais recente
if [ -z "$VERSION" ]; then
    VERSION=$(git log -1 --format=%h)  # Obtém o hash do commit mais recente
fi

# Função para exibir a versão
show_version() {
    echo "Versão do Script (Git): $VERSION"
}

# Exibir a versão se o usuário pedir
if [[ "$1" == "--version" || "$1" == "-v" ]]; then
    show_version
    exit 0
fi


# Função para instalar pacotes
install_package() {
  if command -v apt-get &> /dev/null; then
    sudo apt-get install -y "$1" && installed_packages+=("$1")
  elif command -v brew &> /dev/null; then
    brew install "$1" && installed_packages+=("$1")
  else
    echo "Gerenciador de pacotes não suportado."
    exit 1
  fi
}

# Função para limpar o terminal e mostrar pacotes instalados
clear_and_show_installed() {
  clear
  echo "Pacotes instalados com sucesso:"
  for package in "${installed_packages[@]}"; do
    echo "- $package"
  done
  echo
}

# Lista para armazenar os pacotes instalados com sucesso
installed_packages=()

# Função para configurar o Oh My Zsh com Spaceship e plugins
configure_spaceship_and_plugins() {
  # Clonando o repositório do Spaceship
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1

  # Criando link simbólico para o tema
  ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

  # Alterando o arquivo ~/.zshrc para usar o tema
  sed -i 's/ZSH_THEME=".*"/ZSH_THEME="spaceship"/' ~/.zshrc

  # Configurando o Spaceship no ~/.zshrc
  cat <<EOL >> ~/.zshrc

# Configurações do Spaceship
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  exec_time     # Execution time
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "

EOL

  # Instalando zinit para plugins
  bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

  # Instalando plugins
  echo "zinit light zdharma/fast-syntax-highlighting" >> ~/.zshrc
  echo "zinit light zsh-users/zsh-autosuggestions" >> ~/.zshrc
  echo "zinit light zsh-users/zsh-completions" >> ~/.zshrc
}

# Função para instalar NVM e a versão LTS do Node.js
install_nvm_and_node() {
  # Instalando o NVM
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  # Carregando o NVM no terminal
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Esta linha carrega o NVM
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Para autocompletar

  # Instalando a versão LTS do Node.js
  nvm install --lts
  nvm use --lts
  nvm alias default 'lts/*'
  installed_packages+=("NVM e Node.js LTS")
}

# Função para ajustar as permissões do Docker
adjust_docker_permissions() {
  # Adicionando o usuário ao grupo Docker
  sudo usermod -aG docker $USER
  # Verificando se o usuário foi adicionado ao grupo Docker
  groups $USER

  # Ajustando as permissões do Docker socket
  sudo chown root:docker /var/run/docker.sock

  # Reiniciando o Docker para garantir que as permissões entrem em vigor
  sudo systemctl restart docker

  echo "Permissões do Docker ajustadas e usuário adicionado ao grupo Docker."
}

# Função para instalar o VS Code
install_vscode() {
  if command -v apt-get &> /dev/null; then
    # Para Debian/Ubuntu e derivados
    sudo apt update
    sudo apt install software-properties-common apt-transport-https curl -y
    curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt update
    sudo apt install code -y
    installed_packages+=("Visual Studio Code")
  elif command -v brew &> /dev/null; then
    # Para MacOS
    brew install --cask visual-studio-code
    installed_packages+=("Visual Studio Code")
  else
    echo "Gerenciador de pacotes não suportado para VS Code."
    exit 1
  fi
}




# Menu de opções
while true; do
  echo "Escolha uma opção:"
  echo "1. Instalar Git"
  echo "2. Instalar Zsh"
  echo "3. Instalar Oh My Zsh"
  echo "4. Instalar Docker"
  echo "5. Instalar NVM e Node.js LTS"
  echo "6. Instalar Visual Studio Code"
  echo "0. Sair"
  read -p "Digite sua opção: " option

  case $option in
    1)
      install_package git
      clear_and_show_installed
      ;;
    2)
      install_package zsh
      clear_and_show_installed
      ;;
    3)
      # Instalação do Oh My Zsh
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && installed_packages+=("Oh My Zsh")
      # Configuração do Spaceship e plugins
      configure_spaceship_and_plugins
      clear_and_show_installed
      ;;
    4)
      # Instalação do Docker
      for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg -y; done
      sudo apt-get update -y
      sudo apt-get install ca-certificates curl -y
      sudo install -m 0755 -d /etc/apt/keyrings
      sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
      sudo chmod a+r /etc/apt/keyrings/docker.asc

      # Add the repository to Apt sources:
      echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      sudo apt-get update

      sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      sudo docker run hello-world && installed_packages+=("Docker")
      adjust_docker_permissions
      clear_and_show_installed
      ;;
    5)
      # Instalação do NVM e Node.js LTS
      install_nvm_and_node
      clear_and_show_installed
      ;;
    6)
     # Instalação do VS Code
      install_vscode
      clear_and_show_installed
      ;;
   
    0)
      echo "Saindo..."
      exit 0
      ;;
    *)
      echo "Opção inválida. Tente novamente."
      ;;
  esac
done
