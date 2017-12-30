#!/bin/bash

md_files="intro.md bash.md command_line_tools.md plotting.md ssh.md debugging.md uncategorized.md glossary.md"
md_dialect="markdown+emoji"

# generate the book
pandoc -f $md_dialect --include-before-body=title.md --toc -V toc-title:"Table of Contents" --template=template.md -o be-lazy.md $md_files
pandoc -f $md_dialect --css style.css -o be-lazy.html be-lazy.md

# generate the README
pandoc -f $md_dialect --include-before-body=title.md -o README.md intro.md
