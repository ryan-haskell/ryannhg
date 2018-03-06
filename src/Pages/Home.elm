module Pages.Home exposing (view, Msg)

import Html exposing (Html)
import Element exposing (..)
import Element.Attributes exposing (..)
import Styles exposing (stylesheet)
import Elements exposing (container, navbar)


type Msg
    = NoOp


view : Html Msg
view =
    Element.layout stylesheet <|
        column Styles.None
            []
            [ navbar
            , container
                [ el Styles.None [] (text "Homepage")
                ]
            ]
