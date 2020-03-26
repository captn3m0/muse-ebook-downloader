# muse-downloader

## Requirements

`php`, `pdftk`, `bash`, [`ag`](https://github.com/monochromegane/the_platinum_searcher).

## Limitations

Expects PDF currently. Some books on the MUSE site don't have PDF versions, and this will break for them

## WARNING

- This is still WIP, it doesn't combine the PDFs into a single file yet.
- You are responsible for what you do with this. I hate reading online, so I use this to archive and read offline.

## How to run

1. Ensure you have the dependencies covered
2. Put all the book IDs you want in `ids.txt`
3. Run `./generate.sh`

## Why is (X) a dependency?

File a PR and fix it.

## License

Licensed under the [MIT License](https://nemo.mit-license.org/). See LICENSE file for details.