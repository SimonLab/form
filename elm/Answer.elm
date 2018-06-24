module Answer exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Dict exposing (..)


-- The Flags and Model modules should not depend on each other.
-- https://github.com/NoRedInk/elm-style-guide/blob/master/README.md


type alias Flags =
    { title : String, questions : List QuestionFlags }


type alias QuestionFlags =
    { question : String, answers : List AnswerFlags }


type alias AnswerFlags =
    { answer_id : Int, answer : String, question_id : Int }


type alias Model =
    { title : String, questions : List Question, replies : Replies }


type alias Question =
    { question : String, answers : List Answer }


type alias Answer =
    { answerId : Int, answer : String, questionId : Int }


type alias Replies =
    Dict Int Int


type Msg
    = SelectAnswer Int Int
    | Submit


init : Flags -> ( Model, Cmd Msg )
init flags =
    Model flags.title (initQuestions flags.questions) Dict.empty ! []


initQuestions : List QuestionFlags -> List Question
initQuestions questions =
    List.map (\q -> Question q.question (initAnswers q.answers)) questions


initAnswers : List AnswerFlags -> List Answer
initAnswers answers =
    List.map (\a -> Answer a.answer_id a.answer a.question_id) answers


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectAnswer question answer ->
            let
                replies =
                    Dict.insert question answer model.replies
            in
                { model | replies = replies } ! []

        Submit ->
            model ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ text model.title
        , viewQuestions model.questions
        , button [ onClick Submit ] [ text "Submit" ]
        ]


viewQuestions : List Question -> Html Msg
viewQuestions questions =
    div [] (List.map renderQuestion questions)


renderQuestion : Question -> Html Msg
renderQuestion question =
    div []
        [ text question.question
        , viewAnswers question.answers
        ]


viewAnswers : List Answer -> Html Msg
viewAnswers answers =
    div [] (List.map renderAnswer answers)


renderAnswer : Answer -> Html Msg
renderAnswer answer =
    span []
        [ input [ type_ "radio", name (toString answer.questionId), onClick (SelectAnswer answer.questionId answer.answerId) ] []
        , label [] [ text answer.answer ]
        ]


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
