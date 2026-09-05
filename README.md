# 苍穹外卖

苍穹外卖学习项目，使用单仓库管理 Java 后端、Vue 管理端和 uni-app 微信小程序。

## 项目结构

```text
sky-take-out/
├── sky-common/       # 后端公共模块
├── sky-pojo/         # 实体、DTO 和 VO
├── sky-server/       # Spring Boot 服务，端口 8080
├── sky-admin-vue/    # Vue 2 管理端，端口 8888
└── sky-miniprogram/  # uni-app 微信小程序
```

## 本地环境

- JDK 17（项目以 Java 8 为编译目标）
- Maven 3.9+
- MySQL
- Redis
- Node.js 16.20.2
- 微信开发者工具；开发小程序源码时还需要 HBuilderX

## 启动顺序

```text
MySQL -> Redis -> Java 后端 -> Vue 管理端 -> 微信小程序
```

### 1. 配置数据库和外部服务

复制配置模板：

```bash
cp sky-server/src/main/resources/application-dev.example.yml \
   sky-server/src/main/resources/application-dev.yml
```

然后在 `application-dev.yml` 中填写本机 MySQL、Redis、OSS 和微信配置。该文件已被 Git 忽略，不会提交真实凭据。

数据库名称为 `sky_take_out`。首次运行可执行：

```bash
/usr/local/mysql/bin/mysql -u root -p < docs/sql/sky.sql
```

该脚本会重建项目数据表，仅适合初始化空数据库；已有数据时请先备份。

### 2. 启动后端

在项目根目录执行：

```bash
mvn -pl sky-server -am install -Dmaven.test.skip=true
mvn -pl sky-server spring-boot:run
```

看到 `Started SkyApplication` 后，通过下面的命令验证：

```bash
curl http://localhost:8080/user/shop/status
```

### 3. 启动管理端

新建终端并执行：

```bash
cd sky-admin-vue
source ~/.nvm/nvm.sh
nvm use
npm install --legacy-peer-deps
npm run serve
```

访问 <http://localhost:8888>，默认账号为 `admin`，默认密码为 `123456`。

不要运行 `npm audit fix --force`，旧版 Vue 2 项目可能因强制升级依赖而无法启动。

### 4. 启动微信小程序

`sky-miniprogram` 是 uni-app 项目，可使用 HBuilderX 打开并运行到微信开发者工具。运行本地后端前，需要将 `sky-miniprogram/utils/env.js` 中的 `baseUrl` 改为本机可访问的后端地址。

微信开发者工具模拟器可使用 `http://localhost:8080`；真机调试需要使用电脑局域网 IP 或 HTTPS 公网地址。

## 停止服务

在运行后端或管理端的终端中按 `Control + C` 即可停止对应服务。
