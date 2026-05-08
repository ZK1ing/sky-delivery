# 苍穹外卖 (Sky Take-Out)

基于 Spring Boot 的外卖配送平台后端服务，支持管理端和用户端双端接口。

## 技术栈

| 组件 | 技术 |
|---|---|
| 核心框架 | Spring Boot 2.7.3 |
| ORM | MyBatis + PageHelper |
| 数据库 | MySQL 5.6+ |
| 连接池 | Druid |
| 缓存 | Redis |
| 认证 | JWT (jjwt 0.9.1) |
| 文件存储 | 阿里云 OSS |
| 支付 | 微信支付 API v3 |
| 实时推送 | WebSocket |
| 定时任务 | Spring @Scheduled |
| 接口文档 | Knife4j (Swagger) |
| 工具 | Lombok, Fastjson, Apache POI |

## 模块结构

```
sky-take-out/
├── sky-common/     公共组件 (常量、异常、工具类、返回体)
├── sky-pojo/       数据对象 (Entity、DTO、VO)
├── sky-server/     主服务 (Controller、Service、Mapper、配置)
└── sql/            数据库初始化脚本
```

## 快速开始

### 环境要求

- JDK 1.8+
- MySQL 5.6+
- Redis 5.0+
- Maven 3.6+

### 1. 初始化数据库

```bash
mysql -u root -p < sql/init.sql
```

### 2. 修改配置

编辑 `sky-server/src/main/resources/application-dev.yml`，修改以下配置：

```yaml
sky:
  datasource:
    host: localhost      # 数据库地址
    port: 3306           # 数据库端口
    database: sky_take_out
    username: root       # 数据库账号
    password: your_pwd   # 数据库密码
  redis:
    host: localhost      # Redis地址
    port: 6379
    password: your_pwd   # Redis密码
```

### 3. 启动项目

```bash
# 安装依赖并编译
mvn install -DskipTests

# 启动服务
mvn spring-boot:run -pl sky-server
```

### 4. 访问接口文档

```
http://localhost:8080/doc.html
```

## 初始账号

| 角色 | 账号 | 密码 |
|---|---|---|
| 管理员 | admin | 123456 |

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

- **用户**: 微信登录
- **分类/菜品/套餐**: 浏览查询
- **购物车**: 添加、删除、清空
- **订单**: 下单、历史订单、详情、取消、再来一单、催单
- **地址簿**: 收货地址管理
- **支付回调**: 微信支付通知

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
