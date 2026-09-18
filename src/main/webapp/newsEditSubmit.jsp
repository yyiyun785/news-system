<%--
  Created by IntelliJ IDEA.
  User: 33254
  Date: 2026/5/25
  Time: 15:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ page import="java.sql.*" %>
        <%
            request.setCharacterEncoding("UTF-8");
            String id=request.getParameter("id");
            String title=request.getParameter("title");
            String content=request.getParameter("content");

            String driver="com.mysql.cj.jdbc.Driver";
            String url="jdbc:mysql://localhost:3306/news_system?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
            String dbUser="root";
            String dbPwd="123456";

            Connection conn=null;
            PreparedStatement pstmt=null;

            try{
                Class.forName(driver);
                conn=DriverManager.getConnection(url,dbUser,dbPwd);
                String sql="update news set title=?,content=?,update_time=now() where id=?";
                pstmt=conn.prepareStatement(sql);
                pstmt.setString(1,title);
                pstmt.setString(2,content);
                pstmt.setString(3,id);
                pstmt.executeUpdate();
                response.sendRedirect("newsList.jsp");
            }catch(Exception e){
                e.printStackTrace();
                response.sendRedirect("newsList.jsp");
            }finally{
                try{pstmt.close();conn.close();}catch(Exception e){}
            }
        %></title>
</head>
<body>

</body>
</html>
