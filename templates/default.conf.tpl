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

    gzip on;

    server_tokens off;

    if ( $request_method !~ "GET|HEAD" ) {
        return 405;
    }

{{- if .FORCE_HTTPS }}
    if ( $real_scheme = "http" ) {
        return 301 https://$host$request_uri;
    }
{{ end }}

    location = / {
        rewrite ^ /{{ .INDEX | default "index.html" }} last;
    }

{{ if eq .ROUTING "react" }}
    location / {
        include "gcs.conf";

        error_page 404 403 =200 /{{ .INDEX | default "index.html" }};

        proxy_pass              https://gs/{{ .GCS_BUCKET }}{{ .PATH_PREFIX | default "" }}$uri;
    }
{{ else if eq .ROUTING "gatsby" }}
    location / {
        include "gcs.conf";

        rewrite ^([^.]*[^/])\$ \$1/ permanent;
        error_page 404 403 =200 ${uri}{{ .INDEX | default "index.html" }};

        proxy_pass              https://gs/{{ .GCS_BUCKET }}{{ .PATH_PREFIX | default "" }}$uri;
    }
{{ else }}
    location / {
        include "gcs.conf";
        proxy_pass              https://gs/{{ .GCS_BUCKET }}{{ .PATH_PREFIX | default "" }}$uri;
    }
{{ end }}
}
