FROM nginx:alpine
COPY index.html /usr/share/nginx/html/

EXPOSE 80
COPY nginx.conf /etc/nginx/nginx.conf
ENTRYPOINT ["nginx", "-g", "daemon off;"]
