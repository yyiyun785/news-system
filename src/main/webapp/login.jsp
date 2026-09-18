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
            String sql = "SELECT * FROM user WHERE username=? AND password=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                session.setAttribute("username", username);
                session.setAttribute("role", rs.getString("role"));
                response.sendRedirect("home.jsp");
                return;
            } else {
                msg = "用户名或密码错误！";
            }
        } catch (Exception e) {
            e.printStackTrace();
            msg = "服务器异常！";
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
%>
<html>
<head>
    <title>普通用户登录</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family: "Microsoft YaHei"; }
        body { background:#f0f7ff; display:flex; justify-content:center; padding-top:100px; }
        .login-box {
            width:420px;
            background:#fff;
            padding:45px;
            border-radius:10px;
            border: 1px solid #d1e7ff;
            box-shadow:0 0 12px rgba(64,158,255,0.1);
        }
        .login-box h2 {
            text-align:center;
            margin-bottom:35px;
            color:#409eff;
            font-weight:normal;
        }
        .item { margin-bottom:22px; }
        .item label { display:block; margin-bottom:8px; color:#333; font-size:14px; }
        .item input {
            width:100%;
            height:44px;
            padding:0 15px;
            border:1px solid #dcdfe6;
            border-radius:6px;
            outline:none;
            font-size:14px;
        }
        .item input:focus { border-color:#409eff; }
        .login-btn {
            width:100%;
            height:45px;
            background:#409eff;
            color:#fff;
            border:none;
            border-radius:6px;
            font-size:16px;
            cursor:pointer;
        }
        .login-btn:hover { background:#338eef; }
        .msg { color:red; text-align:center; margin-bottom:15px; font-size:14px; }
        .links { text-align:center; margin-top:18px; font-size:14px; }
        .links a { color:#409eff; text-decoration:none; }
    </style>
</head>
<body>
<div class="login-box">
    <h2>普通用户登录</h2>
    <% if(!msg.isEmpty()){ %>
    <div class="msg"><%=msg%></div>
    <% } %>
    <form method="post">
        <div class="item">
            <label>用户名</label>
            <input type="text" name="username" required>
        </div>
        <div class="item">
            <label>密码</label>
            <input type="password" name="password" required>
        </div>
        <button type="submit" class="login-btn">登录</button>
    </form>
    <div class="links">
        <a href="register.jsp">立即注册</a>
    </div>
</div>
</body>
</html>