FROM nginx:1.27-alpine

# 不在构建期 apk install，避免 Alpine CDN/SSL 导致 build 失败
RUN mkdir -p /usr/share/nginx/html/secure

COPY index.html /usr/share/nginx/html/index.html
COPY flag.txt /usr/share/nginx/html/secure/flag.txt
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
