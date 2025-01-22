# Guia do Projeto LLM Manager

## Visão Geral

O LLM Manager é um sistema gerenciador multi-tenant de LLMs que atua como interface entre empresas e APIs de LLMs. O sistema é projetado para ser modular, escalável e fácil de manter.

## Stack Tecnológico

### Backend
- **Framework Principal**: FastAPI
- **ORM**: SQLAlchemy com Alembic
- **Banco de Dados**: PostgreSQL (multi-tenant com schemas)
- **Cache**: Redis
- **LLM Framework**: LangChain
- **Monitoramento**: Grafana
- **Documentação**: OpenAPI/Swagger

### Frontend
- **Framework**: Next.js 14 (App Router)
- **Estilização**: TailwindCSS + shadcn/ui
- **Gerenciamento de Estado**: 
  - Zustand (estado global)
  - TanStack Query (estado do servidor)
- **Formulários**: React Hook Form + Zod
- **Gráficos**: Tremor + Chart.js

### Infraestrutura
- **Containerização**: Docker + Docker Compose
- **CI/CD**: GitHub Actions
- **Logs**: structlog + OpenTelemetry
- **Métricas**: Prometheus

## Padrões de Desenvolvimento

### 1. Arquitetura

#### Backend
- **Clean Architecture**
  - Controllers (API Routes)
  - Use Cases (Services)
  - Entities (Models)
  - Repositories
  - External Interfaces

#### Frontend
- **Feature-First Architecture**
  - Componentes por feature
  - Hooks compartilhados
  - Utilitários globais

### 2. Padrões de Código

#### Python (Backend)
```python
# Exemplo de serviço
class UserService:
    def __init__(self, repository: UserRepository):
        self.repository = repository
    
    async def create_user(self, user_data: UserCreate) -> User:
        # Validação e lógica de negócio
        pass
```

#### TypeScript (Frontend)
```typescript
// Exemplo de componente
interface ButtonProps {
  variant: 'primary' | 'secondary';
  children: React.ReactNode;
}

export function Button({ variant, children }: ButtonProps) {
  return <button className={styles[variant]}>{children}</button>;
}
```

### 3. Convenções de Nomenclatura

#### Backend
- **Arquivos**: snake_case (user_service.py)
- **Classes**: PascalCase (UserService)
- **Funções/Variáveis**: snake_case (create_user)
- **Constantes**: SCREAMING_SNAKE_CASE (MAX_USERS)

#### Frontend
- **Arquivos**: kebab-case (user-profile.tsx)
- **Componentes**: PascalCase (UserProfile)
- **Funções/Variáveis**: camelCase (getUserData)
- **Tipos/Interfaces**: PascalCase (UserData)

### 4. Estrutura de Diretórios

```
llm-manager/
├── backend/
│   ├── api/            # Endpoints FastAPI
│   ├── core/           # Lógica de negócios
│   ├── db/             # Modelos e migrações
│   └── services/       # Serviços externos
├── frontend/
│   ├── app/           # Páginas Next.js
│   ├── components/    # Componentes React
│   └── lib/          # Utilitários
└── infrastructure/   # Configurações
```

## Práticas de Desenvolvimento

### 1. Controle de Versão
- Branches: feature/, hotfix/, release/
- Commits semânticos (feat:, fix:, docs:, etc.)
- Pull Requests com descrições detalhadas

### 2. Testes
- Backend: pytest para testes unitários e de integração
- Frontend: Jest + React Testing Library
- E2E: Playwright

### 3. Documentação
- Docstrings em Python
- TSDoc em TypeScript
- README.md em cada diretório principal
- Swagger/OpenAPI para APIs

### 4. Segurança
- Autenticação JWT
- Isolamento multi-tenant
- Validação de entrada
- CORS configurado
- Rate limiting

## Multi-tenancy

### 1. Isolamento de Dados
- Schema por tenant no PostgreSQL
- Middleware de identificação de tenant
- Cache isolado no Redis

### 2. Customização
- Temas por tenant
- Configurações específicas
- Limites personalizados

### 3. Billing
- Tracking de uso por tenant
- Limites por plano
- Relatórios detalhados

## Desenvolvimento Local

### 1. Requisitos
- Docker e Docker Compose
- Node.js 18+
- Python 3.11+
- Poetry (gerenciamento de deps Python)
- pnpm (gerenciamento de deps Node)

### 2. Setup
```bash
# Backend
cd backend
poetry install
poetry run alembic upgrade head

# Frontend
cd frontend
pnpm install
pnpm dev

# Infraestrutura
docker-compose up -d
```

### 3. Ambiente de Desenvolvimento
- VSCode com extensões recomendadas
- Prettier + ESLint (Frontend)
- Black + isort (Backend)
- Husky para pre-commit hooks

## Deploy

### 1. Ambientes
- Development
- Staging
- Production

### 2. Processo
- CI/CD automatizado
- Testes antes do deploy
- Migrations automáticas
- Rollback automatizado

### 3. Monitoramento
- Grafana para métricas
- Alertas configurados
- Logs centralizados

## Melhores Práticas

1. **Código**
   - DRY (Don't Repeat Yourself)
   - SOLID Principles
   - Clean Code
   - Type Safety

2. **Performance**
   - Caching estratégico
   - Lazy loading
   - Otimização de queries
   - Bundle optimization

3. **UX/UI**
   - Design system consistente
   - Feedback imediato
   - Loading states
   - Error handling

4. **Segurança**
   - Sanitização de input
   - Proteção contra XSS
   - Rate limiting
   - Audit logs

## Roadmap de Desenvolvimento

### Fase 1 - MVP (4-6 semanas)
- [ ] Setup inicial
- [ ] Autenticação básica
- [ ] Dashboard principal
- [ ] Integração OpenAI

### Fase 2 - Expansão (6-8 semanas)
- [ ] Múltiplos providers
- [ ] Sistema de billing
- [ ] Relatórios avançados
- [ ] Customização white-label

### Fase 3 - Otimização (4-6 semanas)
- [ ] Performance
- [ ] Segurança avançada
- [ ] Analytics
- [ ] Documentação completa
