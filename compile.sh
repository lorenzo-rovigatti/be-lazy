#!/bin/bash

md_files="intro.md bash.md plotting.md ssh.md debugging.md uncategorized.md"
md_dialect="markdown+emoji"

# generate the book
pandoc -f $md_dialect --include-before-body=title.md --toc -V toc-title:"Table of Contents" --template=template.md -o tricks.md $md_files
pandoc -f $md_dialect --css style.css -o tricks.html tricks.md

# generate the README
pandoc -f $md_dialect --include-before-body=title.md -o README.md intro.md
