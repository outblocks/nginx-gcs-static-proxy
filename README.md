# Nginx based image with GCS proxying

Environment variables:

`GCS_BUCKET` - GCS bucket to point at.
`INDEX` - index path. Default: index.html.
`PORT` - port to listen at. Default: 80.
`ERROR404` - Error 404 handler. Default: index.html.
`ERROR404_CODE` - Error 404 code override. Default: 404.
