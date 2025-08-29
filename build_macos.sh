#!/bin/bash
rm -r .out
mkdir .out

cp -r static/* .out/

header=$(cat src/#header.html)
footer=$(cat src/#footer.html)

for filename in src/* src/**/*; do
	if [[ "$filename" != "src/#header.html" && "$filename" != "src/#footer.html" && -f "$filename" ]]; then
		content=$(cat "$filename")

		comments=$(ggrep -oP "(?<=<\!\--\s)(.*?)(?=\s-->)" <<< "$content")
		properties=$(ggrep -oP "(?<=\\$&)(.*?)(?=&\\$)" <<< "$comments")

		finished_header="$header"

		while read -r comment; do
			if [[ $comment =~ title:(.*) ]]; then
				title="${BASH_REMATCH[1]} - TxT's website"
				finished_header="${finished_header//$&title&$/$title}"
			fi
			if [[ $comment =~ description:(.*) ]]; then
				description="${BASH_REMATCH[1]}"
				finished_header="${finished_header//$&description&$/$description}"
			fi
		done <<< "$properties"

		echo "$finished_header$content$footer" > temp
		ginstall -D temp "${filename/#src/.out}"
		rm temp
	fi
done