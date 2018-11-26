该镜像以java为基础镜像，包括应用
1、supervisor
2、kafka
3、kafka安装包中自带的zookeeper

内置用户：linux，暴露端口：2181、9092。其中2181是zookeeper的端口，9092是kafka的端口，如需要创建topic，需要进入容器中执行创建队列的脚本。
注：该镜像还没有试过与php上的kafka对接