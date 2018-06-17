module Index exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)

type Model = Nothing

type Msg = None

init : (Model, Cmd Msg)
init = Nothing ! []

update : Msg -> Model -> (Model, Cmd Msg)
update None model = model ! []

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

view : Model -> Html Msg
view model =
  div []
    [ p [] [text "Create your own forms!"]
    , a [href "/form/new"] [text "Create new form"]
    ]


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
