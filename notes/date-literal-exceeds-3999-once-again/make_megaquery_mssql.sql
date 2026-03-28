SELECT (
    SELECT COALESCE(
        STRING_AGG(
            CONVERT(nvarchar(max),
                'select '''
                + q.TABLE_NAME
                + ''' as [table], '''
                + q.COLUMN_NAME
                + ''' as column_name, '
                + QUOTENAME(q.COLUMN_NAME)
                + ' as field_value, '
                + CASE
                    WHEN q.HasFld626 = 1
                        THEN '[_Fld626] as [_Fld626]'
                    ELSE 'NULL as [_Fld626]'
                  END
                + ' from '
                + QUOTENAME(q.TABLE_SCHEMA) + '.' + QUOTENAME(q.TABLE_NAME)
                + ' where '
                + QUOTENAME(q.COLUMN_NAME)
                + ' > DATEADD(year, 2000, cast(''3999-11-01T00:00:00'' as datetime))'
            ),
            ' union all '
        ),
        N''
    )
    FROM (
        SELECT
            c.TABLE_SCHEMA,
            c.TABLE_NAME,
            c.COLUMN_NAME,
            CASE
                WHEN f.COLUMN_NAME IS NOT NULL THEN 1
                ELSE 0
            END AS HasFld626
        FROM INFORMATION_SCHEMA.COLUMNS c
        LEFT JOIN INFORMATION_SCHEMA.COLUMNS f
            ON f.TABLE_CATALOG = c.TABLE_CATALOG
            AND f.TABLE_SCHEMA = c.TABLE_SCHEMA
            AND f.TABLE_NAME = c.TABLE_NAME
            AND f.COLUMN_NAME = '_Fld626'
        WHERE
            c.TABLE_CATALOG = 'acc01'
            AND c.TABLE_SCHEMA = 'dbo'
            AND c.DATA_TYPE IN ('datetime', 'datetime2')
    ) q
    FOR XML PATH(''), TYPE
) AS sql_text;