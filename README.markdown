Blogín
======

Another dead-simple tiny website generator.

Blogín (pronounced blog-EEN) is a Rakefile that takes all the .txt files in
the current directory, and them to HTML files.

Sound familiar? That's because the same thing is done by
[Webby](http://webby.rubyforge.org), Jeckyl(http://jekyllrb.com/),
[Hobix](http://hobix.rubyforge.org), and probably hundreds of other small
little roll-yer-own scripts all over the Internet.

What makes Blogín different? *Nothing!* The beauty of a tool like
[Ruby](http://ruby-lang.org) is that it already gives you nifty tools to do
everything. In this case, the tools are [YAML](http://yaml.org),
[ERB](http://ruby-doc.org/stdlib/libdoc/erb/rdoc/classes/ERB.html),
[Rake](http://rake.rubyforge.org) and
[RDiscount](http://github.com/rtomayko/rdiscount).

Usage
-----

Just download the Rakefile, stick it in a directory somewhere, write a file in
[Markdown](http://daringfireball.net/projects/markdown/) called "index.txt,
(in the same directory), and run

    rake website

It will make the index.html file for you. Wow.

TODO
----

Update this documentation.
