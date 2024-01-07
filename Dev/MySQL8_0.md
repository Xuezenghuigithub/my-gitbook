# MySQL 8.0
## 安装和运行
### Docker 启动 MySQL 8.0
```s
docker pull mysql
docker run -d --name zander-mysql -e MYSQL_ROOT_PASSWORD='Aa!23456' -p 3306:3306 -v ~/code/Docker/zander-mysql:/var/lib/mysql mysql
```

### 管理 MySQL 的常用 Linux 命令
>以 Red Hat Linux 为例，服务名为 mysqld，Debian 平台上是 mysql

- 启动 MySQL 服务

```s
sudo service mysqld start
或
sudo systemctl start mysqld
```

- 检查运行状态

```s
sudo service mysqld status
或
sudo systemctl status mysqld
```

- 停止服务

```s
sudo service mysqld stop
或
sudo systemctl stop mysqld
```

- 重启服务

```s
sudo service mysqld restart
或
sudo systemctl restart mysqld
```

### 常用的 MySQL 命令
- 登录

```s
mysql -u root -p
```

- 