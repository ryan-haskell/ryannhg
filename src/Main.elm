module Main exposing (Model, Msg, update, view, subscriptions, init)

import Html exposing (..)
import Navigation exposing (Location)
import Routes
import Pages.Home
import Types exposing (Page(..))


main : Program Never Model Msg
main =
    Navigation.program
        HandleLocation
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { page : Types.Page
    }


type Msg
    = HandleLocation Location
    | HomepageMsg Pages.Home.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleLocation location ->
            { model | page = Routes.page location } ! []

        HomepageMsg msg ->
            model ! []


view : Model -> Html Msg
view model =
    case model.page of
        Homepage ->
            Html.map HomepageMsg Pages.Home.view

        NotFound ->
            div [] [ text "Not found." ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : Location -> ( Model, Cmd Msg )
init location =
    ( Model (Routes.page location), Cmd.none )
