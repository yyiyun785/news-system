<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String id = request.getParameter("id");
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String driver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/news_system?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    String dbUser = "root";
    String dbPwd = "123456";

    String title = "", content = "";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, dbUser, dbPwd);
        String sql = "SELECT * FROM news WHERE id=?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, id);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            title = rs.getString("title");
            content = rs.getString("content");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑新闻</title>
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
    <div class="layui-header">
        <div class="top-title">新闻发布系统</div>
        <div style="float:right;margin-right:20px;position:relative">
            <div id="userBtn" style="color:#000;line-height:60px;cursor:pointer">
                欢迎 <%=username%> ▼
            </div>
            <div id="logoutMenu" style="display:none;position:absolute;top:60px;right:0;background:#fff;border:1px solid #eee;box-shadow:0 2px 8px rgba(0,0,0,0.1);width:120px">
                <a href="logout.jsp" style="display:block;padding:10px 15px;color:#000;text-decoration:none">退出登录</a>
            </div>
        </div>
    </div>

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
                    <a href="newsList.jsp">新闻列表</a>
                </li>
                <li class="layui-nav-item">
                    <a href="newsAdd.jsp">发布新闻</a>
                </li>
            </ul>
        </div>
    </div>

    <div class="layui-body">
        <div class="layui-card">
            <div class="layui-card-header">编辑新闻</div>
            <div class="layui-card-body">
                <form class="layui-form" action="newsEditSubmit.jsp" method="post">
                    <input type="hidden" name="id" value="<%=id%>">
                    <div class="layui-form-item">
                        <label class="layui-form-label">新闻标题</label>
                        <div class="layui-input-block">
                            <input type="text" name="title" value="<%=title%>" class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">新闻内容</label>
                        <div class="layui-input-block">
                            <textarea name="content" rows="12" class="layui-textarea"><%=content%></textarea>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block">
                            <button type="submit" class="layui-btn layui-btn-normal">保存修改</button>
                            <a href="newsList.jsp" class="layui-btn layui-btn-primary">返回</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    layui.use('element', function(){
        var element = layui.element;
        element.init();
    });

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