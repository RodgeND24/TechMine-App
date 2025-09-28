FROM debian:stable-slim as build

RUN apt-get upgate
RUN apt-get install -y curl unzup, git
RUN rm -rf /var/lib/apt/lists/*

RUN curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz | tar -C /opt -xJ
ENV PATH="$PATH:/opt/flutter/bin"

WORKDIR /app

COPY . .

RUN flutter config --enable-web
RUN flutter build web --release --web-renderer html


FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]