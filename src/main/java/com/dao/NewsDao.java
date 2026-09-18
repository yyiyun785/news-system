package com.dao;

import com.pojo.News;
import com.utll.jbuutil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 新闻数据访问层（DAO）
 * 负责 news 表的操作，提供查询所有新闻（getAllNews）和添加新闻（addNews）两个方法。
 */
public class NewsDao {

    /**
     * 查询所有新闻，按发布时间倒序排列（最新的在最前面）
     * @return 新闻列表 List<News>
     */
    public List<News> getAllNews() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<News> newsList = new ArrayList<>();

        try {
            conn = jbuutil.getConnection();
            // 按创建时间倒序查询
            String sql = "SELECT * FROM news ORDER BY create_time DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            // 循环读取每一条新闻，封装成 News 对象加入列表
            while (rs.next()) {
                News news = new News();
                news.setId(rs.getInt("id"));
                news.setTitle(rs.getString("title"));
                news.setContent(rs.getString("content"));
                news.setAuthor(rs.getString("author"));
                news.setCreateTime(rs.getTimestamp("create_time"));
                newsList.add(news);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            jbuutil.close(conn, pstmt, rs);
        }
        return newsList;
    }

    /**
     * 添加一条新闻
     * @param news 封装好的新闻对象
     * @return true=成功，false=失败
     */
    public boolean addNews(News news) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        int result = 0;

        try {
            conn = jbuutil.getConnection();
            // 插入语句，create_time 由数据库默认值自动生成
            String sql = "INSERT INTO news (title, content, author) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, news.getTitle());
            pstmt.setString(2, news.getContent());
            pstmt.setString(3, news.getAuthor());
            // 执行插入，返回受影响行数
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            jbuutil.close(conn, pstmt);
        }
        return result > 0;
    }
}
