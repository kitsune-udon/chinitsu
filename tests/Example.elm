module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Main exposing (machi)
import Test exposing (..)


tehai : List Int
tehai =
    [ 1, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 9 ]


suite : Test
suite =
    describe "Always Pass Tests"
        [ test "Churen" <| \_ -> machi tehai |> Expect.equal (List.range 1 9)
        ]
