<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
  // 权限验证：必须登录才能发布新闻
  String username = (String) session.getAttribute("username");
  if(username == null){
    out.println("<script>alert('请先登录！');location.href='login.jsp';</script>");
    return;
  }

  // 设置请求编码，解决中文乱码
  request.setCharacterEncoding("UTF-8");

  // 接收表单数据
  String title = request.getParameter("title");
  String content = request.getParameter("content");

  // 数据验证
  if(title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()){
    out.println("<script>alert('标题和内容不能为空！');history.back();</script>");
    return;
  }

  // 数据库连接信息
  String driver = "com.mysql.cj.jdbc.Driver";
  String url = "jdbc:mysql://localhost:3306/news_system?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
  String dbUser = "root";
  String dbPwd = "123456";

  Connection conn = null;
  PreparedStatement pstmt = null;

  try {
    // 加载驱动并建立连接
    Class.forName(driver);
    conn = DriverManager.getConnection(url, dbUser, dbPwd);

    // 插入新闻数据
    String sql = "INSERT INTO news (title, content, author, create_time) VALUES (?, ?, ?, NOW())";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, title);
    pstmt.setString(2, content);
    pstmt.setString(3, username);

    // 执行插入
    int rows = pstmt.executeUpdate();
    if(rows > 0){
      out.println("<script>alert('新闻发布成功！');location.href='newsList.jsp';</script>");
    }else{
      out.println("<script>alert('新闻发布失败，请重试！');history.back();</script>");
    }
  } catch (Exception e) {
    e.printStackTrace();
    out.println("<script>alert('系统错误，发布失败：" + e.getMessage() + "');history.back();</script>");
  } finally {
    // 关闭资源
    try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
    try { if (conn != null) conn.close(); } catch (Exception e) {}
  }
%>