#!/bin/sh

set -e

ME=$(basename "$0")

auto_gucci() {
    template_dir="${NGINX_GUCCI_TEMPLATE_DIR:-/etc/nginx/templates}"
    suffix="${NGINX_GUCCI_TEMPLATE_SUFFIX:-.tpl}"
    output_dir="${NGINX_GUCCI_OUTPUT_DIR:-/etc/nginx/conf.d}"

    local template relative_path output_path subdir

    [ -d "${template_dir}" ] || return 0
    if [ ! -w "${output_dir}" ]; then
        echo >&3 "${ME}: ERROR: ${template_dir} exists, but ${output_dir} is not writable"
        return 0
    fi

    find "${template_dir}" -follow -type f -name "*${suffix}" -print | while read -r template; do
        relative_path="${template#"${template_dir}"/}"
        output_path="${output_dir}/${relative_path%"${suffix}"}"
        subdir=$(dirname "${relative_path}")

        # create a subdirectory where the template file exists
        mkdir -p "${output_dir}/${subdir}"
        echo >&3 "${ME}: Running gucci on ${template} to ${output_path}"
        gucci -o missingkey=zero "${template}" >"${output_path}"
    done
}

auto_gucci
