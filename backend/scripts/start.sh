#!/bin/bash

# Ativar ambiente virtual do Poetry
source $(poetry env info --path)/bin/activate

# Verificar variáveis de ambiente
if [ ! -f .env ]; then
    echo "Arquivo .env não encontrado. Copiando de .env.example..."
    cp .env.example .env
fi

# Executar migrações
echo "Executando migrações do banco de dados..."
poetry run alembic upgrade head

# Iniciar servidor
echo "Iniciando servidor FastAPI..."
poetry run uvicorn app.main:app --host ${HOST:-0.0.0.0} --port ${PORT:-8000} --workers ${WORKERS:-1} --reload ${RELOAD:-true}
