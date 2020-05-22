module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


suite : Test
suite =
    describe "Always Pass Tests" [ test "Tort" <| \_ -> True |> Expect.equal True ]
