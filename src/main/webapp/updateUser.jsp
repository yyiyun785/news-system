<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,java.util.Arrays" %>
<%
    request.setCharacterEncoding("UTF-8");
    String username = (String) session.getAttribute("username");
    if(username == null){
        response.sendRedirect("login.jsp");
        return;
    }
    String gender="",occupation="",hobbies="",intro="";
    String msg="";

    String driver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/你的数据库名?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    String dbUser = "root";
    String dbPwd = "你的数据库密码";

    Connection conn=null;PreparedStatement pstmt=null;ResultSet rs=null;
    try{
        Class.forName(driver);
        conn=DriverManager.getConnection(url,dbUser,dbPwd);
        String selSql="select gender,occupation,hobbies,introduction from user where username=?";
        pstmt=conn.prepareStatement(selSql);
        pstmt.setString(1,username);
        rs=pstmt.executeQuery();
        if(rs.next()){
            gender=rs.getString("gender");
            occupation=rs.getString("occupation");
            hobbies=rs.getString("hobbies");
            intro=rs.getString("introduction");
        }
        if("post".equalsIgnoreCase(request.getMethod())){
            String newGender=request.getParameter("gender");
            String newOcc=request.getParameter("occupation");
            String[] hbs=request.getParameterValues("hobbies");
            String newHobby=hbs!=null?String.join(",",hbs):"";
            String newIntro=request.getParameter("introduction");

            String upSql="update user set gender=?,occupation=?,hobbies=?,introduction=? where username=?";
            pstmt=conn.prepareStatement(upSql);
            pstmt.setString(1,newGender);
            pstmt.setString(2,newOcc);
            pstmt.setString(3,newHobby);
            pstmt.setString(4,newIntro);
            pstmt.setString(5,username);
            int row=pstmt.executeUpdate();
            msg=row>0?"信息修改成功":"修改失败";
        }
    }catch(Exception e){e.printStackTrace();msg="操作异常";}
    finally{if(rs!=null)rs.close();if(pstmt!=null)pstmt.close();if(conn!=null)conn.close();}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>修改个人信息</title>
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
        .form-box{width:500px;margin:20px auto;}
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
                        <dd><a href="updatePwd.jsp">修改密码</a></dd>
                        <dd class="layui-this"><a href="updateUser.jsp">修改个人信息</a></dd>
                    </dl>
                </li>
                <li class="layui-nav-item"><a href="javascript:;">新闻发布信息</a></li>
            </ul>
        </div>
    </div>
    <div class="layui-body">
        <div class="layui-card">
            <div class="layui-card-header">修改个人信息</div>
            <div class="layui-card-body">
                <%if(!"".equals(msg)){%>
                <div class="layui-alert layui-alert-info"><%=msg%></div>
                <%}%>
                <form method="post" class="form-box layui-form">
                    <div class="layui-form-item">
                        <label class="layui-form-label">性别</label>
                        <div class="layui-input-block">
                            <input type="radio" name="gender" value="男" <%="男".equals(gender)?"checked":""%>>男
                            <input type="radio" name="gender" value="女" <%="女".equals(gender)?"checked":""%>>女
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">职业</label>
                        <div class="layui-input-block">
                            <select name="occupation">
                                <option value="学生" <%="学生".equals(occupation)?"selected":""%>>学生</option>
                                <option value="教师" <%="教师".equals(occupation)?"selected":""%>>教师</option>
                                <option value="程序员" <%="程序员".equals(occupation)?"selected":""%>>程序员</option>
                                <option value="医生" <%="医生".equals(occupation)?"selected":""%>>医生</option>
                                <option value="其他" <%="其他".equals(occupation)?"selected":""%>>其他</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">兴趣爱好</label>
                        <div class="layui-input-block">
                            <%
                                String[] hbArr = hobbies.split(",");
                                boolean hasMusic=false,hasRead=false,hasTravel=false,hasBall=false,hasMovie=false;
                                for(String h:hbArr){
                                    if("音乐".equals(h))hasMusic=true;
                                    if("阅读".equals(h))hasRead=true;
                                    if("旅游".equals(h))hasTravel=true;
                                    if("打球".equals(h))hasBall=true;
                                    if("看电影".equals(h))hasMovie=true;
                                }
                            %>
                            <input type="checkbox" name="hobbies" value="音乐" <%=hasMusic?"checked":""%>>音乐
                            <input type="checkbox" name="hobbies" value="阅读" <%=hasRead?"checked":""%>>阅读
                            <input type="checkbox" name="hobbies" value="旅游" <%=hasTravel?"checked":""%>>旅游
                            <input type="checkbox" name="hobbies" value="打球" <%=hasBall?"checked":""%>>打球
                            <input type="checkbox" name="hobbies" value="看电影" <%=hasMovie?"checked":""%>>看电影
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">个人说明</label>
                        <div class="layui-input-block">
                            <textarea name="introduction" class="layui-textarea"><%=intro%></textarea>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <div class="layui-input-block">
                            <button class="layui-btn layui-btn-normal">保存修改</button>
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