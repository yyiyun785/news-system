<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    String id=request.getParameter("id");

    String driver="com.mysql.cj.jdbc.Driver";
    String url="jdbc:mysql://localhost:3306/news_system?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    String dbUser="root";
    String dbPwd="123456";

    String title="",content="",author="",time="";
    Connection conn=null;
    PreparedStatement pstmt=null;
    ResultSet rs=null;

    try{
        Class.forName(driver);
        conn=DriverManager.getConnection(url,dbUser,dbPwd);
        String sql="select * from news where id=?";
        pstmt=conn.prepareStatement(sql);
        pstmt.setString(1,id);
        rs=pstmt.executeQuery();
        if(rs.next()){
            title=rs.getString("title");
            content=rs.getString("content");
            author=rs.getString("author");
            time=rs.getString("create_time");
        }
    }catch(Exception e){e.printStackTrace();}
    finally{try{rs.close();pstmt.close();conn.close();}catch(Exception e){}}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%=title%></title>
    <link rel="stylesheet" href="https://cdn.staticfile.org/layui/2.8.18/css/layui.css">
</head>
<body style="padding:30px;background:#f5f7fa;">
<div class="layui-card">
    <div class="layui-card-header"><%=title%></div>
    <div class="layui-card-body">
        <p>作者：<%=author%></p>
        <p>时间：<%=time%></p>
        <hr>
        <div style="font-size:16px;line-height:1.8"><%=content%></div>
        <br>
        <a href="newsList.jsp" class="layui-btn layui-btn-primary">返回列表</a>
    </div>
</div>
</body>
</html>