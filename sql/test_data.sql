-- ==========================================
-- 苍穹外卖 测试数据
-- ==========================================
USE sky_take_out;

-- 插入分类 (type: 1菜品分类, 2套餐分类)
INSERT INTO category (id, type, name, sort, status, create_time, update_time, create_user, update_user) VALUES
(1, 1, '热销推荐', 1, 1, NOW(), NOW(), 1, 1),
(2, 1, '精品主食', 2, 1, NOW(), NOW(), 1, 1),
(3, 1, '清爽饮品', 3, 1, NOW(), NOW(), 1, 1),
(4, 1, '经典小吃', 4, 1, NOW(), NOW(), 1, 1),
(5, 2, '超值套餐', 1, 1, NOW(), NOW(), 1, 1),
(6, 2, '双人套餐', 2, 1, NOW(), NOW(), 1, 1);

-- 插入菜品
INSERT INTO dish (id, name, category_id, price, image, description, status, create_time, update_time, create_user, update_user) VALUES
(1,  '红烧牛肉面',     1, 28.00, 'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png', '精选牛腩，慢炖8小时，汤浓味美', 1, NOW(), NOW(), 1, 1),
(2,  '麻辣小龙虾盖饭', 1, 36.00, 'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png', '鲜活小龙虾，麻辣鲜香，下饭神器', 1, NOW(), NOW(), 1, 1),
(3,  '嫩牛五方',       1, 22.00, 'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png', '香嫩牛肉搭配五种蔬菜，营养均衡', 1, NOW(), NOW(), 1, 1),
(4,  '经典番茄意面',   2, 32.00, 'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png', '意大利进口面条，新鲜番茄酱汁', 1, NOW(), NOW(), 1, 1),
(5,  '海鲜炒饭',       2, 35.00, 'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png', '虾仁、鱿鱼、扇贝，海味十足', 1, NOW(), NOW(), 1, 1),
(6,  '日式叉烧拉面',   2, 30.00, 'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png', '浓厚豚骨汤底，秘制叉烧肉', 1, NOW(), NOW(), 1, 1),
(7,  '冰鲜柠檬水',     3, 8.00,  'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png', '新鲜柠檬，冰爽解暑', 1, NOW(), NOW(), 1, 1),
(8,  '珍珠奶茶',       3, 15.00, 'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png', 'Q弹珍珠，浓郁奶茶，甜蜜享受', 1, NOW(), NOW(), 1, 1),
(9,  '满杯百香果',     3, 18.00, 'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png', '新鲜百香果，满满的维C', 1, NOW(), NOW(), 1, 1),
(10, '炸鸡翅(4个)',    4, 18.00, 'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png', '外酥里嫩，金黄酥脆', 1, NOW(), NOW(), 1, 1),
(11, '脆皮春卷',       4, 12.00, 'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png', '酥脆外皮，鲜香内馅', 1, NOW(), NOW(), 1, 1),
(12, '黄金薯条',       4, 10.00, 'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png', '粗切薯条，金黄酥脆，番茄酱搭配', 1, NOW(), NOW(), 1, 1);

-- 插入菜品口味
INSERT INTO dish_flavor (id, dish_id, name, value) VALUES
(1, 2, '辣度', '["微微辣","微辣","中辣","特辣"]'),
(2, 8, '甜度', '["无糖","三分糖","五分糖","七分糖","全糖"]'),
(3, 9, '甜度', '["无糖","三分糖","五分糖","七分糖","全糖"]'),
(4, 1, '口味', '["微辣","中辣","特辣"]'),
(5, 8, '温度', '["常温","去冰","少冰","多冰"]'),
(6, 9, '温度', '["常温","去冰","少冰","多冰"]');

-- 插入套餐
INSERT INTO setmeal (id, category_id, name, price, status, description, image, create_time, update_time, create_user, update_user) VALUES
(1, 5, '工作日单人套餐', 45.00, 1, '红烧牛肉面 + 冰鲜柠檬水 + 炸鸡翅', 'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png', NOW(), NOW(), 1, 1),
(2, 5, '豪华午餐套餐', 58.00, 1, '麻辣小龙虾盖饭 + 珍珠奶茶 + 脆皮春卷', 'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png', NOW(), NOW(), 1, 1),
(3, 6, '双人经典套餐', 88.00, 1, '经典番茄意面 + 日式叉烧拉面 + 黄金薯条 + 2杯饮品', 'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png', NOW(), NOW(), 1, 1);

-- 插入套餐菜品关系
INSERT INTO setmeal_dish (id, setmeal_id, dish_id, name, price, copies) VALUES
(1, 1, 1,  '红烧牛肉面', 28.00, 1),
(2, 1, 7,  '冰鲜柠檬水', 8.00,  1),
(3, 1, 10, '炸鸡翅',     18.00, 1),
(4, 2, 2,  '麻辣小龙虾盖饭', 36.00, 1),
(5, 2, 8,  '珍珠奶茶',       15.00, 1),
(6, 2, 11, '脆皮春卷',       12.00, 1),
(7, 3, 4,  '经典番茄意面',   32.00, 1),
(8, 3, 6,  '日式叉烧拉面',   30.00, 1),
(9, 3, 12, '黄金薯条',       10.00, 1),
(10, 3, 7, '冰鲜柠檬水',     8.00,  2);

-- 插入测试用户 (用于顾客端)
INSERT INTO user (id, openid, name, phone, sex, id_number, avatar, create_time) VALUES
(1, 'mock-openid-test-001', '张三', '13900139000', '1', '110101199001011234', 'https://img.zcool.cn/community/0115fd5e4a7e0aa80121985c3c3f51.png', NOW());

-- 插入测试地址
INSERT INTO address_book (id, user_id, consignee, phone, sex, province_code, province_name, city_code, city_name, district_code, district_name, detail, label, is_default) VALUES
(1, 1, '张三', '13900139000', '1', '440000', '广东省', '440100', '广州市', '440106', '天河区', '体育西路128号天河城大厦A座1801', '公司', 1),
(2, 1, '张三', '13900139000', '1', '440000', '广东省', '440100', '广州市', '440106', '天河区', '珠江新城花城大道66号', '家', 0);
