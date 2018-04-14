module Pages.Thoughts exposing (thoughts, view)

import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Elements exposing (colors)
import Pages.Thoughts.ElmIsEasy as ElmIsEasy
import Types


thoughts : List Types.Post
thoughts =
    [ ElmIsEasy.post
    ]


view : Device -> Element msg
view device =
    column []
        [ Elements.hero device
            { title = "Thoughts."
            , subtitle = "A place to share ideas!"
            }
        , viewThoughts device
        ]


viewThoughts : Device -> Element msg
viewThoughts device =
    Elements.container <|
        (column [ padding 16, spacing 16 ] <|
            List.map (viewThought device) thoughts
        )


viewThought : Device -> Types.Post -> Element msg
viewThought device post =
    link
        [ Border.solid
        , Border.color colors.lightGray
        , Border.width 1
        , padding 32
        , width fill
        ]
        { url = "/thoughts/" ++ post.slug
        , label =
            column [ spacing 4, mouseOver [ moveUp 2 ] ]
                [ el [ Font.size 18 ] (text <| Elements.formatDate post.date)
                , el
                    [ Font.color colors.blue
                    , Font.size 28
                    , Font.semiBold
                    ]
                    (text post.title)
                ]
        }
