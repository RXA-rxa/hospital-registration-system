# 医院挂号系统

Java Web 课设，Servlet + JSP + MySQL 做的医院挂号系统。

## 技术栈

- 后端：Java Servlet
- 前端：JSP + HTML + CSS + JavaScript
- 数据库：MySQL
- 部署：Tomcat

## 功能

- 用户注册、登录、退出
- 按科室选医生，选时间段挂号
- 我的挂号记录、取消订单
- 医生端查看患者记录
- 登录校验、字符编码过滤器

## 怎么跑

1. 把项目导入 IDEA（Eclipse 也行）
2. 配好 Tomcat 和 MySQL
3. 导数据库表（自己建表：用户、科室、医生、时间段、挂号记录）
4. 把项目部署到 Tomcat，启动就行

## 目录结构

```
src/com/hospital/
├── dao/        数据库操作
├── model/      实体类
├── service/    业务逻辑
├── servlet/    接口
├── filter/     过滤器
└── util/       工具类
web/
├── *.jsp       页面
└── WEB-INF/    web.xml 配置
```
