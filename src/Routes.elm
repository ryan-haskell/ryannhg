module Routes exposing (page, parse)

import Navigation exposing (Location)
import Pages.Thoughts exposing (thoughts)
import Types exposing (Page(..))
import UrlParser exposing ((</>), Parser, s, top)


route : Parser (Page -> Page) Page
route =
    UrlParser.oneOf
        [ UrlParser.map Homepage <| top
        , UrlParser.map Projects <| s "projects"
        , UrlParser.map Thoughts <| s "thoughts"
        , UrlParser.map thoughtParser <| s "thoughts" </> UrlParser.string
        ]


page : Location -> Page
page location =
    case parse location of
        Just page ->
            page

        Nothing ->
            NotFound


thoughtParser : String -> Page
thoughtParser slug =
    case getThought slug of
        Just thought ->
            ThoughtDetail thought

        Nothing ->
            NotFound


getThought : String -> Maybe Types.ThoughtMeta
getThought slug =
    thoughts
        |> List.filter (\t -> t.slug == slug)
        |> List.head


parse : Location -> Maybe Page
parse location =
    UrlParser.parsePath route location
