{{ $index := default "index.html" .INDEX -}}
{{ $path_prefix := default "" .PATH_PREFIX -}}
{{ $force_https := default "0" .FORCE_HTTPS -}}
{{ $basic_auth := default "0" .BASIC_AUTH -}}
{{ $remove_trailing_slash := default "0" .REMOVE_TRAILING_SLASH -}}
upstream gs {
    server                   storage.googleapis.com:443;
    keepalive                128;
}

server {
    listen       {{ .PORT | default "80" }};
    server_name  localhost;


    keepalive_timeout  65;

    resolver                   8.8.8.8 valid=300s ipv6=off;
    resolver_timeout           10s;

    gzip              on;
    gzip_disable      "msie6";
    gzip_comp_level   6;
    gzip_min_length   1100;
    gzip_buffers      16 8k;
    gzip_proxied      any;
    gzip_types
        text/plain
        text/css
        text/js
        text/xml
        text/javascript
        application/javascript
        application/x-javascript
        application/json
        application/xml
        application/xml+rss;

    server_tokens           off;
    recursive_error_pages   on;
    absolute_redirect       off;

    if ( $request_method !~ "GET|HEAD" ) {
        return 405;
    }

{{- if eq $force_https "1" }}
    if ( $real_scheme = "http" ) {
        return 301 https://$host$request_uri;
    }
{{ end }}

    location = / {
        rewrite ^ /{{ $index }} last;
    }

{{ if eq .ROUTING "react" }}
    location / {
        include "gcs.conf";

        {{- if eq $remove_trailing_slash "1" }}

        rewrite ^([^.]*[^/])$ $1/ permanent;
        {{ end }}

        {{- if eq $basic_auth "1" }}

        auth_basic              "{{ default .BASIC_AUTH_REALM "restricted" }}";
        auth_basic_user_file    /etc/nginx/auth.htpasswd;
        {{ end }}

        error_page 404 403 =200 /{{ $index }};
        proxy_pass https://gs/{{ .GCS_BUCKET }}{{ $path_prefix }}$uri;
    }
{{ else if eq .ROUTING "gatsby" }}
    location / {
        include "gcs.conf";

        rewrite ^([^.]*[^/])$ $1/ permanent;

        {{- if eq $basic_auth "1" }}

        auth_basic              "{{ default .BASIC_AUTH_REALM "restricted" }}";
        auth_basic_user_file    /etc/nginx/auth.htpasswd;
        {{ end }}

        error_page 404 403 =200 ${uri}{{ $index }};
        proxy_pass https://gs/{{ .GCS_BUCKET }}{{ $path_prefix }}$uri;
    }

    location ~ {{ regexQuoteMeta $index }}$ {
        include "gcs.conf";

        {{- if eq $basic_auth "1" }}

        auth_basic              "{{ default .BASIC_AUTH_REALM "restricted" }}";
        auth_basic_user_file    /etc/nginx/auth.htpasswd;
        {{ end }}

        error_page 404 403 =404 {{ .ERROR_404 | default "/404.html" }};
        proxy_pass https://gs/{{ .GCS_BUCKET }}{{ $path_prefix }}$uri;
    }
{{ else }}
    location / {
        include "gcs.conf";

        {{- if eq $remove_trailing_slash "1" }}

        rewrite ^([^.]*[^/])$ $1/ permanent;
        {{ end }}

        {{- if eq $basic_auth "1" }}

        auth_basic              "{{ default .BASIC_AUTH_REALM "restricted" }}";
        auth_basic_user_file    /etc/nginx/auth.htpasswd;
        {{ end }}

        error_page 404 403 =404 {{ .ERROR_404 | default "/404.html" }};
        proxy_pass https://gs/{{ .GCS_BUCKET }}{{ $path_prefix }}$uri;
    }
{{ end }}
}
