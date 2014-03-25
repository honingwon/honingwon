%%% -------------------------------------------------------------------
%%% Author  : 谢中良
%%% Description :摆摊系统监督进程
%%%
%%% Created : 2011-3-22
%%% -------------------------------------------------------------------
-module(mod_stall_server_sup).

-behaviour(supervisor).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% External exports
%% --------------------------------------------------------------------
-export([
		 start/0,
		 start_link/0
		]).

%% --------------------------------------------------------------------
%% Internal exports
%% --------------------------------------------------------------------
-export([
	 init/1
        ]).

%% --------------------------------------------------------------------
%% Macros
%% --------------------------------------------------------------------
-define(SERVER, ?MODULE).

%% --------------------------------------------------------------------
%% Records
%% --------------------------------------------------------------------

%% ====================================================================
%% External functions
%% ====================================================================
start() ->
	{ok, _} = supervisor:start_child(server_sup, {?MODULE,
												  {?MODULE, start_link, []},
												  permanent, infinity, supervisor,
												  [?MODULE]}).
start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).


%% ====================================================================
%% Server functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Func: init/1
%% Returns: {ok,  {SupFlags,  [ChildSpec]}} |
%%          ignore                          |
%%          {error, Reason}
%% --------------------------------------------------------------------
init([]) ->
	RestartStrategy = one_for_one, %%重启策略
	MaxRestarts = 1000, %% 最大重启次数
	MaxSecondsBetweenRestarts = 3600, %%重启间隔
	SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},
	{ok, {SupFlags, []}}.

    %%AChild = {'AName',{'AModule',start_link,[]},
	%%      permanent,2000,worker,['AModule']},
    %%{ok,{{simple_one_for_one,0,1}, [AChild]}}.

%% ====================================================================
%% Internal functions
%% ====================================================================
