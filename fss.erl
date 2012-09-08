-module(fss).
-author("Duncan Smith <Duncan@xrtc.net>").
-behaviour(gen_server).

% gen_server callbacks
-export([init/1,
		 handle_call/3,
		 handle_cast/2,
		 handle_info/2,
		 terminate/2,
		 code_change/2
		]).

% external functions
-export([order/1]).

-define(SERVER, fss).
-define(DEBUG, 1).

init(args) ->
	{ok, st_idle, []}.

order(<<O:25/bits>>) ->
	gen_server:call(?SERVER, {order, <<O>>}).

handle_call({order, <<Error:5, P:1, A:3, B:3, C:5, D:8>>}, State) ->
	order(A, B, C, D).

debug_text(
