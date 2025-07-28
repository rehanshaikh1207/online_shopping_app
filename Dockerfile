# getting Base image for nodejs

FROM node:18-alpine AS builder

# making a working directory to keep my essential code

WORKDIR /app

# copy the pakages for the app to install and run 

COPY package*.json ./ 

# install pakages 

RUN npm ci

# copy the files required 

COPY . .

# run the all the remaining files

RUN npm run build


# stage 2 to run the application in production through nginx

FROM nginx:alpine

# copy the files that are installed in stage one

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# expose port 80 to run the application on nginx
EXPOSE 80

# serve the application
CMD ["nginx", "-g", "daemon off;"]

