package com.servlet;

import com.dao.UserDao;
import com.pojo.User;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 登录控制器（Servlet）
 * 接收登录表单提交的用户名和密码，调用 UserDao 校验，
 * 成功则把用户信息存入 Session 并跳转到首页，失败则弹窗提示。
 */
public class LoginServlet extends HttpServlet {

    /** GET 请求也交给 doPost 处理（兼容地址栏直接访问） */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    /** 处理登录请求 */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 设置编码（必须放在读取参数之前，否则中文会乱码）
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 2. 获取表单提交的用户名和密码
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 3. 调用 DAO 层查询数据库
        UserDao userDao = new UserDao();
        User user = userDao.login(username, password);

        if (user != null) {
            // 4. 登录成功：把用户对象存入 Session，方便后续页面判断登录状态
            HttpSession session = request.getSession();
            session.setAttribute("loginUser", user);
            // 5. 重定向到首页（用重定向避免刷新重复提交）
            response.sendRedirect("home.jsp");
        } else {
            // 6. 登录失败：弹窗提示并跳回登录页
            response.getWriter().write("<script>alert('用户名或密码错误！');location.href='login.jsp'</script>");
        }
    }
}
