FROM mhart/alpine-node:8.11.3

RUN mkdir -p /app
COPY ./ /app

WORKDIR /app/build

RUN yarn global add serve
CMD ["serve", "-l", "3000"]

EXPOSE 3000