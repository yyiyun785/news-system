<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  // 权限拦截：非管理员禁止访问
  String username = (String) session.getAttribute("username");
  String role = (String) session.getAttribute("role");
  if (username == null || !"admin".equals(role)) {
    response.sendRedirect("login_admin.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>管理员后台</title>
  <link rel="stylesheet" href="https://cdn.staticfile.org/layui/2.8.18/css/layui.css">
  <script src="https://cdn.staticfile.org/layui/2.8.18/layui.js"></script>
  <style>
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
    .layui-body{
      background:#f5f7fa!important;
      padding:15px;
    }
  </style>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
  <div class="layui-header">
    <div class="top-title">新闻发布系统 - 管理员后台</div>
    <div style="float:right;margin-right:20px;color:#fff;">
      欢迎管理员：<%=username%>
      <a href="logout.jsp" style="color:#fff;margin-left:15px;">退出登录</a>
    </div>
  </div>

  <div class="layui-side">
    <div class="layui-side-scroll">
      <ul class="layui-nav layui-nav-tree" lay-filter="sideNav">
        <li class="layui-nav-item layui-this">
          <a href="admin_index.jsp">管理首页</a>
        </li>
        <li class="layui-nav-item">
          <a href="newsList.jsp">全量新闻管理</a>
        </li>
        <li class="layui-nav-item">
          <a href="userList.jsp">用户管理</a>
        </li>
      </ul>
    </div>
  </div>

  <div class="layui-body">
    <div class="layui-card">
      <div class="layui-card-header">管理员工作台</div>
      <div class="layui-card-body">
        <p style="font-size:16px;line-height:2;">
          您好，管理员！<br>
          您可以进行以下操作：<br>
          1. 查看、编辑、删除全站所有新闻<br>
          2. 管理系统所有注册用户<br>
        </p>
      </div>
    </div>
  </div>
</div>

<script>
  layui.use('element', function(){
    var element = layui.element;
    element.init();
  });
</script>
</body>
</html>