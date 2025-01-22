from typing import Optional, Dict
from langchain_openai import ChatOpenAI
from langchain_core.language_models import BaseLLM
from langchain_core.callbacks import CallbackManager

class LLMManager:
    """Gerenciador central de modelos LLM."""
    
    def __init__(self):
        self._llm_instances: Dict[str, BaseLLM] = {}
        
    def get_llm(self, tenant_id: str, model_name: str = "gpt-3.5-turbo") -> BaseLLM:
        """Retorna uma instância LLM específica para o tenant."""
        cache_key = f"{tenant_id}:{model_name}"
        
        if cache_key not in self._llm_instances:
            # Criar nova instância com callbacks específicos do tenant
            callbacks = self._get_tenant_callbacks(tenant_id)
            
            self._llm_instances[cache_key] = ChatOpenAI(
                model_name=model_name,
                temperature=0.7,
                callback_manager=CallbackManager(callbacks),
                streaming=True
            )
        
        return self._llm_instances[cache_key]
    
    def _get_tenant_callbacks(self, tenant_id: str) -> list:
        """Retorna callbacks específicos para o tenant."""
        from .callbacks.usage_tracker import UsageTrackingCallback
        from .callbacks.cost_tracker import CostTrackingCallback
        
        return [
            UsageTrackingCallback(tenant_id),
            CostTrackingCallback(tenant_id)
        ]

# Instância global do gerenciador
llm_manager = LLMManager()
