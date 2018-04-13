module Pages.NotFound exposing (view)

import Element exposing (..)


view : Element msg
view =
    column
        []
        [ el [] (text "Page Not Found!")
        ]
