#!/bin/bash

# Verificar se o pnpm está instalado
if ! command -v pnpm &> /dev/null; then
    echo "pnpm não encontrado. Instalando..."
    npm install -g pnpm
fi

# Instalar dependências
echo "Instalando dependências..."
pnpm install

# Configurar ambiente
if [ ! -f .env ]; then
    echo "Configurando arquivo .env..."
    cp .env.example .env
fi

# Verificar tipos
echo "Verificando tipos TypeScript..."
pnpm type-check

# Instalar husky
echo "Configurando husky..."
pnpm husky install

echo "Setup concluído! Para iniciar o servidor de desenvolvimento, execute:"
echo "pnpm dev"
