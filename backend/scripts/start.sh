#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para exibir mensagens de erro e sair
error() {
    echo -e "${RED}Erro: $1${NC}"
    exit 1
}

# Função para exibir mensagens de aviso
warning() {
    echo -e "${YELLOW}Aviso: $1${NC}"
}

# Função para exibir mensagens de sucesso
success() {
    echo -e "${GREEN}$1${NC}"
}

# Verificar se está no ambiente virtual
if [ -z "$VIRTUAL_ENV" ]; then
    error "Ambiente virtual não ativo. Execute 'source .venv/bin/activate' primeiro."
fi

# Verificar se os diretórios necessários existem
for dir in logs tmp; do
    if [ ! -d "$dir" ]; then
        warning "Diretório $dir não encontrado. Criando..."
        mkdir -p "$dir"
    fi
done

# Verificar variáveis de ambiente
if [ ! -f .env ]; then
    warning "Arquivo .env não encontrado. Copiando de .env.example..."
    if [ ! -f .env.example ]; then
        error "Arquivo .env.example não encontrado!"
    fi
    cp .env.example .env
fi

# Verificar se o banco de dados está acessível
if ! python -c "
import os
from dotenv import load_dotenv
load_dotenv()
import psycopg2
try:
    psycopg2.connect(os.getenv('DATABASE_URL'))
except Exception as e:
    exit(1)
"; then
    error "Não foi possível conectar ao banco de dados. Verifique se o PostgreSQL está rodando e as credenciais estão corretas."
fi

# Verificar se o Redis está acessível
if ! python -c "
import os
from dotenv import load_dotenv
load_dotenv()
import redis
try:
    r = redis.Redis.from_url(os.getenv('REDIS_URL'))
    r.ping()
except Exception as e:
    exit(1)
"; then
    error "Não foi possível conectar ao Redis. Verifique se o Redis está rodando e as credenciais estão corretas."
fi

# Executar migrações
echo "┌─────────────────────────────────────────────────┐"
echo "│            Iniciando LLM Manager                │"
echo "├─────────────────────────────────────────────────┤"
echo "│ 1. Executando migrações do banco de dados...    │"
python -m alembic upgrade head
success "│ ✓ Migrações aplicadas com sucesso              │"

# Iniciar servidor
echo "│ 2. Iniciando servidor FastAPI...                │"
echo "└─────────────────────────────────────────────────┘"

# Configurações do servidor
HOST=${HOST:-0.0.0.0}
PORT=${PORT:-8000}
WORKERS=${WORKERS:-1}
RELOAD=${RELOAD:-true}
LOG_LEVEL=${LOG_LEVEL:-info}

# Iniciar o servidor com as configurações
exec python -m uvicorn app.main:app \
    --host "$HOST" \
    --port "$PORT" \
    --workers "$WORKERS" \
    --reload "$RELOAD" \
    --log-level "$LOG_LEVEL"
