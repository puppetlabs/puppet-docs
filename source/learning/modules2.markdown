---
layout: default
title: Learning — Modules 2
---

Learning — Modules, Classes, and Defined Types (Part Two)
=========================================

Now that you have basic classes and modules under control, it's time for some more advanced code re-use. 

* * *

&larr; [Templates](./templates.html) --- [Index](./) --- TBA &rarr;

* * * 

Mailboxes vs. Investigators
---------------------------

Most classes have to do slightly different things on different systems. You already know some ways to do that --- all of the modules you've written so far have switched their behaviors by looking up system facts. Let's say that they "investigate:" they expect some information to be in a specific place (in the case of facts, a top-scope variable), and go looking for it when they need it. 

But this isn't always the best way to do it, and it starts to break down once you need to change a machine's configuration based on factors that aren't really part of its intrinsic nature. <!-- That's a mouthful. --> Like