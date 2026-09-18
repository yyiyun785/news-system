<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Arrays" %>

<%
  request.setCharacterEncoding("UTF-8");

  // 获取数据
  String username = request.getParameter("username");
  String password = request.getParameter("password");
  String gender = request.getParameter("gender");
  String occupation = request.getParameter("occupation");
  String introduction = request.getParameter("introduction");

  // 接收多选（关键！！！）
  String[] hobbies = request.getParameterValues("hobbies");
  String hobbyStr = "";
  if (hobbies != null) {
    hobbyStr = String.join(",", hobbies);
  }

  // 数据库连接
  String driver = "com.mysql.cj.jdbc.Driver";
  String url = "jdbc:mysql://localhost:3306/news_system?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
  String dbUser = "root";
  String dbPwd = "123456";

  try {
    Class.forName(driver);
    Connection conn = DriverManager.getConnection(url, dbUser, dbPwd);

    String sql = "INSERT INTO user(username,password,gender,occupation,hobbies,introduction) VALUES(?,?,?,?,?,?)";
    PreparedStatement pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, username);
    pstmt.setString(2, password);
    pstmt.setString(3, gender);
    pstmt.setString(4, occupation);
    pstmt.setString(5, hobbyStr);
    pstmt.setString(6, introduction);

    int rows = pstmt.executeUpdate();

    if (rows > 0) {
      response.sendRedirect("success.jsp");
    } else {
      response.sendRedirect("fail.jsp");
    }

    pstmt.close();
    conn.close();

  } catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("fail.jsp");
  }
%>