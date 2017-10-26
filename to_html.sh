#!/bin/bash

md_files="intro.md bash.md plotting.md ssh.md debugging.md uncategorized.md"

pandoc --include-before-body=title.md --toc -V toc-title:"Table of Contents" --template=template.md -o _tricks_intermediate.md $md_files
pandoc --css style.css -o tricks.html _tricks_intermediate.md
rm _tricks_intermediate.md
