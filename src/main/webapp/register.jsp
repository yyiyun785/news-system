<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>用户注册</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .register-box {
            width: 400px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 8px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        .form-item {
            margin-bottom: 15px;
        }
        .form-item label {
            display: inline-block;
            width: 80px;
            text-align: right;
            margin-right: 10px;
            font-size: 14px;
        }
        .form-item input[type="text"],
        .form-item input[type="password"],
        .form-item select,
        .form-item textarea {
            width: 250px;
            padding: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .form-item textarea {
            height: 60px;
            resize: none;
        }
        .gender-group, .hobby-group {
            display: inline-block;
            font-size: 14px;
        }
        .gender-group label, .hobby-group label {
            width: auto;
            margin-right: 15px;
        }
        input[type="submit"] {
            width: 100%;
            padding: 8px;
            background-color: #4096ff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        input[type="submit"]:hover {
            background-color: #1677ff;
        }
        .links {
            text-align: center;
            margin-top: 15px;
            font-size: 14px;
        }
        .links a {
            color: #1677ff;
            text-decoration: none;
        }
        .links a:hover {
            text-decoration: underline;
        }
    </style>
    <script>
        // 密码一致性验证
        function checkPassword() {
            var pwd1 = document.getElementById("password").value;
            var pwd2 = document.getElementById("confirmPassword").value;
            if (pwd1 !== pwd2) {
                alert("两次输入的密码不一致！");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
<div class="register-box">
    <h2>用户注册</h2>
    <form action="submit.jsp" method="post" onsubmit="return checkPassword()">
        <div class="form-item">
            <label>用户名：</label>
            <input type="text" name="username" required>
        </div>
        <div class="form-item">
            <label>密码：</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div class="form-item">
            <label>确认密码：</label>
            <!-- 修复：加了 name -->
            <input type="password" id="confirmPassword" name="confirmPassword" required>
        </div>
        <div class="form-item">
            <label>性别：</label>
            <div class="gender-group">
                <input type="radio" name="gender" value="男" checked> 男
                <input type="radio" name="gender" value="女"> 女
            </div>
        </div>
        <div class="form-item">
            <label>职业：</label>
            <select name="occupation" required>
                <option value="">请选择职业</option>
                <option value="学生">学生</option>
                <option value="教师">教师</option>
                <option value="程序员">程序员</option>
                <option value="医生">医生</option>
                <option value="其他">其他</option>
            </select>
        </div>
        <div class="form-item">
            <div class="form-item">
                <label>兴趣爱好：</label>
                <div class="hobby-group">
                    <input type="checkbox" name="hobbies" value="音乐"> 音乐
                    <input type="checkbox" name="hobbies" value="阅读"> 阅读
                    <input type="checkbox" name="hobbies" value="旅游"> 旅游
                    <input type="checkbox" name="hobbies" value="打球"> 打球
                    <input type="checkbox" name="hobbies" value="看电影"> 看电影
                </div>
            </div>
            <div class="form-item">
                <label>个人说明：</label>
                <textarea name="introduction" placeholder="请输入内容"></textarea>
            </div>
        <input type="submit" value="立即注册">
    </form>
    <div class="links">
        已有账号？<a href="login.jsp">登录</a >
    </div>
</div>
</body>
</html>