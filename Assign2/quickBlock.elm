import Html exposing (..)
import Html.Attributes
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (onClick)
import Mouse exposing (..)
import Random exposing (..)
import Task exposing (..)
import Time exposing (..)
import Round

type alias Model =
  {
    boxPosition : {x : Int, y : Int},
    mousePosition : {x : Int, y : Int},
    counter : Int,
    rectWidth : Int,
    rectHeight : Int,
    startTime : Time,
    endTime : Time,
    prevPosition : {x : Int, y : Int},
    distance : Float,
    finished : Bool
  }

type Msg
  = MouseMsg Mouse.Position
  | NewWidth Int
  | NewHeight Int
  | NewBoxX Int
  | NewBoxY Int
  | Tick Time
  | OnTime Time
  | RestartGame

init : (Model, Cmd Msg)
init = ({
         boxPosition = {x = 0, y = 0},
         mousePosition = {x = 0, y = 0},
         counter = 0,
         rectWidth = 50,
         rectHeight = 50,
         startTime = 0.0,
         endTime = 0.0,
         prevPosition = {x = 0, y = 0}, -- Used to calculate distances, which is used to calculare a score
         distance = 0.0,
         finished = False
         },
         Cmd.batch
          [Random.generate NewWidth (Random.int 25 50),
           Random.generate NewHeight (Random.int 25 50),
           Random.generate NewBoxX (Random.int 50 700),
           Random.generate NewBoxY (Random.int 50 700)])

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MouseMsg pos ->
      if (model.mousePosition.x >= model.boxPosition.x)
      && (model.mousePosition.x <= (model.boxPosition.x + model.rectWidth))
      && (model.mousePosition.y >= model.boxPosition.y)
      && (model.mousePosition.y <= (model.boxPosition.y + model.rectHeight)) then
        if model.counter == 0 then
          ({model | prevPosition = {x = model.boxPosition.x, y = model.boxPosition.y}, mousePosition = {x = pos.x, y = pos.y}, counter = model.counter + 1}
          , Cmd.batch
            [Random.generate NewWidth (Random.int 25 50),
             Random.generate NewHeight (Random.int 25 50),
             Random.generate NewBoxX (Random.int 50 700),
             Random.generate NewBoxY (Random.int 50 700),
             Task.perform OnTime (Time.now)])
        else if (model.counter < 9) then
          ({model | distance = model.distance + abs((sqrt(toFloat (model.boxPosition.x ^ 2 + model.boxPosition.y ^ 2)) - sqrt(toFloat(model.prevPosition.x ^ 2 + model.prevPosition.y ^ 2)))), mousePosition = {x = pos.x, y = pos.y}, counter = model.counter + 1}
          , Cmd.batch
            [Random.generate NewWidth (Random.int 25 50),
             Random.generate NewHeight (Random.int 25 50),
             Random.generate NewBoxX (Random.int 50 700),
             Random.generate NewBoxY (Random.int 50 700)])
          else if (model.counter == 9) then
            ({model | distance = model.distance + abs((sqrt(toFloat (model.boxPosition.x ^ 2 + model.boxPosition.y ^ 2)) - sqrt(toFloat(model.prevPosition.x ^ 2 + model.prevPosition.y ^ 2)))), mousePosition = {x = pos.x, y = pos.y}, counter = model.counter + 1, finished = True}
            , Cmd.batch
              [Random.generate NewWidth (Random.int 25 50),
               Random.generate NewHeight (Random.int 25 50),
               Random.generate NewBoxX (Random.int 50 700),
               Random.generate NewBoxY (Random.int 50 700)])
          else
            ({model | prevPosition = {x =  model.boxPosition.x, y = model.boxPosition.y}, mousePosition = {x = pos.x, y = pos.y}, counter = model.counter + 1}
            , Cmd.batch
              [Random.generate NewWidth (Random.int 25 50),
               Random.generate NewHeight (Random.int 25 50),
               Random.generate NewBoxX (Random.int 50 700),
               Random.generate NewBoxY (Random.int 50 700)])
      else
        ({model | mousePosition = {x = pos.x, y = pos.y}}, Cmd.none)
    NewWidth val ->
      ({model | rectWidth = val}, Cmd.none)
    NewHeight val ->
      ({model | rectHeight = val}, Cmd.none)
    NewBoxX val ->
      ({model | boxPosition = {x = val, y = model.boxPosition.y}}, Cmd.none)
    NewBoxY val ->
      ({model | boxPosition = {x = model.boxPosition.x, y = val}}, Cmd.none)
    Tick time ->
      ({model | endTime = (time / 1000)}, Cmd.none)
    OnTime time ->
      ({model | startTime = (time / 1000)}, Cmd.none)
    RestartGame ->
      ({model | distance = 0, counter = 0, startTime = 0.0, endTime = 0.0, finished = False}
      , Cmd.batch
        [Random.generate NewWidth (Random.int 25 50),
         Random.generate NewHeight (Random.int 25 50),
         Random.generate NewBoxX (Random.int 50 700),
         Random.generate NewBoxY (Random.int 50 700)])

subscriptions : Model -> Sub Msg
subscriptions model =
  if model.counter > 0 && model.counter < 10 then
    Sub.batch [Mouse.moves MouseMsg, every millisecond Tick]
  else
    Mouse.moves MouseMsg

view : Model -> Html Msg
view model =
  if (model.counter < 10) then
    let
      posX = toString model.boxPosition.x
      posY = toString model.boxPosition.y
      rectWidth = toString model.rectWidth
      rectHeight = toString model.rectHeight
      points = toString model.counter
      timer = Round.round 3 (model.endTime - model.startTime)
      score = Round.round 3 (model.distance / (model.endTime - model.startTime))
    in div []
       [
         svg [width "750", height "750"]
           [
             rect [x posX, y posY, width rectWidth,  height rectHeight, fill "red"] []
           , text_ [x "25", y "25", fontSize "20"] [Html.text points]
           , text_ [x "70", y "25", fontSize "25"] [Html.text score]
           ]
       , h2 [] [Html.text "How to Play:"]
       , p [] [Html.text "It's really simple, the goal is to move your cursor on the blocks as quickly as possible. The timer starts as soon as the first block is hit, and continues until the 10th block you swipe over. Don't worry about the randomness, the score calculated is dependent on the time and distance between blocks, so you won't be punished for being unlucky!"]
       , p [] [Html.text "Made by Nicholas Aksamit as a project for the COMPSCI 1XA3 course using the Elm language. Please do not copy. 2018."]
       ]
  else
    let
      posX = toString model.boxPosition.x
      posY = toString model.boxPosition.y
      rectWidth = toString model.rectWidth
      rectHeight = toString model.rectHeight
      points = toString model.counter
      timer = Round.round 3 (model.endTime - model.startTime)
      score = Round.round 3 (model.distance / (model.endTime - model.startTime))
    in div []
       [
         svg [width "750", height "750"]
           [
             rect [x posX, y posY, width rectWidth,  height rectHeight, fill "red"] []
           , text_ [x "25", y "25", fontSize "20"] [Html.text points]
           , text_ [x "400", y "200" ,fontSize "45"] [Html.text "QuickBlock"]
           , text_ [x "400", y "275", fontSize "35"] [Html.text ("Time: " ++ timer)]
           , text_ [x "400", y "350", fontSize "35"] [Html.text ("Score: " ++ score)]
           , Svg.a [onClick RestartGame]
             [
               text_ [x "400", y "425", fontSize "35"] [Html.text "Restart"]
             ]
           ]
       , h2 [] [Html.text "How to Play:"]
       , p [] [Html.text "It's really simple, the goal is to move your cursor on the blocks as quickly as possible. The timer starts as soon as the first block is hit, and continues until the 10th block you swipe over. Don't worry about the randomness, the score calculated is dependent on the time and distance between blocks, so you won't be punished for being unlucky!"]
       , p [] [Html.text "Made by Nicholas Aksamit as a project for the COMPSCI 1XA3 course using the Elm language. Please do not copy. 2018."]
       , p [] [Html.text "~Bread"]
       ]

main : Program Never Model Msg
main = Html.program
        {
          init = init,
          view = view,
          update = update,
          subscriptions = subscriptions
        }
