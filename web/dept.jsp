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
    <title>科室详情 - 挂号系统（增强版）</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: #f5f7fa; color: #333; font-family: "Microsoft YaHei", sans-serif; padding: 20px; }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.1);
        }
        .back { margin-bottom: 20px; }
        .back a {
            color: #2f5496;
            text-decoration: none;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
        }
        .back a::before {
            content: "←";
            margin-right: 5px;
        }
        .back a:hover {
            text-decoration: underline;
        }
        .dept-title {
            color: #2f5496;
            font-size: 24px;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e8f0fe;
        }
        .dept-desc {
            color: #666;
            line-height: 1.6;
            margin-bottom: 30px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 4px;
        }
        .doctor-list { margin: 20px 0; }
        .doctor-item {
            padding: 20px;
            border: 1px solid #e5e5e5;
            border-radius: 6px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }
        .doctor-item:hover {
            border-color: #2f5496;
            box-shadow: 0 2px 8px rgba(47,84,150,0.1);
        }
        .doctor-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .doctor-item h4 {
            color: #333;
            font-size: 17px;
            display: flex;
            align-items: center;
        }
        .doctor-item h4 .level {
            font-size: 12px;
            color: #fff;
            background-color: #ff7f50;
            padding: 2px 8px;
            border-radius: 10px;
            margin-left: 10px;
        }
        .doctor-score {
            color: #ffc107;
            font-size: 14px;
        }
        .doctor-item p {
            color: #666;
            font-size: 13px;
            line-height: 1.6;
            margin-bottom: 8px;
        }
        .doctor-item .time {
            color: #2f5496;
            font-weight: 500;
        }
        .doctor-item .source-status {
            display: inline-block;
            padding: 3px 10px;
            background-color: #d4edda;
            color: #155724;
            font-size: 12px;
            border-radius: 10px;
            margin-left: 10px;
        }
        .register-btn {
            display: inline-block;
            margin-top: 12px;
            padding: 10px 25px;
            background: #2f5496;
            color: #fff;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        .register-btn:hover {
            background: #234680;
        }
        .dept-notice {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px dashed #e5e5e5;
        }
        .dept-notice h5 {
            color: #2f5496;
            font-size: 16px;
            margin-bottom: 10px;
        }
        .dept-notice ul {
            padding-left: 20px;
            color: #666;
            font-size: 13px;
            line-height: 1.8;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="back">
            <a href="index.jsp">返回首页</a>
        </div>

        <%
            String deptName = request.getParameter("deptName");
            if (deptName == null || deptName.trim().isEmpty()) {
                deptName = "未知科室";
            }
            // 查询科室详情
            String deptDesc = "";
            String deptTag = "";
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                conn = DBUtil.getConnection();
                String sql = "SELECT dept_desc, dept_tag FROM dept_info WHERE dept_name = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, deptName);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    deptDesc = rs.getString("dept_desc");
                    deptTag = rs.getString("dept_tag");
                } else {
                    deptDesc = deptName + "是医院的核心专科之一，拥有专业的医疗团队和先进的诊疗设备，为患者提供优质、高效、个性化的医疗服务。";
                    deptTag = "未知分类";
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                DBUtil.close(conn, pstmt, rs);
            }
        %>

        <div class="dept-title">
            <%= deptName %>
        </div>
        <div class="dept-desc">
            <%= deptDesc %>
        </div>

        <div class="title" style="border: none; margin-bottom: 20px;">
            <span style="font-size: 18px; color: #333;">坐诊医生列表</span>
        </div>
        <div class="doctor-list">
            <div class="doctor-item">
                <div class="doctor-header">
                    <h4>张医生 <span class="level">主任医师</span></h4>
                    <div class="doctor-score">★★★★★ 4.9分</div>
                </div>
                <p>擅长：<%= deptName %> 常见疾病、疑难杂症诊疗，临床经验丰富，累计接诊患者超10万人次。</p>
                <p class="time">坐诊时间：周一至周五 上午 8:00-12:00 <span class="source-status">号源充足</span></p>
                <a href="register.jsp?deptName=<%= deptName %>&doctorName=张医生" class="register-btn">预约该医生</a>
            </div>
            <div class="doctor-item">
                <div class="doctor-header">
                    <h4>李医生 <span class="level">副主任医师</span></h4>
                    <div class="doctor-score">★★★★ 4.7分</div>
                </div>
                <p>擅长：<%= deptName %> 微创手术、慢性病管理，专注于精准诊疗，术后恢复效果显著。</p>
                <p class="time">坐诊时间：周一至周六 下午 14:00-18:00 <span class="source-status">剩余5个号</span></p>
                <a href="register.jsp?deptName=<%= deptName %>&doctorName=李医生" class="register-btn">预约该医生</a>
            </div>
        </div>

        <div class="dept-notice">
            <h5><%= deptName %>就诊须知</h5>
            <ul>
                <li>就诊时请携带患者身份证、医保卡及既往病历资料（如有）；</li>
                <li>按预约时间提前30分钟到科室分诊台报到，逾期未到将视为自动放弃；</li>
                <li>就诊过程中请遵守医院秩序，保持安静，尊重医护人员；</li>
                <li>如需开具处方或检查单，请按指引到对应窗口缴费办理。</li>
            </ul>
        </div>
    </div>
</body>
</html>