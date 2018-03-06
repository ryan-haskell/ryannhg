module Pages.Home exposing (view, Msg)

import Html exposing (Html)
import Element exposing (..)
import Element.Attributes exposing (..)
import Styles exposing (stylesheet)
import Elements exposing (..)
import Types


type Msg
    = NoOp


view : Html Msg
view =
    Element.layout stylesheet <|
        column Styles.App
            []
            [ navbar
            , heroWithLink
                { header = "Hi, I'm Ryan."
                , subheader = "And I like coding things."
                , cta =
                    { label = "Prove it, you nerd!"
                    , link = "#/projects"
                    }
                }
            , blogListing
                { title = "Latest thoughts"
                , posts =
                    [ Types.Post
                        "Elm is Awesome, and So Are You"
                        "#/thoughts/elm-is-awesome-and-so-are-you"
                        "Monday - March 5th, 2018"
                    , Types.Post
                        "Making Promises Worth Keeping"
                        "#/thoughts/making-promises-worth-keeping"
                        "Monday - March 3rd, 2018"
                    ]
                }
            , el Styles.None [ paddingTop 32 ] (empty)
            , Elements.footer
            ]
