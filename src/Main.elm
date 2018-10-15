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
import Posts exposing (Post, posts)
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
blogDetailPage { timezone } post =
    column
        [ width fill, sourceSansPro ]
        [ navbar
        , hero { title = post.title, caption = format timezone post.time }
        , el containerStyles <| Posts.view post
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
            [ text "Built by Ryan, "
            , newTabLink linkStyles { url = "https://www.github.com/ryannhg/ryannhg", label = text "made with Elm!" }
            , row [ spacing 16, alignRight ]
                [ newTabLink linkStyles
                    { url = "https://www.github.com/ryannhg", label = text "Github" }
                , newTabLink linkStyles
                    { url = "https://www.twitter.com/ryan_nhg", label = text "Twitter" }
                ]
            ]
