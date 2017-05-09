-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/random.html


module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Random


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { dieFace1 : Int
    , dieFace2 : Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model 1 1, Cmd.none )


dieGenerator : Random.Generator Int
dieGenerator =
    Random.int 1 6


diePairGenerator : Random.Generator ( Int, Int )
diePairGenerator =
    Random.pair dieGenerator dieGenerator



-- UPDATE


type Msg
    = Roll
    | NewFaces ( Int, Int )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFaces diePairGenerator )

        NewFaces ( newFace1, newFace2 ) ->
            ( Model newFace1 newFace2, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text (toString model.dieFace1 ++ " " ++ toString model.dieFace2) ]
        , button [ onClick Roll ] [ text "Roll" ]
        ]
