<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>新闻发布系统-首页</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: "Microsoft YaHei", sans-serif;
    }
    body {
      background-color: #f5f5f5;
      display: flex;
      justify-content: center;
      align-items: flex-start;
      padding-top: 100px;
    }
    .container {
      width: 600px;
      padding: 40px;
      background-color: #ffffff;
      border: 2px solid #1677ff;
      border-radius: 8px;
      box-shadow: 0 2px 12px rgba(22, 119, 255, 0.1);
    }
    .container h1 {
      text-align: center;
      color: #1677ff;
      margin-bottom: 30px;
      font-weight: 500;
    }
    .tip {
      text-align: center;
      font-size: 16px;
      margin-bottom: 30px;
      color: #333333;
    }
    .tip a {
      color: #1677ff;
      text-decoration: underline;
      font-weight: 500;
    }
    .divider {
      border: none;
      border-top: 1px solid #e8e8e8;
      margin-bottom: 30px;
    }
    .news-section h3 {
      color: #333333;
      margin-bottom: 15px;
    }
    .news-section p {
      color: #666666;
    }
  </style>
</head>
<body>
<div class="container">
  <h1>欢迎来到新闻发布系统</h1>
  <p class="tip">您还未登录，请<a href="login.jsp">点击登录</a ></p >
  <hr class="divider">
  <div class="news-section">
    <h3>新闻列表</h3>
    <p>新闻内容将在这里显示</p >
  </div>
</div>
</body>
</html>