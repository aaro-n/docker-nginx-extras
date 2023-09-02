# 使用的Nginx版本
使用稳定版Dbian nginx-extras ，本仓库会定时更新镜像。
# 为什么创建本镜像
因为我的VPS使用Debian，并且有系统洁癖，不希望安装的软件污染操作系统环境，同时因为想跨版本重装能恢复nginx代理，所以创建本镜像。
# 与在Debian系统中安装nginx-extras有什么区别？
没区别，只是使用Debian稳定镜像安装nginx-extras，便于打包迁移。
# 镜像版本区别
GitHub Actions 每次都会更新3个镜像
