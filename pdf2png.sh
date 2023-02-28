#! /usr/bin/bash

currentDir=`pwd`
inputDir=$currentDir
outputDir='pngs'
pattern=''
verbosity=0
force=0


while getopts ':i:o:p:fvh' opt; do
  case $opt in
    i)
      inputDir="$OPTARG"
      ;;
    o)
      outputDir="$OPTARG"
      ;;
    p)
      pattern="$OPTARG"
      ;;
    f)
      force=1
      ;;
    v)
      verbosity=1
      ;;
    h)
      echo 'Usage: ./pdf2png [OPTIONS] -i [input dir] -o [output dir]
      
      By default, the input dir is the current working directroy and the output dir is ./pngs/
      
        Valid options:
          
          -h : Display this help
          -i directory : Input directory
          -o directory : Output directory
          -p pattern : Pattern used to filter pdfs pre-conversion
          -v : Toggle verbose output'
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Check if directories exist
if [ ! -d "$inputDir" ]; then
  echo "Input directory $inputDir does not exist." >&2
  exit
fi

if [ ! -d "$outputDir" ]; then
  mkdir "$outputDir"
fi

# Get all pdf files in the output dir (that match the given pattern)
pdf_files=`ls $inputDir | grep $pattern.*\.pdf$`

# Check if there are any files to convert
if [ ${#pdf_files} -eq 0 ]; then
  echo "No files to convert in $inputDir" >&2
  exit 1
fi

if [ $verbosity -eq 1 ]; then
  # Convert pdfs verbosely
  for pdf in $pdf_files; do
    pngfile=`echo "$pdf" | sed 's/\.\w*$//'`
    if [ -e $outputDir/$pngfile-1.png ]; then
      if [ $force -eq 0 ]; then
        echo $pdf ' already converted ...'
      else
        echo "Removing $pngfile*"
        rm $outputDir/$pngfile*
        echo "Converting "$pdf" ..."
        pdftocairo -png $inputDir/$pdf $outputDir/$pngfile
      fi
    else
      echo "Converting "$pdf" ..."
      pdftocairo -png $inputDir/$pdf $outputDir/$pngfile
    fi
  done
  echo ''
  echo 'All done.'
else
  # Convert pdfs quietly
  for pdf in $pdf_files; do
    pngfile=`echo "$pdf" | sed 's/\.\w*$//'`
    if [ -e $outputDir/$pngfile-1.png ]; then
      if [ $force -eq 0 ]; then
        :
      else
        rm $outputDir/$pngfile*
        pdftocairo -png $inputDir/$pdf $outputDir/$pngfile
      fi
    else
      pdftocairo -png $inputDir/$pdf $outputDir/$pngfile
    fi
  done
fi
exit
