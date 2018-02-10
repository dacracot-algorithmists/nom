set echo on
set define off

CREATE OR REPLACE  PACKAGE BODY nom as
	/*========================================================================*/
	PROCEDURE begin_spool
		AS
		/*-----------------------*/
		/*=======================*/
		BEGIN
		/*=======================*/
			SELECT
				key.NEXTVAL
			INTO
				g_spool_key
			FROM
				DUAL;
		/*=======================*/
		END begin_spool;
	/*========================================================================*/
	PROCEDURE into_spool
		(
		in_txt IN spool.txt%TYPE
		)
		AS
		/*-----------------------*/
		/*=======================*/
		BEGIN
		/*=======================*/
			INSERT INTO
				spool
			VALUES
				(
				g_spool_key,
				in_txt,
				seq.NEXTVAL
				);
		/*=======================*/
		END into_spool;
	/*========================================================================*/
	PROCEDURE reset_spool
		AS
		/*-----------------------*/
		/*=======================*/
		BEGIN
		/*=======================*/
			DELETE
				spool
			WHERE
				key = g_spool_key;
			COMMIT;
			begin_spool;
		/*=======================*/
		END reset_spool;
	/*========================================================================*/
	FUNCTION end_spool
		RETURN t_spool
		AS
		/*-----------------------*/
		v_spool t_spool;
		/*=======================*/
		BEGIN
		/*=======================*/
		/*-----------------------*/
			COMMIT;
			OPEN v_spool FOR
				SELECT
					*
				FROM
					spool
				WHERE
					key = g_spool_key
				ORDER BY
					seq;
			RETURN v_spool;
		/*=======================*/
		END end_spool;
	/*========================================================================*/
	FUNCTION timestamp
		RETURN VARCHAR2
		AS
		/*-----------------------*/
		v_result VARCHAR2(14);
		/*=======================*/
		BEGIN
		/*=======================*/
			SELECT
				TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')
			INTO
				v_result
			FROM
				DUAL;
			RETURN v_result;
		/*=======================*/
		END timestamp;
	/*========================================================================*/
	FUNCTION encode
		(
		in_original IN VARCHAR2
		)
		RETURN VARCHAR2
		AS
		/*-----------------------*/
		v_result VARCHAR2(2048);
		/*=======================*/
		BEGIN
		/*=======================*/
		IF (in_original IS NOT NULL) THEN
			v_result:= REPLACE(in_original,'&','&amp;');
			v_result:= REPLACE(v_result,'"','&quot;');
			v_result:= REPLACE(v_result,'<','&lt;');
			v_result:= REPLACE(v_result,'>','&gt;');
		ELSE
			v_result:= NULL;
		END IF;
		/*-----------------------*/
		RETURN v_result;
		/*=======================*/
		END encode;
-- 	/*========================================================================*/
-- 	PROCEDURE recurseModelIn
-- 		(
-- 		in_elemKey IN elem.key%TYPE
-- 		)
-- 		AS
-- 		/*-----------------------*/
-- 		v_hasChildren NUMBER;
-- 		v_buf VARCHAR2(2048);
-- 		v_key elem.key%TYPE;
-- 		v_name elem.name%TYPE;
-- 		v_attr attrLst.name%TYPE;
-- 		/*-----------------------*/
-- 		CURSOR c_children IS
-- 			SELECT
-- 				key
-- 			FROM
-- 				elem
-- 			WHERE
-- 				elemHier = in_elemKey
-- 			ORDER BY
-- 				name;
-- 		/*-----------------------*/
-- 		CURSOR c_attrLst IS
-- 			SELECT
-- 				name
-- 			FROM
-- 				attrLst
-- 			WHERE
-- 				elemKey = in_elemKey
-- 			ORDER BY
-- 				name;
-- 		/*=======================*/
-- 		BEGIN
-- 		/*=======================*/
-- 		SELECT
-- 			name
-- 		INTO
-- 			v_name
-- 		FROM
-- 			elem
-- 		WHERE
-- 			key = in_elemKey;
-- 		v_buf:= '<elem key="'||in_elemKey||'" name="'||v_name||'" ';
-- 		/*-----------------------*/
-- 		OPEN c_attrLst;
-- 		LOOP
-- 			FETCH c_attrLst INTO v_attr;
-- 			EXIT WHEN (c_attrLst%NOTFOUND);
-- 			v_buf:= v_buf||v_attr||'="" ';
-- 		END LOOP;
-- 		CLOSE c_attrLst;
-- 		/*-----------------------*/
-- 		SELECT
-- 			COUNT(key)
-- 		INTO
-- 			v_hasChildren
-- 		FROM
-- 			elem
-- 		WHERE
-- 			elemHier = in_elemKey;
-- 		IF (v_hasChildren <> 0) THEN
-- 			v_buf:= v_buf||'>';
-- 		/*-----------------------*/
-- 			into_spool(v_buf);
-- 			OPEN c_children;
-- 			LOOP
-- 				FETCH c_children INTO v_key;
-- 				EXIT WHEN (c_children%NOTFOUND);
-- 				recurseModelIn(v_key);
-- 			END LOOP;
-- 			CLOSE c_children;
-- 		/*-----------------------*/
-- 			v_buf:= '</elem>';
-- 			into_spool(v_buf);
-- 		ELSE
-- 			v_buf:= v_buf||'/>';
-- 			into_spool(v_buf);
-- 		END IF;
-- 		/*=======================*/
-- 		END recurseModelIn;
	/*========================================================================*/
    PROCEDURE recurseXmlOut
		(
		in_tagKey IN tag.key%TYPE
		)
		AS
		/*-----------------------*/
		v_timestamp VARCHAR(16);
		v_error VARCHAR2(1024);
		v_hasAttributes NUMBER(9);
		v_hasChildren NUMBER(9);
		v_buf VARCHAR2(32767);
		v_tagKey tag.key%TYPE;
		v_tagName elem.name%TYPE;
		v_tagValue tag.value%TYPE;
		v_attrName attrLst.name%TYPE;
		v_attrValue attr.value%TYPE;
		/*-----------------------*/
		CURSOR c_children IS
			SELECT
				key
			FROM
				tag
			WHERE
				tagHier = in_tagKey
			ORDER BY
				key;
		/*-----------------------*/
		CURSOR c_attr IS
			SELECT
				t.name,
				a.value
			FROM
				attr a,
				attrLst t
			WHERE
				a.tagKey = in_tagKey
			AND
				a.attrLstKey = t.key;
		/*=======================*/
		BEGIN
		/*=======================*/
			v_timestamp:= timestamp;
			into_spool('<recurseXmlOut timestamp="'||v_timestamp||'" feedback="ok">');
		/*-----------------------*/
			SELECT
				e.name,
				t.value
			INTO
				v_tagName,
				v_tagValue
			FROM
				tag t,
				elem e
			WHERE
				t.key = in_tagKey
			AND
				t.elemKey = e.key;
			v_buf:= '<'||v_tagName;
		/*-----------------------*/
			SELECT
				COUNT(key)
			INTO
				v_hasAttributes
			FROM
				attr
			WHERE
				tagKey = in_tagKey;
			IF (v_hasAttributes <> 0) THEN
				OPEN c_attr;
				LOOP
					FETCH c_attr INTO v_attrName, v_attrValue;
					EXIT WHEN (c_attr%NOTFOUND);
					v_buf:= v_buf||' '||v_attrName||'="'||v_attrValue||'"';
				END LOOP;
				CLOSE c_attr;
			END IF;
		/*-----------------------*/
			SELECT
				COUNT(key)
			INTO
				v_hasChildren
			FROM
				tag
			WHERE
				tagHier = in_tagKey;
			IF (v_hasChildren <> 0) THEN
				v_buf:= v_buf||'>';
		/*-----------------------*/
				into_spool(v_buf);
				OPEN c_children;
				LOOP
					FETCH c_children INTO v_tagKey;
					EXIT WHEN (c_children%NOTFOUND);
					recurseXmlOut(v_tagKey);
				END LOOP;
				CLOSE c_children;
		/*-----------------------*/
				v_buf:= '</'||v_tagName||'>';
				into_spool(v_buf);
			ELSIF (v_tagValue IS NOT NULL) THEN
				v_buf:= v_buf||'>'||v_tagValue||'</'||v_tagName||'>';
				into_spool(v_buf);
			ELSE
				v_buf:= v_buf||'/>';
				into_spool(v_buf);
			END IF;
		/*-----------------------*/
		EXCEPTION WHEN OTHERS THEN
			reset_spool;
			v_error:= encode(Sqlerrm);
			into_spool('<recurseXmlOut timestamp="'||v_timestamp||'" feedback="error: '||v_error||'"/>');
		/*=======================*/
		END recurseXmlOut;
	/*========================================================================*/
    FUNCTION xmlOut
		(
		in_tagKey IN tag.key%TYPE
		)
        RETURN SYS_REFCURSOR
		AS
		/*-----------------------*/
		/*=======================*/
		BEGIN
		/*=======================*/
			begin_spool;
			recurseXmlOut(in_tagKey);
			RETURN end_spool;
		/*=======================*/
		END xmlOut;
	/*========================================================================*/
	FUNCTION userKnown
			(
			p_username VARCHAR2
			)
		RETURN BOOLEAN
		AS
		/*-----------------------*/
		v_found BOOLEAN:= FALSE;
		v_key client.key%TYPE;
		/*-----------------------*/
		CURSOR c_user_known IS
			SELECT
				key
			FROM
				client
			WHERE
				username = p_username;
		/*=======================*/
		BEGIN
		/*=======================*/
		/*-----------------------*/
		OPEN c_user_known;
		LOOP
			FETCH c_user_known INTO v_key;
			EXIT WHEN (c_user_known%NOTFOUND);
			v_found:= TRUE;
		END LOOP;
		CLOSE c_user_known;
		/*-----------------------*/
		RETURN(v_found);
		/*=======================*/
		END userKnown;		
	/*========================================================================*/
	FUNCTION userPermission
			(
			p_username VARCHAR2,
			p_event VARCHAR2
			)
		RETURN BOOLEAN
		AS
		/*-----------------------*/
		v_found BOOLEAN:= FALSE;
		v_key client.key%TYPE;
		/*-----------------------*/
		CURSOR c_user_permission IS
			SELECT
				c.key
			FROM
				client c,
				duty d,
				role r,
				perm p,
				event e
			WHERE
				c.username = p_username
			AND
				e.name = p_event
			AND
				e.key = p.eventKey
			AND
				p.roleKey = r.key
			AND
				r.key = d.roleKey
			AND
				d.clientKey = c.key;
		/*=======================*/
		BEGIN
		/*=======================*/
		OPEN c_user_permission;
		LOOP
			FETCH c_user_permission INTO v_key;
			EXIT WHEN (c_user_permission%NOTFOUND);
			v_found:= TRUE;
		END LOOP;
		CLOSE c_user_permission;
		/*-----------------------*/
		RETURN(v_found);
		/*=======================*/
		END userPermission;
	/*========================================================================*/
	FUNCTION stateXferGet
			(
			p_event VARCHAR2,
			p_payload VARCHAR2
			)
		RETURN BOOLEAN
		AS
		/*-----------------------*/
		v_allowed BOOLEAN:= FALSE;
		v_key client.key%TYPE;
		/*-----------------------*/
		CURSOR c_state_xfer IS
			SELECT
				w.nextKey
			FROM
				event e,
				switch w,
				target t
			WHERE
				t.key = p_payload
			AND
				t.stateKey = w.stateKey
			AND
				e.name = p_event
			AND
				e.key = w.eventKey;
		/*=======================*/
		BEGIN
		/*=======================*/
		IF (p_event = 'new') THEN
			v_allowed:= TRUE;
		ELSE
		/*-----------------------*/
			OPEN c_state_xfer;
			LOOP
				FETCH c_state_xfer INTO v_key;
				EXIT WHEN (c_state_xfer%NOTFOUND);
				v_allowed:= (v_key <> -1);  -- should all the -1 be deleted so it is not found?
			END LOOP;
			CLOSE c_state_xfer;
		/*-----------------------*/
		END IF;
		RETURN(v_allowed);
		/*=======================*/
		END stateXferGet;
	/*========================================================================*/
	FUNCTION facttLockGet
			(
			p_username VARCHAR2,
			p_event VARCHAR2,
			p_payload IN OUT VARCHAR2
			)
		RETURN BOOLEAN
		AS
		/*-----------------------*/
		v_allowed BOOLEAN:= TRUE;
		v_key client.key%TYPE;
		v_clientKey fact.clientKey%TYPE;
		/*-----------------------*/
		CURSOR c_fact_lock IS
			SELECT
				clientKey
			FROM
				fact
			WHERE
				key = p_payload
			FOR UPDATE;
		/*=======================*/
		BEGIN
		/*=======================*/
		IF (p_event = 'new') THEN
			-- key.NEXTVAL
			SELECT
				key.NEXTVAL
			INTO
				v_key
			FROM
				DUAL;
			p_payload:= v_key;
			-- insert fact locked
			INSERT INTO fact
				(key, workflowKey, stateKey, clientKey)
				SELECT
					v_key,
					0,
					s.key,
					c.key
				FROM
					state s,
					client c
				WHERE
					c.username = p_username
				AND
					s.name = 'draft';
		ELSE
		/*-----------------------*/
			SELECT
				key
			INTO
				v_key
			FROM
				client
			WHERE
				username = p_username;
		/*-----------------------*/
			OPEN c_fact_lock;
			LOOP
				FETCH c_fact_lock INTO v_clientKey;
				EXIT WHEN (c_fact_lock%NOTFOUND);
				-- NULL is unlocked and allowed
				-- same user allowed to accommodate orphaned locks
				IF ((v_clientKey IS NULL) OR (v_clientKey = v_key)) THEN
					UPDATE
						fact
					SET
						clientKey = v_key
					WHERE CURRENT OF
						c_fact_lock;
				ELSE
					v_allowed:= FALSE;
				END IF;
			END LOOP;
			CLOSE c_fact_lock;
		/*-----------------------*/
		END IF;
		RETURN(v_allowed);
		/*=======================*/
		END factLockGet;
	/*========================================================================*/
	FUNCTION checkOut
			(
			p_username VARCHAR2,
			p_event VARCHAR2,
			p_payload VARCHAR2
			)
		RETURN SYS_REFCURSOR
		AS
		/*-----------------------*/
		v_timestamp VARCHAR(16);
		v_error VARCHAR2(1024);
		v_payload target.key%TYPE;
		/*=======================*/
		BEGIN
		/*=======================*/
		begin_spool;
		v_timestamp:= timestamp;
		-- payload is target.key or NULL
		v_payload:= p_payload;
		/*-----------------------*/
		into_spool('<checkOut timestamp="'||v_timestamp||'" feedback="ok">');
		IF (userKnown(p_username)) THEN
			IF (userPermission(p_username,p_event)) THEN
				IF (stateXferGet(p_event,v_payload)) THEN
					IF (targetLockGet(p_username,p_event,v_payload)) THEN
						into_spool(v_payload);
						-- recurseXmlOut(tag.key)
					ELSE
						reset_spool;
						into_spool('<checkOut timestamp="'||v_timestamp||'" feedback="target previously locked for > '||v_payload||'"/>');
						COMMIT;
						RETURN end_spool;
					END IF;
				ELSE
					reset_spool;
					into_spool('<checkOut timestamp="'||v_timestamp||'" feedback="illegal state change for > '||p_event||':'||v_payload||'"/>');
					COMMIT;
					RETURN end_spool;
				END IF;
			ELSE
				reset_spool;
				into_spool('<checkOut timestamp="'||v_timestamp||'" feedback="no permission for > '||p_username||':'||p_event||'"/>');
				COMMIT;
				RETURN end_spool;
			END IF;
		ELSE
			reset_spool;
			into_spool('<checkOut timestamp="'||v_timestamp||'" feedback="unknown user > '||p_username||'"/>');
			COMMIT;
			RETURN end_spool;
		END IF;
		into_spool('</checkOut>');
		RETURN end_spool;
		/*-----------------------*/
		EXCEPTION WHEN OTHERS THEN
			reset_spool;
			v_error:= encode(Sqlerrm);
			into_spool('<checkOut timestamp="'||v_timestamp||'" feedback="error: '||v_error||'"/>');
		/*=======================*/
		END checkOut;
	/*========================================================================*/
	FUNCTION stateXferPost
			(
			p_event VARCHAR2,
			p_payload VARCHAR2,
			p_stateKey IN OUT state.key%TYPE
			)
		RETURN BOOLEAN
		AS
		/*-----------------------*/
		v_allowed BOOLEAN:= FALSE;
		v_key switch.stateKeyNext%TYPE;
		/*-----------------------*/
		CURSOR c_state_xfer IS
			SELECT
				w.nextKey
			FROM
				event e,
				switch w,
				target t
			WHERE
				t.key = p_payload
			AND
				t.stateKey = w.stateKey
			AND
				e.name = p_event
			AND
				e.key = w.eventKey;
		/*=======================*/
		BEGIN
		/*=======================*/
		IF (p_event = 'new') THEN
			v_allowed:= TRUE;
		ELSE
		/*-----------------------*/
			OPEN c_state_xfer;
			LOOP
				FETCH c_state_xfer INTO v_key;
				EXIT WHEN (c_state_xfer%NOTFOUND);
				v_allowed:= (v_key <> -1);  -- should all the -1 be deleted so it is not found?
				p_stateKey:= v_key;
			END LOOP;
			CLOSE c_state_xfer;
		/*-----------------------*/
		END IF;
		RETURN(v_allowed);
		/*=======================*/
		END stateXferPost;
	/*========================================================================*/
	FUNCTION targetLockPost
			(
			p_username VARCHAR2,
			p_event VARCHAR2,
			p_payload IN OUT VARCHAR2
			)
		RETURN BOOLEAN
		AS
		/*-----------------------*/
		v_allowed BOOLEAN:= TRUE;
		v_key client.key%TYPE;
		v_clientKey target.clientKey%TYPE;
		/*-----------------------*/
		CURSOR c_target_lock IS
			SELECT
				clientKey
			FROM
				target
			WHERE
				key = p_payload;
		/*=======================*/
		BEGIN
		/*=======================*/
		SELECT
			key
		INTO
			v_key
		FROM
			client
		WHERE
			username = p_username;
		/*-----------------------*/
		OPEN c_target_lock;
		LOOP
			FETCH c_target_lock INTO v_clientKey;
			EXIT WHEN (c_target_lock%NOTFOUND);
			-- only same user allowed
			v_allowed:= (v_clientKey = v_key);
		END LOOP;
		CLOSE c_target_lock;
		/*-----------------------*/
		RETURN(v_allowed);
		/*=======================*/
		END targetLockPost;
	/*========================================================================*/
	PROCEDURE targetUnlock
			(
			p_targetKey target.key%TYPE,
			p_stateKey IN OUT state.key%TYPE
			)
		AS
		/*=======================*/
		BEGIN
		/*=======================*/
		UPDATE
			target
		SET
			clientKey = NULL,
			stateKey = p_stateKey
		WHERE
			key = p_targetKey;
		/*=======================*/
		END targetUnlock;
	/*========================================================================*/
	FUNCTION checkIn
			(
			p_username VARCHAR2,
			p_event VARCHAR2,
			p_payload VARCHAR2
			)
		RETURN SYS_REFCURSOR
		AS
		/*-----------------------*/
		v_timestamp VARCHAR(16);
		v_error VARCHAR2(1024);
		v_payload target.key%TYPE;
		v_nextKey switch.nextKey%TYPE;
		/*=======================*/
		BEGIN
		/*=======================*/
		begin_spool;
		v_timestamp:= timestamp;
		-- payload is structured document
		v_payload:= p_payload;
		/*-----------------------*/
		into_spool('<checkIn timestamp="'||v_timestamp||'" feedback="ok">');
		IF (userKnown(p_username)) THEN
			IF (userPermission(p_username,p_event)) THEN
				IF (stateXferPost(p_event,v_payload,v_nextKey)) THEN
					IF (targetLockPost(p_username,p_event,v_payload)) THEN
						into_spool(v_payload);
						-- recurseModelIn(xml)
						targetUnlock(v_payload,v_nextKey);
					ELSE
						reset_spool;
						into_spool('<checkIn timestamp="'||v_timestamp||'" feedback="target locked elsewhere > '||p_username||':'||v_payload||'"/>');
						COMMIT;
						RETURN end_spool;
					END IF;
				ELSE
					reset_spool;
					into_spool('<checkIn timestamp="'||v_timestamp||'" feedback="illegal state change for > '||p_event||':'||v_payload||'"/>');
					COMMIT;
					RETURN end_spool;
				END IF;
			ELSE
				reset_spool;
				into_spool('<checkIn timestamp="'||v_timestamp||'" feedback="no permission for > '||p_username||':'||p_event||'"/>');
				COMMIT;
				RETURN end_spool;
			END IF;
		ELSE
			reset_spool;
			into_spool('<checkIn timestamp="'||v_timestamp||'" feedback="unknown user > '||p_username||'"/>');
			COMMIT;
			RETURN end_spool;
		END IF;
		into_spool('</checkIn>');
		RETURN end_spool;
		/*-----------------------*/
		EXCEPTION WHEN OTHERS THEN
			reset_spool;
			v_error:= encode(Sqlerrm);
			into_spool('<checkIn timestamp="'||v_timestamp||'" feedback="error: '||v_error||'"/>');
			COMMIT;
			RETURN end_spool;
		/*=======================*/
		END checkIn;
	/*========================================================================*/
	FUNCTION getQueues
			(
			p_username VARCHAR2
			)
		RETURN SYS_REFCURSOR
		AS
		/*-----------------------*/
		v_timestamp VARCHAR(16);
		v_error VARCHAR2(1024);
		v_roleName role.name%TYPE;
		v_eventName event.name%TYPE;
		v_stateKey state.key%TYPE;
		v_targetKey target.key%TYPE;
		v_clientName client.name%TYPE;
		/*-----------------------*/
		CURSOR c_permissions IS
			SELECT
				r.name,
				e.name,
				s1.key
			FROM
				client c,
				duty d,
				role r,
				perm p,
				event e,
				switch w,
				state s1,
				state s2
			WHERE
				c.username = p_username AND
				c.key = d.clientKey AND
				d.roleKey = r.key AND
				r.key = p.roleKey AND
				p.eventKey = e.key AND
				e.key = w.eventKey AND
				e.name <> 'edit' AND
				e.name <> 'cancel' AND
				e.name <> 'exit(early)' AND
				w.stateKey = s1.key AND
				w.nextKey = s2.key AND
				w.nextKey <> -1
			ORDER BY
				1,2;
		/*-----------------------*/
		CURSOR c_targets IS
			SELECT
				t.key,
				c.name
			FROM
				client c,
				target t
			WHERE
				t.stateKey = v_stateKey AND
				t.clientKey = c.key(+);
		/*=======================*/
		BEGIN
		/*=======================*/
		begin_spool;
		v_timestamp:= timestamp;
		/*-----------------------*/
		into_spool('<getQueues timestamp="'||v_timestamp||'" feedback="ok">');
		into_spool('<echo key="user">'||p_username||'</echo>');
		/*-----------------------*/
		OPEN c_permissions;
		LOOP
			FETCH c_permissions INTO v_roleName, v_eventName, v_stateKey;
			EXIT WHEN (c_permissions%NOTFOUND);
			into_spool('<queue role="'||v_roleName||'" event="'||v_eventName||'">');
		/*-----------------------*/
			OPEN c_targets;
			LOOP
				FETCH c_targets INTO v_targetKey, v_clientName;
				EXIT WHEN (c_targets%NOTFOUND);
				into_spool('<target key="'||v_targetKey||'" lockedBy="'||v_clientName||'"/>');
			END LOOP;
			CLOSE c_targets;
		/*-----------------------*/
			into_spool('</queue>');
		END LOOP;
		CLOSE c_permissions;
		/*-----------------------*/
		into_spool('</getQueues>');
		RETURN end_spool;
		EXCEPTION WHEN OTHERS THEN
			reset_spool;
			v_error:= encode(Sqlerrm);
			into_spool('<getQueues timestamp="'||v_timestamp||'" feedback="error: '||v_error||'"/>');
			COMMIT;
			RETURN end_spool;
		/*=======================*/
		END getQueues;
	/*========================================================================*/
	END nom;
	/*========================================================================*/

/

SHOW ERRORS PACKAGE BODY nom;

/*------------------------------------------------------------------------*/

