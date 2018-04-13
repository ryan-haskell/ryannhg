module Pages.Thoughts exposing (view)

import Element exposing (..)
import Elements


view : Device -> Element msg
view device =
    Elements.hero device
        { title = "Thoughts."
        , subtitle = "A place to share ideas!"
        }
