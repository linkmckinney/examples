<cfset varibles.dsn = "RailCosts"/>
<cfset varibles.tableCatalog = "Rail"/>
<cfset varibles.tableName = "Railsight"/>
<cfset varibles.tableSchema = "dbo"/>

<cfquery name="data" datasource="#varibles.dsn#" cachedafter="#createTimespan(0,0,0,0)#">
	WITH TABLE_DATA
	          AS (
	               SELECT
	                TABLE_NAME
	              , COLUMN_NAME
	              , DATA_TYPE
	              , CHARACTER_MAXIMUM_LENGTH
	              , IS_NULLABLE
	              , TABLE_CATALOG
	               FROM
	                INFORMATION_SCHEMA.COLUMNS
	               WHERE
	                TABLE_CATALOG in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#varibles.tableCatalog#">)
	                <cfif len(varibles.tableName) GT 0>
					AND TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varibles.tableName#">
	                </cfif>
					AND TABLE_SCHEMA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varibles.tableSchema#">
	             ) ,
	        REQUIRED_COLUMNS
	          AS (
	               --columns that makes the table data required due to primary keys create form that generates the validation aleady
	   SELECT
	    K.TABLE_CATALOG
	  , K.TABLE_NAME
	  , K.COLUMN_NAME
	  , K.ORDINAL_POSITION
	   FROM
	    INFORMATION_SCHEMA.KEY_COLUMN_USAGE K
	   INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC
	   ON
	    K.TABLE_CATALOG = TC.TABLE_CATALOG
	    AND K.TABLE_SCHEMA = TC.TABLE_SCHEMA
	    AND K.CONSTRAINT_NAME = TC.CONSTRAINT_NAME
	   WHERE
	    TC.CONSTRAINT_TYPE = 'PRIMARY KEY'
	    AND K.TABLE_CATALOG in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#varibles.tableCatalog#">)
	    <cfif len(varibles.tableName) GT 0>
		AND K.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varibles.tableName#">
	    </cfif>
		AND K.TABLE_SCHEMA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varibles.tableSchema#">
	             ) ,
	        IDENTITYCOLUMNS
	          AS (
	               -- get the identity field and seed
	   SELECT
	    table_name
	  , column_name
	  , data_type
	   FROM
	    information_schema.columns
	   WHERE
	    table_schema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varibles.tableSchema#">
	    AND TABLE_CATALOG in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#varibles.tableCatalog#">)
	    <cfif len(varibles.tableName) GT 0>
		AND TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varibles.tableName#">
	    </cfif>
		AND COLUMNPROPERTY(OBJECT_ID(table_name), column_name, 'IsIdentity') = 1
	             )
	     SELECT
	        td.*
	      , CASE
	          WHEN rc.COLUMN_NAME IS NULL THEN 'NOT REQUIRED'
	          ELSE 'REQUIRED'
	        END AS REQUIRED_COLUMN
	      , CASE WHEN ic.COLUMN_NAME = td.COLUMN_NAME THEN 'YES'
	             ELSE 'NO'
	        END AS ISIDENTITY
	     FROM
	        TABLE_DATA td
	     LEFT JOIN REQUIRED_COLUMNS rc
	     ON rc.COLUMN_NAME = td.COLUMN_NAME
	        AND rc.TABLE_NAME = td.TABLE_NAME
	        AND rc.TABLE_CATALOG = td.TABLE_CATALOG
	     LEFT JOIN IDENTITYCOLUMNS ic
	     ON td.TABLE_NAME = ic.TABLE_NAME
</cfquery>
