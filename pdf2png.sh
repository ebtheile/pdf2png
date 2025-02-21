#! /usr/bin/bash

currentDir=`pwd`
inputDir=$currentDir
outputDir="$inputDir/pngs"
pattern=''
verbosity=0
force=0

while getopts ':i:o:p:fvh' opt; do
  case $opt in
    i)
      inputDir="$OPTARG"
      outputDir="$inputDir/pngs"
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
      
      By default, the input dir is the current working directory and the output dir is ./pngs/
      
        Valid options:
          
          -f : Force conversion if output files already exist
          -h : Display this help
          -i directory : Input directory
          -o directory : Output directory
          -p pattern : Pattern used to filter PDFs pre-conversion
          -v : Toggle verbose output'
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo 'Use -h for help.'
      exit 1
      ;;
  esac
done

# Check if directories exist
if [ ! -d "$inputDir" ]; then
  echo "Input directory $inputDir does not exist." >&2
  exit
fi

# Enable nullglob to prevent errors if no files match the pattern
shopt -s nullglob

# Get all pdf files in the input dir (that match the given pattern)
pdf_files=("$inputDir"/*"$pattern"*.pdf)

# Check if there are any files to convert
if [ ${#pdf_files[@]} -eq 0 ]; then
  echo "No files to convert in $inputDir" >&2
  exit 1
fi

# Create the output directory if files are found
if [ ! -d "$outputDir" ]; then
  mkdir "$outputDir"
fi

if [ $verbosity -eq 1 ]; then
  # Convert PDFs verbosely
  for pdf in "${pdf_files[@]}"; do
    pngfile=`basename "$pdf" | sed 's/\.\w*$//'`
    if [ -e "$outputDir/$pngfile-1.png" ]; then
      if [ $force -eq 0 ]; then
        echo "$pdf already converted ..."
      else
        echo "Removing $outputDir/$pngfile*"
        rm "$outputDir/$pngfile*"
        echo "Converting $pdf ..."
        pdftocairo -png "$pdf" "$outputDir/$pngfile"
      fi
    else
      echo "Converting $pdf ..."
      pdftocairo -png "$pdf" "$outputDir/$pngfile"
    fi
  done
  echo ''
  echo 'All done.'
else
  # Convert PDFs quietly
  for pdf in "${pdf_files[@]}"; do
    pngfile=`basename "$pdf" | sed 's/\.\w*$//'`
    if [ -e "$outputDir/$pngfile-1.png" ]; then
      if [ $force -eq 0 ]; then
        :
      else
        rm "$outputDir/$pngfile*"
        pdftocairo -png "$pdf" "$outputDir/$pngfile"
      fi
    else
      pdftocairo -png "$pdf" "$outputDir/$pngfile"
    fi
  done
fi

shopt -u nullglob
exit

