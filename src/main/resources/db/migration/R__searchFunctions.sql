CREATE OR REPLACE FUNCTION public.check_whether_values_matches_conditions(conditions jsonb, input jsonb)
    returns boolean
as
$body$
declare
    result              boolean;
    operator            text;
    column_name         text;
    column_type         text;
    column_filter_type  text;
    column_filter_value text;
    input_column_value  text;
    condition_element   jsonb;
    sub_result          boolean;
begin
    operator = to_jsonb(conditions -> 'operator') ->> 0;
    raise notice 'operator is % ',operator;

    IF operator is NULL THEN
        column_name = to_jsonb(conditions -> 'colId') ->> 0;
        column_type = to_jsonb(conditions -> 'filterType') ->> 0;
        column_filter_type = to_jsonb(conditions -> 'type') ->> 0;
        column_filter_value = lower(to_jsonb(conditions -> 'filter') ->> 0);
        input_column_value = to_jsonb(input -> column_name) ->> 0;
        result = false;

        IF input_column_value is NULL THEN
            return result;
        END IF;
        CASE
            WHEN column_type LIKE 'text' THEN CASE
                WHEN column_filter_type LIKE 'equals' THEN IF input_column_value LIKE column_filter_value THEN
                    result = true;
                END IF;
                WHEN column_filter_type LIKE 'contains'
                    THEN IF input_column_value LIKE format('%%%s%%', column_filter_value) THEN
                        result = true;
                    END IF;
                END CASE;
            END CASE;
    ELSE
        result = true;
        IF operator LIKE 'OR' THEN
            result = false;
        END IF;

        FOR condition_element in select * from jsonb_array_elements(conditions -> 'conditions')
            LOOP
                EXECUTE format($child$ select * from public.check_whether_values_matches_conditions($1,$2) $child$)
                    USING condition_element,input
                    INTO sub_result;
                IF operator = 'OR' and sub_result = true THEN
                    return true;
                END IF;
                IF operator = 'AND' and sub_result = false THEN
                    return false;
                END IF;
            END LOOP;
    END IF;
    return result;
end;
$body$
    language plpgsql;



CREATE OR REPLACE FUNCTION public.allow_or_block(input jsonb)
    returns text
as
$body$
declare
    row    public.filter_table%ROWTYPE;
    result boolean;
begin
    for row in (select * from filter_table order by priority desc)
        loop
            EXECUTE format($child$  select * from public.check_whether_values_matches_conditions($1,$2) $child$)
                using row.condition_,input
                into result;
            IF result = true then
                raise notice 'row is %',row;
                return row.action_;
            END IF;
        end loop;
    return 'ALLOW';
end;
$body$
    language plpgsql;