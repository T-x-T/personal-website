#!/bin/bash
rm -r .out
mkdir .out

cp static/* .out/

for filename in src/* src/**/*; do
	if [[ "$filename" != "src/#header.html" && "$filename" != "src/#footer.html" && -f "$filename" ]]; then
		echo "$filename"
		cat "src/#header.html" "$filename" "src/#footer.html" > temp
		install -D temp "${filename/#src/.out}"
		rm temp
	fi
done