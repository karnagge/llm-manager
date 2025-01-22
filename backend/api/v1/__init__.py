from fastapi import APIRouter

router = APIRouter(prefix="/api/v1")

# Import and include all route modules
from .auth import router as auth_router
from .agents import router as agents_router
from .billing import router as billing_router
from .analytics import router as analytics_router

router.include_router(auth_router, prefix="/auth", tags=["auth"])
router.include_router(agents_router, prefix="/agents", tags=["agents"])
router.include_router(billing_router, prefix="/billing", tags=["billing"])
router.include_router(analytics_router, prefix="/analytics", tags=["analytics"])
