该镜像以centos7为基础镜像，包括应用
1、jdk-11

内置用户：linux

注意：估计是因为JDK有防盗链措施，因此无法在构建脚本中。因此JDK的安装包需要先行下载，解压后拷贝到根目录中，文件夹名称与`Dockerfile`中的`JDK_VERSION`一致