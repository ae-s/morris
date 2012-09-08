-module(bgs).
-author("Duncan Smith <Duncan@xrtc.net>").
-behaviour(gen_server).

% gen_server callbacks
-export([init/1,
		 handle_call/3,
		 handle_cast/2,
		 handle_info/2,
		 terminate/2,
		 code_change/3
		]).

% external functions
-export([set_addr/1, get_addr/0, rrg/0, rch/0, rw1/0, rw0/0]).

-define(SERVER, fss).
-define(DEBUG, 1).

init(args) ->
	{ok, st_idle, []}.

set_addr(<<Addr:14>>) ->
	gen_server:cast(?SERVER, {set_addr, <<Addr>>}).

get_addr() ->
	gen_server:call(?SERVER, {get_addr}).

rrg() ->
	gen_server:call(?SERVER, {rrg}).
rch() ->
	gen_server:call(?SERVER, {rch}).
rw1() ->
	gen_server:call(?SERVER, {rw1}).
rw0() ->
	gen_server:call(?SERVER, {rw0}).

replace_data(Data, {Type, Value}) ->
    [{Type, Value} | proplists:delete(Type, Data)];
replace_data(Data, []) ->
    Data;
replace_data(Data, [{Type, Value}|T]) ->
    replace_data(replace_data(Data, {Type, Value}), T).

handle_call({get_addr}, _From, State) ->
	{reply, <<(proplists:get_value(x, State)):7, (proplists:get_value(y, State)):7>>, State};
% read-regenerate (don't alter)
handle_call({rrg}, _From, State) ->
	{reply, 1, State};
% read-change (toggle)
handle_call({rch}, _From, State) ->
	{reply, 1, State};
% read-write1
handle_call({rw1}, _From, State) ->
	{reply, 1, State};
% read-write0
handle_call({rw0}, _From, State) ->
	{reply, 1, State}.


handle_cast({set_addr, <<X:7, Y:7>>}, State) ->
	{noreply, replace_data(State, [{x, X}, {y, Y}])}.


terminate(_,_) ->
    ok.

code_change(_,_,_) ->
    ok.
handle_info(_,_) ->
    ok.
