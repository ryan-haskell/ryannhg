module Types exposing (..)


type Page
    = Homepage
    | NotFound


type alias Post =
    { title : String
    , url : String
    , date : String
    }
