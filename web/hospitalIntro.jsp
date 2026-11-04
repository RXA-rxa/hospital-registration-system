<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.util.DBUtil" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>医院介绍 - 挂号系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: #f5f7fa; color: #333; font-family: "Microsoft YaHei", sans-serif; font-size: 14px; }
        .header {
            background: #2f5496; color: #fff; padding: 15px 0; text-align: center;
            font-size: 22px; font-weight: bold; box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        .container {
            width: 90%; max-width: 1000px; margin: 30px auto; background: #fff;
            padding: 30px; border-radius: 8px; box-shadow: 0 2px 12px rgba(0,0,0,0.1);
        }
        .back { margin-bottom: 20px; }
        .back a {
            color: #2f5496; text-decoration: none; display: inline-flex; align-items: center;
        }
        .back a::before { content: "←"; margin-right: 5px; }
        .hospital-banner {
            width: 100%; height: 250px;
            background: url("https://img.yzcdn.cn/public_files/2017/08/21/6e9e9f0c911c4e94a0219c97a815773c.jpg") center center no-repeat;
            background-size: cover; border-radius: 8px; margin-bottom: 30px;
        }
        .title {
            font-size: 20px; color: #2f5496; margin-bottom: 15px;
            padding-bottom: 10px; border-bottom: 2px solid #e8f0fe;
        }
        .content {
            color: #666; line-height: 1.8; margin-bottom: 30px;
            text-indent: 2em;
        }
        .section {
            margin-bottom: 30px;
        }
        .section h5 {
            font-size: 16px; color: #333; margin-bottom: 15px;
        }
        .advantage-list {
            display: flex; flex-wrap: wrap; gap: 20px;
        }
        .advantage-item {
            width: calc(50% - 10px); background: #e8f0fe;
            padding: 15px; border-radius: 6px;
        }
        .advantage-item h6 {
            color: #2f5496; font-size: 14px; margin-bottom: 8px;
        }
        .advantage-item p {
            color: #666; font-size: 13px; line-height: 1.6;
        }
        .contact-info {
            background: #f8f9fa; padding: 20px; border-radius: 6px;
        }
        .contact-info p {
            margin-bottom: 10px; color: #666;
        }
        .contact-info span {
            color: #2f5496; font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="header">某某医院介绍</div>
    <div class="container">
        <div class="back">
            <a href="index.jsp">返回首页</a>
        </div>

        <div class="hospital-banner"></div>

        <%
            // 查询医院信息
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            String hospitalName = "";
            String hospitalDesc = "";
            String address = "";
            String servicePhone = "";
            String registPhone = "";
            String officialUrl = "";
            String trafficRoute = "";
            try {
                conn = DBUtil.getConnection();
                String sql = "SELECT * FROM hospital_info LIMIT 1";
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    hospitalName = rs.getString("hospital_name");
                    hospitalDesc = rs.getString("hospital_desc");
                    address = rs.getString("address");
                    servicePhone = rs.getString("service_phone");
                    registPhone = rs.getString("regist_phone");
                    officialUrl = rs.getString("official_url");
                    trafficRoute = rs.getString("traffic_route");
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                DBUtil.close(conn, pstmt, rs);
            }
        %>

        <div class="section">
            <div class="title"><%= hospitalName %></div>
            <div class="content">
                <%= hospitalDesc %>
            </div>
        </div>

        <div class="section">
            <div class="title">医院优势</div>
            <div class="advantage-list">
                <div class="advantage-item">
                    <h6>先进设备</h6>
                    <p>配备3.0T核磁共振、64排螺旋CT、医用直线加速器等一系列高端医疗设备，为精准诊疗提供保障。</p>
                </div>
                <div class="advantage-item">
                    <h6>优质服务</h6>
                    <p>推行"以患者为中心"的服务理念，开设一站式服务窗口、无假日门诊，提升患者就医体验。</p>
                </div>
                <div class="advantage-item">
                    <h6>科研实力</h6>
                    <p>承担多项国家级、省级科研项目，每年发表学术论文200余篇，多项科研成果获省级以上奖励。</p>
                </div>
                <div class="advantage-item">
                    <h6>教学培养</h6>
                    <p>作为多所医学院校的教学医院，每年培养大量医学人才，为区域医疗事业发展提供人才支撑。</p>
                </div>
            </div>
        </div>

        <div class="section">
            <div class="title">联系我们</div>
            <div class="contact-info">
                <p>医院地址：<span><%= address %></span></p>
                <p>咨询电话：<span><%= servicePhone %></span>（24小时服务）</p>
                <p>挂号电话：<span><%= registPhone %></span>（工作时间：8:00-18:00）</p>
                <p>官方网址：<span><%= officialUrl %></span></p>
                <p>交通路线：<span><%= trafficRoute %></span></p>
            </div>
        </div>
    </div>
</body>
</html>