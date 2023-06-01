{application, 'phrase', [
	{description, "Erlang Phrasexpr"},
	{vsn, "0.1.0"},
	{modules, ['phrase','phrase_app','phrase_exprs','phrase_file','phrase_sup']},
	{registered, [phrase_sup]},
	{applications, [kernel,stdlib]},
	{optional_applications, []},
	{mod, {phrase_app, []}},
	{env, []}
]}.