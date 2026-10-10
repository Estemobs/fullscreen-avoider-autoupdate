#!/usr/bin/env bash
set -euo pipefail

metadata_file="src/metadata.json"
api_url="https://gitlab.gnome.org/api/v4/projects/GNOME%2Fgnome-shell/releases"

# Get current max version from metadata
current_max="$(jq -r '."shell-version" | map(tonumber) | max' "$metadata_file")"
echo "Current max shell-version in metadata: ${current_max}"

# Fetch all releases from GitLab API (handles pagination)
echo "Fetching GNOME Shell releases from GitLab..."
all_tags="$({
  page=1
  while :; do
    page_data="$(curl -fsSL "${api_url}?per_page=100&page=${page}")"
    count="$(jq 'length' <<<"${page_data}")"
    if [[ "${count}" -eq 0 ]]; then
      break
    fi

    jq -r '.[].tag_name' <<<"${page_data}"
    page=$((page + 1))
  done
})"

# Extract major version numbers from tags like "51.0", "51.rc", "51.beta", "51.alpha"
# Also handle tags like "51" (just major version)
latest_major="$(echo "${all_tags}" | grep -E '^[0-9]+(\.[0-9a-zA-Z]+)?$' | sed -E 's/^([0-9]+).*/\1/' | sort -nu | tail -n1)"

if [[ -z "${latest_major}" ]]; then
  echo "Error: Could not determine latest GNOME Shell major version." >&2
  echo "Fetched tags:" >&2
  echo "${all_tags}" >&2
  exit 1
fi

echo "Latest GNOME Shell major version found: ${latest_major}"

if [[ "${latest_major}" -le "${current_max}" ]]; then
  echo "shell-version is already up to date (${current_max})."
  exit 0
fi

echo "Updating shell-version from ${current_max} to ${latest_major}..."

tmp_file="$(mktemp)"
jq --argjson latest "${latest_major}" '
  ."shell-version" |= (
    map(tonumber) as $versions
    | ($versions | max) as $current_max
    | if $latest <= $current_max then
        $versions
      else
        $versions + [range($current_max + 1; $latest + 1)]
      end
    | map(tostring)
  )
' "$metadata_file" > "$tmp_file"
mv "$tmp_file" "$metadata_file"

echo "shell-version updated successfully up to ${latest_major}."
cat "$metadata_file"