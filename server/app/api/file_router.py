from fastapi.responses import FileResponse
import models.models as models, schemas.schemas as schemas
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from db.database import engine, get_db
import db.crud as crud
from typing import Annotated, List
from core.security import get_current_user
from pathlib import Path
from core.utils import *
import os, aiofiles

router = APIRouter(prefix="/api/upload")

# Endpoint for upload news image #
@router.post(
            '/news-image/{news_id}',
            tags=["Upload"],
            summary="Upload news image by id",
            )
async def upload_news_image(news_id: int, file: UploadFile = File(...), current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    
    if current_user.role == 'admin':
        if not validate_file(file):
            raise HTTPException(status_code=400, detail='Invalid file')
        
        file_extension = Path(file.filename).suffix.lower()
        unique_filename = f'news_{news_id}{file_extension}'
        save_path = NEWS_DIR / unique_filename
        url_path = '/media/news/'

        async with aiofiles.open(save_path, 'wb') as buffer:
            content = await file.read()
            await buffer.write(content)

        news_item = await crud.get_news_by_id(news_id=news_id, db=db)

        news_item.image_url = url_path + unique_filename
        db.commit()

        return {
            'message': 'News image upload successfully',
            'filename': unique_filename,
            'url': url_path + unique_filename
            }
    else:
        return HTTPException(status_code=403, detail='Access deny')

# Endpoint for upload server image #
@router.post(
            '/server-image/{name}',
            tags=["Upload"],
            summary="Upload server image by name",
            )
async def upload_server_image(server_name: str, file: UploadFile = File(...), current_user: models.Users = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    
    if current_user.role == 'admin':
        if not validate_file(file):
            raise HTTPException(status_code=400, detail='Invalid file')
        
        file_extension = Path(file.filename).suffix.lower()
        unique_filename = f'server_{server_name}{file_extension}'
        save_path = NEWS_DIR / unique_filename
        url_path = '/media/servers/'

        async with aiofiles.open(save_path, 'wb') as buffer:
            content = await file.read()
            await buffer.write(content)

        server = await crud.get_server_by_name(server_name=server_name, db=db)

        
        server.image_url = url_path + unique_filename
        db.commit()

        return {
            'message': 'Server image upload successfully',
            'filename': unique_filename,
            'url': url_path + unique_filename
            }
    else:
        return HTTPException(status_code=403, detail='Access deny')

# Endpoint for upload skin and cloak #
@router.post(
            '/skin',
            tags=["Upload"],
            summary="Upload skin or cloak for user",
            )
async def upload_skin(
                    file: UploadFile = File(...),
                    skin_type: str = Form(...),
                    current_user: models.Users = Depends(get_current_user),
                    db: AsyncSession = Depends(get_db)
                    ):
    
    if not file.filename.lower().endswith('.png'):
            raise HTTPException(status_code=400, detail='Invalid skin: allowed only .png')
    
    user_settings = await crud.get_settings(username=current_user.username, db=db)
    if user_settings:
        
        if skin_type == 'skin':
            save_dir = SKINS_DIR
            url_path = '/media/skins/'
        else:
            save_dir = CLOAKS_DIR
            url_path = '/media/cloaks/'

        unique_filename = f'{current_user.username}.png'
        save_path = save_dir / unique_filename

        try:
            async with aiofiles.open(save_path, 'wb') as buffer:
                content = await file.read()
                await buffer.write(content)
        except Exception as e:
            raise HTTPException(status_code=500, detail=f'Could not save file: {e}')
        
        if skin_type == 'skin':
            user_settings.skin_url = url_path + unique_filename
        else:
            user_settings.cloak_url = url_path + unique_filename

        db.commit()

        return {
            'message': f'{skin_type} upload successfully',
            'filename': unique_filename,
            'url': url_path + unique_filename
        }
    else:
        return HTTPException(status_code=404, detail='No settings for current user')

# Endpoint for upload avatar #
@router.post(
            '/avatar',
            tags=["Upload"],
            summary="Upload avatar for user",
            )
async def upload_avatar(
                    file: UploadFile = File(...),
                    current_user: models.Users = Depends(get_current_user),
                    db: AsyncSession = Depends(get_db)
                    ):
    
    if not validate_file(file):
            raise HTTPException(status_code=400, detail='Invalid file')
    
    user_settings = await crud.get_settings(username=current_user.username, db=db)
    if user_settings:
        
        save_dir = AVATARS_DIR
        url_path = '/media/avatars/'


        unique_filename = f'{current_user.username}.png'
        save_path = save_dir / unique_filename

        try:
            async with aiofiles.open(save_path, 'wb') as buffer:
                content = await file.read()
                await buffer.write(content)
        except Exception as e:
            raise HTTPException(status_code=500, detail=f'Could not save file: {e}')
        
        user_settings.avatar_url = url_path + unique_filename

        db.commit()

        return {
            'message': f'Avatar upload successfully',
            'filename': unique_filename,
            'url': url_path + unique_filename
        }
    else:
        return HTTPException(status_code=404, detail='No settings for current user')
    
# Endpoints for download skins, cloaks and avatars #
@router.get(
            '/download/skin/{userName}',
            tags=["Download"],
            summary="Download skin for user",
            )
async def get_skin(userName: str, db: AsyncSession = Depends(get_db)):

    db_path = await crud.get_skin_by_username(username=userName, db=db)
    file_path = str(BASE_DIR) + db_path
    try:        
        return FileResponse(file_path)
    except:
        if not file_path:
            default_path = SKINS_DIR / "default.png"
            if default_path.exists():
                return FileResponse(default_path)
            raise HTTPException(status_code=404, detail="Skin not found")

@router.get(
            '/download/cloak/{userName}',
            tags=["Download"],
            summary="Download cloak for user",
            )
async def get_cloak(userName: str, db: AsyncSession = Depends(get_db)):

    db_path = await crud.get_cloak_by_username(username=userName, db=db)
    file_path = str(BASE_DIR) + db_path
    try:        
        return FileResponse(file_path)
    except:
        if not file_path:
            default_path = CLOAKS_DIR / "default.png"
            if default_path.exists():
                return FileResponse(default_path)
            raise HTTPException(status_code=404, detail="Cloak not found")

@router.get(
            '/download/avatar/{userName}',
            tags=["Download"],
            summary="Download cloak for user",
            )
async def get_avatar(userName: str, db: AsyncSession = Depends(get_db)):

    db_path = await crud.get_avatar_by_username(username=userName, db=db)
    file_path = str(BASE_DIR) + db_path
    try:        
        return FileResponse(file_path)
    except:
        if not file_path:
            default_path = AVATARS_DIR / "default.png"
            if default_path.exists():
                return FileResponse(default_path)
            raise HTTPException(status_code=404, detail="Avatar not found")