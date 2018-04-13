module Routes exposing (page, parse)

import Navigation exposing (Location)
import Types exposing (Page(..))
import UrlParser exposing (Parser)


route : Parser (Page -> Page) Page
route =
    UrlParser.oneOf
        [ UrlParser.map Homepage <| UrlParser.top
        , UrlParser.map Projects <| UrlParser.s "projects"
        , UrlParser.map Thoughts <| UrlParser.s "thoughts"
        ]


page : Location -> Page
page location =
    case parse location of
        Just page ->
            page

        Nothing ->
            NotFound


parse : Location -> Maybe Page
parse location =
    UrlParser.parsePath route location
