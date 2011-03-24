This directory is used in generating a pdf version of the docs. This is done by creating an alternate single-file build of the Jekyll site and then running wkhtmltopdf.

Steps for generating a pdf of the docs: 
------

- Update the pdf_mask/page_order.txt file to include any new pages. 
    - Best way to do this, near as I can tell, is to do a git log -1 puppet.pdf to get the commit where it was last generated, then do a git diff --summary {commit} HEAD -- source to see all the files created or deleted since then. 
- Update the cover page with the current date and git commit. 
- Run rake generate_pdf
- Open pdf_output/index.html and do a find-and-replace of -latest- for -2-6-6- or whatever the latest version is. 
- Run rake serve_pdf
- Run wkhtmltopdf --margin-bottom 17mm --margin-top 17mm --margin-left 15mm --footer-left "[doctitle] • [section]" --footer-right "[page]/[topage]" --footer-line --footer-font-name "Lucida Grande" --footer-font-size 10 cover http://localhost:9292/cover.html http://localhost:9292/ puppet.pdf

TODO:
-----

- Automatically update the cover page. We should be able to write a new liquid tag that just calls git parse-rev HEAD, and it looooks like there's something already there that might help dump the current date? 
- Changing underscores inside <th> elements to spaces using client-side javascript is the fugliest of fugly hacks. This should probably be moved to the main liquid filter, or some other more sane place. 
- Automatically find out which version is latest and do the find-and-replace somewhere other than my text editor. (We should be able to require the puppet docs module from inside the jekyll plugin and just ask it which version is latest!)
- Programatically rack up, rack down, and run wkhtmltopdf. 