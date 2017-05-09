-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/random.html


module Main exposing (..)

import Html exposing (..)
import Html.Attributes
import Html.Events exposing (..)
import Random
import List
import Svg exposing (..)
import Svg.Attributes exposing (..)


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
        [ h1 [] [ Html.text (toString model.dieFace1 ++ " " ++ toString model.dieFace2) ]
        , svg
            [ width "120", height "120", viewBox "0 0 120 120", fill "white", stroke "black", strokeWidth "3", Html.Attributes.style [ ( "padding-left", "20px" ) ] ]
            (List.append
                [ rect [ x "1", y "1", width "100", height "100", rx "15", ry "15" ] [] ]
                (svgCirclesForDieFace model.dieFace1)
            )
        , button [ onClick Roll ] [ Html.text "Roll" ]
        ]


svgCirclesForDieFace : Int -> List (Svg Msg)
svgCirclesForDieFace dieFace =
    case dieFace of
        5 ->
            [ circle [ cx "10", cy "50", r "10", fill "black" ] []
            , circle [ cx "20", cy "50", r "10", fill "black" ] []
            , circle [ cx "30", cy "50", r "10", fill "black" ] []
            , circle [ cx "40", cy "50", r "10", fill "black" ] []
            , circle [ cx "50", cy "50", r "10", fill "black" ] []
            ]

        _ ->
            [ circle [ cx "9", cy "10", r "3", fill "black" ] []
            , circle [ cx "10", cy "10", r "3", fill "black" ] []
            ]
