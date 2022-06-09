%% Copyright (c) 2022 Peter Morgan <peter.james.morgan@gmail.com>
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%% http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.


-module(phrase_exprs_test).


-import(phrase_exprs, [eval/1]).
-import(phrase_exprs, [parse_scan/1]).
-include_lib("eunit/include/eunit.hrl").


local_eval_test_() ->
    Local = fun
                (f, [X]) ->
                    X + 1
            end,

    F = fun
            (S, B) ->
                eval(#{expressions => parse_scan(S),
                       local => Local,
                       bindings => B})
        end,

    ?_assertEqual(5, F("f(4)", #{})).


non_local_eval_test_() ->
    NonLocal = fun
                   ({init, stop}, _) ->
                       denied
               end,

    F = fun
            (S, B) ->
                eval(#{expressions => parse_scan(S),
                       non_local => NonLocal,
                       bindings => B})
        end,

    ?_assertEqual(denied, F("init:stop()", #{})).


eval_test_() ->
    F = fun
            (S, B) ->
                eval(#{expressions => parse_scan(S), bindings => B})
        end,

    [?_assertEqual(4, F("2 + 2", #{})),

     ?_assertError(badarith, F("A / B", #{'A' => 2, 'B' => 0})),

     ?_assertEqual('hello_world!',
                   F("list_to_atom(A)", #{'A' => "hello_world!"})),

     ?_assertEqual(2, F("A + 1", #{'A' => 1}))].
