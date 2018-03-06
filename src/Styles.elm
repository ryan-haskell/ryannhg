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
            (linkStyles
                ++ [ Font.underline
                   ]
            )
        , style Brand
            (linkStyles
                ++ [ Font.size 28
                   , Font.weight 600
                   ]
            )
        , style Header
            [ Color.background Color.white
            , Color.border <| Color.rgb 230 230 230
            , Border.bottom 1
            ]
        , style Footer
            [ Color.background Color.white
            , Color.border <| Color.rgb 230 230 230
            , Border.top 1
            ]
        , style Hero
            [ Color.background <| Color.rgb 240 240 240
            , Color.text <| Color.rgb 30 30 30
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
            [ Transition.all
            , Color.background <| Color.rgb 0 150 200
            , Color.text <| Color.white
            , Font.weight 400
            , Border.rounded 4
            , hover
                [ Color.background <| Color.rgba 0 150 200 0.8
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
            [ Color.text <| Color.rgb 30 30 30
            , Font.size 20
            ]
        ]


linkActiveStyles : List (Style.Property class variation)
linkActiveStyles =
    [ Color.text <| Color.rgb 30 30 30
    ]


linkStyles : List (Style.Property class variation)
linkStyles =
    [ Transition.transitions
        [ { delay = 0
          , duration = 300
          , easing = "ease-in-out"
          , props = [ "color" ]
          }
        ]
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
