module Pages.Thoughts exposing (thoughts, view)

import Date exposing (Date)
import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Elements exposing (colors)
import Types


parseDate : String -> Date
parseDate string =
    case Date.fromString string of
        Ok date ->
            date

        Err reason ->
            Debug.crash ("Could not format: " ++ string)


thoughts : List Types.ThoughtMeta
thoughts =
    [ { title = "Elm is simple."
      , date = parseDate "2018-04-14T20:36:18"
      , description = "And you are smart!"
      , slug = "elm-is-simple"
      , thought = Types.ElmIsSimple
      }
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


viewThought : Device -> Types.ThoughtMeta -> Element msg
viewThought device thought =
    link
        [ Border.solid
        , Border.color colors.lightGray
        , Border.width 1
        , padding 32
        , width fill
        ]
        { url = "/thoughts/" ++ thought.slug
        , label =
            column [ spacing 4, mouseOver [ moveUp 2 ] ]
                [ el [ Font.size 18 ] (text <| Elements.formatDate thought.date)
                , el
                    [ Font.color colors.blue
                    , Font.size 28
                    , Font.semiBold
                    ]
                    (text thought.title)
                ]
        }
