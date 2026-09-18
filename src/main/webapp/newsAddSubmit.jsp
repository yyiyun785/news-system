<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
  request.setCharacterEncoding("UTF-8");
  String username=(String)session.getAttribute("username");
  if(username==null){response.sendRedirect("login.jsp");return;}

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
    String sql="insert into news(title,content,author) values(?,?,?)";
    pstmt=conn.prepareStatement(sql);
    pstmt.setString(1,title);
    pstmt.setString(2,content);
    pstmt.setString(3,username);
    pstmt.executeUpdate();
    response.sendRedirect("newsList.jsp");
  }catch(Exception e){
    e.printStackTrace();
    response.sendRedirect("newsAdd.jsp");
  }finally{
    try{pstmt.close();conn.close();}catch(Exception e){}
  }
%>