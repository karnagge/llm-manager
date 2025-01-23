#!/bin/bash

# Verificar se o Poetry está instalado
if ! command -v poetry &> /dev/null; then
    echo "Poetry não encontrado. Instalando..."
    curl -sSL https://install.python-poetry.org | python3 -
fi

# Configurar Poetry para criar o ambiente virtual no projeto
poetry config virtualenvs.in-project true

# Instalar dependências
echo "Instalando dependências..."
poetry install

# Configurar ambiente
if [ ! -f .env ]; then
    echo "Configurando arquivo .env..."
    cp .env.example .env
fi

# Instalar pre-commit hooks
echo "Configurando pre-commit hooks..."
poetry run pre-commit install

# Criar diretórios necessários
mkdir -p logs
mkdir -p tmp

echo "Setup concluído! Para iniciar o servidor, execute:"
echo "poetry run ./scripts/start.sh"
