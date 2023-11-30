#!/bin/bash
rm -r .out
mkdir .out

cp static/* .out/

header=$(cat src/#header.html)
footer=$(cat src/#footer.html)

for filename in src/* src/**/*; do
	if [[ "$filename" != "src/#header.html" && "$filename" != "src/#footer.html" && -f "$filename" ]]; then
		content=$(cat "$filename")

		comments=$(grep -oP "(?<=<\!\--\s)(.*?)(?=\s-->)" <<< "$content")
		properties=$(grep -oP "(?<=\\$&)(.*?)(?=&\\$)" <<< "$comments")

		while read -r comment; do
			if [[ $comment =~ title:(.*) ]]; then
				title="${BASH_REMATCH[1]} - TxTs website"
				titled_header="${header//$&title&$/$title}"
			fi
		done <<< "$properties"

		echo "$titled_header$content$footer" > temp
		install -D temp "${filename/#src/.out}"
		rm temp
	fi
done