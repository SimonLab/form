module Form exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
type alias Model = {formTitle : String}

type Msg = Title String


init : (Model, Cmd Msg)
init = Model "" ! []

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Title formTitle -> {model | formTitle = formTitle} ! []

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

view : Model -> Html Msg
view model =
  div []
    [ p [] [text <| "New Form: " ++ getTitle model.formTitle]
    , input [onInput Title, placeholder "Title of the form"] []
    ]

getTitle: String -> String
getTitle title =
  if String.isEmpty title then
    "No Title Yet"
  else
    title

main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
