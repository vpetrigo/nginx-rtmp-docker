![](https://github.com/vpetrigo/nginx-rtmp-docker/workflows/Docker/badge.svg)

# Docker container with Nginx + RTMP

This repository contains Dockerfile to build [nginx][nginx] webserver with the following modules
included:

- [nginx-rtmp-module][nginx-rtmp]
- [set-misc-nginx-module][set-misc]
- [ngx_devel_kit][ndk]
- [ngx_http_substitutions_filter_module][ngx_http_subs]

That modules allows to set up secure RTMP/HLS/MPEG-DASH libe streaming and much more.

# Contribution

If you want to improve the Dockerfile or have some proposals, feel free to open a GitHub issue
to discuss whether it is worth spending time in implementing changes. Or open a Pull Request
if a critical issue is found in the project.

[nginx]: https://nginx.org/
[nginx-rtmp]: https://github.com/arut/nginx-rtmp-module
[set-misc]: https://github.com/openresty/set-misc-nginx-module
[ndk]: https://github.com/vision5/ngx_devel_kit
[ngx_http_subs]: https://github.com/yaoweibin/ngx_http_substitutions_filter_module
