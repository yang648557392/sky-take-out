# Sky Takeout

Sky Takeout is a learning project that uses a monorepo to manage a Java backend, a Vue admin dashboard, and a uni-app WeChat Mini Program.

## Project Structure

```text
sky-take-out/
├── sky-common/       # Shared backend module
├── sky-pojo/         # Entities, DTOs, and VOs
├── sky-server/       # Spring Boot service (port 8080)
├── sky-admin-vue/    # Vue 2 admin dashboard (port 8888)
└── sky-miniprogram/  # uni-app WeChat Mini Program
```

## Prerequisites

- JDK 17 (the project targets Java 8 bytecode)
- Maven 3.9+
- MySQL
- Redis
- Node.js 16.20.2
- WeChat DevTools; HBuilderX is also required to work with the Mini Program source code

## Startup Order

```text
MySQL -> Redis -> Java backend -> Vue admin dashboard -> WeChat Mini Program
```

### 1. Configure the Database and External Services

Copy the configuration template:

```bash
cp sky-server/src/main/resources/application-dev.example.yml \
   sky-server/src/main/resources/application-dev.yml
```

Then add your local MySQL, Redis, OSS, and WeChat settings to `application-dev.yml`. This file is ignored by Git, so real credentials will not be committed.

The database name is `sky_take_out`. Run the following command for the initial setup:

```bash
/usr/local/mysql/bin/mysql -u root -p < docs/sql/sky.sql
```

This script recreates the project's database tables and should only be used to initialize an empty database. Back up any existing data before running it.

### 2. Start the Backend

Run the following commands from the project root:

```bash
mvn -pl sky-server -am install -Dmaven.test.skip=true
mvn -pl sky-server spring-boot:run
```

After `Started SkyApplication` appears in the terminal, verify the backend with:

```bash
curl http://localhost:8080/user/shop/status
```

### 3. Start the Admin Dashboard

Open a new terminal and run:

```bash
cd sky-admin-vue
source ~/.nvm/nvm.sh
nvm use
npm install --legacy-peer-deps
npm run serve
```

Open <http://localhost:8888>. The default username is `admin`, and the default password is `123456`.

Do not run `npm audit fix --force`. Forced dependency upgrades may prevent this legacy Vue 2 project from starting.

### 4. Start the WeChat Mini Program

`sky-miniprogram` is a uni-app project. Open it with HBuilderX and run it in WeChat DevTools. Before connecting it to the local backend, change `baseUrl` in `sky-miniprogram/utils/env.js` to a backend address accessible from the Mini Program.

The WeChat DevTools simulator can use `http://localhost:8080`. Testing on a physical device requires your computer's LAN IP address or a public HTTPS address.

## Stopping the Services

Press `Control + C` in the terminal running the backend or admin dashboard to stop that service.
