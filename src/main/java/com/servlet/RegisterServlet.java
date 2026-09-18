package com.servlet;

import com.dao.UserDao;
import com.pojo.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 注册控制器（Servlet）
 * 接收注册表单提交的信息，做简单的非空校验后，封装成 User 对象，
 * 调用 UserDao 插入数据库，成功则跳转到登录页。
 */
public class RegisterServlet extends HttpServlet {

    /** 处理注册请求 */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 先设置编码，顺序绝对不能乱（否则中文参数乱码）
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 2. 获取表单参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String gender = request.getParameter("gender");
        String occupation = request.getParameter("occupation");
        // 爱好是多选复选框，用 getParameterValues 获取数组，再用逗号拼接
        String[] hobbyArray = request.getParameterValues("hobbies");
        String hobbies = hobbyArray != null ? String.join(",", hobbyArray) : "";
        String introduction = request.getParameter("introduction");

        // 3. 简单非空校验（用户名和密码不能为空）
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.getWriter().write("<script>alert('用户名和密码不能为空！');location.href='register.jsp'</script>");
            return;
        }

        // 4. 把表单数据封装成 User 对象
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setGender(gender);
        user.setOccupation(occupation);
        user.setHobbies(hobbies);
        user.setIntroduction(introduction);
        // 注册的用户默认是普通用户角色
        user.setRole("user");

        // 5. 调用 DAO 层插入数据库
        UserDao userDao = new UserDao();
        int rows = userDao.register(user);

        if (rows > 0) {
            // 6. 注册成功：跳转到登录页
            response.sendRedirect("login.jsp");
        } else {
            // 7. 注册失败：弹窗提示
            response.getWriter().write("<script>alert('注册失败！')</script>");
        }
    }
}
