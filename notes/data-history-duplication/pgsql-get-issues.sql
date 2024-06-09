SELECT *
FROM _datahistorymetadata AS metadata
        INNER JOIN (
            SELECT _metadataid, _fld626, MAX(_metadataversionnumber) AS "_version"
            FROM   _datahistorymetadata
            WHERE  _fld626 IS NOT NULL
            GROUP  BY _metadataid, _fld626
        ) AS max_versions
        ON 
            metadata._metadataid = max_versions._metadataid
            AND metadata._fld626 = max_versions._fld626
            AND metadata._isactual = True
            AND metadata._metadataversionnumber <> max_versions._version