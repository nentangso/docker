# Pentaho Data Integration: Carte cluster

Docker image: Pentaho data integration includes drivers: mysql and plugins: AMQP

Docker Hub [https://hub.docker.com/r/nentangso/pentaho-kettle-carte](https://hub.docker.com/r/nentangso/pentaho-kettle-carte)

Docker pull

```sh
docker pull nentangso/pentaho-kettle-carte
```

Build fresh image

```sh
# build base image
docker build -f Dockerfile -t kettle --target kettle .
# build carte
docker build -f Dockerfile -t pentaho-kettle-carte .
# build pan
docker build -f Dockerfile -t pentaho-kettle-pan .
# build kitchen
docker build -f Dockerfile -t pentaho-kettle-kitchen .
```