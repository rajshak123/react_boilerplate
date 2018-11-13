FROM mhart/alpine-node:8.11.3

RUN mkdir -p /app
COPY ./ /app

WORKDIR /app/

RUN yarn global add serve
CMD ["serve", "-l", "3000"]

EXPOSE 3000
