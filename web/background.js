// background.js

document.addEventListener('DOMContentLoaded', () => {
    const canvas = document.getElementById('background-canvas');
    const ctx = canvas.getContext('2d');

    // 设置Canvas尺寸为窗口大小
    function resizeCanvas() {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
    }
    resizeCanvas();
    window.addEventListener('resize', resizeCanvas);

    // --- 绘制太阳 ---
    function drawSun() {
        const sunX = canvas.width - 150;
        const sunY = 100;
        const sunRadius = 60;

        // 绘制渐变光晕
        const gradient = ctx.createRadialGradient(sunX, sunY, 0, sunX, sunY, sunRadius * 1.5);
        gradient.addColorStop(0, 'rgba(255, 255, 0, 0.8)');
        gradient.addColorStop(1, 'rgba(255, 255, 0, 0)');
        ctx.fillStyle = gradient;
        ctx.beginPath();
        ctx.arc(sunX, sunY, sunRadius * 1.5, 0, Math.PI * 2);
        ctx.fill();

        // 绘制太阳本体
        ctx.fillStyle = '#FFD700';
        ctx.beginPath();
        ctx.arc(sunX, sunY, sunRadius, 0, Math.PI * 2);
        ctx.fill();
    }

    // --- 云朵类 ---
    class Cloud {
        constructor(isDepartmentCloud = false, text = '') {
            this.x = Math.random() * canvas.width;
            this.y = Math.random() * canvas.height;
            this.size = Math.random() * 1.5 + 1; // 缩放比例
            this.speed = Math.random() * 0.2 + 0.1;
            this.isDepartmentCloud = isDepartmentCloud;
            this.text = text;
        }

        draw() {
            ctx.save();
            ctx.translate(this.x, this.y);
            ctx.scale(this.size, this.size);

            ctx.fillStyle = 'rgba(255, 255, 255, 0.8)';
            ctx.beginPath();
            ctx.arc(0, 0, 30, 0, Math.PI * 2);
            ctx.arc(40, -15, 25, 0, Math.PI * 2);
            ctx.arc(60, 10, 20, 0, Math.PI * 2);
            ctx.arc(30, 25, 22, 0, Math.PI * 2);
            ctx.arc(-20, 15, 20, 0, Math.PI * 2);
            ctx.closePath();
            ctx.fill();

            // 如果是科室云图，在云朵中间绘制文字
            if (this.isDepartmentCloud && this.text) {
                ctx.fillStyle = '#0d6efd';
                ctx.font = 'bold 16px Microsoft YaHei';
                ctx.textAlign = 'center';
                ctx.textBaseline = 'middle';
                ctx.fillText(this.text, 20, 5);
            }

            ctx.restore();
        }

        update() {
            this.x += this.speed;
            if (this.x > canvas.width + 100) {
                this.x = -100;
                this.y = Math.random() * canvas.height;
            }
        }
    }

    // --- 创建云朵实例 ---
    const clouds = [];
    const numClouds = 10;
    for (let i = 0; i < numClouds; i++) {
        clouds.push(new Cloud());
    }

    // --- 科室云图数据 (这些数据将来可以从数据库动态加载) ---
    const departments = [
        "内科", "外科", "妇产科", "儿科", "骨科",
        "神经科", "眼科", "口腔科", "皮肤科", "急诊科"
    ];
    const departmentClouds = [];
    const numDeptClouds = departments.length;
    for (let i = 0; i < numDeptClouds; i++) {
        departmentClouds.push(new Cloud(true, departments[i]));
    }

    // --- 动画循环 ---
    function animate() {
        // 清空画布
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        // 绘制天空渐变背景
        const skyGradient = ctx.createLinearGradient(0, 0, 0, canvas.height);
        skyGradient.addColorStop(0, '#B0E2FF');
        skyGradient.addColorStop(1, '#87CEEB');
        ctx.fillStyle = skyGradient;
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        drawSun();

        // 判断当前页面是否为main.jsp，以决定是否显示科室云图
        const isMainPage = window.location.pathname.endsWith('main.jsp');

        // 更新和绘制云朵
        clouds.forEach(cloud => {
            cloud.update();
            cloud.draw();
        });

        // 如果是main.jsp，则绘制科室云图
        if (isMainPage) {
            departmentClouds.forEach(cloud => {
                cloud.update();
                cloud.draw();
            });
        }

        requestAnimationFrame(animate);
    }

    // 启动动画
    animate();
});