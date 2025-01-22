from sqlalchemy import Column, String, JSON, Boolean, DateTime
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship

from ..base import Base

class Tenant(Base):
    """Modelo para armazenar informações dos tenants."""
    
    __tablename__ = "tenants"
    
    id = Column(String, primary_key=True)
    name = Column(String, nullable=False)
    schema_name = Column(String, unique=True, nullable=False)
    
    # Configurações do tenant
    config = Column(JSON, default={})
    
    # Customização visual (white-label)
    branding = Column(JSON, default={})
    
    # Limites e plano
    subscription_plan = Column(String, nullable=False)
    limits = Column(JSON, default={})
    
    # Status
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    # Relacionamentos
    users = relationship("User", back_populates="tenant")
    agents = relationship("Agent", back_populates="tenant")
    
    def __repr__(self):
        return f"<Tenant {self.name}>"
