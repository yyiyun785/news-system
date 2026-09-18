package com.dao;

import com.pojo.User;
import com.utll.jbuutil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * 用户数据访问层（DAO）
 * 负责 user 表的操作，提供登录（login）和注册（register）两个核心方法。
 */
public class UserDao {

    /**
     * 登录方法：根据用户名和密码查询用户
     * @param username 用户名
     * @param password 密码
     * @return 查询到的 User 对象；查不到（账号密码错误）时返回 null
     */
    public User login(String username, String password) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            // 1. 获取数据库连接
            conn = jbuutil.getConnection();
            if (conn == null) {
                System.out.println("数据库连接失败！");
                return null;
            }
            // 2. 编写 SQL 查询语句（? 是占位符，防止 SQL 注入）
            String sql = "SELECT * FROM user WHERE username=? AND password=?";
            pstmt = conn.prepareStatement(sql);
            // 3. 给占位符赋值
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            // 4. 执行查询
            rs = pstmt.executeQuery();
            // 5. 如果有结果，把数据封装成 User 对象返回
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setGender(rs.getString("gender"));
                user.setOccupation(rs.getString("occupation"));
                user.setHobbies(rs.getString("hobbies"));
                user.setIntroduction(rs.getString("introduction"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // 6. 无论成功失败，都要关闭资源，防止连接泄漏
            jbuutil.close(conn, pstmt, rs);
        }
        return null;
    }

    /**
     * 注册方法：向 user 表插入一条新用户记录
     * @param user 封装好的用户对象
     * @return 受影响的行数（>0 表示插入成功）
     */
    public int register(User user) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int rows = 0;
        try {
            conn = jbuutil.getConnection();
            // 插入语句，字段必须和数据库表的字段一一对应
            String sql = "INSERT INTO user(username,password,role,gender,occupation,hobbies,introduction) VALUES (?,?,?,?,?,?,?)";
            pstmt = conn.prepareStatement(sql);
            // 依次给占位符赋值
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getRole());
            pstmt.setString(4, user.getGender());
            pstmt.setString(5, user.getOccupation());
            pstmt.setString(6, user.getHobbies());
            pstmt.setString(7, user.getIntroduction());
            // 执行插入，返回受影响行数
            rows = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            jbuutil.close(conn, pstmt, null);
        }
        return rows;
    }
}
