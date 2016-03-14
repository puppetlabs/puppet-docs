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
source_conf="$final/nginx_rewrite.conf"
target_conf="$root/nginx_rewrite.conf"

if diff -q "$source_conf" "$target_conf" >/dev/null 2>&1 ; then
  # Files are the same; no need to swap or reload
  exit 0
fi

cp "$target_conf" "$target_conf".good
cp "$source_conf" "$target_conf"
sudo service nginx configtest || {
  # cp instead of mv in case we can't write to the directory
  cp "$target_conf".good "$target_conf"
  echo "$0: '$source_conf' not valid" >&2
  exit 1
}

sudo service nginx reload || {
  # cp instead of mv in case we can't write to the directory
  cp "$target_conf".good "$target_conf"
  echo "$0: '$source_conf' tested valid, but NGINX cannot reload" >&2
  exit 1
}
