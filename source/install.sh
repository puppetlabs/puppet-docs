#!/bin/zsh

set -e

root="$1"
if [ -z "$root" ] ; then
  echo "Usage: $0 site-root" >&2
  exit 1
fi

stage="$root/stage"
final="$root/final"

# Create tarball
tarball_source="$root/tarball-source"
rsync -a --delete --force "$stage/" "$tarball_source/"
ruby "$stage/linkmunger.rb" "$tarball_source"
( cd "$tarball_source" ; tar -czf - * ) >"$stage/puppetdocs-latest.tar.gz"

# Swap web root into place
rm -rf "$final.moving"
mv "$final" "$final.moving"

if ! mv "$stage" "$final" ; then
  echo "Failed to mv $stage $final" >&2
  echo "Attempting to restore: mv $final.moving $final" >&2
  mv "$final.moving" "$final"
  exit 1
fi

mv "$final.moving" "$stage"

# Swap NGINX configuration into place and reload NGINX
/opt/operations/scripts/swap_nginx_conf \
  "$final/nginx_rewrite.conf" "$root/nginx_rewrite.conf"
