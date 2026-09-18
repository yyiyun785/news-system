# 新闻管理系统（News Management System）

一个基于 **Java Web（JSP + Servlet）** 的新闻管理系统，课程设计项目。

## 技术栈

| 类别 | 技术 |
|------|------|
| 后端 | Java（Servlet + JSP） |
| 数据库 | MySQL（JDBC） |
| 服务器 | Tomcat |
| 构建工具 | Maven |

## 功能

- 用户注册 / 登录 / 修改密码
- 新闻浏览（列表、详情）
- 新闻发布、编辑、删除
- 后台管理（用户管理、新闻管理）
- 角色权限（普通用户 / 管理员）

## 项目结构

```
src/main/java/com/
├── pojo/       # 实体类（User、News）
├── dao/        # 数据访问层（UserDao、NewsDao）
├── servlet/    # 控制层（LoginServlet、RegisterServlet）
└── utll/       # 工具类（数据库连接 jbuutil）
src/main/webapp/  # 视图层（JSP 页面）
```

## 数据库

- 数据库名：`news_system`
- 主要表：`user`（用户表）、`news`（新闻表）
- 连接信息在 `jbuutil.java` 中配置（默认 root / 123456）

## 运行方式

1. 创建数据库 `news_system`，导入表结构
2. 用 IDEA 打开项目，配置 Tomcat
3. 运行，访问 `http://localhost:8080/`
