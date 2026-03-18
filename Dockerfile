FROM nginx:1.27-alpine

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy site files
COPY index.html  /usr/share/nginx/html/index.html
COPY about.html  /usr/share/nginx/html/about.html
COPY style.css   /usr/share/nginx/html/style.css
COPY main.js     /usr/share/nginx/html/main.js
COPY logo.png    /usr/share/nginx/html/logo.png
COPY favicon.png /usr/share/nginx/html/favicon.png

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
