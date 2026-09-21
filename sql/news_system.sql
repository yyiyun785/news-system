-- ============================================================
--  新闻管理系统（News Management System）数据库脚本
--  数据库名 : news_system
--  字符集   : utf8mb4
--  适配版本 : MySQL 5.7 / 8.0
--
--  ✅ 本脚本【安全、可重复执行】
--     · 没有 DROP DATABASE —— 不会删掉已有库和已有数据
--     · 已有库会自动补齐缺少的字段（reg_time / update_time）
--     · 重复执行不报错，也不会重复插入初始数据
--
--  用法： mysql -u root -p < news_system.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS news_system
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE news_system;

-- ------------------------------------------------------------
--  表 1：user（用户表）
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS user (
    id            INT          NOT NULL AUTO_INCREMENT            COMMENT '用户ID',
    username      VARCHAR(50)  NOT NULL                           COMMENT '用户名',
    password      VARCHAR(50)  NOT NULL                           COMMENT '密码',
    role          VARCHAR(20)      NULL DEFAULT 'user'            COMMENT '角色：admin-管理员 / user-普通用户',
    gender        VARCHAR(10)      NULL DEFAULT '男'              COMMENT '性别',
    occupation    VARCHAR(50)      NULL DEFAULT NULL              COMMENT '职业',
    hobbies       VARCHAR(200)     NULL DEFAULT NULL              COMMENT '爱好',
    introduction  TEXT             NULL                           COMMENT '个人简介',
    reg_time      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
    PRIMARY KEY (id),
    UNIQUE KEY username (username)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '用户表';

-- ------------------------------------------------------------
--  表 2：news（新闻表）
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS news (
    id           INT          NOT NULL AUTO_INCREMENT             COMMENT '新闻ID',
    title        VARCHAR(200) NOT NULL                            COMMENT '新闻标题',
    content      TEXT         NOT NULL                            COMMENT '新闻内容',
    author       VARCHAR(50)  NOT NULL                            COMMENT '发布人',
    create_time  DATETIME         NULL DEFAULT CURRENT_TIMESTAMP  COMMENT '发布时间',
    update_time  DATETIME         NULL DEFAULT NULL               COMMENT '最后修改时间',
    PRIMARY KEY (id),
    KEY idx_author (author)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  COMMENT = '新闻表';

-- ============================================================
--  兼容处理：给「早期版本建的库」补上缺少的字段
--  （home.jsp 需要 reg_time，newsEditSubmit.jsp 需要 update_time，
--    早期建表脚本里没有这两个字段，会导致 SQL 报错）
-- ============================================================
SET @c := (SELECT COUNT(*) FROM information_schema.COLUMNS
           WHERE TABLE_SCHEMA = 'news_system' AND TABLE_NAME = 'user' AND COLUMN_NAME = 'reg_time');
SET @s := IF(@c = 0,
    'ALTER TABLE user ADD COLUMN reg_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT ''注册时间''',
    'SELECT ''已存在，跳过：user.reg_time'' AS notice');
PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;

SET @c := (SELECT COUNT(*) FROM information_schema.COLUMNS
           WHERE TABLE_SCHEMA = 'news_system' AND TABLE_NAME = 'news' AND COLUMN_NAME = 'update_time');
SET @s := IF(@c = 0,
    'ALTER TABLE news ADD COLUMN update_time DATETIME NULL DEFAULT NULL COMMENT ''最后修改时间''',
    'SELECT ''已存在，跳过：news.update_time'' AS notice');
PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;

-- ============================================================
--  初始数据
-- ============================================================

-- 两个演示账号（用户名唯一，已存在会自动跳过，不会报错）
INSERT IGNORE INTO user (username, password, role, gender, occupation, hobbies, introduction) VALUES
('admin', 'admin123', 'admin', '男', '系统管理员', '编程、阅读',  '新闻管理系统管理员账号，可进入后台管理用户与新闻。'),
('user',  '123456',   'user',  '男', '学生',       '篮球、编程',  '普通用户演示账号，可发布和管理自己的新闻。');

-- 示例新闻：只在 news 表为空时插入，避免覆盖你已有的数据
SET @n := (SELECT COUNT(*) FROM news);
SET @s := IF(@n = 0,
    'INSERT INTO news (title, content, author) VALUES (''欢迎使用新闻管理系统'', ''这是系统内置的示例新闻。本系统基于 Java Web（Servlet + JSP + MySQL）开发，包含普通用户前台与管理员后台两套功能。'', ''admin'')',
    'SELECT ''news 表已有数据，跳过示例新闻'' AS notice');
PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;

-- ============================================================
--  执行完毕后可自行验证：
--     SELECT * FROM user;
--     SELECT * FROM news;
-- ============================================================


-- ============================================================
--  ⚠️ 只有在你想「彻底重建、清空所有数据」时，
--     才取消下面一行的注释，然后重新执行本脚本
-- ============================================================
-- DROP DATABASE news_system;
