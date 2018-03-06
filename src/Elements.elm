module Elements exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Styles exposing (El)


navbar : El msg
navbar =
    el Styles.Header [] <|
        container
            [ row Styles.None
                [ width fill
                , verticalCenter
                , paddingXY 0 12
                ]
                [ link "/" <|
                    el Styles.Brand [ paddingRight 0 ] (text "ryan")
                , row Styles.None
                    [ width fill
                    , spacing 12
                    , alignRight
                    ]
                    [ newTab "https://www.github.com/ryannhg" <|
                        el Styles.Link [] (text "github")
                    , newTab "https://www.twitter.com/Ryan_NHG" <|
                        el Styles.Link [] (text "twitter")
                    ]
                ]
            ]


container : List (El msg) -> El msg
container innerContent =
    row Styles.None
        [ width fill, center, paddingXY 16 0 ]
        [ column Styles.None
            [ width fill, maxWidth (px 780) ]
            innerContent
        ]
