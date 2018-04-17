module Pages.Home exposing (view)

import Element exposing (..)
import Elements
import Markdown


view : Device -> Element msg
view device =
    column []
        [ Elements.hero device
            { title = "Hey, I'm Ryan."
            , subtitle = "And I like coding things!"
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
## About Me

Hey there, my name is Ryan and I am a Frontend Developer at One North Interactive! I first got involved with programming in high school, learning Java and Object-Oriented programming to make `CheckingAccount` and `SavingsAccount` classes that extended `BankAccount` interfaces.

Luckily, that didn't last too long, when a close friend and I started using Java to make more exciting things after school (like video games!). I decided I wanted to get involved in programming in college, so I applied for Computer Science at the University of Illinois in Urbana-Champaign!

Due to an off-by-one-error, I ended up in the Computer Engineering program, where I got to design processors, wire up robotic cars, and roll my own Linux operating system. Around my junior year, I was introduced to responsive web design and got really passionate about frontend web development!

First I learned some jQuery. Then some Angular 2. Then AngularJS. Then React. Then VueJS. Luckily, that enabled me to land a pretty sweet gig after college at One North!

A few months later, I met [Elm](http://elm-lang.org) and fell in love with the friendly compiler and (even _friendlier_) community.

Now, I like to spend my free time teaching people cool web development things, and working on side projects. Most of those side projects are in Elm, Typescript, and powered by NodeJS. If you're curious about my [projects](/projects) or want to learn more about [the things I like to think about](/thoughts), you're at the right place!
"""
