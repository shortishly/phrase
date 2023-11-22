{application, 'phrase', [
	{description, "Erlang Phrasexpr"},
	{vsn, "0.2.0"},
	{id, "0.2.0-dirty"},
	{modules, ['phrase','phrase_app','phrase_exprs','phrase_file','phrase_sup']},
	{registered, [phrase_sup]},
	{applications, [kernel,stdlib]},
	{optional_applications, []},
	{mod, {phrase_app, []}},
	{env, []}
]}.