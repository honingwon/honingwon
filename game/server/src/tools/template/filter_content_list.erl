%% Author: Administrator
%% Created: 2011-3-28
%% Description: TODO: Add description to filter_content_list
-module(filter_content_list).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([create/1]).


%%
%% API Functions
%%


create([Infos]) ->
	Len = length(Infos),
	FInfo = fun(Info) ->
					Record = list_to_tuple([ets_filter_template] ++ Info),
					Content=string:concat((tool:to_list(Record#ets_filter_template.content)), ",',<,>,\\,/,\","),
					
					if Record#ets_filter_template.type=:=1 ->
						    NewRecord=#ets_filter_template{
										 type = 1,                             
                                         content=Content},
							
							NewContent = sort_string(NewRecord#ets_filter_template.content),
							ContentBin = write_string_by_32(NewContent),
							
								<<(NewRecord#ets_filter_template.type):32/signed,
					              ContentBin/binary>>;							 
					     true->
							NewContent1= sort_string(tool:to_list(Record#ets_filter_template.content)),
							Content1Bin = write_string_by_32(NewContent1),
														
%%                              Content1Bin = create_template_all:write_string(Record#ets_filter_template.content),
							 
                              <<(Record#ets_filter_template.type):32/signed,
					             Content1Bin/binary>>	
			      	end
			end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.


%%将字符串转成二进制
write_string_by_32(Str) ->
	Bin = tool:to_binary(Str),
    Len = byte_size(Bin),	
%% 	?PRINT("write_string_by_32:~w~n",[Len]),
	<<Len:32, Bin/binary>>.

sort_string(Content)->
	Lists = string:tokens(Content, ","),
	F = fun(Info1, Info2) ->
				if erlang:length(Info1) > erlang:length(Info2) ->
					   true;
				   true ->
					   false
				end
		end,
	NewLists = lists:sort(F, Lists),
	FCon = fun(Info, Acc) ->
				   if erlang:length(Info) > 0 ->
						  if erlang:length(Acc) > 0 ->
								 lists:concat([Info, ",", Acc ]);
							 true ->
								 lists:concat([Info])
						  end;
					  true ->
						  Acc
				   end
		   end,
	NewContent = lists:foldr(FCon, "", NewLists),
	NewContent.

%%
%% Local Functions
%%

