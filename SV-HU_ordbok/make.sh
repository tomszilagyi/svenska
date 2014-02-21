#!/bin/bash

NPAGES=1048
PAPER=a5
OUTFILE="Ordbok.pdf"

echo Downloading PNG images for all book pages...
mkdir png; cd png
for i in `seq -w 1 $NPAGES` ; do wget http://runeberg.org/img/svhu1972/$i.3.png ; mv $i.3.png $i.png ; done
cd ..

echo Downloading HTML files containing index information...
mkdir html; cd html
for i in `seq -w 1 $NPAGES` ; do wget -nd -nH -P. -l 0 http://runeberg.org/svhu1972/$i.html ; done
cd ..

echo Converting PNG images to PDF pages...
mkdir pdf;
for i in `seq -w 1 $NPAGES` ; do convert png/$i.png pdf/$i.pdf ; done

echo Creating PDF bookmarks...
for i in `seq -w 1 $NPAGES` ; do cat html/$i.html | awk -f getidx.awk ; done | awk -f mkpdfmarks.awk > pdfmarks

echo Putting it all together...
gs -dBATCH -dNOPAUSE -sPAPERSIZE=$PAPER -sDEVICE=pdfwrite -sOutputFile=$OUTFILE $(ls pdf/*.pdf) pdfmarks
