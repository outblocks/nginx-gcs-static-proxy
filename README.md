# Nginx based image with GCS proxying

Environment variables:

`GCS_BUCKET` - GCS bucket to point at.

`PATH_PREFIX` - Bucket URL path prefix, defaults to empty string.

`INDEX` - index path. Default: index.html.

`PORT` - port to listen at. Default: 80.

`ERROR404` - Error 404 handler. Default: index.html.

`ERROR404_CODE` - Error 404 code override. Default: 404.

`REWRITE_TO_HTTPS` - If defined, will rewrite http to https with 301 http code.
