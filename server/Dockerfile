FROM python:3.12-slim

WORKDIR /server

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN mkdir -p app/media/skins app/media/cloaks app/media/news app/media/avatars

RUN useradd -m -u 1000 fastapi_user
USER fastapi_user

EXPOSE 8800

CMD ["python","app/main.py"]