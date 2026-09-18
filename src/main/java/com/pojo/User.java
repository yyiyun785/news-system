package com.pojo;

/**
 * 用户实体类（POJO）
 * 对应数据库中的 user 表，用来封装和传递用户信息。
 * 每个字段都提供 getter / setter 方法，方便 JSP 和 DAO 层调用。
 */
public class User {
    private int id;              // 用户ID（主键，自增）
    private String username;     // 用户名（登录账号）
    private String password;     // 密码
    private String role;         // 角色：user=普通用户，admin=管理员
    private String gender;       // 性别
    private String occupation;   // 职业
    private String hobbies;      // 爱好
    private String introduction; // 个人简介

    // ============ 以下为各字段的 getter / setter ============

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getOccupation() {
        return occupation;
    }

    public void setOccupation(String occupation) {
        this.occupation = occupation;
    }

    public String getHobbies() {
        return hobbies;
    }

    public void setHobbies(String hobbies) {
        this.hobbies = hobbies;
    }

    public String getIntroduction() {
        return introduction;
    }

    public void setIntroduction(String introduction) {
        this.introduction = introduction;
    }

    /** 无参构造方法（创建空对象用） */
    public User() {
    }

    /**
     * 有参构造方法
     * @param username 用户名
     * @param password 密码
     * @param role     角色
     */
    public User(String username, String password, String role) {
        this.username = username;
        this.password = password;
        this.role = role;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
