
# tamilrockers-search

CLI application to search tamilrockers.com.

> Warning: This application doesn't bypass any regional restrictions to
> tamilrockers.com. The application only works if you're in a country
> where the website is accessible.

## Usage Instructions

    npm install tamilrockers-search -g
    tamilrockers-search -l all -s "petta-2019" -o out.txt
    tamilrockers-search -l tamil -s "petta-2019" -o out.txt
    tamilrockers-search -l tamil -s "vinnaithaandi varuvaayaa" -o out.txt
    tamilrockers-search -l kannada -s "pailwan-2019" -o out.txt
    tamilrockers-search -l malayalam -s "neram (2013)" -o out.txt
    tamilrockers-search -l hindi -s "dangal-2016" -o out.txt

Supported options:
 - Language: -l, --language
 - Movie Name: -s, --searchString
 - Output filename: -o, --output
 
Supported Languages Options:
 - all (Search in all forums)
 - tamil
 - telugu
 - hindi
 - malayalam
 - kannada
 - english
