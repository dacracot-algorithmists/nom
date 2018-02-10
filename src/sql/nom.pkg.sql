set echo on

CREATE OR REPLACE PACKAGE nom AS
	/*========================================================================*/
		g_spool_key spool.key%TYPE := NULL;
		TYPE t_spool IS REF CURSOR RETURN spool%ROWTYPE;
	/*=======================*/
	FUNCTION checkOut
			(
			p_username VARCHAR2,
			p_event VARCHAR2,
			p_payload VARCHAR2
			)
		RETURN SYS_REFCURSOR;
	/*=======================*/
	FUNCTION checkIn
			(
			p_username VARCHAR2,
			p_event VARCHAR2,
			p_payload VARCHAR2
			)
		RETURN SYS_REFCURSOR;
	/*=======================*/
	FUNCTION getQueues
			(
			p_username VARCHAR2
			)
		RETURN SYS_REFCURSOR;
	/*=======================*/
	FUNCTION xmlOut
			(
            in_tagKey IN tag.key%TYPE
			)
		RETURN SYS_REFCURSOR;
	/*=======================*/
	END nom;
	/*========================================================================*/

/

SHOW ERRORS PACKAGE nom;

/*------------------------------------------------------------------------*/

