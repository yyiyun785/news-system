<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
  // 权限验证
  String username = (String) session.getAttribute("username");
  String role = (String) session.getAttribute("role");
  if(username == null){
    response.sendRedirect("login.jsp");
    return;
  }

  // 数据库连接信息
  String driver = "com.mysql.cj.jdbc.Driver";
  String url = "jdbc:mysql://localhost:3306/news_system?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
  String dbUser = "root";
  String dbPwd = "123456";
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>新闻发布系统</title>
  <link rel="stylesheet" href="https://cdn.staticfile.org/layui/2.8.18/css/layui.css">
  <script src="https://cdn.staticfile.org/layui/2.8.18/layui.js"></script>
  <style>
    /* 顶部导航栏 */
    .layui-header{
      background:#409eff!important;
      height:60px;
      line-height:60px;
      position:relative!important;
      z-index:1000;
    }
    .top-title{
      color:#fff;
      font-size:18px;
      padding-left:20px;
      float:left;
    }

    /* 右上角用户下拉菜单 */
    .user-dropdown{
      float:right;
      margin-right:20px;
      position:relative;
      color:#fff;
      font-size:16px;
      cursor:pointer;
      line-height:60px!important;
    }
    .user-dropdown .welcome-text{
      color:#000!important; /* 欢迎两个字黑色 */
    }
    .dropdown-menu{
      display:none;
      position:absolute;
      top:60px!important;
      right:0;
      background:#000!important; /* 下拉菜单黑色背景 */
      border:none;
      box-shadow:0 2px 12px rgba(0,0,0,0.2);
      width:150px;
      z-index:9999;
    }
    .dropdown-menu a{
      display:block;
      padding:12px 20px;
      color:#fff!important; /* 下拉菜单文字白色 */
      text-decoration:none;
      font-size:14px;
      line-height:20px!important;
    }
    .dropdown-menu a:hover{
      background:#333!important; /* 悬停深灰色 */
      color:#fff!important;
    }

    /* 左侧侧边栏 */
    .layui-side{
      background:#f0f7ff!important;
      border-right:1px solid #d9e8ff;
    }
    .layui-nav-tree{
      background:#f0f7ff!important;
    }
    .layui-nav-tree .layui-nav-item a{
      color:#333!important;
      height:45px;
      line-height:45px;
    }
    .layui-nav-tree .layui-nav-item a:hover{
      background:#e0edff!important;
      color:#409eff!important;
    }
    .layui-nav-tree .layui-this>a{
      background:#409eff!important;
      color:#fff!important;
    }
    .layui-nav-tree .layui-nav-child dd a{
      background:#f8fbff!important;
    }
    .layui-nav-tree .layui-nav-child dd.layui-this a{
      background:#409eff!important;
      color:#fff!important;
    }

    /* 主体内容区 */
    .layui-body{
      background:#f5f7fa!important;
      padding:20px;
    }

    /* 统计卡片样式 */
    .stat-card h2{
      font-weight:bold;
      margin-bottom:8px;
    }
    .stat-card p{
      color:#666;
      font-size:14px;
    }
  </style>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
  <!-- 顶部导航栏 -->
  <div class="layui-header">
    <div class="top-title">新闻发布系统</div>
    <div class="user-dropdown" id="userDropdown">
      <span class="welcome-text">欢迎</span> <%=username%> ▼
      <div class="dropdown-menu" id="dropdownMenu">
        <a href="logout.jsp">退出登录</a>
      </div>
    </div>
  </div>

  <!-- 左侧菜单（根据角色动态显示） -->
  <div class="layui-side">
    <div class="layui-side-scroll">
      <ul class="layui-nav layui-nav-tree" lay-filter="sideNav">
        <li class="layui-nav-item layui-this"><a href="home.jsp">首页</a></li>
        <li class="layui-nav-item"><a href="newsAdd.jsp">发布新闻</a></li>
        <li class="layui-nav-item"><a href="newsList.jsp">我的新闻</a></li>

        <%-- 只有管理员才显示这两个菜单 --%>
        <% if("admin".equals(role)){ %>
        <li class="layui-nav-item"><a href="adminNewsList.jsp">新闻管理</a></li>
        <li class="layui-nav-item"><a href="userList.jsp">用户管理</a></li>
        <% } %>

        <li class="layui-nav-item">
          <a href="javascript:;">个人中心</a>
          <dl class="layui-nav-child">
            <dd><a href="viewInfo.jsp">查看信息</a></dd>
            <dd><a href="updateUser.jsp">修改信息</a></dd>
            <dd><a href="updatePwd.jsp">修改密码</a></dd>
          </dl>
        </li>
      </ul>
    </div>
  </div>

  <!-- 主体内容：管理员首页（数据统计+最新新闻） -->
  <div class="layui-body">
    <%-- 管理员专属统计面板 --%>
    <% if("admin".equals(role)){ %>
    <div class="layui-row layui-col-space15" style="margin-bottom:20px;">
      <div class="layui-col-md3">
        <div class="layui-card stat-card">
          <div class="layui-card-body" style="text-align:center; padding:25px 15px;">
            <h2 style="color:#409eff; font-size:36px;">
              <%
                int totalNews = 0;
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                  Class.forName(driver);
                  conn = DriverManager.getConnection(url, dbUser, dbPwd);
                  String sql = "SELECT COUNT(*) FROM news";
                  pstmt = conn.prepareStatement(sql);
                  rs = pstmt.executeQuery();
                  if(rs.next()) totalNews = rs.getInt(1);
                } catch (Exception e) { e.printStackTrace();
                } finally {
                  try { if (rs != null) rs.close(); } catch (Exception e) {}
                  try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
                  try { if (conn != null) conn.close(); } catch (Exception e) {}
                }
              %>
              <%=totalNews%>
            </h2>
            <p>总新闻数</p>
          </div>
        </div>
      </div>
      <div class="layui-col-md3">
        <div class="layui-card stat-card">
          <div class="layui-card-body" style="text-align:center; padding:25px 15px;">
            <h2 style="color:#67c23a; font-size:36px;">
              <%
                int totalUser = 0;
                Connection conn2 = null;
                PreparedStatement pstmt2 = null;
                ResultSet rs2 = null;
                try {
                  Class.forName(driver);
                  conn2 = DriverManager.getConnection(url, dbUser, dbPwd);
                  String sql = "SELECT COUNT(*) FROM user WHERE role='user'";
                  pstmt2 = conn2.prepareStatement(sql);
                  rs2 = pstmt2.executeQuery();
                  if(rs2.next()) totalUser = rs2.getInt(1);
                } catch (Exception e) { e.printStackTrace();
                } finally {
                  try { if (rs2 != null) rs2.close(); } catch (Exception e) {}
                  try { if (pstmt2 != null) pstmt2.close(); } catch (Exception e) {}
                  try { if (conn2 != null) conn2.close(); } catch (Exception e) {}
                }
              %>
              <%=totalUser%>
            </h2>
            <p>注册用户数</p>
          </div>
        </div>
      </div>
      <div class="layui-col-md3">
        <div class="layui-card stat-card">
          <div class="layui-card-body" style="text-align:center; padding:25px 15px;">
            <h2 style="color:#e6a23c; font-size:36px;">
              <%
                int todayNews = 0;
                Connection conn3 = null;
                PreparedStatement pstmt3 = null;
                ResultSet rs3 = null;
                try {
                  Class.forName(driver);
                  conn3 = DriverManager.getConnection(url, dbUser, dbPwd);
                  String sql = "SELECT COUNT(*) FROM news WHERE DATE(create_time)=CURDATE()";
                  pstmt3 = conn3.prepareStatement(sql);
                  rs3 = pstmt3.executeQuery();
                  if(rs3.next()) todayNews = rs3.getInt(1);
                } catch (Exception e) { e.printStackTrace();
                } finally {
                  try { if (rs3 != null) rs3.close(); } catch (Exception e) {}
                  try { if (pstmt3 != null) pstmt3.close(); } catch (Exception e) {}
                  try { if (conn3 != null) conn3.close(); } catch (Exception e) {}
                }
              %>
              <%=todayNews%>
            </h2>
            <p>今日新增新闻</p>
          </div>
        </div>
      </div>
      <div class="layui-col-md3">
        <div class="layui-card stat-card">
          <div class="layui-card-body" style="text-align:center; padding:25px 15px;">
            <h2 style="color:#f56c6c; font-size:36px;">
              <%
                int todayUser = 0;
                Connection conn4 = null;
                PreparedStatement pstmt4 = null;
                ResultSet rs4 = null;
                try {
                  Class.forName(driver);
                  conn4 = DriverManager.getConnection(url, dbUser, dbPwd);
                  String sql = "SELECT COUNT(*) FROM user WHERE DATE(reg_time)=CURDATE() AND role='user'";
                  pstmt4 = conn4.prepareStatement(sql);
                  rs4 = pstmt4.executeQuery();
                  if(rs4.next()) todayUser = rs4.getInt(1);
                } catch (Exception e) { e.printStackTrace();
                } finally {
                  try { if (rs4 != null) rs4.close(); } catch (Exception e) {}
                  try { if (pstmt4 != null) pstmt4.close(); } catch (Exception e) {}
                  try { if (conn4 != null) conn4.close(); } catch (Exception e) {}
                }
              %>
              <%=todayUser%>
            </h2>
            <p>今日新增用户</p>
          </div>
        </div>
      </div>
    </div>
    <% } %>

    <!-- 新闻列表 -->
    <div class="layui-card">
      <div class="layui-card-header">
        <% if("admin".equals(role)){ %>
        最新发布新闻（最近10条）
        <% } else { %>
        全部新闻
        <% } %>
      </div>
      <div class="layui-card-body">
        <table class="layui-table">
          <thead>
          <tr>
            <th>新闻标题</th>
            <th>发布作者</th>
            <th>发布时间</th>
            <th>操作</th>
          </tr>
          </thead>
          <tbody>
          <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
              Class.forName(driver);
              conn = DriverManager.getConnection(url, dbUser, dbPwd);
              // 管理员显示最近10条，普通用户显示全部
              String sql = "SELECT * FROM news ORDER BY create_time DESC";
              if("admin".equals(role)) sql += " LIMIT 10";
              pstmt = conn.prepareStatement(sql);
              rs = pstmt.executeQuery();
              while (rs.next()) {
                int id = rs.getInt("id");
                String title = rs.getString("title");
                String author = rs.getString("author");
                String time = rs.getString("create_time");
          %>
          <tr>
            <td><%=title%></td>
            <td><%=author%></td>
            <td><%=time%></td>
            <td>
              <a href="newsDetail.jsp?id=<%=id%>" class="layui-btn layui-btn-xs layui-btn-normal">查看详情</a>
              <% if("admin".equals(role)){ %>
              <a href="newsEdit.jsp?id=<%=id%>" class="layui-btn layui-btn-xs layui-btn-warm">编辑</a>
              <a href="adminNewsList.jsp?delId=<%=id%>" class="layui-btn layui-btn-xs layui-btn-danger" onclick="return confirm('确定要删除这条新闻吗？删除后不可恢复！');">删除</a>
              <% } %>
            </td>
          </tr>
          <%
              }
            } catch (Exception e) {
              e.printStackTrace();
            } finally {
              try { if (rs != null) rs.close(); } catch (Exception e) {}
              try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
              try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
          %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<script>
  layui.use('element', function(){
    var element = layui.element;
    element.init();
  });

  // 下拉菜单显示/隐藏
  var userDropdown = document.getElementById('userDropdown');
  var dropdownMenu = document.getElementById('dropdownMenu');

  userDropdown.onclick = function(e){
    e.stopPropagation();
    dropdownMenu.style.display = dropdownMenu.style.display === 'block' ? 'none' : 'block';
  }

  // 点击页面其他地方关闭下拉菜单
  document.onclick = function(){
    dropdownMenu.style.display = 'none';
  }
</script>
</body>
</html>                 