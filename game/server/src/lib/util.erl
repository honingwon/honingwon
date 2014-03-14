%%%-----------------------------------
%%% @Module  : util
%%% @Author  : ygzj
%%% @Created : 2010.10.05
%%% @Description: 公共函数
%%%-----------------------------------
-module(util).
-include("common.hrl").
%% -include("record.hrl").
-compile(export_all).


%% 在List中的每两个元素之间插入一个分隔符
implode(_S, [])->
	[<<>>];
implode(S, L) when is_list(L) ->
    implode(S, L, []).
implode(_S, [H], NList) ->
    lists:reverse([thing_to_list(H) | NList]);
implode(S, [H | T], NList) ->
    L = [thing_to_list(H) | NList],
    implode(S, T, [S | L]).

%% 字符->列
explode(S, B)->
    re:split(B, S, [{return, list}]).
explode(S, B, int) ->
    [list_to_integer(Str) || Str <- explode(S, B), length(Str) > 0].

thing_to_list(X) when is_integer(X) -> integer_to_list(X);
thing_to_list(X) when is_float(X)   -> float_to_list(X);
thing_to_list(X) when is_atom(X)    -> atom_to_list(X);
thing_to_list(X) when is_binary(X)  -> binary_to_list(X);
thing_to_list(X) when is_list(X)    -> X.

%% 日志记录函数
log(T, F, _A, _Mod, _Line) ->
    {ok, Fl} = file:open("logs/error_log.txt", [write, append]),
    _Format = list_to_binary("#" ++ T ++" ~s[~w:~w] " ++ F ++ "\r\n~n"),
    {{Y, M, D},{H, I, S}} = erlang:localtime(),
    _Date = list_to_binary([integer_to_list(Y),"-", integer_to_list(M), "-", integer_to_list(D), " ", integer_to_list(H), ":", integer_to_list(I), ":", integer_to_list(S)]),
    file:close(Fl).    

%% 取得当前的unix时间戳
unixtime() ->
    {M, S, _} = misc_timer:now(),
    M * 1000000 + S.

longunixtime() ->
    {M, S, Ms} = misc_timer:now(),
    (M * 1000000000000 + S * 1000000 + Ms) div 1000.

%% 转换成HEX格式的md5
md5(S) ->
    lists:flatten([io_lib:format("~2.16.0b",[N]) || N <- binary_to_list(erlang:md5(S))]).

%% 产生一个介于Min到Max之间的随机整数
rand(Same, Same) -> 
	Same; 
rand(Min, Max) ->
    %% 如果没有种子，将从核心服务器中去获取一个种子，以保证不同进程都可取得不同的种子
    case get("rand_seed") of
        undefined ->
            RandSeed = mod_rand:get_seed(),
            random:seed(RandSeed),
            put("rand_seed", RandSeed);
        _ -> skip
    end,
    %% random:seed(erlang:now()),
    M = Min - 1,
    random:uniform(Max - M) + M.

%%向上取整
ceil(N) ->
    T = trunc(N),
    case N == T of
        true  -> T;
        false -> 1 + T
    end.

%%向下取整
floor(X) ->
    T = trunc(X),
    case (X < T) of
        true -> T - 1;
        _ -> T
    end.

 sleep(T) ->
    receive
    after T -> ok
    end.

 sleep(T, F) ->
    receive
    after T -> F()
    end.

get_list([], _) ->
    [];
get_list(X, F) ->
    F(X).

%% for循环
for(Max, Max, F) ->
    F(Max);
for(I, Max, F)   ->
    F(I),
    for(I+1, Max, F).

%% 带返回状态的for循环
%% @return {ok, State}
for(Max, Min, _F, State) when Min<Max -> 
	{ok, State};
for(Max, Max, F, State) ->F(Max, State);
for(I, Max, F, State)   -> {ok, NewState} = F(I, State), for(I+1, Max, F, NewState).


for_new(Min, Max, _F, State) when (Min > Max) -> 
	{ok, State};
for_new(Min, Max, F, State) -> 
	{ok, NewState} = F(Min, State), 
	for_new(Min+1, Max, F, NewState).


%% term序列化，term转换为string格式，e.g., [{a},1] => "[{a},1]"
term_to_string(Term) ->
    binary_to_list(list_to_binary(io_lib:format("~p", [Term]))).

%% term序列化，term转换为bitstring格式，e.g., [{a},1] => <<"[{a},1]">>
term_to_bitstring(Term) ->
    erlang:list_to_bitstring(io_lib:format("~p", [Term])).

%% term反序列化，string转换为term，e.g., "[{a},1]"  => [{a},1]
string_to_term(String) ->
    case erl_scan:string(String++".") of
        {ok, Tokens, _} ->
            case erl_parse:parse_term(Tokens) of
                {ok, Term} -> Term;
                _Err -> undefined
            end;
        _Error ->
            undefined
    end.

%% term反序列化，bitstring转换为term，e.g., <<"[{a},1]">>  => [{a},1]
bitstring_to_term(undefined) -> undefined;
bitstring_to_term(BitString) ->
    string_to_term(binary_to_list(BitString)).


%% 时间函数
%% -----------------------------------------------------------------
%% 根据1970年以来的秒数获得日期
%% -----------------------------------------------------------------
seconds_to_localtime(Seconds) ->
    DateTime = calendar:gregorian_seconds_to_datetime(Seconds+?DIFF_SECONDS_0000_1900),
    calendar:universal_time_to_local_time(DateTime).

%% -----------------------------------------------------------------
%% 判断是否同一天
%% -----------------------------------------------------------------
is_same_date(Seconds1, Seconds2) ->
    {{Year1, Month1, Day1}, _Time1} = seconds_to_localtime(Seconds1),
    {{Year2, Month2, Day2}, _Time2} = seconds_to_localtime(Seconds2),
    if ((Year1 == Year2) andalso (Month1 == Month2) andalso (Day1 == Day2)) -> 
		   true;
        true -> 
			false
    end.

%% -----------------------------------------------------------------
%% 判断是否同一天(Seconds1,Seconds1 为unix时间)
%% -----------------------------------------------------------------
is_same_date_new(Seconds1, Seconds2) ->
	N1 = tool:floor(Seconds1 / (60*60*24)),
	N2 = tool:floor(Seconds2 / (60*60*24)),
	if N1 == N2 -> 
		   true;
	   true ->
		   false
	end.

%% -----------------------------------------------------------------
%% 判断是否同一星期
%% -----------------------------------------------------------------
is_same_week(Seconds1, Seconds2) ->
    {{Year1, Month1, Day1}, Time1} = seconds_to_localtime(Seconds1),
    % 星期几
    Week1  = calendar:day_of_the_week(Year1, Month1, Day1),
    % 从午夜到现在的秒数
    Diff1  = calendar:time_to_seconds(Time1),
    Monday = Seconds1 - Diff1 - (Week1-1)*?ONE_DAY_SECONDS,
    Sunday = Seconds1 + (?ONE_DAY_SECONDS-Diff1) + (7-Week1)*?ONE_DAY_SECONDS,
    if ((Seconds2 >= Monday) and (Seconds2 < Sunday)) -> true;
        true -> false
    end.

%% -----------------------------------------------------------------
%% 获取当天0点和第二天0点
%% -----------------------------------------------------------------
get_midnight_seconds(Seconds) ->
    {{_Year, _Month, _Day}, Time} = seconds_to_localtime(Seconds),
    % 从午夜到现在的秒数
    Diff   = calendar:time_to_seconds(Time),
    % 获取当天0点
    Today  = Seconds - Diff,
    % 获取第二天0点
    NextDay = Seconds + (?ONE_DAY_SECONDS-Diff),
    {Today, NextDay}.

%% 获取下一天开始的时间
get_next_day_seconds(Now) ->
	{{_Year, _Month, _Day}, Time} = util:seconds_to_localtime(Now),
    % 从午夜到现在的秒数
   	Diff = calendar:time_to_seconds(Time),
	Now + (?ONE_DAY_SECONDS - Diff).

%% -----------------------------------------------------------------
%% 计算相差的天数
%% -----------------------------------------------------------------
get_diff_days(Seconds1, Seconds2) ->
    {{Year1, Month1, Day1}, _} = seconds_to_localtime(Seconds1),
    {{Year2, Month2, Day2}, _} = seconds_to_localtime(Seconds2),
    Days1 = calendar:date_to_gregorian_days(Year1, Month1, Day1),
    Days2 = calendar:date_to_gregorian_days(Year2, Month2, Day2),
	abs(Days2-Days1).
%%     DiffDays=abs(Days2-Days1),
%%     DiffDays + 1.

get_diff_days_new(Seconds1, Seconds2) ->
	DateSeconds = 24*60*60,
	DifSeconds = abs(Seconds2 - Seconds1),
%% 	TempSeconds = DifSeconds rem DateSeconds,
%% 	(DifSeconds-TempSeconds)/DateSeconds.
	DifSeconds div DateSeconds.

%% 获取从午夜到现在的秒数
get_today_current_second() ->
	{_, Time} = calendar:now_to_local_time(misc_timer:now()),
	NowSec = calendar:time_to_seconds(Time),
	NowSec.
	

test1() ->
	A = #ets_users_friends{friend_id=5},
	
	Count = 1000000,
	Rand = rand(1,Count),
	List = test(Count, A, []),
	io:format("length:~w~n",[length(List)]),
	Begin = misc_timer:now_seconds(),

	NewList = test2(100000, List, Rand),

	io:format("time:~w~n", [misc_timer:now_seconds() - Begin]),
	
	Info = lists:keyfind(Rand, #ets_users_friends.friend_id, NewList),
	
	io:format("length:~w~n",[length(NewList)]),
	io:format("Cd:~w~n", [Info#ets_users_friends.state]).


test2(0, _List, _Rand) ->
	_List;
test2(Amount, List, Rand) ->	
	Old = lists:keyfind(Rand, #ets_users_friends.friend_id, List),
	NewList = lists:keydelete(Rand, #ets_users_friends.friend_id, List),
	New = Old#ets_users_friends{state=Old#ets_users_friends.state + 100000},
	test2(Amount - 1, [New|NewList], Rand).


test(0, _, L) ->
	L;
test(Count, A, L) ->
%% 	ets:insert(ets_test, A#ets_item_template{template_id=Count}),
	B = A#ets_users_friends{friend_id=Count},
	test(Count -1, A, [B|L]).








