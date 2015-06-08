%%%-------------------------------------------------------------------
%%% @author iguberman
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Apr 2015 9:28 PM
%%%-------------------------------------------------------------------
-module(jobs_SUITE).
-author("iguberman").

-include_lib("common_test/include/ct.hrl").

-define(JOBS_COUNTER_CONFIG,
  { jobs, [
    { queues, [{ heavy_crunches, [ { regulators, [{ counter, [{ limit, 3 }] } ] }]  } ] },
    { queues, [{ large_payloads, [ { regulators, [{ rate, [{ limit, 100 }] } ] }]  } ] }
    ]
  }
).

%% API
-export([all/0]).

-export([process_payload/2, test_counter/1]).

all()->[test_counter].
%%   , test_rate, test_group_rate, test_regulator_modifier, test_queue_modifier].

configure() ->
  [{require, jobs}].

init_per_suite(Config) ->
  application:set_env(jobs, jobs, ?JOBS_COUNTER_CONFIG),
  application:ensure_started(jobs),
  Config.

end_per_suite(_Config) ->
  application:stop(jobs).

process_req(Payload)->
  timestamp(os:timestamp()),
  ts:sleep(size(Payload) * 100).

random_size_requests()->
  Req = binary:copy(<<"1234567890">>, 100),
  jobs:run(large_payloads, fun()-> process_req(Req) end).

timestamp({MegaSecs, Secs, MicroSecs}) -> (MegaSecs * 1000000 + Secs) * 1000000 + MicroSecs.












