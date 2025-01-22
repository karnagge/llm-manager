# LLM Manager - Sistema Gerenciador Multi-tenant de LLMs

Sistema gerenciador de LLMs multi-tenant que atua como interface entre empresas e APIs de LLMs (OpenAI, Ollama, Gemini, OpenRouter, etc.).

## Estrutura do Projeto

```
llm-manager/
├── backend/
│   ├── api/            # FastAPI endpoints
│   ├── core/           # Lógica de negócios central
│   ├── db/             # Modelos e migrações do banco de dados
│   ├── services/       # Serviços de integração (LLMs, Redis, etc.)
│   └── utils/          # Utilitários e helpers
├── frontend/
│   ├── app/           # Páginas e rotas Next.js
│   ├── components/    # Componentes React reutilizáveis
│   ├── lib/          # Utilitários e configurações
│   └── public/       # Arquivos estáticos
├── infrastructure/    # Configurações de infraestrutura
└── docs/             # Documentação
```

## Stack Tecnológico

### Backend
- Python 3.11+
- FastAPI
- SQLAlchemy (Multi-tenant com schemas PostgreSQL)
- LangChain
- Redis Streams
- Alembic (Migrações)
- Pydantic

### Frontend
- Next.js 14
- TailwindCSS
- Chart.js/D3.js
- React Query
- Zustand

### Infraestrutura
- PostgreSQL
- Redis
- Grafana
- Docker/Docker Compose

## Funcionalidades Principais

### MVP
- [x] Autenticação e autorização multi-tenant
- [x] Integração com OpenAI
- [x] Dashboard básico de uso e custos
- [x] Gestão de agentes
- [x] Controle básico de permissões
- [x] Exportação de relatórios (CSV/Excel)
- [x] Monitoramento técnico básico

### Futuras Versões
- [ ] Suporte a múltiplos provedores de LLM
- [ ] Personalização white-label avançada
- [ ] Dashboards interativos com IA
- [ ] Gestão avançada de bases de conhecimento
- [ ] Sistema avançado de permissões
- [ ] Relatórios financeiros detalhados
- [ ] Alertas e notificações personalizadas

## Setup do Ambiente de Desenvolvimento

1. Clone o repositório
2. Configure o ambiente virtual Python:
   ```bash
   python -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```
3. Configure o ambiente Node.js:
   ```bash
   cd frontend
   npm install
   ```
4. Configure as variáveis de ambiente:
   ```bash
   cp .env.example .env
   ```
5. Inicie os serviços:
   ```bash
   docker-compose up -d
   ```

## Cronograma de Desenvolvimento

### Fase 1 - MVP (4-6 semanas)
- Semana 1-2: Setup inicial e autenticação
- Semana 2-3: Integração com OpenAI e gestão básica de agentes
- Semana 3-4: Dashboard básico e exportação de relatórios
- Semana 4-6: Testes, ajustes e deploy inicial

### Fase 2 - Expansão (6-8 semanas)
- Semana 1-2: Múltiplos provedores de LLM
- Semana 2-4: Dashboards avançados e IA
- Semana 4-6: Sistema avançado de permissões
- Semana 6-8: White-label e personalização

### Fase 3 - Otimização (4-6 semanas)
- Semana 1-2: Otimização de performance
- Semana 2-4: Melhorias UX/UI
- Semana 4-6: Documentação e polimento

## Contribuição

Por favor, siga as diretrizes de contribuição no arquivo CONTRIBUTING.md.

## Licença

Este projeto está licenciado sob a MIT License - veja o arquivo LICENSE para detalhes.
