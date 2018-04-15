module Pages.ThoughtDetail exposing (view)

import Element exposing (..)
import Elements
import Pages.Thoughts.ElmIsSimple
import Types exposing (Thought(..))


view : Device -> Types.ThoughtMeta -> Element msg
view device thought =
    column []
        [ Elements.hero device
            { title = thought.title
            , subtitle = thought.description
            }
        , Elements.container <| el [ padding 16, width fill ] (viewContent device thought)
        ]


viewContent : Device -> Types.ThoughtMeta -> Element msg
viewContent device thought =
    case thought.thought of
        ElmIsSimple ->
            Pages.Thoughts.ElmIsSimple.view device thought
