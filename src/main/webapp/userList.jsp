<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    // 权限拦截：仅管理员可访问
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"admin".equals(role)) {
        response.sendRedirect("login_admin.jsp");
        return;
    }

    String driver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/news_system?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    String dbUser = "root";
    String dbPwd = "123456";

    // 处理删除用户请求
    String delUser = request.getParameter("delUser");
    if (delUser != null && !delUser.equals("admin")) { // 禁止删除管理员账号
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, dbUser, dbPwd);
            String sql = "DELETE FROM user WHERE username=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, delUser);
            pstmt.executeUpdate();
            out.println("<script>alert('用户删除成功！');location.href='userList.jsp';</script>");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('删除失败！');history.back();</script>");
        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户管理 - 管理员后台</title>
    <link rel="stylesheet" href="https://cdn.staticfile.org/layui/2.8.18/css/layui.css">
    <script src="https://cdn.staticfile.org/layui/2.8.18/layui.js"></script>
    <style>
        .layui-header{
            background:#409eff!important;
            height:60px;
            line-height:60px;
        }
        .top-title{
            color:#fff;
            font-size:18px;
            padding-left:20px;
        }
        .layui-side,
        .layui-side-scroll,
        .layui-nav-tree,
        .layui-nav-item,
        .layui-nav-child{
            background:#f0f7ff!important;
        }
        .layui-side{
            border-right:1px solid #d9e8ff;
        }
        .layui-nav{
            list-style:none!important;
            padding-left:0!important;
        }
        .layui-nav-tree .layui-nav-item a{
            color:#333!important;
            height:45px;
            line-height:45px;
            text-decoration:none!important;
        }
        .layui-nav-tree .layui-nav-item a:hover{
            background:#e0edff!important;
            color:#409eff!important;
        }
        .layui-body{
            background:#f5f7fa!important;
            padding:15px;
        }
    </style>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <!-- 顶部导航栏 -->
    <div class="layui-header">
        <div class="top-title">新闻发布系统 - 管理员后台</div>
        <div style="float:right;margin-right:20px;color:#fff;">
            欢迎管理员：<%=username%>
            <a href="logout.jsp" style="color:#fff;margin-left:15px;">退出登录</a>
        </div>
    </div>

    <!-- 左侧菜单 -->
    <div class="layui-side">
        <div class="layui-side-scroll">
            <ul class="layui-nav layui-nav-tree" lay-filter="sideNav">
                <li class="layui-nav-item">
                    <a href="admin_index.jsp">管理首页</a>
                </li>
                <li class="layui-nav-item">
                    <a href="newsList.jsp">全量新闻管理</a>
                </li>
                <li class="layui-nav-item layui-this">
                    <a href="userList.jsp">用户管理</a>
                </li>
            </ul>
        </div>
    </div>

    <!-- 主体内容：用户列表 -->
    <div class="layui-body">
        <div class="layui-card">
            <div class="layui-card-header">用户管理</div>
            <div class="layui-card-body">
                <table class="layui-table">
                    <thead>
                    <tr>
                        <th>用户名</th>
                        <th>角色</th>
                        <th>性别</th>
                        <th>职业</th>
                        <th>注册状态</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        try {
                            Class.forName(driver);
                            conn = DriverManager.getConnection(url, dbUser, dbPwd);
                            String sql = "SELECT * FROM user ORDER BY role DESC, username ASC";
                            pstmt = conn.prepareStatement(sql);
                            rs = pstmt.executeQuery();
                            while (rs.next()) {
                    %>
                    <tr>
                        <td><%=rs.getString("username")%></td>
                        <td>
                            <% if("admin".equals(rs.getString("role"))) { %>
                            <span class="layui-badge layui-bg-blue">管理员</span>
                            <% } else { %>
                            <span class="layui-badge layui-bg-green">普通用户</span>
                            <% } %>
                        </td>
                        <td><%=rs.getString("gender")%></td>
                        <td><%=rs.getString("occupation")%></td>
                        <td>已注册</td>
                        <td>
                            <% if("admin".equals(rs.getString("username"))) { %>
                            <span class="layui-text-gray">不可删除</span>
                            <% } else { %>
                            <a href="userList.jsp?delUser=<%=rs.getString("username")%>"
                               class="layui-btn layui-btn-xs layui-btn-danger"
                               onclick="return confirm('确定要删除该用户吗？删除后该用户将无法登录！');">
                                删除用户
                            </a>
                            <% } %>
                        </td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) rs.close();
                            if (pstmt != null) pstmt.close();
                            if (conn != null) conn.close();
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    layui.use('element', function(){
        var element = layui.element;
        element.init();
    });
</script>
</body>
</html>