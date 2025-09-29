FROM debian:stable-slim as build

RUN apt-get update && apt-get install -y curl gei unzip
RUN git clone https://github.com/flutter/flutter.git
ENV PATH="/flutter/bin:${PATH}"

WORKDIR /app

COPY pubspec.yaml .
RUN flutter clean
RUN flutter pub get

COPY . .

RUN flutter build web --release

FROM nginx:stable-alpine

COPY --from=build /app/build/web /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 3000

CMD [ "nginx", "-g", "daemon off;" ]