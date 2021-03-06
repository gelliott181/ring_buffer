-module (ring_buffer_sup).

-export([start_link/0,new_ring_buffer/3]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

new_ring_buffer(Name, Length, Type ) when is_atom(Name), is_integer(Length), is_atom(Type) ->
	supervisor:start_child(?MODULE,[Name,Length,Type]).

init([]) ->
	Worker = { ring_buffer_server,{ring_buffer_server, start_link, []},
				temporary, brutal_kill, worker,[ring_buffer_server]},
	Children = [Worker],

	RestartStrategy = {simple_one_for_one, 0 ,1},
    {ok, { RestartStrategy, Children}}.