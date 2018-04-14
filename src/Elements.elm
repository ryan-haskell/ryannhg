module Elements exposing (colors, container, footer, formatDate, hero, navbar, pageStyles)

import Color exposing (Color)
import Date exposing (Date)
import DateFormat
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Types exposing (Page(..))


type alias Colors =
    { lightGray : Color
    , white : Color
    , blue : Color
    , darkGray : Color
    }


colors : Colors
colors =
    { lightGray = Color.rgb 240 240 240
    , white = Color.white
    , blue = Color.rgb 0 150 255
    , darkGray = Color.rgb 50 50 50
    }


isActive : Page -> Page -> List (Attribute msg)
isActive currentPage page =
    if page == currentPage then
        [ Font.color colors.blue
        ]
    else
        [ Font.color colors.darkGray
        ]


container : Element msg -> Element msg
container child =
    el
        [ width <| fillBetween { min = Nothing, max = Just 720 }
        , centerX
        ]
        child


navbar : Device -> Page -> Element msg
navbar device page =
    container <|
        row
            [ Background.color colors.white
            , padding 16
            , spacing 8
            ]
            [ link
                ([ Font.semiBold
                 ]
                    ++ isActive page Homepage
                )
                { url = "/"
                , label =
                    text <|
                        if tabletUp device then
                            "ryan haskell-glatz."
                        else
                            "ryan."
                }
            , navLink page Projects "/projects" "projects."
            , navLink page Thoughts "/thoughts" "thoughts."
            ]


navLink : Page -> Page -> String -> String -> Element msg
navLink currentPage page url label =
    link
        ([ alignRight
         ]
            ++ isActive currentPage page
        )
        { url = url
        , label = text label
        }


footer : Device -> Element msg
footer device =
    container <|
        row [ paddingXY 16 32 ]
            [ el
                [ Font.size 16
                , if tabletUp device then
                    alignRight
                  else
                    centerX
                ]
              <|
                row []
                    [ text "This site is "
                    , newTabLink [ Font.color colors.blue ]
                        { url = "https://www.github.com/ryannhg/ryannhg"
                        , label = text "open source"
                        }
                    , text " and built with elm!"
                    ]
            ]


type alias Hero =
    { title : String
    , subtitle : String
    }


tabletUp : Device -> Bool
tabletUp device =
    device.width > 720


hero : Device -> Hero -> Element msg
hero device { title, subtitle } =
    column
        [ Background.color colors.lightGray
        , paddingXY 16
            (if tabletUp device then
                64
             else
                48
            )
        , height shrink
        ]
        [ container <|
            column
                [ spacing 8
                ]
                [ el
                    [ Font.size <|
                        if tabletUp device then
                            56
                        else
                            36
                    , Font.semiBold
                    , centerX
                    ]
                    (text title)
                , el
                    [ centerX
                    , Font.size <|
                        if tabletUp device then
                            28
                        else
                            20
                    ]
                    (text subtitle)
                ]
        ]


pageStyles : List (Attribute msg)
pageStyles =
    [ Font.family
        [ Font.external
            { name = "Source Sans Pro"
            , url = "https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,400i,600,600i"
            }
        , Font.sansSerif
        ]
    , Font.color colors.darkGray
    ]


formatDate : Date -> String
formatDate =
    DateFormat.format
        [ DateFormat.monthNameFull
        , DateFormat.text " "
        , DateFormat.dayOfMonthSuffix
        , DateFormat.text ", "
        , DateFormat.yearNumber
        ]
