from fastapi import APIRouter, Depends, HTTPException
from typing import List, Optional
from pydantic import BaseModel

from ....core.llm.agents.custom_agent import CustomAgent
from ....core.auth.dependencies import get_current_tenant
from ....db.models.tenant import Tenant

router = APIRouter()

class AgentQuery(BaseModel):
    """Modelo para consultas ao agente."""
    query: str
    domain: str
    context: Optional[dict] = None

class AgentResponse(BaseModel):
    """Modelo para respostas do agente."""
    response: str
    metadata: Optional[dict] = None

@router.post("/query", response_model=AgentResponse)
async def query_agent(
    query: AgentQuery,
    tenant: Tenant = Depends(get_current_tenant)
):
    """Endpoint para consultar um agente específico do tenant."""
    try:
        # Criar instância do agente
        agent_manager = CustomAgent(tenant.id)
        
        # Criar agente executável
        agent = await agent_manager.create_agent(
            domain=query.domain
        )
        
        # Executar consulta
        response = await agent_manager.run_agent(
            agent=agent,
            query=query.query,
            **(query.context or {})
        )
        
        return AgentResponse(
            response=response,
            metadata={
                "domain": query.domain,
                "tenant_id": tenant.id
            }
        )
        
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Erro ao processar consulta: {str(e)}"
        )

# Exemplo de uso:
"""
curl -X POST "http://localhost:8000/api/v1/agents/query" \
    -H "Content-Type: application/json" \
    -H "X-Tenant-ID: tenant123" \
    -d '{
        "query": "Analise os dados de vendas do último trimestre",
        "domain": "business_analysis",
        "context": {
            "timeframe": "last_quarter",
            "metrics": ["revenue", "growth"]
        }
    }'
"""
