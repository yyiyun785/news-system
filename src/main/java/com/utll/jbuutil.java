package com.utll;

import java.sql.*;

/**
 * 数据库工具类
 * 负责：1) 加载 MySQL 驱动；2) 获取数据库连接；3) 关闭连接资源。
 * 全项目通过此类统一访问数据库，方便维护。
 */
public class jbuutil {
    // 数据库连接地址（news_system 是数据库名）
    private static final String URL = "jdbc:mysql://localhost:3306/news_system?useUnicode=true&characterEncoding=utf-8&serverTimezone=UTC";
    // 数据库用户名
    private static final String USER = "root";
    // 数据库密码
    private static final String PASSWORD = "123456";

    // 静态代码块：类加载时执行一次，用于注册 MySQL 驱动
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取数据库连接
     * @return Connection 对象；连接失败时返回 null
     */
    public static Connection getConnection() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return conn;
    }

    /**
     * 关闭数据库资源（连接、预编译语句、结果集）
     * @param conn  数据库连接
     * @param pstmt 预编译语句
     * @param rs    结果集
     */
    public static void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** 重载的关闭方法（没有结果集时使用） */
    public static void close(Connection conn, PreparedStatement pstmt) {
        close(conn, pstmt, null);
    }
}
