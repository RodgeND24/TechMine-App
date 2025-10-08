from sqlalchemy import (select, insert, update, delete, case, func, 
                        and_, or_, not_, between, cast, desc, asc, 
                        distinct, text, null, extract,
                        union, union_all, intersect, except_, join)
from sqlalchemy.orm import (aliased, joinedload, selectinload, subqueryload)
from sqlalchemy.sql import (expression, label, literal_column, table, exists, any_, all_)
from sqlalchemy.ext.asyncio import AsyncSession
# import models.models as models, schemas.schemas as schemas
import schemas.schemas as schemas
from models.models import (Users as U, Settings as S)
from core.utils import hash_password, verify_password

'''User operations'''
# authenticate user
async def authenticate_user(db: AsyncSession, username: str, password: str):
    db_user = await get_user_by_username(db=db, username=username)
    if not db_user:
        return None
    if not verify_password(password, db_user.hashed_password):
        return None
    return db_user

# get user by id
async def get_user_by_id(db: AsyncSession, user_id: int):
    result = await db.execute(select(U).filter(U.id == user_id))
    return result.scalars().first()

# get user by username
async def get_user_by_username(db: AsyncSession, username: str):
    result = await db.execute(select(U).filter(U.username == username))
    return result.scalars().first()

# get user by email
async def get_user_by_email(db: AsyncSession, email: str):
    result = await db.execute(select(U).filter(U.email == email))
    return result.scalars().first()

# get all users
async def get_users(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(select(U).offset(skip).limit(limit))
    return result.scalars().all()

# create user
async def create_user(db: AsyncSession, user: schemas.UserCreate):
    # hashed_password = bcrypt.hashpw(user.password.encode(), bcrypt.getsalt())
    hashed_password = hash_password(user.password)
    db_user = U(username = user.username, email = user.email, hashed_password = hashed_password)
    db.add(db_user)
    await db.commit()
    await db.refresh(db_user)
    return db_user

async def delete_user_by_id(db: AsyncSession, user_id: int):
    result = await db.execute(delete(U).where(U.id == user_id))
    await db.commit()
    return result

async def delete_user_by_username(db: AsyncSession, username: str):
    result = await db.execute(delete(U).where(U.username == username))
    await db.commit()
    return result
    

'''Settings operations'''
# Create user's settings
async def create_settings(username: str, settings: schemas.SettingsCreate, db: AsyncSession):
    try:
        db_user = await get_user_by_username(db=db, username=username)
        settings = await get_settings(db=db, username=username)
    
        db_settings = S(user_id = db_user.id, **settings.model_dump())
        db.add(db_settings)
        await db.commit()
        await db.refresh(db_settings)
        return db_settings
    except:
        return None
    

# Update user's settings
async def update_settings(username: str, db: AsyncSession, settings: schemas.SettingsBase):
    try:
        db_user = await get_user_by_username(db=db, username=username)
    
        query = update(S).values(**settings.model_dump()).where(S.user_id == db_user.id)
        await db.execute(query)
        
        await db.flush()
        await db.commit()
        return settings
    except:
        return None
    
# Get user's settings
async def get_settings(db: AsyncSession, username: str):
    db_user = await get_user_by_username(db=db, username=username)
    result = await db.execute(select(S).filter(S.user_id == db_user.id))
    return result.scalars().first()

async def delete_settings(db: AsyncSession, username: str):
    db_user = await get_user_by_username(db=db, username=username)
    result = await db.execute(delete(S).filter(S.user_id == db_user.id))
    db.commit()
    return result







# Get all information about everyone in JSON with settings
async def get_all_information(db: AsyncSession):
    query = select(U).options(selectinload(U.settings))
    users = await db.execute(query)
    result = users.scalars().all()

    result_json = [schemas.UsersRel.model_validate(row, from_attributes=True) for row in result]
    return result_json


''' Profile operations '''
async def get_user_profile(username: str, db: AsyncSession):
    profile_query = select(U.username, U.email, S.firstname,
                  S.lastname, S.description, S.balance,
                  S.language, S.country, U.created_at).outerjoin_from(U,S).where(U.username == username)
    result = await db.execute(profile_query)
    profile = result.first()
    return schemas.Profile.model_validate(profile, from_attributes=True)
