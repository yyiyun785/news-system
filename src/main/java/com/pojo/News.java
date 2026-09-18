package com.pojo;

import java.util.Date;

/**
 * 新闻实体类（POJO）
 * 对应数据库中的 news 表，用来封装和传递一条新闻的信息。
 */
public class News {
    private int id;             // 新闻ID（主键，自增）
    private String title;       // 新闻标题
    private String content;     // 新闻内容
    private String author;      // 作者
    private Date createTime;    // 发布时间

    /** 无参构造方法 */
    public News() {
    }

    /**
     * 有参构造方法（添加新闻时使用）
     * @param title   标题
     * @param content 内容
     * @param author  作者
     */
    public News(String title, String content, String author) {
        this.title = title;
        this.content = content;
        this.author = author;
    }

    // ============ 以下为各字段的 getter / setter ============

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}
