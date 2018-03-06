module Pages.Home exposing (view, Msg)

import Html exposing (..)


type Msg
    = NoOp


view : Html Msg
view =
    div [] [ text "Homepage" ]
