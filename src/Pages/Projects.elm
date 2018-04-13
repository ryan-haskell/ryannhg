module Pages.Projects exposing (view)

import Element exposing (..)
import Elements


view : Device -> Element msg
view device =
    Elements.hero device
        { title = "Projects."
        , subtitle = "Here's what I've been up to!"
        }
