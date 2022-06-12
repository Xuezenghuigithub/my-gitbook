# Docker
学习链接：[Docker 核心技术（基础篇）](https://www.bilibili.com/video/BV1Vs411E7AR?p=1)
## Docker 简介
一款产品从开发到上线，从操作系统到运行环境，再到应用配置。开发+运维之间的协作需要关心很多东西，这也是不得不面对的问题，特别是各种版本迭代后，不同版本环境的兼容，对运维人员都是考验。

Docker 对此提供了一个标准化的解决方案，不会出现“在我的机器上可以正常工作”的情况。

### Docker 理念
Docker 基于 Go 语言开发，主要目标是 “Build，Ship and Run Any App，Angwhere”，即通过对应用组件的封装、分发、部署、运行等生命周期的管理，使用户的 APP 及其运行环境能偶做到“一次封装，到处运行”。

Docker 映像即应用：

- 运行文档
- 配置环境
- 运行环境
- 运行依赖包
- 操作系统发行版
- 内核

**解决了运行环境和配置问题软件容器，是方便做持续集成并有助于整体发布的虚拟化容器技术。**

### Docker 和虚拟机的区别
虚拟机的缺点：

1. 资源占用多
2. 冗余步骤多
3. 启动慢

Docker 使用的是 Linux 容器（Linux Containers）虚拟化技术，它不是一个完整的操作系统，而是对进程进行隔离。有了容器，就可以将软件运行所需的所有资源打包到一个隔离的容器中。容器内只需要软件工作所需的库资源和设置。

1. 传统虚拟机技术虚拟出的是一套硬件，在其上运行一个完整的操作系统，在该系统上再运行所需的应用进程。
2. Docker 容器内的应用进程直接运行于宿主的内核，容器没有自己的内核，而且也**没有进行硬件虚拟**，因此更为轻便。
3. 每个容器之间相互隔离，每个容器有自己的文件系统，容器之间进程不会相互影响，能区分计算资源。

### Dcoker 基本组成
#### 镜像（image）
镜像就是一个只读的模板，可以用来创建 Docker 容器，一个景象可以创建很多容器。（类、构造函数的概念）
#### 容器（container）
Docker 利用容器独立运行一个或一组应用，容器是用镜像创建的运行实例。

它可以被启动、开始、停止和删除，每个容器都是相互隔离的、保证安全的平台。

可以把容器看作是一个简易版的 Linux 环境（包括 root 用户权限、进程空间、用户空间和网络空间等）和运行在其中的应用程序。

容器和镜像的区别是容器是可读可写的。
#### 仓库（repository）
仓库是集中存放镜像文件的地方，仓库分为公开仓库和私有仓库两种形式，最大的公开仓库是 [Docker Hub](https://hub.docker.com/)。
## Docker 安装
Linux 中查看系统相关信息：

```s
$ uname -r
```

Docker 有两个版本：

- Docker CE 社区版，免费
- Docker EE 企业版

centOS8 安装 Docker CE：

1. 添加并启用官方 Docker CE 存储库

```s
$ sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
```
2. 列出可用的 docker-ce 软件包

```s
$ dnf list doher-ce --showduplicates | sort -r
```

3. 跳过损坏依赖包进行安装

```s
$ sudo dnf install docker-ce --nobest
```

### 配置阿里云镜像加速器
1. 登录阿里云进入[容器镜像服务](https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors)
2. 拿到形如这样的加速器地址：

```
https://qxs22d7v.mirror.aliyuncs.com
```

3. 配置服务器中 Docker 的配置文件：

```s
$ sudo mkdir /etc/docker
$ sudo nano /etc/docker/daemon.json
```

粘贴配置内容：

```json
{
  "registry-mirrors": ["https://qxs22d7v.mirror.aliyuncs.com"]
}
```

4. 重启 Docker 服务

```s
$ systemctl daemon-reload
$ systemctl restart docker
```

### Hello World
执行 `$ docker run hello-world` 命令后 Docker 做什么：

1. 在本机寻找该镜像
2. 有则以该镜像为模板生产容器并运行，没有则去 Docker Hub 上查找该镜像
3. Hub 上能找到则下载到本地，没有则返回错误查不到该镜像

### Docker 底层原理
Docker 是一个 CS 结构系统，守护进程运行在主机上，然后通过 Socket 链接从客户端访问，守护进程从客户端接受命令并管理运行在主机上的容器。容器是一个运行时环境，就是集装箱。

为什么 Docker 比传统虚拟机更快：

1. Docker 有着比虚拟机更少的抽象层，不需要 Hypervisor 实现硬件资源虚拟化，在 CPU、内存利用率上有着明显的优势。
2. Docker 利用的是宿主机的内核，而不需要 Guest OS。避免了引寻、加载操作系统内核等比较费时费资源的进程。

||Docker 容器|虚拟机(VM)|
|:-::-:|:-:|:-:|
|操作系统|与宿主机共享 OS|宿主机 OS 上运行虚拟机 OS|
|存储大小|镜像小，便于存储与传输|镜像庞大（vmdk、vdi等）|
|运行性能|几乎无额外性能损失|操作系统额外的 CPU、内存消耗|
|移植性|轻便、灵活，适应于Linux|笨重，与虚拟化技术耦合度高|
|硬件亲和性|面向软件开发者|面向硬件运维者|
|部署速度|快速，秒级|较慢，10s以上|

## Docker 常用命令
### 帮助命令
**1. docker version**

**2. docker info**

Docker 详细信息。

**3. docker --help**

### 镜像命令
#### docker images

列出本地主机上的镜像。

|选项|说明|
|:-:|:-:|
| REPOSITORY |仓库镜像源|
| TAG |镜像标签|
| IMAGES ID|镜像ID|
| CREATED |创建日期|
| SIZE |大小|

Options：

- -a：列出本地所有镜像（含中间映像层）
- -q：只显示镜像 ID
- --digests：显示镜像的摘要信息
- --no-trunc：显示完整的镜像信息

#### docker search 镜像名

在 Docker Hub 上查找镜像。

Options：

- -s 数量：只显示 Star 超过该数值的镜像
- --no-trunc：显示完整的镜像描述
- --automated：只列出 automated build 类型的镜像

#### docker pull 镜像名

下拉镜像。直接写镜像名默认下拉最新版本的镜像。

#### docker rmi 镜像名/ID
删除本机上的镜像。

删除多个：

```s
$ docker rmi -f 镜像名1:TAG 镜像名2:TAG
```

删除全部：

```s
$ docker rmi -f $(docker -qa)
```

Options：

- -f：已存在运行的该镜像的容器时强制删除镜像

### 容器命令
#### 新建并启动容器
```s
$ docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
```

OPTIONS：

- --name="容器名字"：为容器指定一个名字
- -d：后台运行容器，并返回容器 ID，即启动守护式容器
- -i：以交互模式运行容器，通常与 -t 同时使用
- -t：为容器重新分配一个伪输入终端，通常与 -i 同时使用
- -P：随即端口映射
- -p：指定端口映射，有以下四种形式：
	- ip:hostPort : containerPort
	- ip::containerPort
	- **hostPort:containerPort**
	- containerPort

例如启动一个 centos 容器：

```s
$ docker pull centos
$ docker run -it -name="zander" centos
```

#### 列出当前所有正在运行的容器
```s
$ docker ps [OPTIONS]
```
默认显示当前正在运行的容器。

OPTIONS:

- -l：显示上次运行的容器
- -a：显示所有当前运行和历史运行的容器
- -n 数字：显示最近n个创建的容器
- -q：静默模式，只显示容器编号
- --no-trunc：显示详细信息

#### 退出容器
退出容器有两种方式：

**1. exit**

停止并退出容器。

**2. ctrl+P+Q**

容器不停止退出。

#### 启动容器
```s
$ docker start 容器ID/容器名
```

#### 重启容器
```s
$ docker restart 容器ID
```

#### 停止容器
```s
$ docker stop 容器ID
```
#### 强制停止容器
```s
$ docker kill 容器ID
```

#### 删除已停止的容器
```s
$ docker rm 容器ID
```

一次性删除多个容器：

```s
$ docker rm -f $(docker ps -a -q)
```

或

```s
$ docker ps -a -q | xargs docker rm
```

> `| xargs` 意思为将第一个命令的结果作为第二个容器的参数执行之。

### 其它重要命令
#### 启动守护式容器

```s
$ docker run -d 镜像名
```

指不进入交互模式，并且 `docker ps` 不显示该的容器。

原因是 **Docker 容器后台运行，就必须有一个前台进程**。如果容器运行的命令不是那些一直挂起的命令（如运行 top、tail），容器会自动退出。

这是 Docker 的运行机制问题，解决办法是将要运行的程序以前台进程的形式运行。

例子：守护式进程运行 centOS 容器：

```s
$ docker run -d centos /bin/sh -c "while true;do echo hello zander;sleep 2;done"
```

> 然后使用下面的查看容器日志命令可看到打印项，并且使用 `docker ps` 查看 centos 容器在运行中。

#### 查看容器日志
```s
$ docker logs -f -t --tail 容器ID
```

OPTIONS：

- -t：加入时间戳
- -f：跟随最新的日志打印
- --tail 数字：显示最后n条

#### 查看容器内运行的进程
```s
$ docker top 容器ID
```

#### 查看容器内部细节
```s
$ docker inspect 容器ID
```

#### 进入容器并进行命令行交互
进入容器内部：

```s
$ docker attach 容器ID
```

在容器外层执行命令，不进入容器交互模式：

```s
$ docker exec -t 容器ID command
```
> 例：`docker exec -t 10bdadad ls -l /tmp`

#### 从容器内拷贝文件到主机上
```s
$ docker cp 容器ID: 容器内文件路径 目的主机路径
```

## Docker 镜像
镜像是一种轻量级、可执行的独立软件包，用来打包软件运行环境和基于运行环境开发的软件。它包含运行某个软件所需的所有内容，包括代码、运行时、库、环境变量和配置文件。
### UnionFS
UnionFS（联合文件系统）是一种分层、轻量级并且高性能的文件系统，它支持**对文件系统的修改作为一次提交来一层层的叠加**，同时可以将不同目录挂载到同一个虚拟文件系统下。

UnionFS 是 Docker 镜像的基础，镜像可以通过分层来继承，基于基础镜像（没有父镜像的镜像），可以制作各种具体的应用镜像。

### 分层的镜像

Docker 镜像的最底层是 bootfs（boot file system），主要包含 bootloader 和kernel，前者用于引导加载 kernel，Linux 刚启动时会加载 bootfs。boot 加载完成后整个内核就都在内存中了，此时系统会卸载 bootfs。

在 bootfs 上层的是 rootfs（root file system），包含 Linux 中典型的 /dev，/proc，/bin，/etc 等标准目录和文件。rootfs 就是各种不同操作系统发行版，如 Ubuntu、centOS 等。

> 分层体现在使用 docker pull 时多个 Pull complete。

### 为什么 Docker 要采用分层的结构？
最大的好处——**共享资源**。

比如多个镜像都从相同的 base 镜像构建而来，那么宿主机中只需要保存一份 base 镜像，同时内存中也只需加载一份 base 镜像，就可为所有容器服务。

### 镜像的特点
Docker 镜像都是**只读**的，当容器启动时，一个新的可写层被加载到镜像的顶部，这一层就称为“容器层”，“容器层”之下的都是“镜像层”。

### Docker 镜像 commit 操作
**1. docker commit**

提交容器副本使得其成为一个新的镜像，提交后可使用 `$ docker images`
 查看。
**2. docker commit -m="描述信息" -a="作者" 容器ID 要创建的目标镜像名:[标签名]**

## Docker 容器数据卷
1. 容器运行之后产生的数据需要进行持久化存储，而不是容器停止或删除后数据丢失
2. 容器之间可能共享数据

Docker 中容器数据卷由Docker挂载到容器，不属于联合文件系统，完全**独立于容器的生存周期**，作用：

1. **数据持久化**
2. **容器间继承 + 共享数据**

### 在容器内添加数据卷
**1. 通过命令添加**

```s
$ docker run -it -v /宿主机绝对路径目录:/容器内目录 镜像名
```
> 数据卷挂载成功后可通过 `$ docker inspect 容器ID` 命令查看详细信息，其内有数据卷的相关信息。

**目录挂载成功后，容器内文件夹数据的读写可同步共享到宿主机内。**

**容器停止并退出，主机修改数据后重启容器，数据自动同步。**

添加读写保护：

```s
$ docker run -it -v /宿主机绝对路径目录:/容器内目录:ro 镜像名
```

> -ro 为 read only，表示容器内只读，而主机可以进行读写。


**2. DockerFile 添加**

1. 宿主机的根目录下新建文件夹 mydocker 并进入
2. 在 DockerFile 中使用 **VOLUME 指令**给镜像添加一个或多个数据卷

> 出于可移植和分享的考虑，不能在 DockerFile 中指定宿主机的目录，因为不能保证所有的宿主机上都存在这样的特定目录。


3. File 构建

```
FROM centos
VOLUME ["/dataVolumeContainer1", "/dataVolumeContainer2"]
CMD echo "finished, -------success1"
CMD /bin/bash
```

4. build 后生成镜像

```s
$ docker build -f /mydocker/DockerFile -t zander/centos .
```

5. run 容器

```s
$ docker run -it zander/centos
```

6. 容器内的容器卷已经存在，使用 `$ docker inspect 容器id` 查看宿主机上的 Volumes 默认绑定的宿主机路径

> Dcoker 挂载的主机目录访问出现 cannot open directory .:Permission denied 问题解决办法：在`docker run` 命令的挂载目录后加 `--privileged=true` 参数。

### 数据卷容器
命名的容器挂载数据卷，其它容器通过挂载这个（父容器）实现数据共享，挂载数据卷的容器就被称为**数据卷容器**。

1. 先启动一个父容器 dc01，并在 dataVoluneContainer2 新增内容

```s
$ docker run -it --name=dc01 zander/centos
$ cd dataVolumeContainer2
$ touch dc01.txt
```

2. dc02/dc03 继承自dc01，分别也创建相应的内容

```s
$ docker run -it --name dc02 --volumes-from dc01 zander/centos
```

3. 此时 dc01/dc02/dc03 的 /dataVolumeContainer2 中有 dc01.txt、dc02.txt/dc03.txt，即成功共享数据
4. 删除容器 dc01 中的 dc01.txt，但容器dc02/dc03 中仍存在

**结论：容器之间配置信息的传递，数据卷的生命周期一直持续到没有容器使用它为止（删除互不影响）**

## DockerFile
DockerFile 是用来构建 Docker 镜像的构建文件，是由一系列命令和参数构成的脚本。

构建的三个主要步骤：

1. 编写 DockerFile
2. docker build
3. docker run

### DockerFile 构建过程解析
DockerFile 基础知识：

1. 每条保留字指令都必须为大写字母且后面至少要跟随一个参数
2. 指令按照从上到下，顺序执行
3. `#` 表示注释
4. 每条指令都会创建一个新的镜像层，并对镜像进行提交

### DockerFile 保留字指令
#### FROM
基础镜像，当前新镜像是基于哪个镜像的。
#### MAINTAINER
镜像维护者的姓名和邮箱地址。
#### RUN
容器构建时需要运行的命令。
#### EXPOSE
当前容器对外暴露的端口号。
#### WORKDIR
指定创建运行容器后，终端默认所在的工作路径。
#### ENV
用来在构建镜像过程中设置环境变量
#### ADD
将宿主机目录下的文件拷贝进镜像，且 ADD 命令会自动处理 URL 和解压 tar 压缩包。
#### COPY
类似 ADD，拷贝文件和目录到镜像中。将从构建上下文目录中<源路径>的文件/目录复制到新的一层镜像内的<目标路径>位置。
#### VOLUME
容器数据卷，用于数据保存和持久化工作。
#### CMD
指定一个容器启动时要运行的命令。DockerFile 中可以有多个 CMD 指令，但**只有最后一个生效**，CMD 会被 docker run 之后的参数替换。
#### ENTRYPOINT
指定一个容器启动时要运行的命令。目的和 CMD 一样，都是在指定容器启动程序及参数。

`docker run` 之后的参数会被当作参数传递给 ENTRYPOINT，之后形成新的命令组合。
#### ONBUILD
当构建一个被继承的 DockerFile 时运行的命令，父镜像在被子继承后父镜像的 onbuild 被触发。

|BUILD|Both|RUN|
|:-:|:-:|:-:|
|FROM|WORKDIR|CMD|
|MAINTAINER|USER|ENV|
|COPY||EXPOSE|
|ADD||VOLUME|
|RUN||ENTRYPOINT|
|ONBUILD|||
|.dockerignore|||

### 案例
docker run 官方 centos 镜像存在的问题：

1. 进入口默认的路径是根目录
2. 默认不支持 vim（因为是精简版centos）
3. 默认不支持 ifconfig，原因同上

#### 自定义 centos

1. 编写 DockerFile

	```
	FROM centos
	MAINTAINER zander<xuezenghui6@gmail.com>
	ENV MYPATH /usr/local
	WORKDIR $MYPATH
	RUN yum -y install vim
	RUN yum -y net-tools
	EXPOSE 80
	CMD echo $MYPATH
	CMD echo "success"
	CMD /bin/bash
	```

2. 构建镜像

	```s
	$ docker build -f /mydocker/DockerFile2 -t mycentos:1.0 .
	```
	
	> 我的 centos 8 在运行时遇到了 `Failed to download metadata for repo 'AppStream'` 的错误，暂未解决🙁


3. 运行容器

	```s
	$ docker run -it mycentos
	```

> 使用 `$ docker history 镜像ID` 可查看镜像构建详细步骤


#### ONBUILD
1. 新建DcokerFile：

```
FROM centos
CMD ["curl","-s","http://www.baidu.cn"]
ONBUILD RUN echo "father is running-----------------success"
```

2. 创建父镜像

```s
$ docker build -f /mydocker/DockerFile3 -t hello_father .
```

3. 新建DockerFile，继承上方父镜像，构建子镜像

```
FROM myip_father
CMD ["curl","-s","http://www.baidu.cn"]
```

```s
$ docker build -f /mydocker/DockerFile4 -t hello_son .
```

运行此命令时会触发父镜像中的 ONBUILD 项。

## Docker 常用安装
### 安装 mysql
1. docker search mysql
2. docker pull mysql
3. 运行容器

```s
$ docker run -p 12345:3306 --name zander/mysql -e MYSQL_ROOT_PASSWORD=123456 -d mysql
```

### 安装 Nginx
- [安装 NGINX(https://xuezenghui.com/posts/ecs-server/#%E5%AE%89%E8%A3%85-nginx)

## 本地镜像发布到阿里云
### 本地镜像发布到阿里云流程
### 镜像的生成方法
1. DockerFile + docker build

2. 从容器创建一个新的镜像

	```s
	$ docker commit [OPTIONS] 容器ID [REPOSITORY[:TAG]]
	```

### 将本地镜像推送到阿里云
1. 创建本地镜像
2. [阿里云开发者平台](https://cr.console.aliyun.com/cn-hangzhou/instances/repositories)
3. 创建镜像仓库（代码源选择本地仓库）
4. 点击**管理**按照步骤来