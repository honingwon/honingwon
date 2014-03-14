%%% -------------------------------------------------------------------
%%% Author  : Administrator


%%% Description :
%%%
%%% Created : 2011-4-11
%%% -------------------------------------------------------------------
-module(mod_collect_item).
%% 
%% -behaviour(gen_server).
%% %% --------------------------------------------------------------------
%% %% Include files
%% %% --------------------------------------------------------------------
%% -include("common.hrl").
%% %% --------------------------------------------------------------------
%% %% External exports
%% -export([
%% 		 start/1
%% 		 ]).
%% 
%% %% gen_server callbacks
%% -export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
%% 
%% -define(LOOPTIME, 3000). %% 自动循环时间
%% 
%% %% ====================================================================
%% %% External functions
%% %% ====================================================================
%% 
%% 
%% %% ====================================================================
%% %% Server functions
%% %% ====================================================================
%% start([Id, Template, MapId, X, Y, MapPid]) ->
%%     gen_server:start_link(?MODULE, [Id, Template, MapId, X, Y, MapPid], []).
%% 
%% %% --------------------------------------------------------------------
%% %% Function: init/1
%% %% Description: Initiates the server
%% %% Returns: {ok, State}          |
%% %%          {ok, State, Timeout} |
%% %%          ignore               |
%% %%          {stop, Reason}
%% %% --------------------------------------------------------------------
%% init([Id, Template, MapId, X, Y, MapPid]) ->
%% 	Info = lib_collect:create_collect_item(Id, Template, MapId, X, Y, MapPid),
%% %% 	ets:insert(?ETS_MAP_COLLECT, Info),
%% 	
%% 	put(Template#ets_collect_template.template_id, Template),
%% 	
%% 	CollectProcessName = misc:collect_process_name(MapId,Id),
%% 	misc:register(global, CollectProcessName, self()), %注册
%% 	
%% 	erlang:send_after(?LOOPTIME, self(), {'loop'}),
%% 	
%% 	misc:write_monitor_pid(self(),?MODULE, {}),
%%     {ok, Info}.
%% 
%% %% --------------------------------------------------------------------
%% %% Function: handle_call/3
%% %% Description: Handling call messages
%% %% Returns: {reply, Reply, State}          |
%% %%          {reply, Reply, State, Timeout} |
%% %%          {noreply, State}               |
%% %%          {noreply, State, Timeout}      |
%% %%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%% %%          {stop, Reason, State}            (terminate/2 is called)
%% %% --------------------------------------------------------------------
%% handle_call(Info, _From, State) ->
%% 	try
%% 		do_call(Info,_From, State)
%% 	catch
%% 		_:Reason ->
%% 			?WARNING_MSG("mod_collect_item handle_call is exception:~w~n,Info:~w",[Reason, Info]),
%% 			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
%% 			{reply, ok, State}
%% 	end.
%% 
%% %% --------------------------------------------------------------------
%% %% Function: handle_cast/2
%% %% Description: Handling cast messages
%% %% Returns: {noreply, State}          |
%% %%          {noreply, State, Timeout} |
%% %%          {stop, Reason, State}            (terminate/2 is called)
%% %% --------------------------------------------------------------------
%% handle_cast(Info, State) ->
%% 	try
%% 		do_cast(Info, State)
%% 	catch
%% 		_:Reason ->
%% 			?WARNING_MSG("mod_collect_item handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
%% 			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
%% 			{noreply, State}
%% 	end.
%% 
%% %% --------------------------------------------------------------------
%% %% Function: handle_info/2
%% %% Description: Handling all non call/cast messages
%% %% Returns: {noreply, State}          |
%% %%          {noreply, State, Timeout} |
%% %%          {stop, Reason, State}            (terminate/2 is called)
%% %% --------------------------------------------------------------------
%% handle_info(Info, State) ->
%% 	try
%% 		do_info(Info, State)
%% 	catch
%% 		_:Reason ->
%% 			?WARNING_MSG("mod_collect_item handle_info is exception:~w~n,Info:~w",[Reason, Info]),
%% 			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
%% 			{noreply, State}
%% 	end.
%% 
%% %% --------------------------------------------------------------------
%% %% Function: terminate/2
%% %% Description: Shutdown the server
%% %% Returns: any (ignored by gen_server)
%% %% --------------------------------------------------------------------
%% terminate(_Reason, _State) ->
%% 	misc:delete_monitor_pid(self()),
%%     ok.
%% 
%% %% --------------------------------------------------------------------
%% %% Func: code_change/3
%% %% Purpose: Convert process state when code is changed
%% %% Returns: {ok, NewState}
%% %% --------------------------------------------------------------------
%% code_change(_OldVsn, State, _Extra) ->
%%     {ok, State}.
%% 
%% %% --------------------------------------------------------------------
%% %%% Internal functions
%% %% --------------------------------------------------------------------
%% 
%% 
%% %%---------------------do_call--------------------------------
%% do_call(Info, _, State) ->
%% 	?WARNING_MSG("mod_collect_item call is not match:~w",[Info]),
%%     {reply, ok, State}.
%% 
%% 
%% %%---------------------do_cast--------------------------------
%% %% 收集
%% do_cast({'collect', PlayerPid}, State) ->	
%% 	if State#r_collect_info.state =/= 0 ->
%% 		    Template = get(State#r_collect_info.template_id),
%% 		   	NewState = State#r_collect_info{state=0, dead_time=misc_timer:now_milseconds()},
%% 			ets:insert(?ETS_COLLECT_TEMPLATE, NewState),
%% 			{ok, BinData} = pt_12:write(?PP_MAP_COLLECT_UPDATE, [[
%% 																NewState#r_collect_info.id,																
%% 																NewState#r_collect_info.template_id,
%% 																NewState#r_collect_info.x,
%% 																NewState#r_collect_info.y,
%% 																NewState#r_collect_info.state
%% 																]]),
%% 			lib_send:send_to_local_scene(NewState#r_collect_info.map_id,
%% 										 NewState#r_collect_info.x,										 
%% 								 		 NewState#r_collect_info.y,
%% 										 BinData),
%% 			
%% 			gen_server:cast(PlayerPid, {'collect', 
%% 										Template#ets_collect_template.template_id, 
%% 										Template#ets_collect_template.award_hp,
%% 										Template#ets_collect_template.award_mp, 
%% 										Template#ets_collect_template.award_exp, 
%% 										Template#ets_collect_template.award_life_experiences, 
%% 										Template#ets_collect_template.award_yuan_bao, 
%% 										Template#ets_collect_template.award_bind_yuan_bao, 
%% 										Template#ets_collect_template.award_bind_copper, 
%% 										Template#ets_collect_template.award_copper,
%% 										Template#ets_collect_template.award_item}),
%% 			{noreply, NewState};
%% 	   true ->
%% 		   	{noreply, State}
%% 	end;
%% 
%% %% 停止
%% do_cast({stop, _Reason}, State) ->
%% 	{stop, normal, State};
%% 
%% do_cast(Info, State) ->
%% 	?WARNING_MSG("mod_collect_item cast is not match:~w",[Info]),
%%     {noreply, State}.
%% 
%% %%---------------------do_info--------------------------------
%% %% 循环
%% do_info({'loop'} , State) ->
%% 	if State#r_collect_info.state =:= 0  ->
%% 		   Template = get(State#r_collect_info.template_id),
%% 		   Now = misc_timer:now_milseconds(),
%% 		   if State#r_collect_info.dead_time + Template#ets_collect_template.reborn_time < Now ->
%% %% 				  NewState = State#r_collect_info{state=State#r_collect_info.template#ets_collect_template.type},
%% 				  NewState = State#r_collect_info{state=Template#ets_collect_template.type},
%% 				  ets:insert(?ETS_COLLECT_TEMPLATE, NewState),
%% 				  {ok, BinData} = pt_12:write(?PP_MAP_COLLECT_UPDATE, [[
%% 																	   	NewState#r_collect_info.id,																
%% 																		NewState#r_collect_info.template_id,
%% 																		NewState#r_collect_info.x,
%% 																		NewState#r_collect_info.y,
%% 																		NewState#r_collect_info.state
%% 																		]]),
%% 				  
%% 				  lib_send:send_to_local_scene(NewState#r_collect_info.map_id,
%% 										 NewState#r_collect_info.x,										 
%% 								 		 NewState#r_collect_info.y,
%% 										 BinData);
%% 			  true ->
%% 				  NewState = State
%% 		   end;
%% 	   true ->
%% 		   	NewState = State
%% 	end,
%% 	erlang:send_after(?LOOPTIME, self(), {'loop'}),
%% 	{noreply, NewState};
%% 
%% do_info(Info, State) ->
%% 	?WARNING_MSG("mod_collect_item info is not match:~w",[Info]),
%%     {noreply, State}.
%% 
%% 
%% 
%% 
%% 
%% 
%% 
%% 



