This directory is used in generating a pdf version of the docs. This is done by creating an alternate single-file build of the Jekyll site and then running wkhtmltopdf.

Steps for generating a pdf of the docs: 
------

- Update the pdf_mask/pdf_targets.yaml file to include any new pages or targets.
    - It may be helpful to do a git log -1 <name of PDF> to get the commit where it was last generated, then do a git diff --summary <commit> HEAD -- source to see all the files created or deleted since then. 
- Run rake generate_pdf
- Run rake serve_pdf
- Run rake compile_pdf in a different tab

TODO:
-----

- Changing underscores inside <th> elements to spaces using client-side javascript is the fugliest of fugly hacks. This should probably be moved to the main liquid filter, or some other more sane place. 
- Programmatically rack up and rack down, so we can get away with two rake tasks instead of three.
