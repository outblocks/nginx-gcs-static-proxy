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

{{- if .REDIRECT_TO_HTTPS }}
    if ( $scheme = "http" ) {
        return 301 https://$host$request_uri;
    }
{{ end }}

    location / {
        rewrite /$ /{{ .INDEX | default "index.html" }};

        proxy_set_header    Host storage.googleapis.com;
        proxy_pass          https://gs/{{ .GCS_BUCKET }}{{ .PATH_PREFIX | default "" }}$uri;
        proxy_http_version  1.1;
        proxy_set_header    Connection "";

        proxy_intercept_errors on;
        proxy_hide_header       alt-svc;
        proxy_hide_header       X-GUploader-UploadID;
        proxy_hide_header       alternate-protocol;
        proxy_hide_header       x-goog-hash;
        proxy_hide_header       x-goog-generation;
        proxy_hide_header       x-goog-metageneration;
        proxy_hide_header       x-goog-stored-content-encoding;
        proxy_hide_header       x-goog-stored-content-length;
        proxy_hide_header       x-goog-storage-class;
        proxy_hide_header       x-xss-protection;
        proxy_hide_header       accept-ranges;
        proxy_hide_header       Set-Cookie;
        proxy_ignore_headers    Set-Cookie;

        error_page 404 ={{ .ERROR404_CODE | default "404" }} /{{ .ERROR404 | default "index.html" }};
    }
}
