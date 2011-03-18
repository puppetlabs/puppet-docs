This directory is used in generating a pdf version of the docs. This is done by creating an alternate single-file build of the Jekyll site and then running wkhtmltopdf.

Steps for generating a pdf of the docs: 
------

- Update the pdf_mask/page_order.txt file to include any new pages. 
- Update the cover page with the current date and git commit. 
- Run rake generate_pdf
- Open pdf_output/index.html and do a find-and-replace of -latest- for -2-6-6- or whatever the latest version is. 
- Run rake serve_pdf
- Run wkhtmltopdf cover http://localhost:9292/cover.html http://localhost:9292/ puppet.pdf

TODO:
-----

- Automatically find out which version is latest and do the find-and-replace somewhere other than my text editor. 
- Programatically rack up, rack down, and run wkhtmltopdf. 