-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/user_input/buttons.html


module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import String exposing (length)
import Regex exposing (..)


main : Program Never Model Msg
main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { name : String
    , age : Int
    , password : String
    , passwordAgain : String
    , validation : String
    }


model : Model
model =
    Model "" 0 "" "" ""



-- UPDATE


type Msg
    = Name String
    | Age String
    | Password String
    | PasswordAgain String
    | Submit Model


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Age age ->
            { model | age = (String.toInt age) |> Result.withDefault 0 }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }

        Submit model ->
            let
                validationMessage =
                    if
                        List.foldl
                            (\test allValid ->
                                if test model then
                                    False
                                else
                                    allValid
                            )
                            True
                            validations
                    then
                        "Success!"
                    else
                        "Form not submitted. Please correct errors."
            in
                { model | validation = validationMessage }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "text", placeholder "Name", onInput Name ] []
        , input [ type_ "text", placeholder "Age", onInput Age ] []
        , input [ type_ "password", placeholder "Password", onInput Password ] []
        , input [ type_ "password", placeholder "Password", onInput PasswordAgain ] []
        , button [ onClick (Submit model) ] [ text "Submit" ]
        , viewValidation model
        , text model.validation
        ]


viewValidation : Model -> Html msg
viewValidation model =
    let
        message =
            if invalidLength model then
                "Password must be 8 char"
            else if invalidAge model then
                "Invalid Age"
            else if invalidCharacters model then
                "Bad chars"
            else if invalidMatch model then
                "Passwords don't match"
            else
                "OK"
    in
        div
            [ style
                [ ( "color"
                  , if message == "OK" then
                        "green"
                    else
                        "red"
                  )
                ]
            ]
            [ text message ]


invalidName : Model -> Bool
invalidName model =
    length model.name < 2 && length model.name /= 0


invalidLength : Model -> Bool
invalidLength model =
    length model.password < 8 && length model.password > 0


invalidCharacters : Model -> Bool
invalidCharacters model =
    not
        (Regex.contains (regex "[A-Z]") model.password
            && Regex.contains (regex "[a-z]") model.password
            && Regex.contains (regex "[0-9]") model.password
        )
        && length model.password
        /= 0


invalidMatch : Model -> Bool
invalidMatch model =
    model.password /= model.passwordAgain


invalidAge : Model -> Bool
invalidAge model =
    (model.age < 1 || model.age > 95) && model.age /= 0


validations : List (Model -> Bool)
validations =
    [ invalidLength
    , invalidCharacters
    , invalidMatch
    , invalidAge
    ]
