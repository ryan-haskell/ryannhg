module Pages.ThoughtDetail exposing (view)

import Element exposing (..)
import Elements
import Markdown
import Pages.Thoughts.ForLoopsAreUseless
import Types exposing (Thought(..))


view : Device -> Types.ThoughtMeta -> Element msg
view device thought =
    column []
        [ Elements.hero device
            { title = thought.title
            , subtitle = Elements.formatDate thought.date
            }
        , Elements.container <| el [ padding 16, width fill ] (viewContent thought)
        ]


viewThought : String -> Element msg
viewThought content =
    paragraph []
        [ Element.html <| Markdown.toHtml [] content
        ]


viewContent : Types.ThoughtMeta -> Element msg
viewContent { thought } =
    case thought of
        ForLoopsAreUseless ->
            viewThought Pages.Thoughts.ForLoopsAreUseless.content
