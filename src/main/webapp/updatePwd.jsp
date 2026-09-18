<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String username = (String) session.getAttribute("username");
    if(username == null){
        response.sendRedirect("login.jsp");
        return;
    }
    String msg = "";
    if("post".equalsIgnoreCase(request.getMethod())){
        String oldPwd = request.getParameter("oldPwd");
        String newPwd = request.getParameter("newPwd");
        String rePwd = request.getParameter("rePwd");

        if(!newPwd.equals(rePwd)){
            msg = "两次新密码输入不一致";
        }else{
            String driver = "com.mysql.cj.jdbc.Driver";
            String url = "jdbc:mysql://localhost:3306/news_system?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
            String dbUser = "root";
            String dbPwd = "123456";
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try{
                Class.forName(driver);
                conn = DriverManager.getConnection(url,dbUser,dbPwd);
                String sql = "select password from user where username=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1,username);
                rs = pstmt.executeQuery();
                if(rs.next() && rs.getString("password").equals(oldPwd)){
                    String updateSql = "update user set password=? where username=?";
                    pstmt = conn.prepareStatement(updateSql);
                    pstmt.setString(1,newPwd);
                    pstmt.setString(2,username);
                    int rows = pstmt.executeUpdate();
                    if(rows>0){
                        msg = "密码修改成功";
                    }else{
                        msg = "修改失败";
                    }
                }else{
                    msg = "原密码错误";
                }
            }catch(Exception e){
                e.printStackTrace();
                msg = "数据库异常";
            }finally{
                if(rs!=null)rs.close();
                if(pstmt!=null)pstmt.close();
                if(conn!=null)conn.close();
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>修改密码</title>
    <link rel="stylesheet" href="https://cdn.staticfile.org/layui/2.8.18/css/layui.css">
    <script src="https://cdn.staticfile.org/layui/2.8.18/layui.js"></script>
    <style>
        .layui-header{background:#409eff!important;height:60px;line-height:60px;}
        .top-title{color:#fff;font-size:18px;padding-left:20px;}
        .layui-side,.layui-side-scroll,.layui-nav-tree,.layui-nav-item,.layui-nav-child{background:#f0f7ff!important;}
        .layui-side{border-right:1px solid #d9e8ff;}
        .layui-nav{list-style:none!important;padding-left:0!important;}
        .layui-nav-tree .layui-nav-item a{color:#333!important;height:45px;line-height:45px;text-decoration:none!important;}
        .layui-nav-tree .layui-nav-item a:hover{background:#e0edff!important;color:#409eff!important;}
        .layui-nav-tree .layui-nav-itemed>a{background:#d0e4ff!important;color:#409eff!important;font-weight:500;}
        .layui-nav-tree .layui-nav-child dd.layui-this a{background:#409eff!important;color:#fff!important;}
        .layui-body{background:#f5f7fa!important;padding:15px;}
        .form-box{width:400px;margin:30px auto;}
    </style>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <div class="layui-header">
        <div class="top-title">新闻发布系统</div>
        <div style="float:right;margin-right:20px;position:relative">
            <div id="userBtn" style="color:#000;line-height:60px;cursor:pointer">欢迎 <%=username%> ▼</div>
            <div id="logoutMenu" style="display:none;position:absolute;top:60px;right:0;background:#fff;border:1px solid #eee;width:120px">
                <a href="logout.jsp" style="display:block;padding:10px 15px;color:#000;text-decoration:none">退出登录</a>
            </div>
        </div>
    </div>
    <div class="layui-side">
        <div class="layui-side-scroll">
            <ul class="layui-nav layui-nav-tree" lay-filter="sideNav">
                <li class="layui-nav-item layui-nav-itemed">
                    <a href="javascript:;">个人信息</a>
                    <dl class="layui-nav-child">
                        <dd><a href="viewInfo.jsp">查看信息</a></dd>
                        <dd class="layui-this"><a href="updatePwd.jsp">修改密码</a></dd>
                        <dd><a href="updateUser.jsp">修改个人信息</a></dd>
                    </dl>
                </li>
                <li class="layui-nav-item"><a href="javascript:;">新闻发布信息</a></li>
            </ul>
        </div>
    </div>
    <div class="layui-body">
        <div class="layui-card">
            <div class="layui-card-header">修改密码</div>
            <div class="layui-card-body">
                <%if(!"".equals(msg)){%>
                <div class="layui-alert layui-alert-info"><%=msg%></div>
                <%}%>
                <form method="post" class="form-box">
                    <div class="layui-form-item">
                        <label class="layui-form-label">原密码</label>
                        <div class="layui-input-block">
                            <input type="password" name="oldPwd" required class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">新密码</label>
                        <div class="layui-input-block">
                            <input type="password" name="newPwd" required class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">确认新密码</label>
                        <div class="layui-input-block">
                            <input type="password" name="rePwd" required class="layui-input">
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block">
                            <button class="layui-btn layui-btn-normal">提交修改</button>
                            <a href="home.jsp" class="layui-btn layui-btn-primary">返回</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
    layui.use('element',function(){var e=layui.element;e.init();});
    var userBtn=document.getElementById('userBtn'),menu=document.getElementById('logoutMenu');
    userBtn.onclick=e=>{e.stopPropagation();menu.style.display=menu.style.display==='block'?'none':'block';};
    document.onclick=()=>menu.style.display='none';
</script>
</body>
</html>