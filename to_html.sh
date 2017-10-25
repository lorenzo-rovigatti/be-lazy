#!/bin/bash

pandoc --include-before-body=title.md --toc -V toc-title:"Table of Contents" --template=template.md -o _tricks_intermediate.md tricks.md 
pandoc --css style.css -o tricks.html _tricks_intermediate.md
rm _tricks_intermediate.md
