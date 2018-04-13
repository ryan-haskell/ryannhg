module Types exposing (..)


type Page
    = Homepage
    | Projects
    | Thoughts
    | NotFound


type alias Post =
    { title : String
    , url : String
    , date : String
    }
