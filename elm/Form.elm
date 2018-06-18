module Form exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Http
import Json.Decode as Json exposing (..)
import Json.Encode as Encode exposing (..)
import Json.Decode.Pipeline exposing (..)


type alias Model =
    { formTitle : String, questions : List Question, currentQuestion : Question, currentAnswer : String }


type alias Question =
    { question : String, answers : List String }


type Msg
    = Title String
    | QuestionText String
    | AnswerText String
    | AddQuestion
    | AddAnswer
    | PublishForm
    | ReplyForm (Result Http.Error Reply)


init : ( Model, Cmd Msg )
init =
    { formTitle = "", questions = [], currentQuestion = initQuestion, currentAnswer = "" } ! []


initQuestion : Question
initQuestion =
    Question "" []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Title formTitle ->
            { model | formTitle = formTitle } ! []

        QuestionText question ->
            let
                currentQuestion =
                    model.currentQuestion

                newCurrentQuestion =
                    { currentQuestion | question = question }
            in
                { model | currentQuestion = newCurrentQuestion } ! []

        AnswerText answer ->
            { model | currentAnswer = answer } ! []

        AddQuestion ->
            { model | questions = model.questions ++ [ model.currentQuestion ], currentQuestion = initQuestion } ! []

        AddAnswer ->
            let
                currentQuestion =
                    model.currentQuestion

                newCurrentQuestion =
                    { currentQuestion | answers = currentQuestion.answers ++ [ model.currentAnswer ] }
            in
                { model | currentQuestion = newCurrentQuestion, currentAnswer = "" } ! []

        PublishForm ->
            ( model, publishForm model )

        ReplyForm (Ok data) ->
            model ! []

        ReplyForm (Err err) ->
            model ! []


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text <| "New Form: " ++ getTitle model.formTitle ]
        , input [ onInput Title, placeholder "Title of the form" ] []
        , p [] [ text "Questions" ]
        , questionFormView model
        , p [] [ text <| "Number of questions: " ++ (toString <| List.length model.questions) ]
        , viewQuestions model.questions
        , button [ onClick PublishForm ] [ text "Publish form" ]
        ]


getTitle : String -> String
getTitle title =
    if String.isEmpty title then
        "No Title Yet"
    else
        title


questionFormView : Model -> Html Msg
questionFormView model =
    div []
        [ label [] [ text "Question" ]
        , input [ onInput QuestionText, placeholder "Question", Html.Attributes.value <| getQuestionValue model.currentQuestion ] []
        , showAnswers model.currentQuestion
        , answerFormView model
        , button [ onClick AddQuestion ] [ text "Add question" ]
        ]


showAnswers : Question -> Html Msg
showAnswers question =
    div []
        [ fieldset [] (List.map displayAnswer question.answers) ]


displayAnswer : String -> Html Msg
displayAnswer answer =
    label []
        [ input [ type_ "radio", disabled True ] []
        , text answer
        ]


answerFormView : Model -> Html Msg
answerFormView model =
    div []
        [ p [] [ text "Answers" ]
        , label [] [ text "Answer" ]
        , input [ onInput AnswerText, placeholder "answer", Html.Attributes.value model.currentAnswer ] []
        , button [ onClick AddAnswer ] [ text "Add answer" ]
        ]


getQuestionValue : Question -> String
getQuestionValue question =
    question.question


viewQuestions : List Question -> Html Msg
viewQuestions questions =
    div [] (List.map showQuestion questions)


showQuestion : Question -> Html Msg
showQuestion question =
    p [] [ text question.question ]


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


publishForm : Model -> Cmd Msg
publishForm model =
    let
        body =
            model
                |> formEncoder
                |> Http.jsonBody
    in
        Http.post ("/form/create") body formDecoder
            |> Http.send ReplyForm


formEncoder : Model -> Encode.Value
formEncoder model =
    Encode.object
        [ ( "title", Encode.string model.formTitle )
        , ( "questions", Encode.list <| List.map questionEncoder model.questions )
        ]


questionEncoder : Question -> Encode.Value
questionEncoder question =
    Encode.object
        [ ( "question", Encode.string question.question )
        , ( "answers", Encode.list <| List.map Encode.string question.answers )
        ]


type alias Reply =
    { ok : Bool }


formDecoder : Json.Decoder Reply
formDecoder =
    decode Reply
        |> Json.Decode.Pipeline.required
            "ok"
            Json.bool
