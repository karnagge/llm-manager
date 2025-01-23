#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# Função para exibir mensagens informativas
info() {
    echo -e "${BLUE}$1${NC}"
}

# Função para verificar se o Docker está rodando
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        error "Docker não está rodando. Por favor, inicie o Docker primeiro."
    fi
}

# Função para verificar status dos containers
check_containers() {
    # Parar containers existentes
    cd ..
    docker-compose down > /dev/null 2>&1

    # Iniciar containers
    echo "│ Iniciando serviços Docker...                   │"
    if ! docker-compose up -d; then
        cd backend
        error "Falha ao iniciar serviços Docker."
    fi

    # Aguardar PostgreSQL ficar saudável
    echo "│ Aguardando PostgreSQL ficar pronto...          │"
    until docker-compose exec -T postgres pg_isready -U llm_manager > /dev/null 2>&1; do
        echo -n "."
        sleep 1
    done

    # Verificar se o banco foi criado corretamente
    echo "│ Verificando banco de dados...                  │"
    if ! docker-compose exec -T postgres psql -U llm_manager -d llm_manager -c '\q' > /dev/null 2>&1; then
        echo "│ Recriando banco de dados...                   │"
        docker-compose exec -T postgres dropdb -U llm_manager --if-exists llm_manager
        docker-compose exec -T postgres createdb -U llm_manager llm_manager
    fi

    # Aguardar Redis ficar saudável
    echo "│ Aguardando Redis ficar pronto...               │"
    until docker-compose exec -T redis redis-cli ping > /dev/null 2>&1; do
        echo -n "."
        sleep 1
    done

    cd backend
    success "│ ✓ Todos os serviços estão saudáveis           │"
}

# Função para verificar conexão com o banco
check_database_connection() {
    echo "Verificando conexão com o banco de dados..."
    python -c "
import os
from dotenv import load_dotenv
load_dotenv()
import psycopg2

try:
    url = os.getenv('DATABASE_URL')
    print(f'Tentando conectar a: {url}')
    conn = psycopg2.connect(url)
    conn.close()
    print('Conexão bem sucedida!')
except Exception as e:
    print(f'Erro ao conectar: {str(e)}')
    exit(1)
"
}

# Função para verificar conexão com Redis
check_redis_connection() {
    echo "Verificando conexão com Redis..."
    python -c "
import os
from dotenv import load_dotenv
load_dotenv()
import redis

try:
    url = os.getenv('REDIS_URL')
    print(f'Tentando conectar a: {url}')
    r = redis.Redis.from_url(url)
    r.ping()
    print('Conexão bem sucedida!')
except Exception as e:
    print(f'Erro ao conectar: {str(e)}')
    exit(1)
"
}

# Função para iniciar serviços do Docker
start_docker_services() {
    echo "┌─────────────────────────────────────────────────┐"
    echo "│         Verificando serviços Docker...          │"
    echo "├─────────────────────────────────────────────────┤"

    # Verificar se o Docker está rodando
    check_docker

    # Verificar e reiniciar containers
    check_containers

    echo "└─────────────────────────────────────────────────┘"
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

# Instalar psycopg2 se necessário
pip install psycopg2-binary > /dev/null 2>&1

# Iniciar serviços Docker
start_docker_services

# Aguardar um pouco mais para garantir que os serviços estão prontos
sleep 3

# Verificar conexões
check_database_connection
check_redis_connection

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

# Exibir URLs dos serviços
info "\nServiços disponíveis:"
echo "- API: http://$HOST:$PORT"
echo "- API Docs: http://$HOST:$PORT/docs"
echo "- pgAdmin: http://localhost:5050"
echo "  Email: admin@llm-manager.com"
echo "  Senha: admin"
echo "- Redis Commander: http://localhost:8081"

# Iniciar o servidor com as configurações
exec python -m uvicorn app.main:app \
    --host "$HOST" \
    --port "$PORT" \
    --workers "$WORKERS" \
    --reload "$RELOAD" \
    --log-level "$LOG_LEVEL"
