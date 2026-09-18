<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
  request.setCharacterEncoding("UTF-8");
  String msg = "";

  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    String driver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/news_system?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    String dbUser = "root";
    String dbPwd = "123456";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
      Class.forName(driver);
      conn = DriverManager.getConnection(url, dbUser, dbPwd);
      // 只允许管理员 role='admin' 登录
      String sql = "SELECT * FROM user WHERE username=? AND password=? AND role='admin'";
      pstmt = conn.prepareStatement(sql);
      pstmt.setString(1, username);
      pstmt.setString(2, password);
      rs = pstmt.executeQuery();

      if (rs.next()) {
        session.setAttribute("username", username);
        session.setAttribute("role", rs.getString("role"));
        response.sendRedirect("admin_index.jsp");
        return;
      } else {
        msg = "管理员账号或密码错误！";
      }
    } catch (Exception e) {
      e.printStackTrace();
      msg = "服务器异常，请重试！";
    } finally {
      try { if (rs != null) rs.close(); } catch (Exception e) {}
      try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
      try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
  }
%>
<html>
<head>
  <title>管理员登录 - 新闻发布系统</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: "Microsoft YaHei", sans-serif;
    }
    body {
      background-color: #f5f5f5;
      display: flex;
      justify-content: center;
      align-items: flex-start;
      padding-top: 100px;
    }
    .login-box {
      width: 400px;
      padding: 40px;
      background-color: #ffffff;
      border: 2px solid #1677ff;
      border-radius: 8px;
      box-shadow: 0 2px 12px rgba(22, 119, 255, 0.1);
    }
    .login-box h2 {
      text-align: center;
      margin-bottom: 30px;
      color: #1677ff;
      font-weight: 500;
    }
    .input-group {
      margin-bottom: 20px;
    }
    .input-group label {
      display: block;
      margin-bottom: 8px;
      color: #333333;
      font-size: 14px;
    }
    .input-group input {
      width: 100%;
      height: 40px;
      padding: 0 15px;
      border: 1px solid #d9d9d9;
      border-radius: 4px;
      font-size: 14px;
      transition: border-color 0.3s;
    }
    .input-group input:focus {
      outline: none;
      border-color: #1677ff;
      box-shadow: 0 0 0 2px rgba(22, 119, 255, 0.2);
    }
    .login-btn {
      width: 100%;
      height: 42px;
      background-color: #1677ff;
      color: #ffffff;
      border: none;
      border-radius: 4px;
      font-size: 16px;
      cursor: pointer;
      transition: background-color 0.3s;
      margin-bottom: 15px;
    }
    .login-btn:hover {
      background-color: #4096ff;
    }
    .links {
      text-align: center;
      font-size: 14px;
    }
    .links a {
      color: #1677ff;
      text-decoration: none;
    }
    .links a:hover {
      text-decoration: underline;
    }
    .msg {
      color: red;
      text-align: center;
      margin-bottom: 15px;
      font-size: 14px;
    }
  </style>
</head>
<body>
<div class="login-box">
  <h2>管理员登录</h2>
  <% if (!msg.isEmpty()) { %>
  <div class="msg"><%= msg %></div>
  <% } %>
  <form action="login_admin.jsp" method="post">
    <div class="input-group">
      <label for="username">管理员账号</label>
      <input type="text" id="username" name="username" placeholder="请输入管理员账号" required>
    </div>
    <div class="input-group">
      <label for="password">密码</label>
      <input type="password" id="password" name="password" placeholder="请输入密码" required>
    </div>
    <button type="submit" class="login-btn">登录</button>
    <div class="links" style="margin-top:15px;">
      <a href="login.jsp">普通用户入口</a>
    </div>
  </form>
</div>
</body>
</html>