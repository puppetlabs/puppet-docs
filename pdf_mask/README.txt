This directory is used in generating a pdf version of the docs. This is done by creating an alternate single-file build of the Jekyll site and then running wkhtmltopdf.

Steps for generating a pdf of the docs:
------

- Update the pdf_mask/pdf_targets.yaml file to include any new pages or targets.
    - FIND UPDATES. Two steps:
        - Check the first page of one of the existing PDFs (one that's being currently updated; we froze the oldest PE ones to get no new updates, so watch out for that) to get the commit where they were last generated. Then, do a `git diff --summary <commit> HEAD -- source` to see all the files created or deleted since then.
        - Diff the _config.yml file since that last update and add any new PuppetDB versions as targets (since these are being maintained outside our repo and won't be caught up in the first step).
    - ADD NEW TARGETS OR PAGES. To add a target, you must:
        - Create a new key and array for it in the yaml file.
            - Note that the top.html and bottom.html items are mandatory.
            - The key (and filename, as used below) can't have any dots in it. Use underscores or something if you're trying to write a version like 3.0.
            - You can use the sidebar for the large document you're adding (and some careful find-and-replace) to compile the list of filenames you need in the array in the yaml file.
            - The paths must be in a certain format, so just follow the examples already there.
        - Create a pdf_mask/cover_<target>.markdown file for the new target.
        - If you're using any funky layouts in the source files, create a ringer layout in pdf_mask/_layouts identical to default.html.
    - REALITY CHECK. Diff the pdf_targets.yaml file to make sure you added what you think you added.
- Run rake generate_pdf
- Run rake serve_pdf
- In a different terminal tab, run rake compile_pdf

And then make sure you kick the PDFs out of the puppet-docs directory and upload them.

UPLOADING:
-----

1. Get the PDFs out of the docs directory and into their own folder on like your desktop.

2. Zip them up -- you can do this on your own desktop, because if you're downloading them all it's reasonable to assume you don't need the old PE versions. If you're doing this, make sure the zip file is named puppet_labs_docs_pdfs.zip, and upload it at the same time as the PDFs themselves.

3. Copy them to the /opt/downloads/docs folder on Burji (downloads.puppetlabs.com).

    cd ~/Desktop/newpdfs
    rsync -av ./ deploy@downloads.puppetlabs.com:/opt/downloads/docs/

(Don't use --delete, you want to leave any frozen pdfs in place.)


POSTING LINKS
-----

Just tell Kent.

- (We used to just edit the wordpress page ourselves, but now that they're transitioning to Drupal and you need to edit both, we're leaving it to the pros.)

TODO:
-----

- Changing underscores inside <th> elements to spaces using client-side javascript is the fugliest of fugly hacks. This should probably be moved to the main liquid filter, or some other more sane place.
- Programmatically rack up and rack down, so we can get away with two rake tasks instead of three.
