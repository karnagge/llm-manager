#!/bin/bash

# Função para verificar se um comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Função para desativar ambiente virtual atual
deactivate_current_env() {
    if [ -n "$VIRTUAL_ENV" ]; then
        deactivate
    fi
    if [ -n "$CONDA_DEFAULT_ENV" ]; then
        conda deactivate
    fi
}

# Desativar qualquer ambiente virtual atual
echo "Desativando ambientes virtuais ativos..."
deactivate_current_env

# Verificar Python
if ! command_exists python3; then
    echo "Python 3 não encontrado. Por favor, instale o Python 3.11 ou superior."
    exit 1
fi

# Verificar versão do Python usando Python
MIN_VERSION="3.11"
PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
if python3 -c "import sys; exit(0 if sys.version_info >= (3, 11) else 1)"; then
    echo "Python $PYTHON_VERSION encontrado"
else
    echo "Python 3.11 ou superior é necessário. Versão atual: $PYTHON_VERSION"
    exit 1
fi

# Criar e ativar ambiente virtual
echo "Criando ambiente virtual..."
python3 -m venv .venv
source .venv/bin/activate

# Atualizar pip
echo "Atualizando pip..."
python -m pip install --upgrade pip

# Instalar dependências
echo "Instalando dependências..."
pip install -r requirements.txt

# Instalar pre-commit
echo "Instalando pre-commit..."
pip install pre-commit
pre-commit install

# Configurar ambiente
if [ ! -f .env ]; then
    echo "Configurando arquivo .env..."
    cp .env.example .env
fi

# Criar diretórios necessários
echo "Criando diretórios..."
mkdir -p logs
mkdir -p tmp

echo "┌─────────────────────────────────────────────────┐"
echo "│             Setup concluído com sucesso!        │"
echo "├─────────────────────────────────────────────────┤"
echo "│ Para iniciar o servidor, execute:               │"
echo "│                                                 │"
echo "│   1. source .venv/bin/activate                  │"
echo "│   2. ./scripts/start.sh                         │"
echo "└─────────────────────────────────────────────────┘"
