#! /usr/bin/bash

pdf_files=`ls | grep \\.pdf$`
for pdf in $pdf_files

do
pngfile=`echo "$pdf" | sed 's/\.\w*$//'`

if [ -e pngs/$pngfile-1.png ]
then
echo $pdf " already converted ..."
else
echo "Converting "$pdf" ..."
pdftocairo -png $pdf pngs/$pngfile
fi

done

echo ""
echo "All done."
