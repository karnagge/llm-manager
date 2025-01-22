from typing import List, Optional
from langchain_core.documents import Document
from langchain.chains import ConversationalRetrievalChain
from langchain.memory import ConversationBufferMemory
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings

from ..base import llm_manager

class DocumentQAChain:
    """Chain para responder perguntas sobre documentos específicos do tenant."""
    
    def __init__(self, tenant_id: str):
        self.tenant_id = tenant_id
        self.llm = llm_manager.get_llm(tenant_id)
        self.embeddings = OpenAIEmbeddings()
        
    async def create_knowledge_base(
        self,
        documents: List[Document],
        collection_name: Optional[str] = None
    ) -> str:
        """Cria uma base de conhecimento a partir de documentos."""
        # Usar nome da coleção específico do tenant
        collection_name = collection_name or f"tenant_{self.tenant_id}_default"
        
        # Criar vectorstore
        vectorstore = Chroma.from_documents(
            documents=documents,
            embedding=self.embeddings,
            collection_name=collection_name
        )
        
        return collection_name
    
    async def get_chain(
        self,
        collection_name: str,
        memory_key: str = "chat_history"
    ) -> ConversationalRetrievalChain:
        """Retorna uma chain configurada para QA."""
        # Recuperar vectorstore
        vectorstore = Chroma(
            collection_name=collection_name,
            embedding_function=self.embeddings
        )
        
        # Configurar memória
        memory = ConversationBufferMemory(
            memory_key=memory_key,
            return_messages=True
        )
        
        # Criar chain
        chain = ConversationalRetrievalChain.from_llm(
            llm=self.llm,
            retriever=vectorstore.as_retriever(),
            memory=memory,
            verbose=True
        )
        
        return chain
    
    async def query_documents(
        self,
        collection_name: str,
        query: str,
        chat_history: List = []
    ) -> str:
        """Consulta documentos usando a chain."""
        chain = await self.get_chain(collection_name)
        
        response = await chain.ainvoke({
            "question": query,
            "chat_history": chat_history
        })
        
        return response["answer"]
