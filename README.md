# middleman-kss

`middleman-kss` provides [KSS][kss] helpers for
[Middleman](http://middlemanapp.com/). With these helpers, you can easily
insert KSS styleguide blocks. Great for creating styleguides or design
guidelines.

P.S. This gem was mainly created to be used with my
[middleman-styleguide-template][template], which I use for creating styleguides
and other documentation.

## Installation

Add this line to your Middleman project Gemfile:

    gem 'middleman-kss'

And then execute:

    $ bundle

Open your `config.rb` and add the required settings:

    set :markdown_engine, :redcarpet
    activate :kss, :kss_dir => 'stylesheets/external'

Note: The :kss_dir should be set so all the `url('...')`s in your CSS map correctly.

Create a `styleblocks`-directory under `source/`

    $ mkdir source/styleblocks

And read the next chapter for usage instructions.

## Usage

Okay, here's the deal:

1. Write your CSS/SCSS/LESS in [KSS][kss]
2. Insert your CSS/SCSS/LESS into the `kss_dir`
3. Write the HTML for individual style blocks into `source/styleblocks`
4. Use the helpers to print the style blocks

See my [middleman-styleguide-template][template] for examples!

### Helpers

**styleblock** <%= styleblock 'filename', [section: '1.1'] %>

Renders the styleblock named `filename`.

*Optional:* `section` parameter maps the
rendered styleblock to a KSS section, which will expand the section into a fully
documented KSS styleblock with all the available classes and such.


## Contributing

Contributions are most welcome! And well-tested and documented contributions are
more welcome than others ;)

1. [Fork the repository][fork]
2. [Create a branch][branch] (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. [Create a pull request][pr]

[kss]: https://github.com/kneath/kss
[template]: https://github.com/Darep/middleman-styleguide-template
[fork]: http://help.github.com/fork-a-repo/
[branch]: http://learn.github.com/p/branching.html
[pr]: http://help.github.com/send-pull-requests/
