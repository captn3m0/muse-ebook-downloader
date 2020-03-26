<?php

$bookId = $argv[1];
$contents = file("$bookId/index.csv");

@mkdir("$bookId/bookmarked");

$joinCommand = "pdftk ";

// Validate all the files are present
foreach ($contents as $row) {
	if (strlen($row) > 4 ) {
		list($chapter, $title) = explode("|", $row);
		$title=trim($title);
		$chapter = trim($chapter);
		if (!file_exists("$bookId/$chapter.pdf")) {
			echo "$chapter missing for $bookId. Skipping this book for now" .  PHP_EOL;
			exit;
		}
		if (!file_exists("$bookId/bookmarked/$chapter.pdf")) {
		$bookmark = <<<END
BookmarkBegin
BookmarkTitle: $title
BookmarkLevel: 1
BookmarkPageNumber: 1
END;
		file_put_contents("$bookId/$chapter.txt", $bookmark);
		`pdftk "$bookId/$chapter.pdf" update_info "$bookId/$chapter.txt" output "$bookId/bookmarked/$chapter.pdf"`;
		}

		assert(file_exists("$bookId/bookmarked/$chapter.pdf"));
		$joinCommand = $joinCommand . escapeshellarg("$bookId/bookmarked/$chapter.pdf") . " ";
	}
}
	
$joinCommand .= "cat output $bookId.pdf";
shell_exec($joinCommand);