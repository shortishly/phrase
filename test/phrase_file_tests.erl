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


-module(phrase_file_tests).


-include_lib("eunit/include/eunit.hrl").


file_consult_test_() ->
    ?_assertMatch({error, _}, file:consult("test/phrase.terms")).


consult_test_() ->
    ?_assertEqual([abc, 4, "hello_world!", 9],
                  phrase_file:consult("test/phrase.terms")).
