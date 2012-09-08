-module(cc).
-author("Duncan Smith <Duncan@xrtc.net>").
-behaviour(gen_fsm).

% 
-export([handle_order/1]).

% gen_fsm callbacks
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).


% A = 3
% Bp= 1  % B-prime, noted as "spare" in the patent and "B" in the book
% B = 2
% C = 5
% D = 7

handle_order(<<A:3, Bp:1, B:2, C:5, D:7>>) ->
	order(A, Bp, B, C, D).

%%%% Read BGS instructions

%% RY

% Read and regenerate the barrier grid store at the Y address
% specified in the D part of the order and an X address stored in the
% barrier grid store address register.  The Y address is also stored
% in the Y portion of the barrier grid register in response to this
% order.
%
order(0, Bp, B, 4, D) when B != 3,
						   D == <<0:1, _:7>> ->
	

