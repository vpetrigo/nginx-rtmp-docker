#!/bin/bash

docker run --rm -it -v `pwd`/nginx.conf:/etc/nginx/nginx.conf \
    -p 1935:1935 -p 80:80 nginx-rtmp
