module Pages.Thoughts.ElmIsEasy exposing (post, view)

import Date exposing (Date)
import DateFormat
import Element exposing (..)
import Elements
import Types


post : Types.Post
post =
    { title = "Elm is easy."
    , date = parseDate "2018-04-14T20:36:18"
    , description = "And you are smart!"
    , slug = "elm-is-easy"
    }


parseDate : String -> Date
parseDate string =
    case Date.fromString string of
        Ok date ->
            date

        Err reason ->
            Debug.crash ("Could not format: " ++ string)


view : Device -> Element msg
view device =
    Elements.hero device
        { title = post.title
        , subtitle = Elements.formatDate post.date
        }
