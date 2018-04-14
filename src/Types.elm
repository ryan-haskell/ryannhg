module Types exposing (..)

import Date exposing (Date)


type Page
    = Homepage
    | Projects
    | Thoughts
    | NotFound


type alias Post =
    { title : String
    , date : Date
    , slug : String
    , description : String
    }
