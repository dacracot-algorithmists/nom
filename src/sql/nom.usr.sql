set echo on
spool nom.usr.sql.err

/*------------------------------------------------------------------------*/

CREATE USER nom IDENTIFIED BY n0mb8by DEFAULT TABLESPACE users TEMPORARY TABLESPACE TEMP;
ALTER USER nom QUOTA UNLIMITED ON users; 
GRANT CONNECT TO nom;
GRANT RESOURCE TO nom;
GRANT CREATE VIEW TO nom;
GRANT CREATE ANY CONTEXT TO nom;
GRANT DROP ANY CONTEXT TO nom;

/*------------------------------------------------------------------------*/

spool off
exit
