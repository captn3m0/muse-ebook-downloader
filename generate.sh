#!/bin/bash

while IFS= read -r ID; do
  mkdir -p "$ID"
  if [ ! -f "$ID/info.html" ]; then
  	  # echo "Download HTML"
	  curl --silent https://muse.jhu.edu/book/$ID > "$ID/info.html"
  fi
  if [ ! -f "$ID/index.csv" ]; then
	  ag --only-matching --nofilename --no-number "chapter/(\d+)\">(.+)</a>" "$ID/info.html" >  "$ID/index.txt"
	  php parseIndex.php "$ID/index.txt" > "$ID/index.csv"
  fi

  # Download the PDFs
  while read ROW; do
  	CHAPTER_ID=$(echo $ROW | cut -d '|' -f 1 | tr -d '[:space:]')
  	CHAPTER_TITLE=$(echo $ROW | cut -d '|' -f 2)
  	if [ ! -f "$ID/$CHAPTER_ID.pdf" ]; then
  		wget "https://muse.jhu.edu/chapter/$CHAPTER_ID/pdf" -O "$ID/tmp-$CHAPTER_ID.pdf"
  		if [ -f "$ID/tmp-$CHAPTER_ID.pdf" ]; then
  			pdftk "$ID/tmp-$CHAPTER_ID.pdf" cat 2-end output "$ID/$CHAPTER_ID.pdf"
  		fi
  	fi
  done < "$ID/index.csv"
done < ids.txt