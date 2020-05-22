module Main exposing (..)

import Array
import Browser
import Html exposing (Html, button, div, h3, img, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import List exposing (..)
import Random exposing (..)
import Random.List


main : Program () Model Msg
main =
    Browser.document { init = init, subscriptions = subscriptions, update = update, view = view }


init _ =
    ( [], Cmd.none )


type alias Model =
    List Int


type Msg
    = Shuffle
    | NewFace (List Int)


tiles =
    range 1 9 |> repeat 4 |> concat


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Shuffle ->
            ( model, Random.generate NewFace (Random.List.shuffle tiles) )

        NewFace newFace ->
            ( newFace |> List.take 13 |> sort, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Browser.Document Msg
view model =
    { title = "清一色の待ち"
    , body =
        [ div [ class "container-fluid" ]
            [ div [ class "row" ] [ button [ onClick Shuffle, class "col btn btn-primary" ] [ h3 [] [ text "Shuffle" ] ] ]
            , div [ class "row card bg-light" ]
                [ div [ class "card-header" ] [ text "手牌" ]
                , div [ class "card-body" ]
                    [ div [ class "card-text" ] (displayTehai model)
                    ]
                ]
            , div [ class "row card bg-light" ]
                [ div [ class "card-header" ] [ text "答え" ]
                , div [ class "card-body" ]
                    [ div [ class "card-text" ] (displayMachi model)
                    ]
                ]
            ]
        ]
    }


toImg xs =
    let
        swap f =
            \x y -> f y x

        imgurls =
            List.map String.fromInt xs |> List.map ((++) "img/p_ss") |> List.map (swap (++) "_1.gif")
    in
    List.map (\x -> img [ src x ] []) imgurls


displayTehai model =
    toImg model


displayMachi model =
    toImg (machi model)


machi tehai =
    filter (isChinitsu tehai) (range 1 9)


isChinitsu tehai cand =
    let
        gt x i arr =
            case Array.get i arr of
                Just y ->
                    y > x

                Nothing ->
                    False

        get i arr =
            case Array.get i arr of
                Just x ->
                    x

                Nothing ->
                    0

        counting xs =
            let
                a =
                    range 1 9 |> List.map (\x -> List.filter (\y -> x == y) xs |> List.length) |> Array.fromList
            in
            if Array.toList a |> List.any (\x -> x > 4) then
                Nothing

            else
                Just a

        eyes arr =
            range 1 9 |> List.filter (\i -> gt 1 (i - 1) arr) |> List.map (\i -> Array.set (i - 1) (get (i - 1) arr - 2) arr)

        meld arrs =
            pong arrs ++ chow arrs

        pong arrs =
            let
                f arr =
                    range 1 9 |> List.filter (\i -> gt 2 (i - 1) arr) |> List.map (\i -> Array.set (i - 1) (get (i - 1) arr - 3) arr)
            in
            arrs |> List.map f |> List.concat

        chow arrs =
            let
                hasChow i arr =
                    get (i - 1) arr > 0 && get i arr > 0 && get (i + 1) arr > 0

                decl i arr =
                    Array.set i (get i arr - 1) arr

                removeChow x arr =
                    arr |> decl (x - 1) |> decl x |> decl (x + 1)

                f arr =
                    range 1 7 |> List.filter (\x -> hasChow x arr) |> List.map (\x -> removeChow x arr)
            in
            arrs |> List.map f |> List.concat
    in
    case counting (cand :: tehai) of
        Just a ->
            a |> eyes |> meld |> meld |> meld |> meld |> List.length |> (<) 0

        Nothing ->
            False
