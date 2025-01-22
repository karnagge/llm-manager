# Estrutura de Diretórios do LLM Manager

## Backend

```
backend/
├── api/                    # Camada de API
│   ├── v1/                # Versão 1 da API
│   │   ├── auth/          # Endpoints de autenticação
│   │   ├── agents/        # Endpoints de gestão de agentes
│   │   ├── billing/       # Endpoints de faturamento
│   │   └── analytics/     # Endpoints de análise
│   ├── middleware/        # Middlewares da API
│   │   ├── auth/          # Middleware de autenticação
│   │   ├── tenant/        # Middleware multi-tenant
│   │   └── logging/       # Middleware de logging
│   ├── routers/           # Roteadores FastAPI
│   └── schemas/           # Schemas Pydantic
│
├── core/                  # Lógica de negócios central
│   ├── auth/             # Autenticação e autorização
│   │   ├── jwt.py
│   │   └── permissions.py
│   ├── billing/          # Lógica de faturamento
│   │   ├── costs.py
│   │   └── usage.py
│   ├── llm/              # Lógica de LLMs
│   │   ├── chains/
│   │   └── prompts/
│   ├── tenants/          # Gestão de tenants
│   ├── agents/           # Lógica de agentes
│   └── knowledge_base/   # Gestão de bases de conhecimento
│
├── db/                   # Camada de dados
│   ├── migrations/       # Migrações Alembic
│   ├── models/          # Modelos SQLAlchemy
│   │   ├── tenant.py
│   │   ├── user.py
│   │   └── agent.py
│   └── repositories/     # Padrão Repository
│
├── services/            # Serviços externos
│   ├── llm_providers/   # Integrações com LLMs
│   │   ├── openai/
│   │   ├── gemini/
│   │   └── ollama/
│   ├── notification/    # Serviço de notificações
│   ├── storage/         # Serviço de armazenamento
│   └── analytics/       # Serviço de análise
│
└── utils/              # Utilitários
    ├── logging/        # Configuração de logs
    ├── monitoring/     # Monitoramento
    └── security/       # Utilitários de segurança
```

## Frontend

```
frontend/
├── app/                # Páginas Next.js
│   ├── auth/          # Autenticação
│   ├── dashboard/     # Dashboard principal
│   ├── settings/      # Configurações
│   ├── agents/        # Gestão de agentes
│   ├── reports/       # Relatórios
│   └── admin/         # Área administrativa
│
├── components/        # Componentes React
│   ├── ui/           # Componentes de UI básicos
│   │   ├── buttons/
│   │   ├── inputs/
│   │   └── cards/
│   ├── charts/       # Componentes de visualização
│   ├── forms/        # Componentes de formulário
│   ├── layout/       # Componentes de layout
│   └── modals/       # Modais e diálogos
│
├── lib/             # Bibliotecas e utilitários
│   ├── api/        # Cliente API
│   ├── auth/       # Lógica de autenticação
│   ├── store/      # Estado global (Zustand)
│   ├── utils/      # Utilitários
│   └── types/      # Tipos TypeScript
│
├── styles/         # Estilos globais
└── public/         # Arquivos estáticos
    ├── assets/     # Imagens e mídia
    └── icons/      # Ícones
```

## Infrastructure

```
infrastructure/
├── docker/         # Configurações Docker
│   ├── dev/       # Ambiente de desenvolvimento
│   └── prod/      # Ambiente de produção
├── k8s/           # Configurações Kubernetes
└── terraform/     # IaC com Terraform
```

## Tests

```
tests/
├── unit/          # Testes unitários
├── integration/   # Testes de integração
└── e2e/           # Testes end-to-end
```

## Docs

```
docs/
├── api/           # Documentação da API
├── architecture/  # Documentação arquitetural
└── deployment/    # Guias de deployment
```

## Principais Características da Estrutura

1. **Modularidade**
   - Cada módulo é independente e tem responsabilidade única
   - Fácil adição de novos provedores LLM
   - Separação clara entre lógica de negócios e infraestrutura

2. **Escalabilidade**
   - Estrutura preparada para múltiplos tenants
   - Fácil adição de novos recursos e funcionalidades
   - Suporte a diferentes ambientes (dev, staging, prod)

3. **Manutenibilidade**
   - Organização clara e intuitiva
   - Separação de concerns
   - Fácil localização de código

4. **Testabilidade**
   - Estrutura dedicada para diferentes tipos de testes
   - Fácil mock de serviços externos
   - Suporte a testes automatizados

5. **Segurança**
   - Isolamento de configurações sensíveis
   - Middleware de segurança centralizado
   - Gestão de permissões granular

6. **Observabilidade**
   - Estrutura para logs centralizados
   - Monitoramento de métricas
   - Rastreamento de requisições

## Convenções de Nomenclatura

1. **Arquivos Python**
   - snake_case para módulos e pacotes
   - PascalCase para classes
   - snake_case para funções e variáveis

2. **Arquivos TypeScript/React**
   - PascalCase para componentes
   - camelCase para funções e variáveis
   - kebab-case para arquivos CSS

3. **Diretórios**
   - kebab-case para todos os diretórios
   - Nomes descritivos e auto-explicativos
