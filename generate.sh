#!/bin/bash

while IFS= read -r ID; do
  mkdir -p "$ID"
  if [ ! -f "$ID/info.html" ]; then
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
      curl --silent "https://muse.jhu.edu/chapter/$CHAPTER_ID/pdf" \
        -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:74.0) Gecko/20100101 Firefox/74.0' \
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
        -H 'Accept-Language: en-US,en;q=0.5' --compressed \
        -H "Referer: https://muse.jhu.edu/verify?url=%2Fchapter%2F$CHAPTER_ID%2Fpdf" \
        -H 'DNT: 1' \
        -H 'Connection: keep-alive' \
        -H 'Upgrade-Insecure-Requests: 1' \
        -H 'Cache-Control: max-age=0' \
        > "$ID/tmp-$CHAPTER_ID.pdf"
  		if [ -f "$ID/tmp-$CHAPTER_ID.pdf" ]; then
  			pdftk "$ID/tmp-$CHAPTER_ID.pdf" cat 2-end output "$ID/$CHAPTER_ID.pdf"
        rm "$ID/tmp-$CHAPTER_ID.pdf"
  		fi
      echo "Downloaded $ID/$CHAPTER_ID"
  	fi
  done < "$ID/index.csv"

  if [ ! -f "$ID.pdf" ]; then
    php stitch.php $ID
  else
    # If the PDF exists, make sure to publish it with a title:
    # TODO
    echo "Please add code here to update the PDF with a title"
    # https://sejh.wordpress.com/2014/11/26/changing-pdf-titles-with-pdftk/
  fi
  echo "$ID | " $(ag citation_isbn "$ID/info.html"  --nonumbers | ag -o "\d+")
done < ids.txt