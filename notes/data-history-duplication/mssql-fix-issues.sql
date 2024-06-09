UPDATE _datahistorymetadata
SET    _isactual = 0x00
FROM   (SELECT _metadataid, _fld626, MAX(_metadataversionnumber) AS "_version"
        FROM   _datahistorymetadata
        WHERE  _fld626 IS NOT NULL
        GROUP  BY _metadataid, _fld626) AS max_versions
WHERE  _datahistorymetadata._metadataid = max_versions._metadataid
       AND _datahistorymetadata._fld626 = max_versions._fld626
       AND _datahistorymetadata._isactual = 0x01
       AND _datahistorymetadata._metadataversionnumber <> max_versions._version