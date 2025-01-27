# VM 부하 최적화를 위해 경량화 이미지 사용; 파이프라인에서 빌드 및 전달 받음
FROM nginx:1.26.2-alpine

# Nginx 템플릿 파일 복사
COPY conf.d/default.conf.template /etc/nginx/templates/default.conf.template

# 타임존 환경 변수 설정
ENV TZ Asia/Seoul

# 컨테이너 실행 시 환경변수 대체 및 Nginx 실행
ENTRYPOINT ["sh", "-c", "sed 's|${NGINX_SERVER_NAME}|'$NGINX_SERVER_NAME'|g; s|${CORS_ORIGIN_1}|'$CORS_ORIGIN_1'|g; s|${CORS_ORIGIN_2}|'$CORS_ORIGIN_2'|g; s|${CORS_ORIGIN_3}|'$CORS_ORIGIN_3'|g; s|${CIABATTA_CORE_PORT}|'$CIABATTA_CORE_PORT'|g' /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]