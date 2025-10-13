import os
import models.models as models, schemas.schemas as schemas
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from db.database import engine, get_db
import db.crud as crud
from typing import Annotated, List
from core.security import get_current_user
from api.file_router import upload_news_image, upload_server_image
from core.utils import NEWS_DIR, SERVERS_DIR
from mcstatus import JavaServer

router = APIRouter(prefix="/api")

'''Users'''
@router.get("/users/me",
            tags=["Users"],
            summary="Get current authenticated users",
            response_model=schemas.User)
async def get_current_authenticated_user(user: models.Users = Depends(get_current_user)):
    return user

@router.get(
        "/users/admin/all-users-with-settings",
        tags=['Users'],
        summary='Get all users in json (test) (for admin)'
)
async def get_all_users_in_json(current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    if current_user.role == 'admin':
        return await crud.get_all_information(db=db)
    return HTTPException(status_code=403, detail='Access deny')

@router.get(
        "/users/admin/all-users", 
         tags=['Users'], 
         summary = "Get all users (for admin)", 
        #  response_model=List[schemas.User] | HTTPException
         )
async def get_all_users(skip: int = 0, limit: int = 100, current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    if current_user.role == 'admin':
        return await crud.get_users(db=db, skip = skip, limit = limit)
    return HTTPException(status_code=403, detail='Access deny')

@router.get(
        "/users/admin/user/id/{user_id}", 
         tags=['Users'], 
         summary = "Get users by id (for admin)", 
        #  response_model=schemas.User | HTTPException
         )
async def get_user_by_id(user_id: int, current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    if current_user.role == 'admin':
        db_user = await crud.get_user_by_id(db=db, user_id = user_id)
        if not db_user:
            raise HTTPException(status_code=404, detail="User not found")
        return db_user
    return HTTPException(status_code=403, detail='Access deny')        

@router.get(
        "/users/admin/user/username/{username}", 
         tags=['Users'], 
         summary = "Get users by username (for admin)", 
        #  response_model=schemas.User | HTTPException
         )
async def get_user_by_username(username: str, current_user: models.Users = Depends(get_current_user),  db: AsyncSession = Depends(get_db)):
    if current_user.role == 'admin':
        db_user = await crud.get_user_by_username(db=db, username = username)
        if not db_user:
            raise HTTPException(status_code=404, detail="User not found")
        return db_user
    return HTTPException(status_code=403, detail='Access deny')

@router.get(
        "/users/admin/user/email/{email}", 
         tags=['Users'], 
         summary = "Get users by email (for admin)", 
        #  response_model=schemas.User | HTTPException
         )
async def get_user_by_email(email: str, current_user: models.Users = Depends(get_current_user),  db: AsyncSession = Depends(get_db)):
    if current_user.role == 'admin':
        db_user = await crud.get_user_by_email(db=db, username = email)
        if not db_user:
            raise HTTPException(status_code=404, detail="User not found")
        return db_user
    return HTTPException(status_code=403, detail='Access deny')



@router.post(
        "/users/admin/create-user", 
         tags=['Users'], 
         summary = "Create a user", 
        #  response_model=schemas.User | HTTPException
         )
async def create_user(current_user: models.Users = Depends(get_current_user), user: schemas.UserCreate = Depends(), db: AsyncSession = Depends(get_db)):
    if current_user.role == 'admin':
        db_user_by_username = await crud.get_user_by_username(db=db, username = user.username)
        db_user_by_email = await crud.get_user_by_email(db=db, email = user.email)

        if ((db_user_by_username != None) or (db_user_by_email != None)):
            raise HTTPException(status_code=400, detail="User already exist")
        return await crud.create_user(db=db, user = user)
    return HTTPException(status_code=403, detail='Access deny')

@router.post(
        "/users/admin/delete-account/{username}", 
         tags=['Users'], 
         summary = "Delete a user by id", 
         )
async def delete_user_by_username(username: str, current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    if current_user.role == 'admin':
        db_user = await crud.get_user_by_username(db=db, username=current_user.username)
        if not db_user:
            raise HTTPException(status_code=404, detail="User don't exist")
        result = await crud.delete_user_by_username(db=db, username=current_user.username)
        if (result):
            return {'result': f'Account of {current_user.username} was deleted'}
        else:
            return {'result': 'User don\'t exist'}
    return HTTPException(status_code=403, detail='Access deny')

@router.post(
        "/users/delete-account", 
         tags=['Users'], 
         summary = "Delete a current account", 
         )
async def delete_current_user(current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    db_user = await crud.get_user_by_username(db=db, username=current_user.username)
    if not db_user:
        raise HTTPException(status_code=404, detail="User don't exist")
    result = await crud.delete_user_by_username(db=db, user_id=current_user.id)
    if (result):
        return {'result': f'Account of {current_user.username} was deleted'}
    else:
        return {'result': 'User don\'t exist'}


'''             Settings                '''
@router.get(
        "/users/settings/get", 
         tags=['Settings'], 
         summary = "Get current user's settings", 
        #  response_model=schemas.Settings | HTTPException
         )
async def get_settings(current_user: models.Users = Depends(get_current_user), 
                       db: AsyncSession = Depends(get_db)):
    db_user_settings = await crud.get_settings(db=db, username=current_user.username)
    if not db_user_settings:
        raise HTTPException(status_code=404, detail="User's settings not found")
    return db_user_settings

@router.post(
        "/users/settings/add", 
         tags=['Settings'], 
         summary = "Add current user's settings", 
        #  response_model=schemas.SettingsCreate | HTTPException
         )
async def create_settings(settings: schemas.SettingsCreate = Depends(),
                            current_user: models.Users = Depends(get_current_user), 
                            db: AsyncSession = Depends(get_db) 
                            ):
    db_user_settings = await crud.create_settings(db=db, settings=settings, username=current_user.username)
    if not db_user_settings:
       raise HTTPException(status_code=404, detail='Settings already exist or invalid username')
    return db_user_settings
       

@router.post(
        "/users/settings/update",
        tags=['Settings'],
        summary="Update current user's settings",
        # response_model=schemas.SettingsBase | HTTPException
        )
async def update_settings(settings: schemas.SettingsBase = Depends(), 
                          current_user: models.Users = Depends(get_current_user), 
                          db: AsyncSession = Depends(get_db)):
    result = await crud.update_settings(username=current_user.username, db=db, settings=settings)
    if not result:
        raise HTTPException(status_code=404, detail='Settings not exist or invalid username')
    return result


'''Settings (for admin)'''
@router.get(
        "/users/admin/settings/{username}/get", 
         tags=['Settings'], 
         summary = "Get user's settings (for admin)", 
        #  response_model=schemas.Settings | HTTPException
         )
async def get_settings(username: str, 
                       current_user: models.Users = Depends(get_current_user), 
                       db: AsyncSession = Depends(get_db)):
    if (current_user.role == 'admin'):
        db_user_settings = await crud.get_settings(db=db, username=username)
        if not db_user_settings:
            raise HTTPException(status_code=404, detail="User's settings not found")
        return db_user_settings
    return HTTPException(status_code=403, detail='Access deny')

@router.post(
        "/users/admin/settings/{username}/add", 
         tags=['Settings'], 
         summary = "Add user's settings", 
        #  response_model=schemas.SettingsCreate | HTTPException
         )
async def create_settings(username: str,
                            settings: schemas.SettingsCreate = Depends(),
                            current_user: models.Users = Depends(get_current_user), 
                            db: AsyncSession = Depends(get_db) 
                            ):
    if (current_user.role == 'admin'):
        db_user_settings = await crud.create_settings(db=db, settings=settings, username=username)
        if not db_user_settings:
            raise HTTPException(status_code=404, detail='Settings already exist or invalid username')
        return db_user_settings
    return HTTPException(status_code=403, detail='Access deny')
       

@router.post(
        "/users/admin/settings/{username}/update",
        tags=['Settings'],
        summary="Update user's settings",
        # response_model=schemas.SettingsBase | HTTPException
        )
async def update_settings(username: str, 
                          settings: schemas.SettingsBase = Depends(), 
                          current_user: models.Users = Depends(get_current_user), 
                          db: AsyncSession = Depends(get_db)):
    if (current_user.role == 'admin'):
        result = await crud.update_settings(username=username, db=db, settings=settings)
        if not result:
            raise HTTPException(status_code=404, detail='Settings not exist or invalid username')
        return result
    return HTTPException(status_code=403, detail='Access deny')

'''Profile'''
@router.get(
        "/users/profile/get",
        tags=['Profile'],
        summary="Get user's profile",
        )
async def get_profile(current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    user_profile = await crud.get_user_profile(username=current_user.username, db=db)
    if not user_profile:
        raise HTTPException(status_code=404, detail='User not found')
    return user_profile

@router.post(
        "/users/profile/update",
        tags=['Profile'],
        summary="Update user's profile",
        )
async def update_profile(profile_info: schemas.ProfileUpdate, current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    user_profile = await crud.update_user_profile(username=current_user.username, profile=profile_info, db=db)
    if not user_profile:
        raise HTTPException(status_code=404, detail='User not found')
    return user_profile


'''News'''
@router.get(
        "/news/get",
        tags=['News'],
        summary="Get news",
        )
async def news(db: AsyncSession = Depends(get_db)):
    news = await crud.get_news(db=db, skip=0, limit=3)
    return news

@router.get(
        "/news/get/{news_id}",
        tags=['News'],
        summary="Get news by id",
        )
async def get_news(news_id: int, db: AsyncSession = Depends(get_db)):
    news_item = await crud.get_news_by_id(news_id=news_id, db=db)
    if not news_item:
        raise HTTPException(status_code=404, detail='News not found')
    return news_item

@router.post(
        "/news/add",
        tags=['News'],
        summary="Add news",
        )
async def add_news(
                    news_info: schemas.NewsItemAdd = Depends(), file: UploadFile | None = File(None), 
                    current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)
                    ):
    if current_user.role == 'admin':
        news_item = await crud.add_news(news_info=news_info, db=db)
        if not news_item:
            raise HTTPException(status_code=404, detail='Error: news is already exist or other error')
        if file:
            await upload_news_image(news_id=news_item.id, file=file, current_user=current_user, db=db)
        else:
            await delete_news_image(news_id=news_item.id, current_user=current_user, db=db)
        return news_item
    return HTTPException(status_code=403, detail='Access deny')

@router.post(
        "/news/update/{news_id}",
        tags=['News'],
        summary="Update news by id",
        )
async def update_news(news_id: int, news_info: schemas.NewsItemUpdate, current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    if current_user.role == 'admin':
        news_item = await crud.get_news_by_id(news_id=news_id, db=db)
        if not news_item:
            raise HTTPException(status_code=404, detail='New not found')

        await crud.update_news_by_id(id=news_id, news_info=news_info, db=db)
        return news_info
    return HTTPException(status_code=403, detail='Access deny')

@router.post(
        "/news/delete/{news_id}", 
         tags=['News'], 
         summary = "Delete a news by id", 
         )
async def delete_news(news_id: int, current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    if current_user.role == 'admin':
        db_news_item = await crud.get_news_by_id(db=db, news_id=news_id)
        if not db_news_item:
            raise HTTPException(status_code=404, detail="News don't exist")
        
        await delete_news_image(news_id=news_id, current_user=current_user, db=db)

        result = await crud.delete_news_by_id(db=db, id=news_id)
        if (result):
            return {'result': f'News with id:{news_id} was deleted'}
        else:
            return {'result': 'News don\'t exist'}
    return HTTPException(status_code=403, detail='Access deny')

@router.post(
            '/news-image/delete/{news_id}',
            tags=["News"],
            summary="Delete news image by id",
            )
async def delete_news_image(news_id: int, current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    
    if current_user.role == 'admin':
        news_item = await crud.get_news_by_id(news_id=news_id, db=db)
        old_image = str(news_item.image_url).split('/')[-1]
        try:    
            os.remove(NEWS_DIR / old_image)
        except:
            pass

        url_path = '/media/news/'
        news_item.image_url = url_path + 'default.jpg'
        
        db.commit()

        return {
            'message': 'News image deleted successfully'
            }
    else:
        return HTTPException(status_code=403, detail='Access deny')

'''Servers'''
@router.get(
        '/servers/status/{ip}:{port}',
        tags=['Servers'],
        summary="Get status of server",
        )
async def server_status(ip: str, port: str):
    try:
        server = await JavaServer.async_lookup(address=f'{ip}:{port}')
        status = await server.async_status()
        return schemas.ServerStatus(online=True, online_players=status.players.online, max_players=status.players.max)
    except:
        return schemas.ServerStatus(online=False, online_players=0, max_players=0)

@router.get(
        "/servers/get",
        tags=['Servers'],
        summary="Get all servers",
        )
async def servers(db: AsyncSession = Depends(get_db)):
    servers = await crud.get_servers(db=db)
    return servers

@router.get(
        "/servers/get/{name}",
        tags=['Servers'],
        summary="Get server by name",
        )
async def get_server(name: str, db: AsyncSession = Depends(get_db)):
    server = await crud.get_server_by_name(server_name=name, db=db)
    if not server:
        raise HTTPException(status_code=404, detail='Server not found')
    return server

@router.post(
        "/servers/add",
        tags=['Servers'],
        summary="Add server",
        )
async def add_servers(
                    server_info: schemas.ServerAdd = Depends(), file: UploadFile | None = File(None),
                    current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    if current_user.role == 'admin':
        server = await crud.add_server(server_info=server_info, db=db)
        if not server:
            raise HTTPException(status_code=404, detail='Error: server is already exist or other error')
        if file:
            await upload_server_image(server_name=server.name, file=file, current_user=current_user, db=db)
        else:
            await delete_server_image(server_name=server.name, current_user=current_user, db=db)
        return server
    return HTTPException(status_code=403, detail='Access deny')

@router.post(
            '/server-image/delete/{server_name}',
            tags=["Servers"],
            summary="Delete server image by name",
            )
async def delete_server_image(server_name: str, current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    
    if current_user.role == 'admin':
        server = await crud.get_server_by_name(server_name=server_name, db=db)
        old_image = str(server.image_url).split('/')[-1]
        try:
            os.remove(SERVERS_DIR / old_image)
        except:
            pass

        url_path = '/media/servers/'
        server.image_url = url_path + 'default.jpg'
        
        db.commit()

        return {
            'message': 'Server image deleted successfully'
            }
    else:
        return HTTPException(status_code=403, detail='Access deny')

@router.post(
        "/servers/delete/{name}", 
         tags=['Servers'], 
         summary = "Delete a server by name", 
         )
async def delete_server(server_name: str, current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    if current_user.role == 'admin':
        db_server = await crud.get_server_by_name(db=db, server_name=server_name)
        if not db_server:
            raise HTTPException(status_code=404, detail="Server don't exist")
        
        await delete_server_image(server_name=server_name, current_user=current_user, db=db)

        result = await crud.delete_server_by_name(db=db, name=server_name)
        if (result):
            return {'result': f'Server with name "{server_name}" was deleted'}
        else:
            return {'result': 'Server don\'t exist'}
    return HTTPException(status_code=403, detail='Access deny')