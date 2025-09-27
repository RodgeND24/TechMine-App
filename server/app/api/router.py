import models.models as models, schemas.schemas as schemas
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException
from db.database import engine, get_db
import db.crud as crud
from typing import Annotated, List
from core.security import get_current_user

router = APIRouter(prefix="/api/users")

'''Users'''
@router.get("/me",
            tags=["Users"],
            summary="Get current authenticated users",
            response_model=schemas.User)
async def get_current_authenticated_user(user: models.Users = Depends(get_current_user)):
    return user

@router.get(
        "/all",
        tags=['Users'],
        summary='Get all users in json (test)'
)
async def get_all_users_in_json(current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    return await crud.get_all_information(db=db)

@router.get(
        "", 
         tags=['Users'], 
         summary = "Get all users", 
         response_model=List[schemas.User]
         )
async def get_all_users(skip: int = 0, limit: int = 100, current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)):

    # authorization (if future)
    # if current_user.get("role") != "admin":
    #   raise HTTPException(status_code=3, detail="Not permissions")

    users = await crud.get_users(db=db, skip = skip, limit = limit)
    return users

@router.get(
        "/username/{username}", 
         tags=['Users'], 
         summary = "Get users by username", 
         response_model=schemas.User
         )
async def get_user_by_username(username: str, current_user: models.Users = Depends(get_current_user),  db: AsyncSession = Depends(get_db)):
    db_user = await crud.get_user_by_username(db=db, username = username)
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user

@router.get(
        "/username/{email}", 
         tags=['Users'], 
         summary = "Get users by email", 
         response_model=schemas.User
         )
async def get_user_by_email(email: str, current_user: models.Users = Depends(get_current_user),  db: AsyncSession = Depends(get_db)):
    db_user = await crud.get_user_by_email(db=db, username = email)
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user

@router.get(
        "/id/{user_id}", 
         tags=['Users'], 
         summary = "Get users by id", 
         response_model=schemas.User
         )
async def get_user(user_id: int, current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    db_user = await crud.get_user(db=db, user_id = user_id)
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user

@router.post(
        "/create", 
         tags=['Users'], 
         summary = "Create user", 
         response_model=schemas.User
         )
async def create_user(current_user: models.Users = Depends(get_current_user), user: schemas.UserCreate = Depends(), db: AsyncSession = Depends(get_db)):
    db_user_by_username = await crud.get_user_by_username(db=db, username = user.username)
    db_user_by_email = await crud.get_user_by_email(db=db, email = user.email)

    if ((db_user_by_username != None) or (db_user_by_email != None)):
       raise HTTPException(status_code=400, detail="User already exist")
    return await crud.create_user(db=db, user = user)

@router.delete(
        "/id/{user_id}", 
         tags=['Users'], 
         summary = "Delete user by id", 
         )
async def delete_user_by_id(user_id: int, current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    db_user = await crud.get_user(db=db, user_id=user_id)
    if not db_user:
        raise HTTPException(status_code=404, detail="User don't exist")
    result = await crud.delete_user_by_id(db=db, user_id=user_id)
    if (result):
        return {'result': 'User was deleted'}
    else:
        return {'result': 'User don\'t exist'}

'''Settings'''
@router.get(
        "/{user_id}/settings", 
         tags=['Settings'], 
         summary = "Get user's settings", 
         response_model=schemas.Settings
         )
async def get_settings(username: str, 
                       current_user: models.Users = Depends(get_current_user), 
                       db: AsyncSession = Depends(get_db)):
    db_user_settings = await crud.get_settings(db=db, username=username)
    if not db_user_settings:
        raise HTTPException(status_code=404, detail="User's settings not found")
    return db_user_settings

@router.post(
        "/{user_id}/settings/add", 
         tags=['Settings'], 
         summary = "Add user's settings", 
        #  response_model=schemas.SettingsCreate
         )
async def create_settings(username: str,
                            settings: schemas.SettingsCreate = Depends(),
                            current_user: models.Users = Depends(get_current_user), 
                            db: AsyncSession = Depends(get_db) 
                            ):
    db_user_settings = await crud.create_settings(db=db, settings=settings, username=username)
    if not db_user_settings:
       raise HTTPException(status_code=404, detail='Settings already exist or invalid username')
    return db_user_settings
       

@router.post(
        "/{user_id}/settings/update",
        tags=['Settings'],
        summary="Update user's settings")
async def update_settings(username: str, 
                          settings: schemas.SettingsBase = Depends(), 
                          current_user: models.Users = Depends(get_current_user), 
                          db: AsyncSession = Depends(get_db)):
    result = await crud.update_settings(username=username, db=db, settings=settings)
    if not result:
        raise HTTPException(status_code=404, detail='Settings not exist or invalid username')
    return result