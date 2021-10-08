# Nginx based image with GCS proxying

Environment variables:

`GCS_BUCKET` - GCS bucket to point at.

`ROUTING` - routing to use. Possible values: `react`, `gatsby`, `disabled`.

`PATH_PREFIX` - Bucket URL path prefix, defaults to empty string.

`INDEX` - index path. Default: index.html.

`PORT` - port to listen at. Default: 80.

`FORCE_HTTPS` - If defined, will redirect http to https with 301 http code.
