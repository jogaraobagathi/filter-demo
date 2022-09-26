CREATE OR REPLACE FUNCTION public.insert(
      id integer,
     condition_ jsonb,
    priority integer,
	action_ action_type
)
    RETURNS VOID AS
$BODY$
BEGIN
	INSERT INTO public.filter_table
	values ($1,$2,$3,$4);
END;
$BODY$ LANGUAGE plpgsql;

