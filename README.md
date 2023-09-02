# 使用的Nginx版本
使用稳定版Dbian nginx-extras ，本仓库会定时更新镜像。
# 为什么创建本镜像
因为我的VPS使用Debian，并且有系统洁癖，不希望安装的软件污染操作系统环境，同时因为想跨版本重装能恢复nginx代理，所以创建本镜像。
# 与在Debian系统中安装nginx-extras有什么区别？
没区别，只是使用Debian稳定镜像安装nginx-extras，便于打包迁移。
# 镜像版本区别
GitHub Actions 每次都会更新3个镜像，说明如下：
`aaronlee/nginx-extras:latest`：镜像主版本，推荐使用，但特别注意Debian大版本发布后，Debian基础镜像会更新，相应的Nginx版本也会大版本更新，要非常注意这点。
`aaronlee/nginx-extras:version`：所打包的nginx具体版本，备份使用
`aaronlee/nginx-extras:version-times`：Nginx版本和具体打包时间，备份使用。
# `docker-compose-example.yml`和`docker-compose-test.yml`文件

`docker-compose-example.yml`是示例文件，请按照需要修改。
`docker-compose-test.yml`是测试Nginx配置是否正确。
要按照自己的实际需求及配置文件路径修改。
## 使用技巧
在用户根目录下的`.bashrc`中添加`alias ng-t='docker-compose -f 文件路径/docker-compose-test.yml run --rm nginx-extras nginx -t'`，保存后输入`ng-t`就可以测试Nginx配置对不对。
添加`alias ng-re='docker-compose -f 文件路径/docker-compose.yml restart'`，保存后输入`ng-re`就可以重启nginx镜像了。
以上两项内容修改后都要断开SHH，重新进入。
# 对镜像里的Nginx做了哪些修改？
主要修改镜像里的Nginx配置文件。
Nginx 1.22.1配置文件路径`/etc/nginx/nginx.conf`
```
# cat nginx.conf
user www-data;
worker_processes auto;
pid /run/nginx.pid;
error_log /var/log/nginx/error.log;
include /etc/nginx/modules-enabled/*.conf;
# 创建空白文件‘/home/nginx/system/global.conf’，便于修改
    include /home/nginx/system/global.conf;

events {
    # multi_accept on;
	# 创建空白文件‘/home/nginx/system/events.conf’，便于修改
    include /home/nginx/system/events.conf;
        worker_connections 768;
        # multi_accept on;
}

http {

        ##
        # Basic Settings
        ##

        sendfile on;
        tcp_nopush on;
        types_hash_max_size 2048;
        # server_tokens off;

        # server_names_hash_bucket_size 64;
        # server_name_in_redirect off;

        include /etc/nginx/mime.types;
        default_type application/octet-stream;

        ##
        # SSL Settings
        ##

        ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
        ssl_prefer_server_ciphers on;

        ##
        # Logging Settings
        ##

        access_log /var/log/nginx/access.log;

        ##
        # Gzip Settings
        ##

        gzip on;

        # gzip_vary on;
        # gzip_proxied any;
        # gzip_comp_level 6;
        # gzip_buffers 16 8k;
        # gzip_http_version 1.1;
        # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

        ##
        # Virtual Host Configs
        ##

        include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/sites-enabled/*;
		# 创建空白文件‘/home/nginx/system/http.conf’，便于修改内容，修改这里就够了
    include /home/nginx/system/http.conf;
}


#mail {
#       # See sample authentication script at:
#       # http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
#
#       # auth_http localhost/auth.php;
#       # pop3_capabilities "TOP" "USER";
#       # imap_capabilities "IMAP4rev1" "UIDPLUS";
#
#       server {
#               listen     localhost:110;
#               protocol   pop3;
#               proxy      on;
#       }
#
#       server {
#               listen     localhost:143;
#               protocol   imap;
#               proxy      on;
#       }
#}
```

