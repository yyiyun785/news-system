<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    // 严格权限验证：仅管理员可访问
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if(username == null || !"admin".equals(role)){
        response.sendRedirect("login.jsp");
        return;
    }

    // 数据库连接信息
    String driver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/news_system?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    String dbUser = "root";
    String dbPwd = "123456";

    // 处理删除新闻（管理员可删除任意新闻）
    String delId = request.getParameter("delId");
    if(delId != null){
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, dbUser, dbPwd);
            String sql = "DELETE FROM news WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(delId));
            int rows = pstmt.executeUpdate();
            if(rows > 0){
                out.println("<script>alert('删除成功！');location.href='adminNewsList.jsp';</script>");
            }else{
                out.println("<script>alert('删除失败！');history.back();</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('删除失败！');history.back();</script>");
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>新闻管理 - 管理员后台</title>
    <link rel="stylesheet" href="https://cdn.staticfile.org/layui/2.8.18/css/layui.css">
    <script src="https://cdn.staticfile.org/layui/2.8.18/layui.js"></script>
    <style>
        /* 顶部导航栏 */
        .layui-header{
            background:#409eff!important;
            height:60px;
            line-height:60px;
            position:relative!important;
            z-index:1000;
        }
        .top-title{
            color:#fff;
            font-size:18px;
            padding-left:20px;
            float:left;
        }

        /* 右上角用户下拉菜单 */
        .user-dropdown{
            float:right;
            margin-right:20px;
            position:relative;
            color:#fff;
            font-size:16px;
            cursor:pointer;
            line-height:60px!important;
        }
        .user-dropdown .welcome-text{
            color:#000!important;
        }
        .dropdown-menu{
            display:none;
            position:absolute;
            top:60px!important;
            right:0;
            background:#000!important;
            border:none;
            box-shadow:0 2px 12px rgba(0,0,0,0.2);
            width:150px;
            z-index:9999;
        }
        .dropdown-menu a{
            display:block;
            padding:12px 20px;
            color:#fff!important;
            text-decoration:none;
            font-size:14px;
            line-height:20px!important;
        }
        .dropdown-menu a:hover{
            background:#333!important;
            color:#fff!important;
        }

        /* 左侧侧边栏 */
        .layui-side{
            background:#f0f7ff!important;
            border-right:1px solid #d9e8ff;
        }
        .layui-nav-tree{
            background:#f0f7ff!important;
        }
        .layui-nav-tree .layui-nav-item a{
            color:#333!important;
            height:45px;
            line-height:45px;
        }
        .layui-nav-tree .layui-nav-item a:hover{
            background:#e0edff!important;
            color:#409eff!important;
        }
        .layui-nav-tree .layui-this>a{
            background:#409eff!important;
            color:#fff!important;
        }
        .layui-nav-tree .layui-nav-child dd a{
            background:#f8fbff!important;
        }
        .layui-nav-tree .layui-nav-child dd.layui-this a{
            background:#409eff!important;
            color:#fff!important;
        }

        /* 主体内容区 */
        .layui-body{
            background:#f5f7fa!important;
            padding:20px;
        }
    </style>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <!-- 顶部导航栏 -->
    <div class="layui-header">
        <div class="top-title">新闻发布系统 - 管理员后台</div>
        <div class="user-dropdown" id="userDropdown">
            <span class="welcome-text">欢迎</span> <%=username%> ▼
            <div class="dropdown-menu" id="dropdownMenu">
                <a href="logout.jsp">退出登录</a>
            </div>
        </div>
    </div>

    <!-- 左侧菜单（管理员专属） -->
    <div class="layui-side">
        <div class="layui-side-scroll">
            <ul class="layui-nav layui-nav-tree" lay-filter="sideNav">
                <li class="layui-nav-item"><a href="home.jsp">首页</a></li>
                <li class="layui-nav-item"><a href="newsAdd.jsp">发布新闻</a></li>
                <li class="layui-nav-item"><a href="newsList.jsp">我的新闻</a></li>
                <li class="layui-nav-item layui-this"><a href="adminNewsList.jsp">新闻管理</a></li>
                <li class="layui-nav-item"><a href="userList.jsp">用户管理</a></li>
                <li class="layui-nav-item">
                    <a href="javascript:;">个人中心</a>
                    <dl class="layui-nav-child">
                        <dd><a href="viewInfo.jsp">查看信息</a></dd>
                        <dd><a href="updateUser.jsp">修改信息</a></dd>
                        <dd><a href="updatePwd.jsp">修改密码</a></dd>
                    </dl>
                </li>
            </ul>
        </div>
    </div>

    <!-- 主体内容：所有新闻管理 -->
    <div class="layui-body">
        <div class="layui-card">
            <div class="layui-card-header">新闻管理（管理员可管理所有新闻）</div>
            <div class="layui-card-body">
                <table class="layui-table">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>新闻标题</th>
                        <th>发布作者</th>
                        <th>发布时间</th>
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
                            // 查询所有新闻，按发布时间倒序
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
                        <td><%=id%></td>
                        <td><%=title%></td>
                        <td><%=author%></td>
                        <td><%=time%></td>
                        <td>
                            <a href="newsDetail.jsp?id=<%=id%>" class="layui-btn layui-btn-xs layui-btn-normal">查看</a>
                            <a href="newsEdit.jsp?id=<%=id%>" class="layui-btn layui-btn-xs layui-btn-warm">编辑</a>
                            <a href="adminNewsList.jsp?delId=<%=id%>" class="layui-btn layui-btn-xs layui-btn-danger" onclick="return confirm('确定要删除这条新闻吗？删除后不可恢复！');">删除</a>
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

    // 下拉菜单显示/隐藏
    var userDropdown = document.getElementById('userDropdown');
    var dropdownMenu = document.getElementById('dropdownMenu');

    userDropdown.onclick = function(e){
        e.stopPropagation();
        dropdownMenu.style.display = dropdownMenu.style.display === 'block' ? 'none' : 'block';
    }

    document.onclick = function(){
        dropdownMenu.style.display = 'none';
    }
</script>
</body>
</html>