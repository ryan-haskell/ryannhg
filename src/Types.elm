module Types exposing (..)

import Date exposing (Date)


type Page
    = Homepage
    | Projects
    | Thoughts
    | ThoughtDetail ThoughtMeta
    | NotFound


type Thought
    = ElmIsSimple


type alias ThoughtMeta =
    { title : String
    , date : Date
    , slug : String
    , description : String
    , thought : Thought
    }
