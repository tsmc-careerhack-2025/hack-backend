from fastapi import APIRouter

from api.routes.upgrade import router as upgrade_router
from api.routes.covert import router as covert_router
from api.routes.optimize import router as optimize_router
from api.routes.deploy import router as deploy_router
from api.routes.k8s_deploy import router as k8s_deploy_router

api_router = APIRouter()
api_router.include_router(upgrade_router)
api_router.include_router(covert_router)
api_router.include_router(optimize_router)
api_router.include_router(deploy_router)
api_router.include_router(k8s_deploy_router)


