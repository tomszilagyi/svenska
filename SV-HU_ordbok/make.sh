#!/bin/bash

NPAGES=1048
PAPER=a5
OUTFILE="Ordbok.pdf"

echo Downloading TIFF images for all book pages...
mkdir tif; cd tif
for i in `seq -w 1 $NPAGES` ; do wget http://runeberg.org/img/svhu1972/$i.1.tif ; mv $i.1.tif $i.tif ; done
cd ..

echo Downloading HTML files containing index information...
mkdir html; cd html
for i in `seq -w 1 $NPAGES` ; do wget -nd -nH -P. -l 0 http://runeberg.org/svhu1972/$i.html ; done
cd ..

echo Converting TIFF images to PDF pages...
mkdir pdf;
for i in `seq -w 1 $NPAGES` ; do convert tif/$i.tif pdf/$i.pdf ; done

echo Creating PDF bookmarks...
for i in `seq -w 1 $NPAGES` ; do cat html/$i.html | awk -f getidx.awk ; done | awk -f mkpdfmarks.awk > pdfmarks

echo Putting it all together...
gs -dBATCH -dNOPAUSE -sPAPERSIZE=$PAPER -sDEVICE=pdfwrite -sOutputFile=$OUTFILE $(ls pdf/*.pdf) pdfmarks
