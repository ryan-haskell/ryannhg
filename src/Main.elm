port module Main exposing (main)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import DateFormat
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region
import Html exposing (Html)
import Html.Attributes as Attr
import Markdown
import Task
import Time exposing (Zone)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), s, string)


type alias Flags =
    ()


type alias Model =
    { url : Url
    , key : Key
    , timezone : Zone
    }


type Msg
    = OnUrlRequest UrlRequest
    | OnUrlChange Url
    | SetTimezone Zone


type Page
    = Homepage
    | BlogDetail Post
    | NotFound


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        , onUrlRequest = OnUrlRequest
        , onUrlChange = OnUrlChange
        }


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model url key Time.utc
    , getTimezone
    )


getTimezone : Cmd Msg
getTimezone =
    Task.perform SetTimezone Time.here


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTimezone zone ->
            ( { model | timezone = zone }
            , Cmd.none
            )

        OnUrlRequest urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , outgoing url
                    )

        OnUrlChange url ->
            ( { model | url = url }
            , outgoing "URL_CHANGE"
            )


port outgoing : String -> Cmd msg


pageTitle : Url -> String
pageTitle url =
    String.join " | " <|
        case pageFromUrl url of
            Homepage ->
                [ "Ryan Haskell-Glatz" ]

            BlogDetail post ->
                [ post.title, "Blog", "Ryan Haskell-Glatz" ]

            NotFound ->
                [ "Not Found", "Ryan Haskell-Glatz" ]


view : Model -> Document msg
view model =
    { title = pageTitle model.url
    , body = [ Element.layout [] (page model) ]
    }


colors =
    { white = rgb 1 1 1
    , blue = rgb255 0 100 175
    , darkBlue = rgb255 0 125 200
    , lightGray = rgb 0.9 0.9 0.9
    , darkGray = rgb 0.3 0.3 0.3
    }


sourceSansPro =
    Font.family
        [ Font.typeface "Source Sans Pro"
        ]


page : Model -> Element msg
page model =
    case pageFromUrl model.url of
        Homepage ->
            homepage model

        BlogDetail post ->
            blogDetailPage model post

        NotFound ->
            notFoundPage


pageFromUrl : Url -> Page
pageFromUrl url =
    case Parser.parse route url of
        Just page_ ->
            page_

        Nothing ->
            NotFound


route : Parser.Parser (Page -> a) a
route =
    Parser.oneOf
        [ Parser.map Homepage Parser.top
        , Parser.map BlogDetail (s "blog" </> Parser.custom "POST" postFromSlug)
        ]


postFromSlug : String -> Maybe Post
postFromSlug slug =
    posts
        |> List.filter (\post -> post.slug == slug)
        |> List.head


homepage : Model -> Element msg
homepage model =
    column
        [ width fill, sourceSansPro ]
        [ navbar
        , hero
            { title = "ryan."
            , caption = "i like coding things!"
            }
        , latestPosts model.timezone
        , footer
        ]


notFoundPage : Element msg
notFoundPage =
    column
        [ width fill, sourceSansPro ]
        [ navbar
        , hero { title = "page not found.", caption = "sorry about that!" }
        , footer
        ]


blogDetailPage : Model -> Post -> Element msg
blogDetailPage { timezone } { title, time, content } =
    column
        [ width fill, sourceSansPro ]
        [ navbar
        , hero { title = title, caption = format timezone time }
        , el containerStyles <|
            textColumn
                [ Element.htmlAttribute (Attr.class "markdown") ]
                (List.map Element.html (Markdown.toHtml Nothing content))
        , footer
        ]


navbar : Element msg
navbar =
    el
        [ width fill
        , Background.color colors.blue
        , Font.color colors.white
        , paddingXY 0 16
        ]
    <|
        row containerStyles
            [ brand
            , el [ alignRight ] <|
                row [ spacing 12, Font.size 16 ] <|
                    List.map
                        (\name ->
                            link
                                navLinkStyles
                                { url = "/" ++ name, label = text name }
                        )
                        pages
            ]


navLinkStyles =
    [ Font.underline
    ]


pages =
    [--     "about"
     -- , "blog"
     -- , "projects"
    ]


containerStyles =
    [ width (fill |> maximum 720)
    , centerX
    , paddingXY 16 0
    ]


brand =
    link [ Font.semiBold, Font.size 24 ]
        { url = "/"
        , label = text "ryan."
        }


hero : { a | title : String, caption : String } -> Element msg
hero { title, caption } =
    el
        [ Background.color colors.blue
        , Background.gradient
            { steps = [ colors.darkBlue, colors.blue ]
            , angle = 0
            }
        , Font.color colors.white
        , width fill
        , paddingXY 0 128
        ]
    <|
        textColumn ([ spacing 12 ] ++ containerStyles)
            [ paragraph
                [ Font.size 64
                , Font.semiBold
                , Region.heading 1
                ]
                [ text title ]
            , paragraph
                [ Font.size 28
                , Region.heading 2
                ]
                [ text caption ]
            ]


type alias Post =
    { title : String
    , slug : String
    , tags : List String
    , time : Time.Posix
    , content : String
    }


posts =
    [ Post
        "Big things, tiny functions"
        "big-things-tiny-functions"
        [ "javascript", "es6", "functional" ]
        (Time.millisToPosix 1539268876)
        """
## Functions can return things.

Since I gave Elm a try, I've realized that's the only thing I want my functions to do! Every now and then in JavaScript, I'll make a side effect like printing to the console, saving an item in MongoDB, or rendering something on a webpage.

But as much as possible, I try to make my JavaScript functions __take in some input__ and __return some output__.

Building big stuff is easier when you can work with one step at a time. And if those steps are tiny functions, then it's easier to confirm that things are going smoothly in an incremental way.

Let's go through a quick code challenge together: Make a function called `sluggify` that takes in an article title and returns a "slug", something we can use in the URL for that blog post.

For example:

```js
sluggify('Hello') // hello
sluggify('Hello World') // hello-world
sluggify("Elm is cool!") // elm-is-cool
```

Before I learned about `map`, `filter`, and `reduce` in JavaScript, the code I would write for this would be in one multiline function.

Now, I can write it one step at a time! Check it out:

#### Step 1: Lowercase the letters

```js
const sluggify = words =>
  words
    .toLowerCase()
```

```js
sluggify('Hello') // hello
sluggify('Hello World') // hello world
sluggify("Elm is cool!") // elm is cool!
```

#### Step 2: Remove special characters

```js
const sluggify = words =>
  words
    .toLowerCase()
    .split('')
    .filter(isLetterOrNumber)
    .join('')

const isLetterOrNumber = char => {
  const getCode = char => char.getCharCodeAt(0)
  const code = getCode(char)
  const isLetter = code >= getCode('a') && code <= getCode('z')
  const isNumber = code >= getCode('0') && code <= getCode('9')
  return isLetter || isNumber
}
```
```js
sluggify('Hello') // hello
sluggify('Hello World') // hello world
sluggify("Elm is cool!") // elm is cool
```

#### Step 3. Convert spaces to dashes

```js
const sluggify = words =>
  words
    .toLowerCase()
    .split('')
    .filter(isLetterOrNumber)
    .join('')
    .split(' ').filter(notEmpty).join('-')

const isLetterOrNumber = char => {
  const getCode = char => char.getCharCodeAt(0)
  const code = getCode(char)
  const isLetter = code >= getCode('a') && code <= getCode('z')
  const isNumber = code >= getCode('0') && code <= getCode('9')
  return isLetter || isNumber
}

const notEmpty = char => char.length > 0
```

```js
sluggify('Hello') // hello
sluggify('Hello World') // hello-world
sluggify("Elm is cool!") // elm-is-cool
```

And that's it! By breaking things down into small steps that just take input and return output, it's really easy to build bigger things!

Give map, filter, and reduce a try! They're unfamiliar at first, but they really simplify the way you write functions in your JavaScript application.
```
"""
    , Post
        "New site, new life!"
        "new-site-new-life"
        [ "elm", "web", "project" ]
        (Time.millisToPosix 1539137597759)
        """
## Elm is neat.

I just built this entire site with it! Alright, I guess there's a bit of HTML, CSS, and JS too. But that's just the glue to attach the Elm to everything.

_The coolest part?_ I built all of this with almost zero CSS! Using the `elm-ui` package, I was able to layout this page in terms of normal things, like "rows" and "columns". Not "divs" and "spans".

Let's take a look at what the homepage hero looks like in Elm UI:

```elm
hero =
    column
        [ padding 32
        , Font.color white
        , Background.color blue
        ]
        [ text "ryan."
        , text "i like coding things!"
        ]
```

In Elm UI, when I want things to stack I can use a `column`. When I want things side-by-side, I use a `row`. Behind the scenes, everything compiles to the cross-browser supported CSS.

No more debugging any IE 11 CSS issues!

On top of that, it's really easy to keep track of colors used across the site because you can share variables between Elm (unlike variables across HTML, JS and CSS).

```elm
white : Color
white =
    rgb 1 1 1

blue : Color
blue =
    rgb255 0 100 175

hero : Element a
hero =
    column
        [ padding 32
        , Font.color white
        , Background.color blue
        ]
        [ text "ryan."
        , text "i like coding things!"
        ]
```

With elm, making something like `hero` a partial that can take in different kinds of inputs is super-easy too. This is because everything in Elm is already a function. We can pass in the title and caption as string inputs!


```elm
white : Color
white =
    rgb 1 1 1

blue : Color
blue =
    rgb255 0 100 175

type alias HeroContent =
    { title : String
    , caption : String
    }

hero : HeroContent -> Element a
hero content =
    column
        [ padding 32
        , Font.color white
        , Background.color blue
        ]
        [ text content.title
        , text content.caption
        ]

homepageHero : Element a
homepageHero =
    hero
        { title = "ryan."
        , caption = "i like coding things!"
        }

blogDetailHero : BlogPost -> Element a
blogDetailHero post =
    hero
        { title = post.title
        , caption = post.date
        }
```

If you want to learn more, check out [the repo here](https://github.com/mdgriffith/elm-ui)! Building websites without CSS is a great way to learn Elm's non-C-style syntax!

"""
    ]


latestPosts : Zone -> Element msg
latestPosts timezone =
    el ([] ++ containerStyles) <|
        textColumn [ paddingXY 0 64, spacing 36 ]
            [ el [ Region.heading 3, Font.size 48, Font.semiBold ] (text "Latest posts")
            , column [ spacing 24 ] (List.map (viewPostListing timezone) posts)
            ]


viewPostListing : Zone -> Post -> Element msg
viewPostListing timezone post =
    link
        [ paddingXY 32 16
        , width fill
        , Border.width 1
        , Border.rounded 4
        , Border.color colors.lightGray
        , mouseOver
            [ Border.shadow
                { offset = ( 0, 4 )
                , size = 2
                , blur = 8
                , color = colors.lightGray
                }
            ]
        , Element.htmlAttribute
            (Attr.style
                "transition"
                "box-shadow 300ms ease-in-out"
            )
        ]
        { url = "/blog/" ++ post.slug
        , label =
            column [ paddingXY 0 16, spacing 8 ]
                [ el
                    [ Font.size 24
                    , Font.semiBold
                    ]
                    (text post.title)
                , el [ Font.color colors.darkGray ] (text (format timezone post.time))
                ]
        }


format : Zone -> Time.Posix -> String
format zone =
    DateFormat.format
        [ DateFormat.monthNameFull
        , DateFormat.text " "
        , DateFormat.dayOfMonthSuffix
        , DateFormat.text ", "
        , DateFormat.yearNumber

        -- , DateFormat.text " at "
        -- , DateFormat.hourNumber
        -- , DateFormat.text ":"
        -- , DateFormat.minuteFixed
        -- , DateFormat.amPmLowercase
        ]
        zone


linkStyles =
    [ Font.color colors.blue
    , mouseOver
        [ alpha 0.75
        ]
    ]


footer : Element msg
footer =
    el containerStyles <|
        row
            [ Font.size 16
            , paddingXY 0 32
            , width fill
            ]
            [ text "Built by Ryan, made with "
            , newTabLink linkStyles { url = "https://elm-lang.org", label = text "Elm!" }
            , row [ spacing 16, alignRight ]
                [ newTabLink linkStyles
                    { url = "https://www.github.com/ryannhg", label = text "Github" }
                , newTabLink linkStyles
                    { url = "https://www.twitter.com/ryan_nhg", label = text "Twitter" }
                ]
            ]
