module Form exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)

type alias Model = {formTitle : String, questions: List Question, currentQuestion: Question}

type alias Question = {question: String}

type Msg =
    Title String
  | QuestionText String
  | AddQuestion


init : (Model, Cmd Msg)
init = {formTitle = "", questions = [], currentQuestion = initQuestion} ! []

initQuestion : Question
initQuestion = Question ""

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Title formTitle -> {model | formTitle = formTitle} ! []
    QuestionText question -> {model | currentQuestion = Question question} ! []
    AddQuestion -> {model | questions = model.questions ++ [model.currentQuestion], currentQuestion = initQuestion} ! []

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

view : Model -> Html Msg
view model =
  div []
    [ p [] [text <| "New Form: " ++ getTitle model.formTitle]
    , input [onInput Title, placeholder "Title of the form"] []
    , p [] [text "Questions"]
    , questionFormView model
    , p [] [text <| "Number of questions: " ++ (toString <| List.length model.questions)]
    ]

getTitle: String -> String
getTitle title =
  if String.isEmpty title then
    "No Title Yet"
  else
    title

questionFormView : Model -> Html Msg
questionFormView model =
  div []
    [ label [] [text "Question"]
    , input [onInput QuestionText, placeholder "Question", value <| getQuestionValue model.currentQuestion] []
    , button [onClick AddQuestion] [text "Add question"]
    ]

getQuestionValue : Question -> String
getQuestionValue question = question.question

main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
