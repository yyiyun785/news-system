<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String username = (String)session.getAttribute("username");
    if(username == null){
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>发布新闻</title>
    <link rel="stylesheet" href="https://cdn.staticfile.org/layui/2.8.18/css/layui.css">
    <style>
        body{ background:#f5f7fa; }
        .layui-card{ margin:30px auto; width:800px; }
        .layui-btn-normal{ background:#409eff!important; }
    </style>
</head>
<body>
<div class="layui-card">
    <div class="layui-card-header">发布新闻</div>
    <div class="layui-card-body">
        <form action="doAddNews.jsp" method="post">
            <div class="layui-form-item">
                <label class="layui-form-label">新闻标题</label>
                <div class="layui-input-block">
                    <input type="text" name="title" class="layui-input" required>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">新闻内容</label>
                <div class="layui-input-block">
                    <textarea name="content" class="layui-textarea" rows="10" required></textarea>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn layui-btn-normal" type="submit">发布新闻</button>
                </div>
            </div>
        </form>
    </div>
</div>
</body>
</html>