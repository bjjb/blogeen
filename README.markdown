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
[RDoc](http://rdoc.rubyforge.org/RDoc/Markup.html).

Usage
-----

Just download the Rakefile, stick it in a directory somewhere, write a file in
[RDoc](http://rdoc.rubyforge.org/RDoc/Markup.html) called "index.txt,
(in the same directory), and run

rake

It will make the index.html file for you. Wow. It also makes a file called
index.yml, which you can customise for that one page - running `rake` again
will rebuild the HTML with your new customisations.

If you want to get fancier, you should create a YAML file called _site.yml_.
Then you can do things like add a layout ERB file somewhere, and add

    layout: layout.erb.html

Suddenly you can have all kinds of styles and javascript in your pages.

If you need more granularity, you can also use a template option, which will
be processed _before_ the layout.

All .txt files will be processed with RDoc, and then run through the ERB file.
Within the ERB, an object is available called "page", which contains all of
the configuration options. You should take care of presentation (date
formatting, etc) in there.

If you already have a Rakefile for your site, and you don't want it to
interfere, that's ok. You can just rename the Blogín Rakefile to
"blogeen.rake" (or something), require it by your main rakefile, *within a
namespace*, and then you can call *mynamespace:default* to generate the
site.

I don't like Markdown!
----------------------

No bother. Set the `markdown` option in your site.yml to `rdiscount`, or
`redcloth`, or `maruku`. If you want something else, like BlueCloth, you
should add the method to the Rakefile (just copy and adjust the `rdiscount`
method).

Code Highlighting
-----------------

If you have [pygments][http://pygments.org/] installed, then you can add
`highlight: pygmentize` to your site.yml, and all pre-blocks will be run
through the executable (it _must_ be in your `PATH`). Specify the lexer on the
first line of the block, with `#!_lang_`, thusly:


    #!java
    public static void main(String argv[]) {
        System.out.println("Hello, world!");
    }

This is quite slow, but pygments has a lexer for more languages than any other
highlighter I could find. Feel free to use something different - create a
method in the Rakefile which takes HTML and outputs highlighted HTML, and set
that to your "highlight" option instead.

It doesn't do X, Y or Z
-----------------------

I don't care. It's all very simple - steal it and change it as you like.
