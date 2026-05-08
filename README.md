# 苍穹外卖 (Sky Delivery)

基于 Spring Boot + Vue3 的全栈外卖配送平台，包含管理端后台和顾客端移动 H5，支持从点餐到配送的完整业务流程。

## 项目预览

| 端 | 地址 | 说明 |
|---|---|---|
| 管理端 | http://localhost:5174 | Vue3 + Element Plus 后台管理 |
| 顾客端 | http://localhost:5175 | Vue3 + Vant4 移动点餐 H5 |
| 接口文档 | http://localhost:8080/doc.html | Knife4j Swagger 文档 |

## 技术栈

### 后端
| 组件 | 技术 |
|---|---|
| 核心框架 | Spring Boot 2.7.3 |
| ORM | MyBatis + PageHelper |
| 数据库 | MySQL 5.6+ |
| 连接池 | Druid |
| 缓存 | Redis |
| 认证 | JWT (jjwt 0.9.1) — 管理端 `token` / 用户端 `authentication` |
| 文件存储 | 阿里云 OSS |
| 支付 | 微信支付 API v3 |
| 实时推送 | WebSocket |
| 定时任务 | Spring @Scheduled |
| 接口文档 | Knife4j (Swagger) |
| 工具 | Lombok, Fastjson, Apache POI |

### 管理端前端 (sky-frontend)
| 组件 | 技术 |
|---|---|
| 框架 | Vue 3.5 + TypeScript |
| 构建 | Vite 8 |
| UI 组件 | Element Plus 2.x |
| 图表 | ECharts 5.x |
| 路由 | Vue Router 4 |
| 状态管理 | Pinia 3 |
| HTTP | Axios |

### 顾客端前端 (sky-customer)
| 组件 | 技术 |
|---|---|
| 框架 | Vue 3.5 + TypeScript |
| 构建 | Vite 8 |
| UI 组件 | Vant 4.x |
| 路由 | Vue Router 4 |
| HTTP | Axios |

## 项目结构

```
sky-delivery/
├── sky-common/         公共组件 (常量、异常、工具类、返回体)
├── sky-pojo/           数据对象 (Entity、DTO、VO)
├── sky-server/         主服务 (Controller、Service、Mapper、配置)
├── sky-frontend/       管理端前端 (Vue3 + Element Plus)
├── sky-customer/       顾客端前端 (Vue3 + Vant4 移动 H5)
└── sql/                数据库脚本
    ├── init.sql        建表 + 管理员账号
    └── test_data.sql   测试数据 (分类、菜品、套餐、用户、地址)
```

## 快速开始

### 环境要求

- JDK 1.8+
- MySQL 5.6+
- Redis 5.0+
- Maven 3.6+
- Node.js 18+

### 1. 初始化数据库

```bash
mysql -u root -p < sql/init.sql
```

### 2. 插入测试数据（可选，开发调试用）

```bash
mysql -u root -p --default-character-set=utf8mb4 sky_take_out < sql/test_data.sql
```

### 3. 修改后端配置

编辑 `sky-server/src/main/resources/application-dev.yml`，修改数据库和 Redis 连接信息：

```yaml
sky:
  datasource:
    host: localhost
    port: 3306
    database: sky_take_out
    username: root
    password: your_pwd
  redis:
    host: localhost
    port: 6379
    password: your_pwd
```

### 4. 启动后端

```bash
# 安装依赖并编译
mvn install -DskipTests

# 启动服务 (端口 8080)
cd sky-server
mvn spring-boot:run -DskipTests
```

### 5. 启动管理端前端

```bash
cd sky-frontend
npm install
npm run dev
# → http://localhost:5173
```

### 6. 启动顾客端前端

```bash
cd sky-customer
npm install
npm run dev
# → http://localhost:5174
```

## 初始账号

| 角色 | 账号 | 密码 | 说明 |
|---|---|---|---|
| 管理员 | admin | 123456 | 管理后台登录 |
| 测试用户 | (模拟登录) | — | 顾客端点击"模拟登录"即可 |

## 接口分组

### 管理端接口 (`/admin/**`)

- **员工管理**: 登录、分页查询、新增、启用/禁用、编辑
- **分类管理**: 菜品分类 / 套餐分类 的增删改查
- **菜品管理**: 菜品(含口味)的增删改查、起售/停售
- **套餐管理**: 套餐的增删改查、起售/停售
- **订单管理**: 订单搜索、接单、拒单、取消、派送、完成、订单统计
- **报表统计**: 营业额统计、用户统计、订单统计、销量Top10、Excel导出
- **工作台**: 今日数据概览
- **店铺管理**: 店铺营业状态设置

### 用户端接口 (`/user/**`)

- **用户**: 微信登录 (支持 `mock-code-` 前缀的模拟登录)
- **分类/菜品/套餐**: 浏览查询
- **购物车**: 添加、删除、清空
- **订单**: 下单、历史订单、详情、取消、再来一单、催单
- **地址簿**: 收货地址管理
- **支付回调**: 微信支付通知

> **模拟登录**: 顾客端开发环境下，后端支持以 `mock-code-` 为前缀的授权码直接模拟登录，无需真实的微信 API 调用。

## 订单状态流转

```
待付款(1) → 待接单(2) → 已接单(3) → 派送中(4) → 已完成(5)
    ↓            ↓
  已取消(6)    已取消(6)
```

## 定时任务

| 任务 | 执行频率 | 说明 |
|---|---|---|
| 支付超时处理 | 每分钟 | 扫描15分钟前未支付的订单，自动取消 |
| 派送完成处理 | 每天凌晨1:00 | 将1小时前的派送中订单标记为已完成 |

## WebSocket 实时推送

通过 `/ws/{sid}` 连接，支持：

- **来单提醒** (type=1): 用户支付成功后推送给商家
- **催单提醒** (type=2): 用户催单时推送给商家

## 数据库表

| 表名 | 说明 |
|---|---|
| employee | 员工表 |
| category | 分类表 |
| dish | 菜品表 |
| dish_flavor | 菜品口味表 |
| setmeal | 套餐表 |
| setmeal_dish | 套餐菜品关系表 |
| user | 用户表 |
| address_book | 收货地址表 |
| orders | 订单表 |
| order_detail | 订单详情表 |
| shopping_cart | 购物车表 |
