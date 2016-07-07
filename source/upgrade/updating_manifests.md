---
layout: default
title: Updating 3.x Manifests for Puppet 4.x
toc: false
---

[str2bool]: https://forge.puppetlabs.com/puppetlabs/stdlib#str2bool
[file_mode]: ./type.html#file-attribute-mode
[where]: ./whered_it_go.html
[reserved]: ./lang_reserved.html
[numeric]: ./lang_data_number.html
[expressions]: ./lang_expressions.html
[boolean]: ./lang_data_boolean.html

Several breaking changes were introduced in Puppet 4.0. If you previously used Puppet 3.x, your manifests will need to be updated for the new implementation. This page lists the most important steps to update your manifests to be 4.x compatible.


<div class="panel-heading" role="tab" id="headingOne">
    <a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">Make sure everything is in the right place</a>
</div>
<div id="collapseOne" class="collapse" role="tabpanel" aria-labelledby="headingOne">
  The locations of code directories and important config files have changed. Read about where everything went to make sure your files are in the correct place before tackling updates to your manifests.
</div>
<div class="panel-heading" role="tab" id="headingTwo">
    <a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">Double-check to make sure it's safe before purging `cron` resources</a>
</div>
<div id="collapseTwo" class="collapse" role="tabpanel" aria-labelledby="headingTwo">
  Previously, using <code>resources {'cron': purge => true}</code> to purge <code>cron</code> resources would only purge jobs belonging to the current user performing the Puppet run (usually <code>root</code>`). In Puppet 4, this action is more aggressive and causes <em>all</em> unmanaged cron jobs to be purged.
  <br><br>
  Make sure this is what you want. You might want to set <code>noop => true</code> on the purge resource to keep an eye on it.
</div>
<div class="panel-heading" role="tab" id="headingThree">
    <a class="collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseThree" aria-expanded="false" aria-controls="collapseThree">Check your data types</a>
</div>
<div id="collapseThree" class="collapse" role="tabpanel" aria-labelledby="headingThree">
  Data types have changed in a few ways.

  <h3>Boolean facts are always real booleans</h3>

  In Puppet 3, facts with boolean true/false values (like `$is_virtual`) were converted to strings unless the `stringify_facts` setting was disabled. This meant it was common to test for these facts with the `==` operator, like `if $is_virtual == 'true' { ... }`.
  <br><br>
  In Puppet 4, boolean facts are never turned into strings, and those `==` comparisons will always evaluate to `false`. This can cause serious problems. Check your manifests for any comparisons that treat boolean facts like strings; if you need a manifest to work with both Puppet 3 and Puppet 4, you can convert a boolean to a string and then pass it to [the stdlib module's `str2bool` function][str2bool]:
  <br><br>
  <pre class=" language-ruby"><code class=" language-ruby"><span class="token keyword">if</span> <span class="token function">str2bool</span><span class="token punctuation">(</span><span class="token string">"$is_virtual"</span><span class="token punctuation">)</span> <span class="token punctuation">{</span> <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span> <span class="token punctuation">}</span>
</code></pre>

  <h3>Numbers and strings are different in the DSL</h3>

  For full details, [see the language page about numeric values.][numeric]
  <br>
  Previously, Puppet would convert everything to strings, then attempt to convert those strings back into numbers when they were used in a numeric context. In Puppet 4, numbers in the DSL are parsed and maintained internally as numbers. The following examples would have been equivalent in Puppet 3, but are now different:
  <br>
<pre class=" language-ruby"><code class=" language-ruby"><span class="token variable">$port_a</span> <span class="token operator">=</span> <span class="token number">80</span>   <span class="token comment" spellcheck="true"># Parsed and maintained as a number, errors if NOT a number</span>
<span class="token variable">$port_b</span> <span class="token operator">=</span> <span class="token string">'80'</span> <span class="token comment" spellcheck="true"># Parsed and maintained as a string</span>
</code></pre>
  <br>
  The difference now is that Puppet will STRICTLY enforce numerics and will throw errors if values that begin with a number are not valid numbers.
  <br>
<pre class=" language-ruby"><code class=" language-ruby">node 1name <span class="token punctuation">{</span><span class="token punctuation">}</span> <span class="token comment" spellcheck="true"># invalid because 1name is not a valid decimal number; you would need to quote this name</span>
<span class="token function">notice</span><span class="token punctuation">(</span>0xggg<span class="token punctuation">)</span> <span class="token comment" spellcheck="true"># invalid because 0xggg is not a valid hexadecimal number</span>
<span class="token variable">$a</span> <span class="token operator">=</span> <span class="token number">1</span> <span class="token operator">+</span> <span class="token number">0789</span> <span class="token comment" spellcheck="true"># invalid because 0789 is not a valid octal number</span>
</code></pre>
  <br>
  <h3>Arithmetic expressions</h3>

  Mathematical expressions still convert strings to numeric values. If a value begins with 0 or 0x, it will be interpreted as an octal or hex number, respectively.  An error is raised if either side in an arithmetic expression is not a number or a string that can be converted to a number.  For example:
  <br>
  <code>
<pre class=" language-ruby"><code class=" language-ruby"><span class="token variable">$valid</span> <span class="token operator">=</span> <span class="token number">40</span> <span class="token operator">+</span> <span class="token number">50</span>       <span class="token comment" spellcheck="true"># valid because both values are numeric</span>
<span class="token variable">$valid</span> <span class="token operator">=</span> <span class="token number">25</span> <span class="token operator">+</span> <span class="token string">'30'</span>     <span class="token comment" spellcheck="true"># valid because '30' can be cast numerically</span>
<span class="token variable">$invalid</span> <span class="token operator">=</span> <span class="token number">40</span> <span class="token operator">+</span> <span class="token number">0789</span>   <span class="token comment" spellcheck="true"># invalid because 0789 isn't a valid octal number</span>
<span class="token variable">$invalid</span> <span class="token operator">=</span> <span class="token number">40</span> <span class="token operator">+</span> <span class="token string">'0789'</span> <span class="token comment" spellcheck="true"># invalid because '0789' can't be cast numerically</span>
</code></pre>
  </code>
</div>
