module Pages.NotFound exposing (view)

import Element exposing (..)
import Element.Font as Font
import Elements exposing (colors)


view : Element msg
view =
    column
        [ spacing 8 ]
        [ el [ centerX, centerY, Font.size 24 ] (text "Oops! I can't find that page.")
        , link [ centerX, centerY, Font.color colors.blue ]
            { url = "/", label = text "Back to home?" }
        ]
