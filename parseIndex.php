<?php
$file = file($argv[1]);

foreach ($file as $line) {
	if(strlen($line) > 5) {
		$re = '/chapter\/(\d+)">(.+)<\/a>/m';
		preg_match($re, $line, $matches, PREG_OFFSET_CAPTURE, 0);
		echo $matches[1][0] . '|' . $matches[2][0] . PHP_EOL;
	}
}