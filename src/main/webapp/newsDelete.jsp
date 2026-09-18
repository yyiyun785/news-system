<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String id=request.getParameter("id");
    String driver="com.mysql.cj.jdbc.Driver";
    String url="jdbc:mysql://localhost:3306/news_system?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    String dbUser="root";
    String dbPwd="123456";

    Connection conn=null;
    PreparedStatement pstmt=null;

    try{
        Class.forName(driver);
        conn=DriverManager.getConnection(url,dbUser,dbPwd);
        String sql="delete from news where id=?";
        pstmt=conn.prepareStatement(sql);
        pstmt.setString(1,id);
        pstmt.executeUpdate();
    }catch(Exception e){e.printStackTrace();}
    finally{try{pstmt.close();conn.close();}catch(Exception e){}}
    response.sendRedirect("newsList.jsp");
%>