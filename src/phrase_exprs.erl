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


-module(phrase_exprs).


-export([eval/1]).
-export([parse/1]).
-export([parse_scan/1]).
-export([scan/1]).


parse_scan(Expressions) ->
    parse(scan(Expressions)).


parse(Tokens) ->
    case erl_parse:parse_exprs(Tokens) of
        {ok, Expressions} ->
            Expressions;

        {error, _} ->
            error(badarg, [Tokens])
    end.


scan(S) ->
    case erl_scan:string(S) of
        {ok, Tokens, _} ->
            ensure_dot_terminated(Tokens);

        {error, _, _} ->
            error(badarg, [S])
    end.


ensure_dot_terminated(Tokens) ->
    case lists:last(Tokens) of
        {dot, _} ->
            Tokens;

        _ ->
            Tokens ++ [{dot, 1}]
    end.


eval(#{expressions := Expressions,
       bindings := Bindings,
       local := LocalFunctions,
       non_local := NonLocalFunctions}) ->

        {value, Result, _} = erl_eval:exprs(
                               Expressions,
                               Bindings,
                               function_handler(LocalFunctions),
                               function_handler(NonLocalFunctions)),
        Result;


eval(#{expressions := _} = Parameters) ->
    ?FUNCTION_NAME(
       maps:merge(
         #{bindings => erl_eval:new_bindings(),
           local => none,
           non_local => none},
         Parameters)).


function_handler(none) ->
    none;

function_handler(F) when is_function(F) ->
    {value, F}.
