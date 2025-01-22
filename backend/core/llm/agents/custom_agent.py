from typing import List, Optional
from langchain.agents import AgentExecutor, create_openai_functions_agent
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_core.tools import BaseTool
from langchain.memory import ConversationBufferMemory

from ..base import llm_manager

class CustomAgent:
    """Agente personalizado com ferramentas específicas do tenant."""
    
    def __init__(self, tenant_id: str):
        self.tenant_id = tenant_id
        self.llm = llm_manager.get_llm(tenant_id)
        
    def _get_prompt(self) -> ChatPromptTemplate:
        """Retorna o prompt base para o agente."""
        return ChatPromptTemplate.from_messages([
            ("system", "Você é um assistente especializado em {domain}. "
                      "Use as ferramentas disponíveis para ajudar o usuário."),
            MessagesPlaceholder(variable_name="chat_history"),
            ("human", "{input}"),
            MessagesPlaceholder(variable_name="agent_scratchpad"),
        ])
    
    def _get_tools(self, domain: str) -> List[BaseTool]:
        """Retorna ferramentas específicas para o domínio."""
        from .tools import (
            DocumentSearchTool,
            DataAnalysisTool,
            APIIntegrationTool
        )
        
        return [
            DocumentSearchTool(tenant_id=self.tenant_id),
            DataAnalysisTool(tenant_id=self.tenant_id),
            APIIntegrationTool(tenant_id=self.tenant_id)
        ]
    
    async def create_agent(
        self,
        domain: str,
        memory_key: str = "chat_history"
    ) -> AgentExecutor:
        """Cria um agente executável."""
        # Configurar memória
        memory = ConversationBufferMemory(
            memory_key=memory_key,
            return_messages=True
        )
        
        # Obter ferramentas e prompt
        tools = self._get_tools(domain)
        prompt = self._get_prompt()
        
        # Criar agente
        agent = create_openai_functions_agent(
            llm=self.llm,
            prompt=prompt,
            tools=tools
        )
        
        # Criar executor
        executor = AgentExecutor(
            agent=agent,
            tools=tools,
            memory=memory,
            verbose=True
        )
        
        return executor
    
    async def run_agent(
        self,
        agent: AgentExecutor,
        query: str,
        **kwargs
    ) -> str:
        """Executa uma consulta usando o agente."""
        response = await agent.ainvoke({
            "input": query,
            **kwargs
        })
        
        return response["output"]
