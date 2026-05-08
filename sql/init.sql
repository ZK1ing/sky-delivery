-- ==========================================
-- 苍穹外卖 (Sky Take-Out) 数据库初始化脚本
-- 数据库: sky_take_out
-- ==========================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS sky_take_out DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sky_take_out;

-- ==========================================
-- 1. 员工表 (employee)
-- ==========================================
DROP TABLE IF EXISTS employee;
CREATE TABLE employee (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    name        VARCHAR(32)  COMMENT '员工姓名',
    username    VARCHAR(32)  COMMENT '账号',
    password    VARCHAR(64)  COMMENT '密码',
    phone       VARCHAR(11)  COMMENT '手机号',
    sex         VARCHAR(2)   COMMENT '性别',
    id_number   VARCHAR(18)  COMMENT '身份证号',
    status      INT DEFAULT 1 COMMENT '状态 1启用 0禁用',
    create_time DATETIME     COMMENT '创建时间',
    update_time DATETIME     COMMENT '更新时间',
    create_user BIGINT       COMMENT '创建人ID',
    update_user BIGINT       COMMENT '更新人ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='员工表';

-- ==========================================
-- 2. 分类表 (category)
-- ==========================================
DROP TABLE IF EXISTS category;
CREATE TABLE category (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    type        INT          COMMENT '类型 1菜品分类 2套餐分类',
    name        VARCHAR(32)  COMMENT '分类名称',
    sort        INT DEFAULT 0 COMMENT '排序',
    status      INT DEFAULT 1 COMMENT '状态 1启用 0禁用',
    create_time DATETIME     COMMENT '创建时间',
    update_time DATETIME     COMMENT '更新时间',
    create_user BIGINT       COMMENT '创建人ID',
    update_user BIGINT       COMMENT '更新人ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分类表';

-- ==========================================
-- 3. 菜品表 (dish)
-- ==========================================
DROP TABLE IF EXISTS dish;
CREATE TABLE dish (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    name        VARCHAR(64)    COMMENT '菜品名称',
    category_id BIGINT         COMMENT '分类ID',
    price       DECIMAL(10,2)  COMMENT '价格',
    image       VARCHAR(200)   COMMENT '图片URL',
    description VARCHAR(200)   COMMENT '描述',
    status      INT DEFAULT 1  COMMENT '状态 1起售 0停售',
    create_time DATETIME       COMMENT '创建时间',
    update_time DATETIME       COMMENT '更新时间',
    create_user BIGINT         COMMENT '创建人ID',
    update_user BIGINT         COMMENT '更新人ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜品表';

-- ==========================================
-- 4. 菜品口味表 (dish_flavor)
-- ==========================================
DROP TABLE IF EXISTS dish_flavor;
CREATE TABLE dish_flavor (
    id      BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    dish_id BIGINT        COMMENT '菜品ID',
    name    VARCHAR(32)   COMMENT '口味名称',
    value   VARCHAR(200)  COMMENT '口味值(JSON列表)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='菜品口味表';

-- ==========================================
-- 5. 套餐表 (setmeal)
-- ==========================================
DROP TABLE IF EXISTS setmeal;
CREATE TABLE setmeal (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    category_id BIGINT         COMMENT '分类ID',
    name        VARCHAR(64)    COMMENT '套餐名称',
    price       DECIMAL(10,2)  COMMENT '套餐价格',
    status      INT DEFAULT 1  COMMENT '状态 1启用 0停用',
    description VARCHAR(200)   COMMENT '描述',
    image       VARCHAR(200)   COMMENT '图片URL',
    create_time DATETIME       COMMENT '创建时间',
    update_time DATETIME       COMMENT '更新时间',
    create_user BIGINT         COMMENT '创建人ID',
    update_user BIGINT         COMMENT '更新人ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='套餐表';

-- ==========================================
-- 6. 套餐菜品关系表 (setmeal_dish)
-- ==========================================
DROP TABLE IF EXISTS setmeal_dish;
CREATE TABLE setmeal_dish (
    id         BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    setmeal_id BIGINT        COMMENT '套餐ID',
    dish_id    BIGINT        COMMENT '菜品ID',
    name       VARCHAR(64)   COMMENT '菜品名称(冗余)',
    price      DECIMAL(10,2) COMMENT '菜品原价',
    copies     INT           COMMENT '份数'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='套餐菜品关系表';

-- ==========================================
-- 7. 用户表 (user)
-- ==========================================
DROP TABLE IF EXISTS user;
CREATE TABLE user (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    openid      VARCHAR(45)  COMMENT '微信OpenID',
    name        VARCHAR(32)  COMMENT '姓名',
    phone       VARCHAR(11)  COMMENT '手机号',
    sex         VARCHAR(2)   COMMENT '性别',
    id_number   VARCHAR(18)  COMMENT '身份证号',
    avatar      VARCHAR(500) COMMENT '头像URL',
    create_time DATETIME     COMMENT '注册时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ==========================================
-- 8. 地址簿表 (address_book)
-- ==========================================
DROP TABLE IF EXISTS address_book;
CREATE TABLE address_book (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    user_id       BIGINT       COMMENT '用户ID',
    consignee     VARCHAR(50)  COMMENT '收货人',
    phone         VARCHAR(11)  COMMENT '手机号',
    sex           VARCHAR(2)   COMMENT '性别',
    province_code VARCHAR(12)  COMMENT '省级区划编号',
    province_name VARCHAR(32)  COMMENT '省级名称',
    city_code     VARCHAR(12)  COMMENT '市级区划编号',
    city_name     VARCHAR(32)  COMMENT '市级名称',
    district_code VARCHAR(12)  COMMENT '区级区划编号',
    district_name VARCHAR(32)  COMMENT '区级名称',
    detail        VARCHAR(200) COMMENT '详细地址',
    label         VARCHAR(100) COMMENT '标签(家/公司/学校)',
    is_default    INT DEFAULT 0 COMMENT '是否默认 0否 1是'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='地址簿表';

-- ==========================================
-- 9. 订单表 (orders)
-- ==========================================
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    id                      BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    number                  VARCHAR(50)   COMMENT '订单号',
    status                  INT           COMMENT '订单状态 1待付款 2待接单 3已接单 4派送中 5已完成 6已取消',
    user_id                 BIGINT        COMMENT '用户ID',
    address_book_id         BIGINT        COMMENT '地址ID',
    order_time              DATETIME      COMMENT '下单时间',
    checkout_time           DATETIME      COMMENT '结账时间',
    pay_method              INT           COMMENT '支付方式 1微信 2支付宝',
    pay_status              INT           COMMENT '支付状态 0未支付 1已支付 2退款',
    amount                  DECIMAL(10,2) COMMENT '实收金额',
    remark                  VARCHAR(100)  COMMENT '备注',
    phone                   VARCHAR(11)   COMMENT '手机号',
    address                 VARCHAR(200)  COMMENT '收货地址',
    consignee               VARCHAR(50)   COMMENT '收货人',
    cancel_reason           VARCHAR(200)  COMMENT '取消原因',
    rejection_reason        VARCHAR(200)  COMMENT '拒单原因',
    cancel_time             DATETIME      COMMENT '取消时间',
    estimated_delivery_time DATETIME      COMMENT '预计送达时间',
    delivery_status         INT           COMMENT '配送状态 1立即送出 0选择具体时间',
    delivery_time           DATETIME      COMMENT '送达时间',
    pack_amount             INT           COMMENT '打包费',
    tableware_number        INT           COMMENT '餐具数量',
    tableware_status        INT           COMMENT '餐具数量状态 1按餐量提供 0选择具体数量'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- ==========================================
-- 10. 订单详情表 (order_detail)
-- ==========================================
DROP TABLE IF EXISTS order_detail;
CREATE TABLE order_detail (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    name        VARCHAR(64)   COMMENT '菜品名称',
    order_id    BIGINT        COMMENT '订单ID',
    dish_id     BIGINT        COMMENT '菜品ID',
    setmeal_id  BIGINT        COMMENT '套餐ID',
    dish_flavor VARCHAR(50)   COMMENT '口味',
    number      INT           COMMENT '数量',
    amount      DECIMAL(10,2) COMMENT '金额',
    image       VARCHAR(200)  COMMENT '图片URL'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单详情表';

-- ==========================================
-- 11. 购物车表 (shopping_cart)
-- ==========================================
DROP TABLE IF EXISTS shopping_cart;
CREATE TABLE shopping_cart (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    name        VARCHAR(64)   COMMENT '菜品名称',
    user_id     BIGINT        COMMENT '用户ID',
    dish_id     BIGINT        COMMENT '菜品ID',
    setmeal_id  BIGINT        COMMENT '套餐ID',
    dish_flavor VARCHAR(50)   COMMENT '口味',
    number      INT           COMMENT '数量',
    amount      DECIMAL(10,2) COMMENT '金额',
    image       VARCHAR(200)  COMMENT '图片URL',
    create_time DATETIME      COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表';

-- ==========================================
-- 初始化数据: 管理员账号
-- 账号: admin  密码: 123456
-- ==========================================
INSERT INTO employee (name, username, password, phone, sex, id_number, status, create_time, update_time, create_user, update_user)
VALUES ('管理员', 'admin', '123456', '13800138000', '1', '110101199001011234', 1, NOW(), NOW(), 1, 1);
