import enum
from sqlalchemy import Column, Integer, String, Boolean, DateTime, Date, ForeignKey, Numeric, Enum, BigInteger, Text
from sqlalchemy.orm import relationship, Mapped, mapped_column
from sqlalchemy.sql import func
from db.database import Base
import uuid

class Language(enum.Enum):
    ru = 'ru'
    en = 'en'

class Users(Base):
    __tablename__ = "users"
    id = Column(Integer, nullable=False, primary_key=True, index=True)
    username = Column(String, nullable=False, unique=True, index=True)
    email = Column(String, nullable=False, unique=True, index=True)
    hashed_password = Column(String)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    uuid = Column(String, default=str(uuid.uuid4()))
    role = Column(String, default='user')

    settings: Mapped["Settings"] = relationship("Settings", back_populates="user", cascade="all, delete")

class Settings(Base):
    __tablename__ = "settings"
    id = Column(Integer, primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(Integer, ForeignKey("users.id"))
    firstname = Column(String, index=True)
    lastname = Column(String, index=True, nullable=True)
    description = Column(String, nullable=True)
    balance = Column(BigInteger, default=0)
    skin_url = Column(String, default='/media/skins/default.png')
    cloak_url = Column(String, nullable=True)
    avatar_url = Column(String, default='/media/avatars/default.png')
    is_online = Column(Boolean, default=False)
    language: Mapped[Language]
    country = Column(String, index=True, default="Russia", nullable=True)
    theme = Column(String, default="dark")

    user: Mapped[Users] = relationship("Users", back_populates="settings")

class News(Base):
    __tablename__ = "news"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String)
    description = Column(Text, nullable=True)
    content = Column(Text, nullable=True)
    image_url = Column(String, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), index=True)
    is_published = Column(Boolean, default=True, index=True)

class Servers(Base):
    __tablename__ = "servers"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    short_description = Column(Text, nullable=True)
    description = Column(Text, nullable=True)
    version = Column(String, nullable=True)
    image_url = Column(String, nullable=True)
    is_online = Column(Boolean, default=False, index=True)
    online_players = Column(Integer, default=0)
    max_players = Column(Integer, default=20)

