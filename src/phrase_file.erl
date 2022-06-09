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


-module(phrase_file).


-export([consult/1]).


consult(Filename) ->
    case file:open(Filename, [read]) of
        {ok, FD} ->
            R = consult_stream(FD),
            _ = file:close(FD),
            R;

        Error ->
            Error
    end.


consult_stream(FD) ->
    ?FUNCTION_NAME(FD, 1, []).

consult_stream(FD, Location, A) ->
    case io:scan_erl_exprs(FD, '', Location) of
        {ok, Tokens, EndLocation} ->
            case erl_parse:parse_exprs(Tokens) of
                {ok, Expressions} ->
                    ?FUNCTION_NAME(
                       FD,
                       EndLocation,
                       [phrase_exprs:eval(#{expressions => Expressions}) | A]);

                {error, _} ->
                    error(badarg, [not_good])
            end;

        {eof, _}  ->
            lists:reverse(A)
    end.
