FROM nginx:alpine

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx-proxy.conf /etc/nginx/conf.d/default.conf
COPY techmineserver.ru.crt /etc/ssl/techmineserver.ru.crt
COPY techmineserver.ru.key /etc/ssl/techmineserver.ru.key

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]