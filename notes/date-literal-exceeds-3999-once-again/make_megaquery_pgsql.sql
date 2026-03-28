SELECT
    string_agg(issues.query_text, ' union all ')
FROM (
    SELECT
        'select '''
        || table_name
        || ''' as table, '''
        || column_name
        || ''' as column_name, 1 AS counter from '
        || table_name
        || ' where '
        || column_name
        || ' > ''3999-11-01 00:00:00''::timestamp' AS query_text
    FROM
        information_schema.columns
    WHERE
        table_catalog = 'acc01'
        AND table_schema = 'public'
        AND data_type = 'timestamp without time zone'
    ORDER BY
        table_name,
        column_name
) AS issues;