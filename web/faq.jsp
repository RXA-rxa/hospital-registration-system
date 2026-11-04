<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>常见问题 - 挂号系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: #f5f7fa; color: #333; font-family: "Microsoft YaHei", sans-serif; font-size: 14px; }
        .header {
            background: #2f5496; color: #fff; padding: 15px 0; text-align: center;
            font-size: 22px; font-weight: bold; box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        .container {
            width: 90%; max-width: 800px; margin: 30px auto; background: #fff;
            padding: 30px; border-radius: 8px; box-shadow: 0 2px 12px rgba(0,0,0,0.1);
        }
        .back { margin-bottom: 20px; }
        .back a {
            color: #2f5496; text-decoration: none; display: inline-flex; align-items: center;
        }
        .back a::before { content: "←"; margin-right: 5px; }
        .title {
            font-size: 20px; color: #2f5496; margin-bottom: 25px;
            padding-bottom: 10px; border-bottom: 2px solid #e8f0fe;
        }
        .faq-list {
            margin-bottom: 20px;
        }
        .faq-item {
            margin-bottom: 15px; border: 1px solid #e5e5e5;
            border-radius: 6px; overflow: hidden;
        }
        .faq-question {
            padding: 15px; background: #e8f0fe; color: #2f5496;
            font-weight: 500; cursor: pointer; display: flex;
            justify-content: space-between; align-items: center;
        }
        .faq-answer {
            padding: 15px; color: #666; line-height: 1.7;
            display: block; /* 默认展开，如需折叠可改为none，配合JS实现切换 */
        }
        .faq-question .icon {
            font-size: 16px; transition: all 0.3s ease;
        }
    </style>
</head>
<body>
    <div class="header">常见问题解答</div>
    <div class="container">
        <div class="back">
            <a href="index.jsp">返回首页</a>
        </div>

        <div class="title">挂号常见问题</div>

        <div class="faq-list">
            <div class="faq-item">
                <div class="faq-question">
                    <span>1. 如何进行网上挂号？</span>
                    <span class="icon">▼</span>
                </div>
                <div class="faq-answer">
                    步骤：① 进入本系统首页，点击“进入挂号系统（动态版）”；② 选择就诊科室；③ 选择坐诊医生；
                    ④ 填写患者姓名、身份证号、联系电话等个人信息；⑤ 选择预约日期，提交预约即可完成挂号。
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <span>2. 网上挂号支持哪些证件类型？</span>
                    <span class="icon">▼</span>
                </div>
                <div class="faq-answer">
                    目前网上挂号仅支持中华人民共和国居民身份证（18位），儿童可使用监护人身份证进行预约，
                    就诊时需携带儿童出生证明或户口本原件进行身份验证。
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <span>3. 最多可以预约几天内的号源？</span>
                    <span class="icon">▼</span>
                </div>
                <div class="faq-answer">
                    最多可预约7天内的号源，每日18:00开放次日号源，号源约满即止。建议您提前预约，避免号源紧张。
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <span>4. 如何取消预约挂号？</span>
                    <span class="icon">▼</span>
                </div>
                <div class="faq-answer">
                    步骤：① 进入“我的预约”页面；② 找到需要取消的预约记录；③ 点击“取消”按钮；
                    ④ 进入确认取消页面，点击“确认取消”即可完成操作。取消预约需提前24小时，逾期无法取消。
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <span>5. 预约成功后，就诊时需要携带哪些资料？</span>
                    <span class="icon">▼</span>
                </div>
                <div class="faq-answer">
                    需携带：① 患者本人身份证原件；② 预约编号（可打印预约单携带，或手机截图保存）；
                    ③ 既往病历资料、检查报告（如有）；④ 医保卡（如需医保结算）。
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">
                    <span>6. 医生停诊了怎么办？</span>
                    <span class="icon">▼</span>
                </div>
                <div class="faq-answer">
                    若预约医生临时停诊，医院将通过短信方式通知您，请保持手机畅通。您可选择：① 更换同科室其他医生；
                    ② 调整预约日期；③ 取消预约并全额退还挂号费用（如有）。
                </div>
            </div>
        </div>
    </div>
</body>
</html>