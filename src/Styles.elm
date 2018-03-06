module Styles exposing (stylesheet, El, Styles(..))

import Color
import Element exposing (Element)
import Style exposing (..)
import Style.Color as Color
import Style.Font as Font
import Style.Border as Border
import Style.Transition as Transition


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
    , Font.underline
    , Font.size 18
    , hover linkActiveStyles
    , focus linkActiveStyles
    ]


stylesheet : Stylesheet
stylesheet =
    Style.styleSheet
        [ style None []
        , style Link linkStyles
        , style Brand
            (linkStyles ++ [ Font.size 28 ])
        , style Header
            [ Color.background Color.white
            , Color.border <| Color.rgb 200 200 200
            , Border.bottom 1
            ]
        ]


type Variation
    = NoVariation


type alias Stylesheet =
    StyleSheet Styles Variation


type alias El msg =
    Element Styles Variation msg


type Styles
    = None
    | Header
    | Brand
    | Link
