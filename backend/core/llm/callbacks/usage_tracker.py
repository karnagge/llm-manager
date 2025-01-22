from typing import Any, Dict, List, Optional
from langchain_core.callbacks import BaseCallbackHandler
from langchain_core.messages import BaseMessage
import structlog

logger = structlog.get_logger()

class UsageTrackingCallback(BaseCallbackHandler):
    """Callback para rastrear uso de tokens e custos por tenant."""
    
    def __init__(self, tenant_id: str):
        self.tenant_id = tenant_id
        self.current_tokens = 0
        
    def on_llm_start(
        self,
        serialized: Dict[str, Any],
        prompts: List[str],
        *,
        run_id: str,
        parent_run_id: Optional[str] = None,
        **kwargs: Any,
    ) -> None:
        """Chamado quando uma chamada LLM começa."""
        logger.info(
            "llm_call_started",
            tenant_id=self.tenant_id,
            run_id=run_id,
            model=serialized.get("name", "unknown")
        )
    
    def on_chat_model_start(
        self,
        serialized: Dict[str, Any],
        messages: List[List[BaseMessage]],
        *,
        run_id: str,
        parent_run_id: Optional[str] = None,
        **kwargs: Any,
    ) -> None:
        """Chamado quando um modelo de chat começa."""
        # Calcular tokens de entrada
        from .token_counter import count_message_tokens
        for message_list in messages:
            self.current_tokens += sum(
                count_message_tokens(m) for m in message_list
            )
    
    def on_llm_end(
        self,
        response: Any,
        *,
        run_id: str,
        parent_run_id: Optional[str] = None,
        **kwargs: Any,
    ) -> None:
        """Chamado quando uma chamada LLM termina."""
        # Registrar uso no Redis e banco de dados
        from ...services.analytics.usage_service import record_usage
        
        record_usage(
            tenant_id=self.tenant_id,
            run_id=run_id,
            tokens_in=self.current_tokens,
            tokens_out=response.llm_output.get("token_usage", {}).get("completion_tokens", 0),
            model=response.llm_output.get("model_name", "unknown")
        )
        
        logger.info(
            "llm_call_completed",
            tenant_id=self.tenant_id,
            run_id=run_id,
            tokens_used=self.current_tokens
        )
