module Pages.Projects exposing (view)

import Element exposing (..)
import Elements
import Markdown


view : Device -> Element msg
view device =
    column []
        [ Elements.hero device
            { title = "Projects."
            , subtitle = "Here's what I've been up to!"
            }
        , Elements.container <|
            el [ padding 16, width fill ]
                (paragraph []
                    [ Element.html <| Markdown.toHtml [] content
                    ]
                )
        ]


content : String
content =
    """
## Jangle
> a cms for humans.

I'm working on an open-source CMS called Jangle to help make maintaining websites easy for people that don't know how to code. I'm deeply inspired by existing open-source projects like Wordpress, KeystoneJS, and want to focus on making content management much simpler and friendly!

The project is broken up into a couple layers, to hopefully add some flexibility for the future. This also means have to use a variety of languages and technologies:

- __Jangle Core__: A Typescript NodeJS application that uses Mongoose and JWT to provide publishing, history, and authentication on top of a MongoDB.
- __Jangle API__: Another Typescript NodeJS application that uses ExpressJS to automatically generate REST API endpoints for your content. (This builds on top of Jangle Core)
- __Jangle CMS__: An Elm web application that makes requests to Jangle API to empower non-technical users to make updates to their content.

Check it out the organization on [Github](https://github.com/jangle-cms)!

---

## ryannhg
> My personal website.

A few years ago, I became familiar with Elm, and since then have been gained an unhealthy obsession with it's libraries. This site was built (almost) entirely in Elm, and use's Matt Griffith's style-elements library to help me style things in an easy way.

The site is powered by Netlify, and I use Evan Czaplicki's `elm-markdown` package to add content. Which is nice, because now when I'm stuck between coding Elm or writing a blog post, I can technically do both! Woohoo!

Check it out on [Github](https://github.com/ryannhg/ryannhg)!

---

## elm-date-format
> A reliable way to format dates with Elm!

elm-date-format was my first contribution to the elm package ecosystem! What's great about publishing packages with Elm, is that it automatically enforces semantic versioning. So if I make a breaking change, it will require me to update the Major version, so other people don't have broken code!

Despite that seemingly frustrating quality, deploying a package with Elm was so much easier for me to get right than NPM. In addition, the community provided a lot of great feedback for my first contribution. With their help, I was able to add automated tests and tweak the designso that I could easily add features without requiring a major release (thanks, Richard Feldman)!

The project was inspired by MomentJS, which is an awesome library for formatting dates and times in Javascript. With Elm's epic type system, I was able to eliminate the need to remember the difference between "mm", "MM", and "MMMM", while still making it easy to use for the community.

Feel free out the [package](http://package.elm-lang.org/packages/ryannhg/elm-date-format/latest) or the [repo](https://github.com/ryannhg/elm-date-format)!

---

I've got plenty of other projects worth checking out in case you are more interested in [Typescript](https://github.com/jangle-cms/jangle-core), [VueJS](https://github.com/ryannhg/one-north-demo), [KeystoneJS](https://github.com/ryannhg/luckydaygaming), [Wordpress](https://github.com/ryannhg/oni-wordpress), or fun games written in [Object Oriented Javascript](https://github.com/ryannhg/druid) or [the best language ever](https://github.com/ryannhg/seven-seas-elm).
"""
