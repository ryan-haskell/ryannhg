module Styles exposing (stylesheet, El, Styles(..))

import Color
import Element exposing (Element)
import Style exposing (..)
import Style.Color as Color
import Style.Font as Font
import Style.Border as Border
import Style.Transition as Transition


type Styles
    = None
    | App
    | Header
    | Footer
    | Brand
    | Link
    | Hero
    | HeroHeader
    | HeroSubheader
    | Button
    | Section
    | SectionHeader
    | Listing
    | ListingHeader
    | ListingSubheader
    | Copyright


darkGray : Color.Color
darkGray =
    Color.rgb 30 30 30


lightGray : Color.Color
lightGray =
    Color.rgb 240 240 240


blue : Color.Color
blue =
    Color.rgb 0 150 200


stylesheet : Stylesheet
stylesheet =
    Style.styleSheet
        [ style None []
        , style App
            [ Font.typeface
                [ Font.importUrl
                    { url = "https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,300i,400,400i,600"
                    , name = "Source Sans Pro"
                    }
                ]
            , Font.weight 300
            ]
        , style Link
            (linkStyles)
        , style Brand
            (linkStyles
                ++ [ Font.size 28
                   , Font.weight 600
                   ]
            )
        , style Header
            [ Color.background Color.white
            , Color.border <| lightGray
            , Border.bottom 1
            ]
        , style Footer
            [ Color.background Color.white
            , Color.border lightGray
            , Border.top 1
            ]
        , style Hero
            [ Color.background lightGray
            , Color.text darkGray
            ]
        , style HeroHeader
            [ Font.size 56
            , Font.weight 600
            ]
        , style HeroSubheader
            [ Font.size 28
            , Font.lowercase
            ]
        , style Button
            [ transition [ "background-color" ]
            , Color.background blue
            , Color.text Color.white
            , Font.weight 600
            , Border.rounded 4
            , Font.size 18
            , hover
                [ Color.background darkGray
                ]
            ]
        , style Section
            []
        , style SectionHeader
            [ Font.size 48
            , Font.weight 600
            ]
        , style Listing []
        , style ListingHeader
            (linkStyles
                ++ [ Font.size 32
                   , Font.weight 600
                   ]
            )
        , style ListingSubheader
            [ Font.size 24 ]
        , style Copyright
            [ Color.text darkGray
            , Font.size 20
            ]
        ]


linkActiveStyles : List (Style.Property class variation)
linkActiveStyles =
    [ Color.text darkGray
    ]


transition : List String -> Property class variation
transition props =
    Transition.transitions
        [ { delay = 0
          , duration = 300
          , easing = "ease-in-out"
          , props = props
          }
        ]


linkStyles : List (Style.Property class variation)
linkStyles =
    [ transition [ "color" ]
    , Color.text <| Color.rgb 0 150 200
    , Font.size 20
    , hover linkActiveStyles
    , focus linkActiveStyles
    ]


type Variation
    = NoVariation


type alias Stylesheet =
    StyleSheet Styles Variation


type alias El msg =
    Element Styles Variation msg
