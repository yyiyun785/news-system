# 新闻管理系统（News Management System）

> 一个基于 **Java Web（Servlet + JSP）** 的新闻管理系统 —— 课程设计项目
>
> 后端 Servlet + JSP · 数据库 MySQL(JDBC) · 服务器 Tomcat · 构建 Maven

---

## 📖 项目简介

本项目实现了一个完整的**新闻发布与管理**网站，包含**前台（普通用户）**和**后台（管理员）**两套功能，覆盖了 Java Web 课程的核心知识点：

- **MVC 分层**：`pojo`（实体）→ `dao`（数据访问）→ `servlet`（控制）→ `jsp`（视图）
- **Servlet + JSP** 协作，使用 `web.xml` 配置 Servlet 映射
- **JDBC 数据库访问**，全部使用 `PreparedStatement` 占位符传参（**防 SQL 注入**）
- **Session 会话管理**，实现登录状态保持与角色区分
- 数据库资源统一在 `finally` 中关闭，避免连接泄漏

---

## ✨ 功能清单

### 前台 · 普通用户

| 功能 | 页面 |
|------|------|
| 用户注册 | `register.jsp` → `submit.jsp` |
| 普通用户登录 | `login.jsp` |
| 退出登录 | `logout.jsp` |
| 浏览新闻列表 | `newsList.jsp` / `guest.jsp`（游客） |
| 查看新闻详情 | `newsDetail.jsp` |
| 发布新闻 | `newsAdd.jsp` → `newsAddSubmit.jsp` |
| 编辑自己发布的新闻 | `newsEdit.jsp` → `newsEditSubmit.jsp` |
| 删除自己发布的新闻 | `newsDelete.jsp` |
| 查看 / 修改个人资料 | `viewInfo.jsp` / `updateUser.jsp` |
| 修改密码 | `updatePwd.jsp` |

### 后台 · 管理员

| 功能 | 页面 |
|------|------|
| 管理员登录（校验 `role='admin'`） | `login_admin.jsp` |
| 后台首页 | `admin_index.jsp` |
| 数据统计：新闻总数 / 用户数 / 今日新增 | `home.jsp` |
| 新闻管理（查看全部、删除任意新闻） | `adminNewsList.jsp` |
| 用户管理（查看用户列表、删除用户） | `userList.jsp` |

---

## 🛠️ 技术栈

| 类别 | 技术 | 版本 |
|------|------|------|
| 后端语言 | Java | JDK 8+ |
| Web 组件 | Servlet / JSP | Servlet 4.0.1 / JSP 2.2 |
| 数据库 | MySQL | 5.7 / 8.0 |
| 数据库驱动 | MySQL Connector/J（`com.mysql.cj.jdbc.Driver`） | 8.x |
| Web 服务器 | Apache Tomcat | **9.x**（不要用 Tomcat 10+，见下方说明） |
| 构建工具 | Maven | 3.6+ |
| 视图层 | JSP + 原生 CSS | — |

> ⚠️ **必须使用 Tomcat 9 及以下版本**
> 本项目依赖 `javax.servlet.*`（Servlet 4.0）。从 **Tomcat 10 开始包名改为 `jakarta.servlet.*`**，
> 直接部署到 Tomcat 10+ 会报 `ClassNotFoundException: javax.servlet.http.HttpServlet`。

---

## 📁 项目结构

```
news-system/
├── pom.xml                                  # Maven 配置（servlet / jsp 依赖，scope=provided）
├── sql/
│   └── news_system.sql                      # 数据库建表脚本（含初始数据）
├── src/main/java/com/
│   ├── pojo/                                # 实体类
│   │   ├── User.java                        #   用户实体
│   │   └── News.java                        #   新闻实体
│   ├── dao/                                 # 数据访问层
│   │   ├── UserDao.java                     #   登录 login() / 注册 register()
│   │   └── NewsDao.java                     #   查询全部 getAllNews() / 添加 addNews()
│   ├── servlet/                             # 控制层
│   │   ├── LoginServlet.java                #   映射 /login
│   │   └── RegisterServlet.java             #   映射 /register
│   └── utll/                                # 工具类
│       └── jbuutil.java                     #   数据库连接与资源关闭（JDBC 工具类）
└── src/main/webapp/                         # 视图层
    ├── WEB_INF/web.xml                      # Servlet 映射 + 欢迎页配置
    └── *.jsp                                # 24 个 JSP 页面
```

---

## 🗄️ 数据库设计

**数据库名：`news_system`** ｜ 字符集：`utf8mb4`

### 表 1：`user`（用户表）

| 字段 | 类型 | 说明 |
|------|------|------|
| `id` | INT AUTO_INCREMENT | 主键 |
| `username` | VARCHAR(50) | 用户名（唯一，登录账号） |
| `password` | VARCHAR(100) | 密码 |
| `role` | VARCHAR(20) | 角色：`user` / `admin`，**默认 `user`** |
| `gender` | VARCHAR(10) | 性别 |
| `occupation` | VARCHAR(50) | 职业 |
| `hobbies` | VARCHAR(255) | 爱好 |
| `introduction` | TEXT | 个人简介 |
| `reg_time` | DATETIME | 注册时间，**默认 `CURRENT_TIMESTAMP`** |

### 表 2：`news`（新闻表）

| 字段 | 类型 | 说明 |
|------|------|------|
| `id` | INT AUTO_INCREMENT | 主键 |
| `title` | VARCHAR(200) | 新闻标题 |
| `content` | TEXT | 新闻正文 |
| `author` | VARCHAR(50) | 作者（对应 `user.username`） |
| `create_time` | DATETIME | 发布时间，**默认 `CURRENT_TIMESTAMP`** |
| `update_time` | DATETIME | 最后修改时间（编辑时更新） |

> 💡 **两个容易踩的坑**（脚本里已处理）：
> 1. `user.role` 必须有默认值 `'user'` —— `submit.jsp` 注册时**不传 role**，没默认值会插入失败。
> 2. `news.create_time` 必须有默认值 —— `newsAddSubmit.jsp` 的 INSERT **不带 create_time**。

---

## 🚀 运行步骤

### 步骤 1：初始化数据库

```bash
mysql -u root -p < sql/news_system.sql
```

或者用 Navicat / IDEA 的 Database 面板打开 `sql/news_system.sql`，全选执行。

执行完会自动创建 `news_system` 库、两张表和**初始数据**。

### 步骤 2：确认数据库连接配置

默认配置为：

```
地址：jdbc:mysql://localhost:3306/news_system
账号：root
密码：123456
```

如果你的 MySQL 密码不是 `123456`，需要修改：

- `src/main/java/com/utll/jbuutil.java`
- **以及各 JSP 页面里的连接参数**（`login.jsp`、`home.jsp`、`newsList.jsp` 等共 16 个文件）

> ⚠️ 这是本项目当前的一个待改进点，见下方「已知问题」。

### 步骤 3：配置 Tomcat 并运行

**方式 A：用 IDEA（推荐）**

1. IDEA → `File` → `Open`，选择项目根目录
2. `File` → `Project Structure` → `Modules` → 确认已识别为 **Web 项目**，`Web Resource Directory` 指向 `src/main/webapp`
3. `Run` → `Edit Configurations` → `+` → **Tomcat Server** → `Local`
4. `Deployment` 标签 → `+` → `Artifact` → 选择 `news-system:war exploded`
5. `Application context` 建议填 `/news`
6. 点击运行，浏览器访问 **http://localhost:8080/news/**

**方式 B：命令行打包后手动部署**

```bash
mvn clean package          # 生成 target/news-system.war
# 把 war 复制到 Tomcat 的 webapps 目录，然后启动 Tomcat
```

### 步骤 4：登录系统

| 角色 | 账号 | 密码 | 入口 |
|------|------|------|------|
| **管理员** | `admin` | `admin123` | 首页 → 管理员登录 |
| **普通用户** | `user` | `123456` | 首页 → 普通用户登录 |

也可以点「立即注册」自己注册一个新账号（默认角色为普通用户）。

---

## 🔗 页面与路由一览

| 路径 | 说明 |
|------|------|
| `/` | 欢迎页（`web.xml` 配置为 `index.jsp` → `login.jsp`） |
| `/login` | `LoginServlet` 登录处理 |
| `/register` | `RegisterServlet` 注册处理 |
| `/login.jsp` | 普通用户登录页 |
| `/login_admin.jsp` | 管理员登录页（校验 `role='admin'`） |
| `/home.jsp` | 登录后首页 / 数据概览 |
| `/newsList.jsp` | 我的新闻列表 |
| `/newsDetail.jsp` | 新闻详情 |
| `/admin_index.jsp` | 管理员后台首页 |
| `/adminNewsList.jsp` | 后台 · 新闻管理 |
| `/userList.jsp` | 后台 · 用户管理 |

---

## ❓ 常见问题

**1. 中文乱码**

- 数据库字符集必须是 `utf8mb4`（脚本已设置）
- JSP 页面顶部需要 `<%@ page contentType="text/html;charset=UTF-8" %>`
- 表单提交前需 `request.setCharacterEncoding("UTF-8")`
- JDBC 连接串要带 `useUnicode=true&characterEncoding=UTF-8`

**2. `ClassNotFoundException: com.mysql.cj.jdbc.Driver`**

Maven 依赖里缺少 MySQL 驱动，在 `pom.xml` 中加入：

```xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
</dependency>
```

**3. `ClassNotFoundException: javax.servlet.http.HttpServlet`**

Tomcat 版本过高，**换成 Tomcat 9**（Tomcat 10+ 用的是 `jakarta.servlet`）。

**4. 数据库连不上 / `Public Key Retrieval is not allowed`**

在连接串后追加参数：

```
?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Shanghai
```

**5. 页面 404**

检查 IDEA 里 Tomcat 的 `Application context` 和 `Deployment` 是否配置正确，
访问地址要带上 context（如 `http://localhost:8080/news/`）。

---

## ⚠️ 已知问题与可改进点

本项目作为课程设计已实现完整功能，以下是**有意保留的真实状态**，也是后续可优化的方向：

| # | 问题 | 建议改进 |
|---|------|----------|
| 1 | **密码明文存储** | 生产环境应使用 BCrypt / SHA-256 加盐加密 |
| 2 | **数据库连接参数散落在 16 个 JSP 中** | 统一收敛到 `jbuutil` 工具类，或改用连接池（Druid / HikariCP） |
| 3 | 部分业务逻辑写在 JSP 脚本片段里 | 继续下沉到 Servlet / Service 层，JSP 只负责展示 |
| 4 | `utll` 包名拼写有误（应为 `util`） | 重命名包并同步 import |
| 5 | 每次请求都新建连接，未使用连接池 | 引入连接池提升性能 |
| 6 | 没有 CSRF 防护、没有输入长度校验 | 增加表单令牌与后端校验 |

---

## 📌 说明

- 本项目为**个人课程设计作品**，仅供学习交流使用
- 项目中的数据库账号密码为**本地开发默认值**，不是真实敏感信息
- 所有 SQL 均使用 `PreparedStatement` 占位符传参，**已防止 SQL 注入**

---

## 📄 License

MIT
