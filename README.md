# Nginx based image with GCS proxying

## Environment variables

`GCS_BUCKET` - GCS bucket to point at.

`ROUTING` - routing to use. Possible values: `react`, `gatsby`, `disabled`.

`PATH_PREFIX` - Bucket URL path prefix, defaults to empty string.

`INDEX` - index path. Default: `index.html`.

`PORT` - port to listen at. Default: `80`.

`FORCE_HTTPS` - when value equals to `1` will redirect http to https with 301 http code.

`ERROR_404` - error 404 handling. Not available when routing is `react`. Default: `/404.html`.

`REMOVE_TRAILING_SLASH` -  when value equals to `1` will remove trailing slash (permanent redirect). This is default behavior in `gatsby` routing.

### Basic Auth

`BASIC_AUTH` -  when value equals to `1` will enable basic auth.

`BASIC_AUTH_REALM` - name of basic auth realm. Default: `restricted`.

`ACCOUNT_<user>` - basic auth accounts defined in form of `ACCOUNT_<user>` = `<password>` e.g. `ACCOUNT_myname=mypassword`. Password can be defined as either a plain text or in a form of apr1 hash (used by htpasswd) e.g. `ACCOUNT_myname=$apr1$HcwEV./z$5q8WibCrp743km2HltqOn`.
