# 医院挂号系统

Java Web 项目设计，用 Servlet + JSP + MySQL 做的医院挂号系统。

## 项目简介

一个简单的医院在线挂号平台，患者可以注册登录后按科室选医生、选时间段挂号，也能查看和取消挂号记录。医生端可以查看自己的患者记录和出诊科室。整体是 MVC 分层架构， Servlet 处理请求，JSP 做页面，MySQL 存数据。

## 技术栈

| 层 | 技术 |
| --- | --- |
| 后端 | Java Servlet |
| 前端 | JSP + HTML + CSS + JavaScript |
| 数据库 | MySQL |
| 部署 | Tomcat |
| 认证 | Session + Filter 登录校验 |

## 功能模块

### 患者端

- 用户注册、登录、退出
- 按科室浏览医生，选择时间段挂号
- 查看我的挂号记录
- 取消挂号订单
- 个人信息管理

### 医生端

- 查看自己的患者就诊记录
- 查看出诊科室列表
- 科室信息编辑

### 公共功能

- 登录校验过滤器（未登录不能访问内部页面）
- 字符编码过滤器（统一 UTF-8）
- 操作日志过滤器
- 医院介绍页、FAQ 页面

## 系统架构

```
浏览器 (JSP 页面)
    ↓
Filter 过滤器（编码 → 登录校验 → 日志）
    ↓
Servlet 控制器（接收请求、调用 Service）
    ↓
Service 业务层（挂号逻辑、费用计算）
    ↓
DAO 数据访问层（操作 MySQL）
```

## 数据库设计

主要数据表：

- **user** — 用户账号（患者、医生）
- **department** — 科室
- **doctor** — 医生信息
- **time_slot** — 出诊时间段
- **registration_record** — 挂号记录

## 实现方式

1. 把项目导入 IDEA（或者Eclipse）
2. 配好 Tomcat 和 MySQL
3. 在 MySQL 里建库建表，插入初始数据（科室、医生、时间段）
4. 修改 `DBUtil.java` 里的数据库连接配置
5. 把项目部署到 Tomcat，启动

## 目录结构

```
src/com/hospital/
├── dao/        数据库操作（BaseDAO + 各表 DAO）
├── model/      实体类（User、Doctor、Patient、RegistrationRecord...）
├── service/    业务逻辑（挂号、费用计算、用户管理）
├── servlet/    接口（登录、挂号、医生、患者...）
├── filter/     过滤器（登录校验、编码、日志）
└── util/       工具类（DB连接、日期、Session、字符串、校验）

web/
├── *.jsp       页面
├── *.css       样式
├── *.js        脚本
└── WEB-INF/
    └── web.xml  配置
```
