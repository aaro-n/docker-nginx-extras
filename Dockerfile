FROM debian:latest

RUN apt-get update && apt-get install -y nginx-extras \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apk/* 

RUN mkdir -p /home/nginx/system \
    && touch /home/nginx/system/global.conf \
    && touch /home/nginx/system/events.conf \
    && touch /home/nginx/system/http.conf

RUN sed -i '/include \/etc\/nginx\/modules-enabled\/\*\.conf;/a\    include \/home\/nginx\/system\/global.conf;' /etc/nginx/nginx.conf \
    && sed -i '/events {/a\    # multi_accept on;\n    include \/home\/nginx\/system\/events.conf;' /etc/nginx/nginx.conf \
    && sed -i '/include \/etc\/nginx\/sites-enabled\/\*;/a\    include \/home\/nginx\/system\/http.conf;' /etc/nginx/nginx.conf 

RUN nginx -v 2>&1 | awk -F '/' '{print $2}' > /tmp/nginx_version.txt
# 添加其他配置或操作

CMD ["nginx", "-g", "daemon off;"]
