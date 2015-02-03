---
layout: default
title: "Assessing Module Quality"
canonical: "/forge/assessingmodulequality.html"
---

[forge]: https://forge.puppetlabs.com
[styleguide]: https://docs.puppetlabs.com/guides/style_guide.html
[modulequality]: ./images/modulequality.png
[details]: ./images/details.png
[qualityscoredetail]: ./images/qualityscoredetail.png
[qualityflags]: ./images/qualityflags.png
[releasechange]: ./images/releasechange.png
[noreleasechange]: ./images/noreleasechange.png
[communityquestions]: ./images/communityquestions.png
[questionsanswered]: ./images/questionsanswered.png
[communityratingscale]: ./images/communityratingscale.png

#Assessing Module Quality

The [Puppet Forge](forge) has both a codified and a crowd-sourced way of gauging the quality of any module.

![module ratings][modulequality]

##Quality Score

A module's quality score is based on a variety of lint, compatibility, and metadata tests. Individual validations are combined to create the total score. If you are comparing modules to use, a module's quality score will give you some indication of its overall soundness and completeness.

For more information about a specific module's quality score, click "details".

![find quality score details][details]

Then scroll down the page and you will see information about the results of the lint, compatibility, and metadata tests represented as: Code Quality, Puppet Compatibility, and Metadata Quality.

![Quality score details][qualityscoredetail]

You can click "View full results..." for even more detailed information on the scores for each section. It is possible that a module will have a perfect Code Quality score, in which case there will not be additional results to view. Otherwise, you will see some combination of the below flags: 

**XX**![Quality flags][qualityflags]

###Quality Flags

####Error
An error flag indicates a severe problem with the module. The flag will be appended to the line in the module causing the issue, which could be anything from a critical bug to a failure to follow a high-priority [best practice](styleguide). If you are the module's author, an error flag negatively impacts your score most heavily. 

####Warning
A warning flag notes a general problem with the module. The flag will be appended to the line in module causing the issue, which could be nonconformance with [best practices](styleguide) or other smaller issue in the module's structure or code. If you are the module's author, a warning flag will negatively impact your score, but is weighted less heavily than an error. 

####Notice
A notice flag indicates something in the module that warrants attention. The notice flag is used for both positive and negative things of note, and as such does not impact the module's score.

####Success
A success flag highlights information the module covers completely. This flag only applies to Puppet Compatibility and Metadata Quality, and can be used to assess whether the module covers things like listing operating system compatibility and having a verified source url. If you are the module's author, a success flag will positively impact your score.

###Updates

When a module has a new release, the quality scoring tests are rerun and a new score is displayed. You will know this happened because you will see an indication of percentage change since last release;

![Quality change since release][releasechange]

Or you will see that it has had no change.

![No quality change since release][noreleasechange]

##Community Rating
A module's community rating is based on the average of user responses to the questions found on every module page on the Forge:

![Community rating quesitons][communityquestions]

And just like any good community rating system, you can see how many questions have been answered overall. For instance, in the module pictured below, 74 questions have been answered:

![Number of questions answered][questionsanswered]

For more details about the answers to the questions, you can click "details". If you scroll down the page, you will find bar graphs showing the average of the answers to the questions on a scale.

![Community ratings on a scale][communityratingscale]