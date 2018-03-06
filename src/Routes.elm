module Routes exposing (page)

import Types exposing (Page(..))
import Navigation exposing (Location)
import UrlParser exposing (Parser)


page : Location -> Page
page location =
    case UrlParser.parsePath route location of
        Just page ->
            page

        Nothing ->
            NotFound


route : Parser (Page -> Page) Page
route =
    UrlParser.oneOf
        [ UrlParser.map Homepage UrlParser.top
        ]
