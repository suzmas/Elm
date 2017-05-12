module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import String exposing (length)
import Regex exposing (..)


-- MODEL


type alias Model =
    { topic : String
    , gifURL : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "cats" "waiting.gif", Cmd.none )



-- UPDATE


type Msg
    = MorePlease
    | NewGif (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text model.topic ]
        , img [ src model.gifURL ] []
        , button [ onClick MorePlease ] [ text "More Please" ]
        ]
