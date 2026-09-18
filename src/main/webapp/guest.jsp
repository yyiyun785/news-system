<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null) {
        response.sendRedirect("login_user.jsp");
        return;
    }

    String driver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/news_system?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    String dbUser = "root";
    String dbPwd = "123456";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>新闻浏览 - 普通用户</title>
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
        .layui-nav-tree .layui-nav-itemed>a{
            background:#d0e4ff!important;
            color:#409eff!important;
            font-weight:500;
        }
        .layui-nav-tree .layui-nav-child dd.layui-this a{
            background:#409eff!important;
            color:#fff!important;
        }
        .layui-body{
            background:#f5f7fa!important;
            padding:15px;
        }
    </style>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <!-- 顶部栏 -->
    <div class="layui-header">
        <div class="top-title">新闻发布系统 - 新闻浏览</div>
        <div style="float:right;margin-right:20px;position:relative">
            <div id="userBtn" style="color:#000;line-height:60px;cursor:pointer">
                欢迎您：<%=username%> ▼
            </div>
            <div id="logoutMenu" style="display:none;position:absolute;top:60px;right:0;background:#fff;border:1px solid #eee;box-shadow:0 2px 8px rgba(0,0,0,0.1);width:120px">
                <a href="logout.jsp" style="display:block;padding:10px 15px;color:#000;text-decoration:none">退出登录</a>
            </div>
        </div>
    </div>

    <!-- 侧边栏：加上个人信息菜单 -->
    <div class="layui-side">
        <div class="layui-side-scroll">
            <ul class="layui-nav layui-nav-tree" lay-filter="sideNav">
                <li class="layui-nav-item">
                    <a href="home.jsp">首页</a>
                </li>
                <li class="layui-nav-item">
                    <a href="javascript:;">个人信息</a>
                    <dl class="layui-nav-child">
                        <dd><a href="viewInfo.jsp">查看信息</a></dd>
                        <dd><a href="updatePwd.jsp">修改密码</a></dd>
                        <dd><a href="updateUser.jsp">修改个人信息</a></dd>
                    </dl>
                </li>
                <li class="layui-nav-item layui-this">
                    <a href="guest.jsp">新闻浏览</a>
                </li>
            </ul>
        </div>
    </div>

    <!-- 主体内容：纯新闻列表，仅查看 -->
    <div class="layui-body">
        <div class="layui-card">
            <div class="layui-card-header">全部新闻</div>
            <div class="layui-card-body">
                <table class="layui-table">
                    <thead>
                    <tr>
                        <th>新闻标题</th>
                        <th>发布作者</th>
                        <th>发布时间</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        try {
                            Class.forName(driver);
                            conn = DriverManager.getConnection(url, dbUser, dbPwd);
                            String sql = "SELECT * FROM news ORDER BY create_time DESC";
                            pstmt = conn.prepareStatement(sql);
                            rs = pstmt.executeQuery();
                            while (rs.next()) {
                                int id = rs.getInt("id");
                                String title = rs.getString("title");
                                String author = rs.getString("author");
                                String time = rs.getString("create_time");
                    %>
                    <tr>
                        <td><%=title%></td>
                        <td><%=author%></td>
                        <td><%=time%></td>
                        <td>
                            <a href="newsDetail.jsp?id=<%=id%>" class="layui-btn layui-btn-xs layui-btn-normal">查看详情</a>
                        </td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            try { if (rs != null) rs.close(); } catch (Exception e) {}
                            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
                            try { if (conn != null) conn.close(); } catch (Exception e) {}
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

    // 右上角下拉菜单
    var userBtn = document.getElementById('userBtn');
    var logoutMenu = document.getElementById('logoutMenu');
    userBtn.onclick = function(e){
        e.stopPropagation();
        logoutMenu.style.display = logoutMenu.style.display === 'block' ? 'none' : 'block';
    }
    document.onclick = function(){
        logoutMenu.style.display = 'none';
    }
</script>
</body>
</html>