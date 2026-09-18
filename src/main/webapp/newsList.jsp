<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    if(username == null){
        response.sendRedirect("login.jsp");
        return;
    }

    // 数据库连接信息
    String driver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/news_system?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    String dbUser = "root";
    String dbPwd = "123456";

    // 处理删除自己的新闻
    String delId = request.getParameter("delId");
    if(delId != null){
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, dbUser, dbPwd);
            // 只能删除自己发布的新闻
            String sql = "DELETE FROM news WHERE id=? AND author=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(delId));
            pstmt.setString(2, username);
            int rows = pstmt.executeUpdate();
            if(rows > 0){
                out.println("<script>alert('删除成功！');location.href='newsList.jsp';</script>");
            }else{
                out.println("<script>alert('只能删除自己发布的新闻！');history.back();</script>");
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
    <title>我的新闻</title>
    <link rel="stylesheet" href="https://cdn.staticfile.org/layui/2.8.18/css/layui.css">
    <script src="https://cdn.staticfile.org/layui/2.8.18/layui.js"></script>
    <style>
        /* 顶部栏蓝色 */
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

        /* 侧边栏统一蓝色系 */
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
        /* 选中状态蓝色 */
        .layui-nav-tree .layui-this>a{
            background:#409eff!important;
            color:#fff!important;
        }
        /* 子菜单样式 */
        .layui-nav-tree .layui-nav-child dd a{
            background:#f8fbff!important;
        }
        .layui-nav-tree .layui-nav-child dd.layui-this a{
            background:#409eff!important;
            color:#fff!important;
        }

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
        <div class="top-title">新闻发布系统</div>
        <div style="float:right; margin-right:20px; color:#fff;">
            欢迎：<%=username%>
            <a href="logout.jsp" style="color:#fff; margin-left:15px;">退出登录</a>
        </div>
    </div>

    <!-- 左侧菜单（全蓝色系） -->
    <div class="layui-side">
        <div class="layui-side-scroll">
            <ul class="layui-nav layui-nav-tree" lay-filter="sideNav">
                <li class="layui-nav-item"><a href="home.jsp">首页</a></li>
                <li class="layui-nav-item"><a href="newsAdd.jsp">发布新闻</a></li>
                <li class="layui-nav-item layui-this"><a href="newsList.jsp">我的新闻</a></li>
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

    <!-- 主体内容：只显示自己发布的新闻 -->
    <div class="layui-body">
        <div class="layui-card">
            <div class="layui-card-header">我的新闻（仅显示您发布的内容）</div>
            <div class="layui-card-body">
                <table class="layui-table">
                    <thead>
                    <tr>
                        <th>新闻标题</th>
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
                            // 关键：只查询当前用户自己发布的新闻
                            String sql = "SELECT * FROM news WHERE author=? ORDER BY create_time DESC";
                            pstmt = conn.prepareStatement(sql);
                            pstmt.setString(1, username);
                            rs = pstmt.executeQuery();

                            boolean hasNews = false;
                            while (rs.next()) {
                                hasNews = true;
                                int id = rs.getInt("id");
                                String title = rs.getString("title");
                                String time = rs.getString("create_time");
                    %>
                    <tr>
                        <td><%=title%></td>
                        <td><%=time%></td>
                        <td>
                            <a href="newsDetail.jsp?id=<%=id%>" class="layui-btn layui-btn-xs layui-btn-normal">查看</a>
                            <a href="newsEdit.jsp?id=<%=id%>" class="layui-btn layui-btn-xs layui-btn-warm">编辑</a>
                            <a href="newsList.jsp?delId=<%=id%>" class="layui-btn layui-btn-xs layui-btn-danger" onclick="return confirm('确定要删除这条新闻吗？');">删除</a>
                        </td>
                    </tr>
                    <%
                        }
                        if(!hasNews){
                    %>
                    <tr>
                        <td colspan="3" style="text-align:center; color:#999;">您还没有发布过新闻，点击【发布新闻】开始创作吧！</td>
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
</script>
</body>
</html>