module Main exposing (main)

import Element exposing (..)
import Elements
import Navigation exposing (Location)
import Pages.Home
import Pages.NotFound
import Pages.Projects
import Pages.Thoughts
import Routes
import Task
import Types exposing (Page(..))
import Window


main : Program Never Model Msg
main =
    Navigation.program
        HandleLocation
        { init = init
        , view = view >> layout []
        , update = update
        , subscriptions = always (Window.resizes OnResize)
        }


type alias Model =
    { location : Location
    , device : Maybe Element.Device
    }


type Msg
    = HandleLocation Location
    | OnResize Window.Size


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleLocation location ->
            { model | location = location } ! []

        OnResize size ->
            { model | device = Just (Element.classifyDevice size) } ! []


view : Model -> Element Msg
view model =
    case model.device of
        Just device ->
            column
                Elements.pageStyles
                [ Elements.navbar device (Routes.page model.location)
                , el [ height fill, width fill ] (viewPage device model)
                , Elements.footer device
                ]

        Nothing ->
            empty


viewPage : Device -> Model -> Element Msg
viewPage device model =
    case Routes.page model.location of
        Homepage ->
            Pages.Home.view device

        Projects ->
            Pages.Projects.view device

        Thoughts ->
            Pages.Thoughts.view device

        NotFound ->
            Pages.NotFound.view


init : Location -> ( Model, Cmd Msg )
init location =
    ( Model location Nothing, Task.perform OnResize Window.size )
