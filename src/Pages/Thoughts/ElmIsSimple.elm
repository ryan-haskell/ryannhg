module Pages.Thoughts.ElmIsSimple exposing (view)

import Element exposing (..)
import Elements
import Types


view : Device -> Types.ThoughtMeta -> Element msg
view device thought =
    el [] (text "Elm is simple tho.")
