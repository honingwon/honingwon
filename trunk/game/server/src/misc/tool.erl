-module(tool).

-export([ip/1, 
		 sort/1, 
		 reversion/1,
		 for/3, 
		 f2s/1, 
		 to_atom/1, 
		 to_list/1, 
		 to_binary/1, 
		 to_integer/1, 
		 to_bool/1, 
		 to_tuple/1,
         get_type/2, 
		 is_string/1,
%% 		 list_random/1, 
%% 		 random/2, 
%% 		 random_dice/2, 
%% 		 odds/2, odds_list/1, odds_list/2,
%%          odds_list_sum/1, 
		 ceil/1, floor/1, 
		 subatom/2, 
		 sleep/1, 
		 md5/1, 
		 list_to_hex/1, 
		 int_to_hex/1, 
		 hex/1,
         list_to_atom2/1,
		 combine_lists/2, 
		 get_process_info_and_zero_value/1, 
		 get_msg_queue/0, 
		 get_memory/0,
         get_heap/1, 
		 get_processes/0, 
		 list_to_term/1, 
		 substr_utf8/2, 
		 substr_utf8/3, 
		 ip_str/1, 
		 remove_string_black/1,
		 split_string_to_intlist/1,
		 split_string_to_intlist1/1,
		 intlist_to_string/1,
		 change_list_to_string/1,
		 intlist_to_string_1/1,
		 intlist_to_string_2/1,
		 intlist_to_string_3/1,
		 split_string_to_intlist/2,
	     split_string_to_intlist/3,
		 split_string_to_record/1,
		 delete_with_index/2,
		 date_to_unix/1,
		 unix_to_date/1
		]).

%% 转为unix时间戳
-define(UNIX_BASE_TICK, 62167132800 - 32 * 60 * 60).

%% @doc get IP address string from Socket
ip(Socket) ->
  	{ok, {IP, _Port}} = inet:peername(Socket),
  	{Ip0,Ip1,Ip2,Ip3} = IP,
	list_to_binary(integer_to_list(Ip0)++"."++integer_to_list(Ip1)++"."++integer_to_list(Ip2)++"."++integer_to_list(Ip3)).


%% @doc quick sort
sort([]) ->
	[];
sort([H|T]) -> 
	sort([X||X<-T,X<H]) ++ [H] ++ sort([X||X<-T,X>=H]).

%% 反转
reversion(List) ->
	reversion(List,[]).

reversion([],List) ->
	List;
reversion([H|L],List) ->
	reversion(L,[H|List]).

%% for
for(Max,Max,F)->[F(Max)];
for(I,Max,F)->[F(I)|for(I+1,Max,F)].


%% @doc convert float to string,  f2s(1.5678) -> 1.57
f2s(N) when is_integer(N) ->
    integer_to_list(N) ++ ".00";
f2s(F) when is_float(F) ->
    [A] = io_lib:format("~.2f", [F]),
	A.


%% @doc convert other type to atom
to_atom(Msg) when is_atom(Msg) -> 
	Msg;
to_atom(Msg) when is_binary(Msg) -> 
	tool:list_to_atom2(binary_to_list(Msg));
to_atom(Msg) when is_list(Msg) -> 
    tool:list_to_atom2(Msg);
to_atom(_) -> 
    throw(other_value).  %%list_to_atom("").

%% @doc convert other type to list
to_list(Msg) when is_list(Msg) -> 
    Msg;
to_list(Msg) when is_atom(Msg) -> 
    atom_to_list(Msg);
to_list(Msg) when is_binary(Msg) -> 
    binary_to_list(Msg);
to_list(Msg) when is_integer(Msg) -> 
    integer_to_list(Msg);
to_list(Msg) when is_float(Msg) -> 
    f2s(Msg);
to_list(Msg) when is_tuple(Msg) ->
	tuple_to_list(Msg);
to_list(_) ->
    throw(other_value).

%% @doc convert other type to binary
to_binary(Msg) when is_binary(Msg) -> 
    Msg;
to_binary(Msg) when is_atom(Msg) ->
	list_to_binary(atom_to_list(Msg));
	%%atom_to_binary(Msg, utf8);
to_binary(Msg) when is_list(Msg) -> 
	list_to_binary(Msg);
to_binary(Msg) when is_integer(Msg) -> 
	list_to_binary(integer_to_list(Msg));
to_binary(Msg) when is_float(Msg) -> 
	list_to_binary(f2s(Msg));
to_binary(Msg) when is_tuple(Msg) ->
	list_to_binary(tuple_to_list(Msg));
to_binary(_Msg) ->
    throw(other_value).

%% @doc convert other type to float
%% to_float(Msg)->
%% 	Msg2 = to_list(Msg),
%% 	list_to_float(Msg2).

%% @doc convert other type to integer
-spec to_integer(Msg :: any()) -> integer().
to_integer(Msg) when is_integer(Msg) -> 
    Msg;
to_integer(Msg) when is_binary(Msg) ->
	Msg2 = binary_to_list(Msg),
    list_to_integer(Msg2);
to_integer(Msg) when is_list(Msg) -> 
    list_to_integer(Msg);
to_integer(Msg) when is_float(Msg) -> 
    round(Msg);
to_integer(_Msg) ->
    throw(other_value).

to_bool(D) when is_integer(D) ->
	D =/= 0;
to_bool(D) when is_list(D) ->
	length(D) =/= 0;
to_bool(D) when is_binary(D) ->
	to_bool(binary_to_list(D));
to_bool(D) when is_boolean(D) ->
	D;
to_bool(_D) ->
	throw(other_value).

%% @doc convert other type to tuple
to_tuple(T) when is_tuple(T) -> T;
to_tuple(T) when is_list(T) -> 
	list_to_tuple(T);
to_tuple(T) -> {T}.

%% @doc get data type {0=integer,1=list,2=atom,3=binary}
get_type(DataValue,DataType)->
	case DataType of
		0 ->
			DataValue2 = binary_to_list(DataValue),
			list_to_integer(DataValue2);
		1 ->
			binary_to_list(DataValue);
		2 ->
			DataValue2 = binary_to_list(DataValue),
			list_to_atom(DataValue2);
		3 -> 
			DataValue
	end.

%% @spec is_string(List)-> yes|no|unicode  
is_string([]) -> yes;
is_string(List) -> is_string(List, non_unicode).

is_string([C|Rest], non_unicode) when C >= 0, C =< 255 -> is_string(Rest, non_unicode);
is_string([C|Rest], _) when C =< 65000 -> is_string(Rest, unicode);
is_string([], non_unicode) -> yes;
is_string([], unicode) -> unicode;
is_string(_, _) -> no.



%% @doc get random list
%% list_random(List)->
%% 	case List of
%% 		[] ->
%% 			{};
%% 		_ ->
%% 			RS			=	lists:nth(random:uniform(length(List)), List),
%% 			ListTail	= 	lists:delete(RS,List),
%% 			{RS,ListTail}
%% 	end.

%% @doc get a random integer between Min and Max
%% 不能使用
%% random(Min,Max)->
%% 	Min2 = Min-1,
%% 	random:uniform(Max-Min2)+Min2.

%% @doc 掷骰子
%% random_dice(Face,Times)->
%% 	if
%% 		Times == 1 ->
%% 			random(1,Face);
%% 		true ->
%% 			lists:sum(for(1,Times, fun(_)-> random(1,Face) end))
%% 	end.

%% @doc 机率
%% odds(Numerator, Denominator)->
%% 	Odds = random:uniform(Denominator),
%% 	if
%% 		Odds =< Numerator -> 
%% 			true;
%% 		true ->
%% 			false
%% 	end.
%% 
%% odds_list(List)->
%% 	Sum = odds_list_sum(List),
%% 	odds_list(List,Sum).
%% odds_list([{Id,Odds}|List],Sum)->
%% 	case odds(Odds,Sum) of
%% 		true ->
%% 			Id;
%% 		false ->
%% 			odds_list(List,Sum-Odds)
%% 	end.
%% odds_list_sum(List)->
%% 	{_List1,List2} = lists:unzip(List),
%% 	lists:sum(List2).


%% @doc 取整 大于X的最小整数
ceil(X) ->
    T = trunc(X),
	if 
		X - T == 0 ->
			T;
		true ->
			if
				X > 0 ->
					T + 1;
				true ->
					T
			end			
	end.


%% @doc 取整 小于X的最大整数
floor(X) ->
    T = trunc(X),
	if 
		X - T == 0 ->
			T;
		true ->
			if
				X > 0 ->
					T;
				true ->
					T-1
			end
	end.
%% 4舍5入
%% round(X)

%% subatom
subatom(Atom,Len)->	
	list_to_atom(lists:sublist(atom_to_list(Atom),Len)).

%% @doc 暂停多少毫秒
sleep(Msec) ->
	receive
		after Msec ->
			true
	end.

md5(S) ->        
	Md5_bin =  erlang:md5(S), 
    Md5_list = binary_to_list(Md5_bin), 
    lists:flatten(list_to_hex(Md5_list)). 
 
list_to_hex(L) -> 
	lists:map(fun(X) -> int_to_hex(X) end, L). 
 
int_to_hex(N) when N < 256 -> 
    [hex(N div 16), hex(N rem 16)]. 
hex(N) when N < 10 -> 
       $0+N; 
hex(N) when N >= 10, N < 16 ->      
	$a + (N-10).

list_to_atom2(List) when is_list(List) ->
	case catch(list_to_existing_atom(List)) of
		{'EXIT', _} -> erlang:list_to_atom(List);
		Atom when is_atom(Atom) -> Atom
	end.
	
combine_lists(L1, L2) ->
	Rtn = 
	lists:foldl(
		fun(T, Acc) ->
			case lists:member(T, Acc) of
				true ->
					Acc;
				false ->
					[T|Acc]
			end
		end, lists:reverse(L1), L2),
	lists:reverse(Rtn).


get_process_info_and_zero_value(InfoName) ->
	PList = erlang:processes(),
	ZList = lists:filter( 
		fun(T) -> 
			case erlang:process_info(T, InfoName) of 
				{InfoName, 0} -> false; 
				_ -> true 	
			end
		end, PList ),
	ZZList = lists:map( 
		fun(T) -> {T, erlang:process_info(T, InfoName), erlang:process_info(T, registered_name)} 
		end, ZList ),
	[ length(PList), InfoName, length(ZZList), ZZList ].

get_process_info_and_large_than_value(InfoName, Value) ->
	PList = erlang:processes(),
	ZList = lists:filter( 
		fun(T) -> 
			case erlang:process_info(T, InfoName) of 
				{InfoName, VV} -> 
					if VV >  Value -> true;
						true -> false
					end;
				_ -> true 	
			end
		end, PList ),
	ZZList = lists:map( 
		fun(T) -> {T, erlang:process_info(T, InfoName), erlang:process_info(T, registered_name)} 
		end, ZList ),
	[ length(PList), InfoName, Value, length(ZZList), ZZList ].

get_msg_queue() ->
	io:fwrite("process count:~p~n~p value is not 0 count:~p~nLists:~p~n", 
				get_process_info_and_zero_value(message_queue_len) ).

get_memory() ->
	io:fwrite("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n", 
				get_process_info_and_large_than_value(memory, 1048576) ).

%% get_memory(Value) ->
%% 	io:fwrite("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n", 
%% 				get_process_info_and_large_than_value(memory, Value) ).
%% 
%% get_heap() ->
%% 	io:fwrite("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n", 
%% 				get_process_info_and_large_than_value(heap_size, 1048576) ).

get_heap(Value) ->
	io:fwrite("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n", 
				get_process_info_and_large_than_value(heap_size, Value) ).

get_processes() ->
	io:fwrite("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n",
	get_process_info_and_large_than_value(memory, 0) ).


list_to_term(String) ->
	{ok, T, _} = erl_scan:string(String++"."),
	case erl_parse:parse_term(T) of
		{ok, Term} ->
			Term;
		{error, Error} ->
			Error
	end.


substr_utf8(Utf8EncodedString, Length) ->
	substr_utf8(Utf8EncodedString, 1, Length).
substr_utf8(Utf8EncodedString, Start, Length) ->
	ByteLength = 2*Length,
	Ucs = xmerl_ucs:from_utf8(Utf8EncodedString),
	Utf16Bytes = xmerl_ucs:to_utf16be(Ucs),
	SubStringUtf16 = lists:sublist(Utf16Bytes, Start, ByteLength),
	Ucs1 = xmerl_ucs:from_utf16be(SubStringUtf16),
	xmerl_ucs:to_utf8(Ucs1).

ip_str(IP) ->
	case IP of
		{A, B, C, D} ->
			lists:concat([A, ".", B, ".", C, ".", D]);
		{A, B, C, D, E, F, G, H} ->
			lists:concat([A, ":", B, ":", C, ":", D, ":", E, ":", F, ":", G, ":", H]);
		Str when is_list(Str) ->
			Str;
		_ ->
			[]
	end.

%%去掉字符串空格
remove_string_black(L) ->
	F = fun(S) ->
				if S == 32 -> [];
				   true -> S
				end
		end,
	Result = [F(lists:nth(I,L)) || I <- lists:seq(1,length(L))],
	lists:filter(fun(T) -> T =/= [] end,Result).

%%根据"|"及","拆分字符串并返回整形列表 
%例 "1,2,3|4,5|1" -> [{1,2,3},{4,5},{1}],"1" -> [{1}]

split_string_to_intlist(SL) ->
	if SL =:= undefined ->
			[];
		true ->
			split_string_to_intlist(SL, "|", ",")
	end.

%脚步解析ets_1:1,3|1,4;ets_2:4,5
%%解析后的格式[{ets_1,[{1,3},{1,4}]},{ets_2,[{4,5}]}]
split_string_to_record(SL) ->
	if SL =:= undefined ->
			[];
		true ->
			split_string_to_record1(SL)
	end.
split_string_to_record1(SL) ->
	SList = string:tokens(to_list(SL), ";"),
	F = fun(S, L) ->
			case string:tokens(S, ":") of
				[M,N] ->
					Falg = to_atom(M),
					Value = split_string_to_intlist(N, "|", ","),
					[{Falg,Value}| L];
				_ ->
					L
			end
		end,
	lists:foldr(F,[],SList).

split_string_to_intlist(SL, Split) ->
	NewSplit = to_list(Split),
	SList = string:tokens(to_list(SL), NewSplit),
	F = fun(X,L) ->
			{V1,_} = string:to_integer(X),
			[V1|L]
		end,
	lists:foldr(F,[],SList).

split_string_to_intlist(SL, Split1, Split2) ->
	NewSplit1 = to_list(Split1),
 	NewSplit2 = to_list(Split2),
	SList = string:tokens(to_list(SL), NewSplit1),
	F = fun(X,L) -> 
			case string:tokens(X, NewSplit2) of
	 			[M,N] ->
					{V1,_} = string:to_integer(M),
					{V2,_} = string:to_integer(N), 
					[{V1,V2}|L];

				[M,N,O] ->
					{V1,_} = string:to_integer(M),
					{V2,_} = string:to_integer(N),
					{V3,_} = string:to_integer(O),
					[{V1,V2,V3}|L];
				[M,N,O,P] ->
					{V1,_} = string:to_integer(M),
					{V2,_} = string:to_integer(N),
					{V3,_} = string:to_integer(O),
					{V4,_} = string:to_integer(P),
					[{V1,V2,V3,V4}|L];
				[M,N,O,P,I] ->
					{V1,_} = string:to_integer(M),
					{V2,_} = string:to_integer(N),
					{V3,_} = string:to_integer(O),
					{V4,_} = string:to_integer(P),
					{V5,_} = string:to_integer(I),
					[{V1,V2,V3,V4,V5}|L];
                [M,N,O,P,Q,I] ->
                    {V1,_} = string:to_integer(M),
					{V2,_} = string:to_integer(N),
					{V3,_} = string:to_integer(O),
					{V4,_} = string:to_integer(P),
					{V5,_} = string:to_integer(Q),
                    {V6,_} = string:to_integer(I),
					[{V1,V2,V3,V4,V5,V6}|L];
				[M] ->
					{V1,_} = string:to_integer(M),
					[{V1}|L];
				_ ->
					L
			end 
		end,
	lists:foldr(F,[],SList).


%例 "1,2,3" -> [1,2,3]
split_string_to_intlist1(SL) ->
	if SL =:= undefined ->
			[];
		true ->
			split_string_to_intlist1(SL, ",")
	end.

split_string_to_intlist1(SL, Split1) ->
	NewSplit1 = to_list(Split1),
	SList = string:tokens(to_list(SL), NewSplit1),
	F = fun(X,L) ->
				{V,_} = string:to_integer(X),
				[V|L]			
		end,
	lists:foldr(F,[],SList).


%% 列表转化为字符串类型 [{1,2},{3,4}]
intlist_to_string(List) ->
    F = fun({Type,Value}, [[_|Acce], String]) ->     
           if
              erlang:length(Acce) =:= 0 ->
                 String1 = lists:concat([Type, ',', Value]),
                 String2 = string:concat(String, String1),
                 [Acce, String2];
                
              true ->
                 String1 = lists:concat([Type, ',', Value, '|']),
                 String2 = string:concat(String, String1),
                 [Acce, String2]
            end
        end,
    [_, FinalString] = lists:foldl(F, [List, ""], List),
    FinalString.

%% 列表转化为字符串类型 [{1,1,2,2},{2,3,4,5}]
intlist_to_string_1(List) ->
    F = fun({Index,Type,Value,Setion}, [[_|Acce], String]) ->     
           if
              erlang:length(Acce) =:= 0 ->
                 String1 = lists:concat([Index, ',',Type, ',', Value, ',', Setion]),
                 String2 = string:concat(String, String1),
                 [Acce, String2];
                
              true ->
                 String1 = lists:concat([Index, ',',Type, ',', Value, ',', Setion, '|']),
                 String2 = string:concat(String, String1),
                 [Acce, String2]
            end
        end,
    [_, FinalString] = lists:foldl(F, [List, ""], List),
    FinalString.


%% 列表转化为字符串类型 [1,2,3,4] => "1,2,3,4"
intlist_to_string_2(List) ->
     F = fun(Value, [[_|Acce], String]) ->     
           if
              erlang:length(Acce) =:= 0 ->
                 String1 = lists:concat([ Value]),
                 String2 = string:concat(String, String1),
                 [Acce, String2];
                
              true ->
                 String1 = lists:concat([ Value, ',']),
                 String2 = string:concat(String, String1),
                 [Acce, String2]
            end
        end,
    [_, FinalString] = lists:foldl(F, [List, ""], List),
    FinalString.


%% 列表转化为字符串类型 [{1,2,3},{4,5,6}]
intlist_to_string_3(List) ->
    F = fun({Index,Type,Value}, [[_|Acce], String]) ->     
           if
              erlang:length(Acce) =:= 0 ->
                 String1 = lists:concat([Index, ',',Type, ',', Value]),
                 String2 = string:concat(String, String1),
                 [Acce, String2];
                
              true ->
                 String1 = lists:concat([Index, ',',Type, ',', Value,  '|']),
                 String2 = string:concat(String, String1),
                 [Acce, String2]
            end
        end,
    [_, FinalString] = lists:foldl(F, [List, ""], List),
    FinalString.

%% 列表转化为字符串类型 [1|2,3|4]
change_list_to_string(List) ->
    F = fun({Type,Value}, [[_|Acce], String]) ->     
           if
              erlang:length(Acce) =:= 0 ->
                 String1 = lists:concat([Type, '|', Value]),
                 String2 = string:concat(String, String1),
                 [Acce, String2];
                
              true ->
                 String1 = lists:concat([Type, '|', Value, ',']),
                 String2 = string:concat(String, String1),
                 [Acce, String2]
            end
        end,
    [_, FinalString] = lists:foldl(F, [List, ""], List),
    FinalString.
   

%% 把时间转为unix时间
date_to_unix(Date) ->
	Dates = string:tokens(Date, "-"),
	{Year, Month, Day} = tool:to_tuple(Dates),
	IYear = to_integer(Year),
	IMonth = to_integer(Month),
	IDay = to_integer(Day),
	Tick = calendar:datetime_to_gregorian_seconds({{IYear, IMonth, IDay}, {0, 0, 0}}),
    UnixTick = Tick - ?UNIX_BASE_TICK,
	UnixTick.


%% unix时间转为日期
unix_to_date(Tick) ->
	%% 加上1970
    calendar:gregorian_seconds_to_datetime(Tick + 62167132800 + 32 * 60 * 60).


%%delete list with index
delete_with_index(List, Index) ->
	delete_with_index1(List, Index, []).
	
delete_with_index1([], _Index, List) ->
	{List,[]};
delete_with_index1([H|L], Index, List) ->
	if
		Index =:= 1 ->
			{List ++ L,[H]};
		true ->
			delete_with_index1(L, Index - 1, [H|List])
	end.
	

