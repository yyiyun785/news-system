<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    // 中文乱码处理
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    // 从session获取当前登录用户（你项目里用的是username参数，这里兼容两种方式）
    String username = (String) session.getAttribute("username");
    if (username == null) {
        username = request.getParameter("username");
    }
    if (username == null) {
        // 未登录跳转到登录页
        response.sendRedirect("login.jsp");
        return;
    }

    // 数据库连接信息（改成你自己的）
    String driver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/news_system?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    String dbUser = "root";
    String dbPwd = "123456";

    // 定义变量存储用户信息
    String password = "";
    String gender = "";
    String occupation = "";
    String hobbies = "";
    String introduction = "";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName(driver);
        conn = DriverManager.getConnection(url, dbUser, dbPwd);

        // 查询当前用户信息
        String sql = "SELECT password, gender, occupation, hobbies, introduction FROM user WHERE username=?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, username);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            password = rs.getString("password");
            gender = rs.getString("gender");
            occupation = rs.getString("occupation");
            hobbies = rs.getString("hobbies");
            introduction = rs.getString("introduction");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>查看个人信息</title>
    <link rel="stylesheet" href="https://cdn.staticfile.org/layui/2.8.18/css/layui.css">
    <script src="https://cdn.staticfile.org/layui/2.8.18/layui.js"></script>
    <style>
        /* 顶部蓝色栏 */
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

        /* 侧边栏浅蓝白背景 */
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

        /* 侧边栏菜单样式 */
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

        /* 主体区域 */
        .layui-body{
            background:#f5f7fa!important;
            padding:15px;
        }

        /* 信息卡片样式 */
        .info-card{
            background:#fff;
            border-radius:8px;
            padding:20px;
            margin-bottom:15px;
        }
        .info-item{
            margin-bottom:15px;
            font-size:15px;
        }
        .info-label{
            display:inline-block;
            width:100px;
            color:#666;
        }
        .info-value{
            color:#333;
        }
    </style>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <!-- 顶部导航栏 -->
    <div class="layui-header">
        <div class="top-title">新闻发布系统</div>

        <!-- 右上角用户菜单 -->
        <div style="float:right;margin-right:20px;position:relative">
            <div id="userBtn" style="color:#000000;line-height:60px;cursor:pointer">
                欢迎 <%= username %> ▼
            </div>
            <div id="logoutMenu" style="display:none;position:absolute;top:60px;right:0;background:#fff;border:1px solid #eee;box-shadow:0 2px 8px rgba(0,0,0,0.1);width:120px">
                <a href="logout.jsp" style="display:block;padding:10px 15px;color:#000;text-decoration:none">退出登录</a>
            </div>
        </div>
    </div>

    <!-- 左侧菜单 -->
    <div class="layui-side">
        <div class="layui-side-scroll">
            <ul class="layui-nav layui-nav-tree" lay-filter="sideNav">
                <li class="layui-nav-item layui-nav-itemed">
                    <a href="javascript:;">个人信息</a>
                    <dl class="layui-nav-child">
                        <dd class="layui-this"><a href="viewInfo.jsp">查看信息</a></dd>
                        <dd><a href="javascript:;">修改密码</a></dd>
                        <dd><a href="javascript:;">修改个人信息</a></dd>
                    </dl>
                </li>
                <li class="layui-nav-item">
                    <a href="javascript:;">新闻发布信息</a>
                </li>
            </ul>
        </div>
    </div>

    <!-- 主体内容区域：查看个人信息 -->
    <div class="layui-body">
        <div class="layui-card">
            <div class="layui-card-header">查看个人信息</div>
            <div class="layui-card-body">
                <div class="info-card">
                    <div class="info-item">
                        <span class="info-label">用户名：</span>
                        <span class="info-value"><%= username %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">性别：</span>
                        <span class="info-value"><%= gender %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">职业：</span>
                        <span class="info-value"><%= occupation %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">兴趣爱好：</span>
                        <span class="info-value"><%= hobbies %></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">个人说明：</span>
                        <span class="info-value"><%= introduction %></span>
                    </div>
                </div>
                <a href="home.jsp" class="layui-btn layui-btn-primary">返回首页</a>
            </div>
        </div>
    </div>
</div>

<!-- 初始化LayUI + 下拉菜单JS -->
<script>
    layui.use('element', function(){
        var element = layui.element;
    });

    // 下拉菜单
    var userBtn=document.getElementById('userBtn');
    var logoutMenu=document.getElementById('logoutMenu');
    userBtn.onclick=function(e){
        e.stopPropagation();
        logoutMenu.style.display=logoutMenu.style.display==='block'?'none':'block';
    }
    document.onclick=function(){
        logoutMenu.style.display='none';
    }
</script>
</body>
</html>