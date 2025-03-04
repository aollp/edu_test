#!/bin/bash

# 1. 기존 도커 컨테이너 및 이미지 정리
echo "모든 도커 컨테이너를 중지하고 삭제합니다..."
docker stop $(docker ps -aq) 2>/dev/null || true
docker rm $(docker ps -aq) 2>/dev/null || true
docker system prune -af --volumes

# 2. 웹 페이지 디렉토리 생성 (이미 존재하면 건너뜀)
mkdir -p ./web-content

# 3. HTML 파일 생성
cat > ./web-content/index.html << 'EOF'
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>자동 배포 웹 페이지</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background-color: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 600px;
        }
        h1 {
            color: #333;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>자동 배포된 웹 페이지</h1>
        <p>이 페이지는 김밥집 할머니와 함께 배포하느라 힘들었지만 좋은 시간이었습니다다.</p>
        <p>배포 시간: $(date)</p>
        <p>현재 시간: <span id="current-time"></span></p>
    </div>

    <script>
        function updateTime() {
            document.getElementById('current-time').textContent = new Date().toLocaleString();
        }
        updateTime();
        setInterval(updateTime, 1000);
    </script>
</body>
</html>
EOF

# 4. Dockerfile 생성
cat > ./web-content/Dockerfile << 'EOF'
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
EOF

# 5. 도커 이미지 빌드 및 실행
cd ./web-content
docker build -t simple-web:latest .
docker run -d -p 80:80 --name web-container simple-web:latest

# 6. 완료 메시지 및 로그
echo "웹 서버가 배포되었습니다! ($(date))"
echo "배포 완료: $(date)" >> ./deploy.log