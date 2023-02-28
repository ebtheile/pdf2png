# pdf2png

Convert all pdf files (which match an optional pattern) in some input directory to png files and save them in some output directory. This script is a wrapper around pdftocairo.

### How to use

Run with flag `-h` to see this message:

```
Usage: ./pdf2png [OPTIONS]
      
      By default, the input dir is the current working directroy and the output dir is ./pngs/
      
        Valid options:
          
          -f : Force conversion if output files already exist
          -h : Display this help
          -i directory : Input directory
          -o directory : Output directory
          -p pattern : Pattern used to filter pdfs pre-conversion
          -v : Toggle verbose output
```


