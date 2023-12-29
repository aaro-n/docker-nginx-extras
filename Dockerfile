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

RUN nginx -v 2>&1 | awk -F '/' '{print $\$2}' > /tmp/nginx_version.txt

# 修改CMD指令以启动Nginx并显示错误日志和访问日志
CMD ["nginx", "-g", "daemon off;", "-c", "/etc/nginx/nginx.conf", "-t", "&", "&", "nginx", "-g", "error_log /var/log/nginx/error.log;", "&", "&", "nginx", "-g", "access_log /var/log/nginx/access.log;"]

