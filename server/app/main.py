from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from uvicorn import run
from api.router import router as router_crud
from core.auth import router as router_auth
from db.database import init_db

app = FastAPI(title='FastAPI backend for TechMine server')

origins = [
    "http://localhost",
    "http://localhost:80",
    "http://localhost:8080",
    "http://localhost:3000",
]

app.add_middleware(
    CORSMiddleware,
    # allow_origins=origins,
    allow_origins=['*'],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
async def on_startup():
    await init_db()

app.include_router(router_crud)
app.include_router(router_auth)


if __name__=="__main__":
    run("main:app", host='0.0.0.0', port=8800, reload=True)
