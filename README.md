# PortForwardGo-Docker

# ⚠️ Project Deprecated

## This project is no longer maintained

This repository is no longer actively maintained and will not receive any further updates or bug fixes. Users are encouraged to explore alternative solutions or fork this project if necessary.

Thank you for your interest and support.

# ⚠️ 项目已停止维护

## 本项目已经不再维护

本仓库将不再进行任何更新或 bug 修复。建议用户探索其他替代方案，或者根据需要自行 fork 本项目。

感谢大家一直以来的关注和支持。

---

PortForwardGo 项目下的内网穿透客户端 docker 版本

使用的网络服务里面有个这玩意，为了方便管理所以弄个 Docker 镜像

## 环境变量/传入参数

| 变量名      | 对应客户端选项 | 值类型 | 解释         | arg 传入选项  |
| ----------- | -------------- | ------ | ------------ | ------------- |
| API_URL     | -api           | string | 服务器地址   | --api         |
| API_ID      | -id            | string | 面板提供的ID | --id          |
| API_SECRET  | -secret        | string | 面板提供密钥 | --secret      |
| CONFIG_PATH | -config        | string | 配置文件目录 | --config      |
| LOG_PATH    | -log           | string | 日志文件路径 | --log         |
| DEBUG_FLAG  | -debug         | bool   | 调试模式     | --debug       |
| DISABLE_UDP | -disable-udp   | bool   | 关闭UDP      | --disable-udp |
|             | -h             |        | 帮助         | -h            |

## Docker 命令行运行
``` shell
docker run --rm --name rclient -e TZ=Asia/Singapore -d docker.io/yucatovo/rclient:latest --api "http://api.example.com" --id "my-api-id" --secret "my-api-secret"
```
``` shell
docker run --rm --name rclient -e TZ=Asia/Singapore -e API_URL="http://api.example.com" -e API_ID="my-api-id" -e API_SECRET="my-api-secret" -e DISABLE_UDP=true -d docker.io/yucatovo/rclient:latest
```
### 获取帮助
``` shell
docker run --rm --name rclient docker.io/yucatovo/rclient:latest --help