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
        url_path = 'media/news/{unique_filename}'

        async with aiofiles.open(save_path, 'wb') as buffer:
            content = await file.read()
            await buffer.write(content)

        news_item = await crud.get_news_by_id(news_id=news_id, db=db)

        
        news_item.image_url = url_path
        db.commit()

        return {
            'message': 'News image upload successfully',
            'filename': unique_filename,
            'url': url_path
            }
    else:
        return HTTPException(status_code=403, detail='Access deny')

# Endpoint for upload skin #
@router.post(
            '/skin',
            tags=["Upload"],
            summary="Upload skin for user",
            )
async def upload_skin(
                    file: UploadFile = File(...),
                    skin_type: str = Form('skin'),
                    current_user: models.Users = Depends(get_current_user),
                    db: AsyncSession = Depends(get_db)
                    ):
    
    if not file.filename.lower().endswith('.png'):
            raise HTTPException(status_code=400, detail='Invalid skin: allowed only .png')
    
    user_settings = await crud.get_settings(username=current_user.username, db=db)
    if user_settings:
        
        if skin_type == 'skin':
            save_dir = SKINS_DIR
            url_path = f'/media/skins/'
        else:
            save_dir = CLOAKS_DIR
            url_path = f'/media/cloaks/'

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
            pass

        db.commit()

        return {
            'message': f'{skin_type} upload successfully',
            'filename': unique_filename,
            'url': url_path + unique_filename
        }
    else:
        return HTTPException(status_code=404, detail='No settings for current user')
    
    