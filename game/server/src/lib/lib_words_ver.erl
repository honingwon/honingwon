%%%-------------------------------------------------------------------
%%% Module  : lib_words_ver
%%% Author  : 
%%% Description : 敏感词处理
%%%-------------------------------------------------------------------
-module(lib_words_ver).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
%% -include("record.hrl").

%%-define(Macro, value).
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
-export([words_ver/1, words_filter/1]).
%%====================================================================
%% External functions
%%====================================================================
%% 敏感词处理
words_filter(Words_for_filter) -> 
	Words_List = data_words:get_words_verlist(),
	binary:bin_to_list(lists:foldl(fun(Kword, Words_for_filter)->
										   re:replace(Words_for_filter, Kword, "*", [global, caseless, {return, binary}])
								   end,
								   Words_for_filter, Words_List)).

words_ver(Words_for_ver) ->
	Words_List = data_words:get_words_verlist(),
	words_ver_i(erlang:length(Words_List), Words_List, Words_for_ver).


%%====================================================================
%% Private functions
%%====================================================================
words_ver_i(1, Words_List, Words_for_ver) -> 
    case re:run(Words_for_ver, lists:nth(1, Words_List), [caseless]) of
    	nomatch -> true;
    	_-> false
    end; 
words_ver_i(N, Words_List, Words_for_ver) ->
    case re:run(Words_for_ver, lists:nth(N, Words_List), [caseless]) of
    	nomatch -> words_ver_i(N-1, Words_List, Words_for_ver);
    	_-> false
    end.

