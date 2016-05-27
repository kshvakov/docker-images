# docker-images


```
docker run -d \
  --name postgres-ci-app-server \
  -e DB_HOST=172.16.9.131 \
  -e DB_USERNAME=postgres_ci \
  -e DB_PASSWORD=iAmAdiscoDancer \
   postgresci/app-server
```

```
docker run -d \
  --name postgres-ci-worker \
  -e DB_HOST=172.16.9.131 \
  -e DB_USERNAME=postgres_ci \
  -e DB_PASSWORD=iAmAdiscoDancer \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /tmp/postgres-ci/builds/:/tmp/postgres-ci/builds/ \
   postgresci/worker
```