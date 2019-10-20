该镜像以centos7为基础镜像，开放ssh端口22，环境变量`ROOT_PASSWORD`可以修改root登录密码

```
docker run -d -p 36000:22 magic/centos7_sshd
```
