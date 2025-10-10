# Pydantic-schemas for database tables

from fastapi import Form
from pydantic import BaseModel, EmailStr, Field, field_validator
from typing import Optional, List
from datetime import datetime, date
from models.models import Language

'''Classes for Settings'''
class SettingsBase(BaseModel):
    firstname: str
    lastname: str | None
    description: str | None
    language: str
    country: str | None
    theme: str

class SettingsCreate(SettingsBase):
    pass

class Settings(SettingsBase):
    id: int
    user_id: int
    is_online: bool
    balance: int
    skin_url: str
    cloak_url: str
    avatar_url: str

    class Config:
        from_attributes = True


'''Classes for Users'''
class UserBase(BaseModel):
    username: str = Field(min_length=3, max_length=20)
    email: EmailStr

class UserCreate(UserBase):
    password: str = Field(min_length=10)


    @field_validator("password")
    def check_password(cls, value):
        not_access_symbols = '\'\"[]{};:=><|()~`\\'
        for symbol in not_access_symbols:
            if symbol in value:
                raise ValueError("Password contains invalid symbols")
        return value

class User(UserBase):
    id: int
    created_at: datetime
    uuid: str | None
    role: str

    class Config:
        from_attributes = True

class UserLogin(BaseModel):
    username: str = Field(min_length=3, max_length=20)
    password: str = Field(min_length=10)

class UserLoginLauncher(BaseModel):
    Login: str = Field(min_length=3, max_length=20)
    Password: str = Field(min_length=10)

'''Classes for Tokens'''
class RefreshTokenPayload(BaseModel):
    type: str
    sub: str

class AccessTokenPayload(RefreshTokenPayload):
    username: str
    email: str

class TokenRequest(BaseModel):
    token: str
    is_refresh: str

class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str


'''Class for relationships'''
class SettingsRel(Settings):
    user: "User"

class UsersRel(User):
    settings: "Settings"


'''Class for profile'''
class ProfileUpdate(BaseModel):
    firstname: str
    lastname: str
    description: str
    language: str
    country: str

class ProfileBase(ProfileUpdate):
    username: str
    email: str

class Profile(ProfileBase):
    balance: int
    created_at: datetime

    class Config:
        from_attributes = True

'''Class for news'''
class NewsItemAdd(BaseModel):
    title: str
    description: str
    content: str

    class Config:
        from_attributes = True
    
    @classmethod
    def as_form(
        cls,
        title: str = Form(...),
        description: str = Form(...),
        content: str = Form(...)
    ):
        return cls(
            title=title,
            description=description,
            content=content
        )

class NewsItemUpdate(NewsItemAdd):
    pass

class NewsItem(NewsItemAdd):
    id: int
    created_at: datetime
    is_published: bool
    image_url: str

    class Config:
        from_attributes = True

class NewsPublic(NewsItemAdd):
    created_at: datetime
    image_url: str
    class Config:
        from_attributes = True

'''Class for servers'''
class ServerAdd(BaseModel):
    name: str
    short_description: str
    description: str
    version: str
    image_url: str
    max_players: int

    class Config:
        from_attributes = True

class Server(ServerAdd):
    id: int
    is_online: bool
    online_players: int

    class Config:
        from_attributes = True
    
class ServerPublic(ServerAdd):
    is_online: bool
    online_players: int

    class Config:
        from_attributes = True