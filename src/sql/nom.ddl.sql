set echo on
spool nom.ddl.sql.err

/*------------------------------------------------------------------------*/

CREATE SEQUENCE key START WITH 10000;
CREATE SEQUENCE seq START WITH 1;

/*------------------------------------------------------------------------*/

CREATE TABLE app
	(
	version VARCHAR2(255) NOT NULL,
	uri VARCHAR2(1024) NOT NULL
	)
;

/*-------------------------------------*/

COMMENT ON TABLE app IS 'App defines the application version and URI location.';

/*------------------------------------------------------------------------*/

CREATE TABLE spool
	(
	key NUMBER(11) NOT NULL,
	txt VARCHAR2(2048) NULL,
	seq NUMBER(11) NOT NULL
	)
;

/*-------------------------------------*/

ALTER TABLE spool NOLOGGING;

/*-------------------------------------*/

COMMENT ON TABLE spool IS 'Spool temporarily hold data constructed for the client.';

/*------------------------------------------------------------------------*/

CREATE TABLE client
	(
	key NUMBER(11) NOT NULL CONSTRAINT clientPkey PRIMARY KEY USING INDEX,
	name VARCHAR2(255) NOT NULL,
	describe VARCHAR2(1024),
	username VARCHAR2(1024)
	)
;

/*-------------------------------------*/

COMMENT ON TABLE client IS 'Users of the system, either human or machine.';

/*------------------------------------------------------------------------*/

CREATE TABLE class
	(
	key NUMBER(11) NOT NULL CONSTRAINT classPkey PRIMARY KEY USING INDEX,
	abbrv VARCHAR2(31) NOT NULL,
	name VARCHAR2(255) NOT NULL,
	describe VARCHAR2(1024)
	)
;

/*-------------------------------------*/

COMMENT ON TABLE class IS 'Classification definitions.';

/*------------------------------------------------------------------------*/

CREATE TABLE cleared
	(
	classKey NUMBER(11) NOT NULL,
	clientKey NUMBER(11) NOT NULL
	)
;

/*-------------------------------------*/

COMMENT ON TABLE cleared IS 'The association of users and their clearances.';

/*-------------------------------------*/

CREATE INDEX clearedClassFndx ON
	cleared
		(
		classKey
		)
;

/*-------------------------------------*/

CREATE INDEX clearedClientFndx ON
	cleared
		(
		clientKey
		)
;

/*------------------------------------------------------------------------*/

CREATE TABLE disallows
	(
	classKey NUMBER(11) NOT NULL,
	disallowsKey NUMBER(11) NOT NULL
	)
;

/*-------------------------------------*/

COMMENT ON TABLE disallows IS 'The relationship of how one classification can disallow another.  (Confidential disallows Unclassified)';

/*-------------------------------------*/

CREATE INDEX disallowsClassFndx ON
	disallows
		(
		classKey
		)
;

/*-------------------------------------*/

CREATE INDEX disallowsClassDisallowsFndx ON
	disallows
		(
		disallowsKey
		)
;

/*------------------------------------------------------------------------*/

CREATE TABLE implied
	(
	classKey NUMBER(11) NOT NULL,
	impliedKey NUMBER(11) NOT NULL
	)
;

/*-------------------------------------*/

COMMENT ON TABLE implied IS 'The relationship of how one classification can imply another.  (RELTO FVEY implies RELTO USA)';

/*-------------------------------------*/

CREATE INDEX impliedClassFndx ON
	implied
		(
		classKey
		)
;

/*-------------------------------------*/

CREATE INDEX impliedClassImpliedFndx ON
	implied
		(
		impliedKey
		)
;

/*------------------------------------------------------------------------*/

CREATE TABLE marking
	(
	classKey NUMBER(11) NOT NULL,
	tagKey NUMBER(11) NOT NULL
	)
;

/*-------------------------------------*/

COMMENT ON TABLE marking IS 'The association of data to its classifications.';

/*-------------------------------------*/

CREATE INDEX markingClassFndx ON
	marking
		(
		classKey
		)
;

/*-------------------------------------*/

CREATE INDEX markingTagFndx ON
	marking
		(
		tagKey
		)
;

/*------------------------------------------------------------------------*/

CREATE TABLE required
	(
	classKey NUMBER(11) NOT NULL,
	requiredKey NUMBER(11) NOT NULL
	)
;

/*-------------------------------------*/

COMMENT ON TABLE required IS 'The relationship of how one classification can requires another.  (RD requires SECRET or higher)';

/*-------------------------------------*/

CREATE INDEX requiredClassFndx ON
	required
		(
		classKey
		)
;

/*-------------------------------------*/

CREATE INDEX requiredClassRequiredFndx ON
	required
		(
		requiredKey
		)
;

/*------------------------------------------------------------------------*/

CREATE TABLE trumps
	(
	classKey NUMBER(11) NOT NULL,
	trumpsKey NUMBER(11) NOT NULL
	)
;

/*-------------------------------------*/

COMMENT ON TABLE trumps IS 'The relationship of how one classification can trumps another.  (example?)';

/*-------------------------------------*/

CREATE INDEX trumpsClassFndx ON
	trumps
		(
		classKey
		)
;

/*-------------------------------------*/

CREATE INDEX trumpsClassTrumpsFndx ON
	trumps
		(
		trumpsKey
		)
;

/*------------------------------------------------------------------------*/

CREATE TABLE role
	(
	key NUMBER(11) NOT NULL CONSTRAINT rolePkey PRIMARY KEY USING INDEX,
	name VARCHAR2(255) NOT NULL,
	describe VARCHAR2(1024)
	)
;

/*-------------------------------------*/

COMMENT ON TABLE role IS 'Role defines a grouping of permissions to control events.';

/*------------------------------------------------------------------------*/

CREATE TABLE duty
	(
	clientKey NUMBER(11) NOT NULL,
	roleKey NUMBER(11) NOT NULL
	)
;

/*-------------------------------------*/

COMMENT ON TABLE duty IS 'Duty is an association of users to roles.';

/*-------------------------------------*/

CREATE INDEX dutyClientkey ON
	duty
		(
		clientKey
		)
;

/*-------------------------------------*/

CREATE INDEX dutyRoleFndx ON
	duty
		(
		roleKey
		)
;

/*------------------------------------------------------------------------*/

CREATE TABLE perm
	(
	eventKey NUMBER(11) NOT NULL,
	roleKey NUMBER(11) NOT NULL
	)
;

/*-------------------------------------*/

COMMENT ON TABLE perm IS 'Permission is an association of events to roles.';

/*-------------------------------------*/

CREATE INDEX permEventFndx ON
	perm
		(
		eventKey
		)
;

/*-------------------------------------*/

CREATE INDEX permRoleFndx ON
	perm
		(
		roleKey
		)
;

/*------------------------------------------------------------------------*/

CREATE TABLE readonly
	(
	xpath VARCHAR2(1024) NOT NULL,
	roleKey NUMBER(11) NOT NULL
	)
;

/*-------------------------------------*/

COMMENT ON TABLE readonly IS 'Readonly associates a role with the path within the document tree that should be read only.';

/*-------------------------------------*/

CREATE INDEX readonlyRoleFndx ON
	readonly
		(
		roleKey
		)
;

/*------------------------------------------------------------------------*/

CREATE TABLE hide
	(
	xpath VARCHAR2(1024) NOT NULL,
	roleKey NUMBER(11) NOT NULL
	)
;

/*-------------------------------------*/

COMMENT ON TABLE hide IS 'Hide associates a role with the path within the document tree that should be hidden.';

/*-------------------------------------*/

CREATE INDEX hideRoleFndx ON
	hide
		(
		roleKey
		)
;

/*------------------------------------------------------------------------*/

CREATE TABLE subscribe
	(
	clientKey NUMBER(11) NOT NULL,
	eventKey NUMBER(11) NOT NULL,
	pushUrl VARCHAR2(1024) NOT NULL,
	xslUrlOut VARCHAR2(1024) NOT NULL
	)
;

/*-------------------------------------*/

COMMENT ON TABLE subscribe IS 'Subscribe pushes events to users after their execution.';

/*-------------------------------------*/

CREATE INDEX subscribeClientFndx ON
	subscribe
		(
		clientKey
		)
;

/*-------------------------------------*/

CREATE INDEX subscribeEventFndx ON
	subscribe
		(
		eventKey
		)
;

/*------------------------------------------------------------------------*/

CREATE TABLE translate
	(
	clientKey NUMBER(11) NOT NULL,
	eventKey NUMBER(11) NOT NULL,
	xslUrlIn VARCHAR2(1024) NOT NULL,
	xslUrlOut VARCHAR2(1024) NOT NULL
	)
;

/*-------------------------------------*/

COMMENT ON TABLE translate IS 'Translate provides the transform URL for events and clients.';

/*-------------------------------------*/

CREATE INDEX translateClientFndx ON
	translate
		(
		clientKey
		)
;

/*-------------------------------------*/

CREATE INDEX translateEventFndx ON
	translate
		(
		eventKey
		)
;

/*------------------------------------------------------------------------*/

CREATE TABLE attr
	(
	key NUMBER(11) NOT NULL CONSTRAINT attrPkey PRIMARY KEY USING INDEX,
	value CLOB,
	attrLstKey NUMBER(11) NOT NULL,
	tagKey NUMBER(11) NOT NULL
	)
;

/*-------------------------------------*/

COMMENT ON TABLE attr IS 'Attributes associated with an instance of an tag.';

/*-------------------------------------*/

CREATE INDEX attrAttrLstFndx ON
	attr
		(
		attrLstKey
		)
;

/*-------------------------------------*/

CREATE INDEX attrTagFndx ON
	attr
		(
		tagKey
		)
;

/*------------------------------------------------------------------------*/

CREATE TABLE fact
	(
	tagKey NUMBER(11) NOT NULL,
	clientKey NUMBER(11) NOT NULL,
	eventKey NUMBER(11) NOT NULL,
	stateKey NUMBER(11) NOT NULL,
	clientKeyLock NUMBER(11),
	clock DATE NOT NULL
	)
;

/*-------------------------------------*/

COMMENT ON TABLE fact IS 'Fact is a document tree created by an event.';

/*-------------------------------------*/

CREATE INDEX factTagFndx ON
	fact
		(
		tagKey
		)
;

/*-------------------------------------*/

CREATE INDEX factEventFndx ON
	fact
		(
		eventKey
		)
;

/*-------------------------------------*/

CREATE INDEX factClientFndx ON
	fact
		(
		clientKey
		)
;

/*-------------------------------------*/

CREATE INDEX targetStateFndx ON
	fact
		(
		stateKey
		)
;

/*-------------------------------------*/

CREATE INDEX targetClientLockFndx ON
	fact
		(
		clientKeyLock
		)
;

/*------------------------------------------------------------------------*/

CREATE TABLE tag
	(
	key NUMBER(11) NOT NULL CONSTRAINT tagPkey PRIMARY KEY USING INDEX,
	value CLOB,
	elemKey NUMBER(11) NOT NULL,
	tagHier NUMBER(11)
	)
;

/*-------------------------------------*/

COMMENT ON TABLE tag IS 'Tag is an instance of an element.';

/*-------------------------------------*/

CREATE INDEX tagElemFndx ON
	tag
		(
		elemKey
		)
;

/*-------------------------------------*/

CREATE INDEX tagTagFndx ON
	tag
		(
		tagHier
		)
;

/*------------------------------------------------------------------------*/

CREATE TABLE event
	(
	key NUMBER(11) NOT NULL CONSTRAINT eventPkey PRIMARY KEY USING INDEX,
	name VARCHAR2(255) NOT NULL,
	describe VARCHAR2(1024)
	)
;

/*-------------------------------------*/

COMMENT ON TABLE event IS 'Event is a action that affects the data in the data store.  Not to be confused with an event defined by the ontology.';

/*------------------------------------------------------------------------*/

CREATE TABLE gather
	(
	xpath VARCHAR2(1024) NOT NULL,
	eventKey NUMBER(11) NOT NULL
	)
;

/*-------------------------------------*/

COMMENT ON TABLE gather IS 'Gather associates an event with the path within the document tree that should be generated upon its execution.';

/*-------------------------------------*/

CREATE INDEX gatherEventFndx ON
	gather
		(
		eventKey
		)
;

/*------------------------------------------------------------------------*/

CREATE TABLE state
	(
	key NUMBER(11) NOT NULL CONSTRAINT statePkey PRIMARY KEY USING INDEX,
	name VARCHAR2(255) NOT NULL,
	describe VARCHAR2(1024)
	)
;

/*-------------------------------------*/

COMMENT ON TABLE state IS 'State is the categorical condition of a fact of data. Negative keys are prohibited state changes.';

/*------------------------------------------------------------------------*/

CREATE TABLE switch
	(
	eventKey NUMBER(11) NOT NULL,
	stateKey NUMBER(11) NOT NULL,
	stateKeyNext NUMBER(11) NOT NULL
	)
;

/*-------------------------------------*/

COMMENT ON TABLE switch IS 'Switch defines the state transition between the current state and execution of an event.';

/*-------------------------------------*/

CREATE INDEX switchEventFndx ON
	switch
		(
		eventKey
		)
;

/*-------------------------------------*/

CREATE INDEX switchStateFndx ON
	switch
		(
		stateKey
		)
;

/*-------------------------------------*/

CREATE INDEX switchStateNextFndx ON
	switch
		(
		stateKeyNext
		)
;

/*------------------------------------------------------------------------*/

CREATE TABLE attrLst
	(
	key NUMBER(11) NOT NULL CONSTRAINT attrLstPkey PRIMARY KEY USING INDEX,
	name VARCHAR2(255) NOT NULL,
	elemKey NUMBER(11) NOT NULL,
	attrTypeKey NUMBER(11) NOT NULL
	)
;

/*-------------------------------------*/

COMMENT ON TABLE attrLst IS 'The list of attributes that may be applied to a instance of an element.';

/*-------------------------------------*/

CREATE INDEX attrLstElemFndx ON
	attrLst
		(
		elemKey
		)
;

/*-------------------------------------*/

CREATE INDEX attrLstAttrTypeFndx ON
	attrLst
		(
		attrTypeKey
		)
;

/*------------------------------------------------------------------------*/

CREATE TABLE choice
	(
	key NUMBER(11) NOT NULL CONSTRAINT choicePkey PRIMARY KEY USING INDEX,
	name VARCHAR2(255) NOT NULL,
	describe VARCHAR2(1024)
	)
;

/*-------------------------------------*/

COMMENT ON TABLE choice IS 'One of several options if there is an enumerated list of values for an attribute.';

/*------------------------------------------------------------------------*/

CREATE TABLE attrType
	(
	key NUMBER(11) NOT NULL CONSTRAINT attrTypePkey PRIMARY KEY USING INDEX,
	name VARCHAR2(255) NOT NULL,
	describe VARCHAR2(1024),
	mask VARCHAR2(255)
	)
;

/*-------------------------------------*/

COMMENT ON TABLE attrType IS 'A data type specification for an attribute. (floating point)';

/*------------------------------------------------------------------------*/

CREATE TABLE elem
	(
	key NUMBER(11) NOT NULL CONSTRAINT elemPkey PRIMARY KEY USING INDEX,
	name VARCHAR2(255) NOT NULL,
	elemHier NUMBER(11)
	)
;

/*-------------------------------------*/

COMMENT ON TABLE elem IS 'The definition of a entity.';

/*-------------------------------------*/

CREATE INDEX elemElemFndx ON
	elem
		(
		elemHier
		)
;

/*------------------------------------------------------------------------*/

CREATE TABLE enum
	(
	attrTypeKey NUMBER(11) NOT NULL,
	choiceKey NUMBER(11) NOT NULL
	)
;

/*-------------------------------------*/

COMMENT ON TABLE enum IS 'The association of a attribute and the list of valid choices.';

/*-------------------------------------*/

CREATE INDEX enumAttrTypeFndx ON
	enum
		(
		attrTypeKey
		)
;

/*-------------------------------------*/

CREATE INDEX enumChoiceFndx ON
	enum
		(
		choiceKey
		)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		cleared
	ADD CONSTRAINT
		clearedClassFkey
	FOREIGN KEY
		(classKey)
	REFERENCES
		class(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		cleared
	ADD CONSTRAINT
		clearedClientFkey
	FOREIGN KEY
		(clientKey)
	REFERENCES
		client(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		disallows
	ADD CONSTRAINT
		disallowsClassFkey
	FOREIGN KEY
		(classKey)
	REFERENCES
		class(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		disallows
	ADD CONSTRAINT
		disallowsClassDisallowsFkey
	FOREIGN KEY
		(disallowsKey)
	REFERENCES
		class(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		implied
	ADD CONSTRAINT
		impliedClassFkey
	FOREIGN KEY
		(classKey)
	REFERENCES
		class(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		implied
	ADD CONSTRAINT
		impliedClassImpliedFkey
	FOREIGN KEY
		(impliedKey)
	REFERENCES
		class(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		marking
	ADD CONSTRAINT
		markingClassFkey
	FOREIGN KEY
		(classKey)
	REFERENCES
		class(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		required
	ADD CONSTRAINT
		requiredClassFkey
	FOREIGN KEY
		(classKey)
	REFERENCES
		class(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		required
	ADD CONSTRAINT
		requiredClassRequiredFkey
	FOREIGN KEY
		(requiredKey)
	REFERENCES
		class(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		trumps
	ADD CONSTRAINT
		trumpsClassFkey
	FOREIGN KEY
		(classKey)
	REFERENCES
		class(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		trumps
	ADD CONSTRAINT
		trumpsClassTrumpsFkey
	FOREIGN KEY
		(trumpsKey)
	REFERENCES
		class(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		duty
	ADD CONSTRAINT
		dutyClientkey
	FOREIGN KEY
		(clientKey)
	REFERENCES
		client(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		duty
	ADD CONSTRAINT
		dutyRoleFkey
	FOREIGN KEY
		(roleKey)
	REFERENCES
		role(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		perm
	ADD CONSTRAINT
		permEventFkey
	FOREIGN KEY
		(eventKey)
	REFERENCES
		event(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		perm
	ADD CONSTRAINT
		permRoleFkey
	FOREIGN KEY
		(roleKey)
	REFERENCES
		role(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		subscribe
	ADD CONSTRAINT
		subscribeClientFkey
	FOREIGN KEY
		(clientKey)
	REFERENCES
		client(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		subscribe
	ADD CONSTRAINT
		subscribeEventFkey
	FOREIGN KEY
		(eventKey)
	REFERENCES
		event(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		translate
	ADD CONSTRAINT
		translateClientFkey
	FOREIGN KEY
		(clientKey)
	REFERENCES
		client(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		translate
	ADD CONSTRAINT
		translateEventFkey
	FOREIGN KEY
		(eventKey)
	REFERENCES
		event(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		attr
	ADD CONSTRAINT
		attrAttrLstFkey
	FOREIGN KEY
		(attrLstKey)
	REFERENCES
		attrLst(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		attr
	ADD CONSTRAINT
		attrTagFkey
	FOREIGN KEY
		(tagKey)
	REFERENCES
		tag(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		fact
	ADD CONSTRAINT
		factTagFkey
	FOREIGN KEY
		(tagKey)
	REFERENCES
		tag(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		fact
	ADD CONSTRAINT
		factEventFkey
	FOREIGN KEY
		(eventKey)
	REFERENCES
		event(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		fact
	ADD CONSTRAINT
		factClientFkey
	FOREIGN KEY
		(clientKey)
	REFERENCES
		client(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		fact
	ADD CONSTRAINT
		factStateFkey
	FOREIGN KEY
		(stateKey)
	REFERENCES
		state(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		fact
	ADD CONSTRAINT
		factClientLockFkey
	FOREIGN KEY
		(clientKeyLock)
	REFERENCES
		client(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		tag
	ADD CONSTRAINT
		tagElemFkey
	FOREIGN KEY
		(elemKey)
	REFERENCES
		elem(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		tag
	ADD CONSTRAINT
		tagTagFkey
	FOREIGN KEY
		(tagHier)
	REFERENCES
		tag(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		gather
	ADD CONSTRAINT
		gatherEventFkey
	FOREIGN KEY
		(eventKey)
	REFERENCES
		event(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		readonly
	ADD CONSTRAINT
		readonlyRoleFkey
	FOREIGN KEY
		(roleKey)
	REFERENCES
		role(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		hide
	ADD CONSTRAINT
		hideRoleFkey
	FOREIGN KEY
		(roleKey)
	REFERENCES
		role(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		switch
	ADD CONSTRAINT
		switchEventFkey
	FOREIGN KEY
		(eventKey)
	REFERENCES
		event(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		switch
	ADD CONSTRAINT
		switchStateFkey
	FOREIGN KEY
		(stateKey)
	REFERENCES
		state(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		switch
	ADD CONSTRAINT
		switchStateNextFkey
	FOREIGN KEY
		(stateKeyNext)
	REFERENCES
		state(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		attrLst
	ADD CONSTRAINT
		attrLstElemFkey
	FOREIGN KEY
		(elemKey)
	REFERENCES
		elem(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		attrLst
	ADD CONSTRAINT
		attrLstAttrTypeFkey
	FOREIGN KEY
		(attrTypeKey)
	REFERENCES
		attrType(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		elem
	ADD CONSTRAINT
		elemElemFkey
	FOREIGN KEY
		(elemHier)
	REFERENCES
		elem(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		enum
	ADD CONSTRAINT
		enumAttrTypeFkey
	FOREIGN KEY
		(attrTypeKey)
	REFERENCES
		attrType(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		enum
	ADD CONSTRAINT
		enumChoiceFkey
	FOREIGN KEY
		(choiceKey)
	REFERENCES
		choice(key)
;

/*------------------------------------------------------------------------*/

ALTER TABLE
		marking
	ADD CONSTRAINT
		markingTagFkey
	FOREIGN KEY
		(tagKey)
	REFERENCES
		tag(key)
;

/*------------------------------------------------------------------------*/

CREATE OR REPLACE CONTEXT session_context USING session_context_api;

/*-------------------------------------*/

CREATE OR REPLACE PACKAGE session_context_api AS
	PROCEDURE set_key_value(p_key IN VARCHAR2, p_value IN VARCHAR2);
END session_context_api;
/
SHOW ERRORS PACKAGE session_context_api

/*-------------------------------------*/

CREATE OR REPLACE PACKAGE BODY session_context_api IS
	/*---------------------------------*/
	PROCEDURE set_key_value(p_key IN VARCHAR2, p_value IN VARCHAR2) IS
		BEGIN
			DBMS_SESSION.set_context('session_context', p_key, p_value);
		END set_key_value;
	/*---------------------------------*/
END session_context_api;
/
SHOW ERRORS PACKAGE BODY session_context_api

/*------------------------------------------------------------------------*/

CREATE OR REPLACE PACKAGE audit_ddl AS
	PROCEDURE add_audit;
	PROCEDURE add_archive;
END audit_ddl;
/
SHOW ERRORS PACKAGE audit_ddl

/*-------------------------------------*/

CREATE OR REPLACE PACKAGE BODY audit_ddl IS
	/*---------------------------------*/
	PROCEDURE add_audit AS 
		v_count NUMBER:= 0;
		CURSOR c_tab IS
			SELECT UNIQUE table_name FROM user_tab_columns WHERE table_name <> 'SPOOL' ORDER BY table_name;
		v_tab VARCHAR2(255);
		BEGIN

			DELETE spool;
			COMMIT;
	
			OPEN c_tab;
				LOOP
					FETCH c_tab INTO v_tab;
					EXIT WHEN (c_tab%NOTFOUND);

					INSERT INTO spool VALUES(v_count,'ALTER TABLE '||v_tab||' ADD audit_user VARCHAR2(31) DEFAULT USER;',seq.NEXTVAL);
					INSERT INTO spool VALUES(v_count,'ALTER TABLE '||v_tab||' ADD audit_client NUMBER(11) DEFAULT SYS_CONTEXT(''session_context'', ''clientKey'');',seq.NEXTVAL);
					INSERT INTO spool VALUES(v_count,'ALTER TABLE '||v_tab||' ADD audit_edited TIMESTAMP DEFAULT CURRENT_TIMESTAMP;',seq.NEXTVAL);

					v_count:= v_count + 1;

				END LOOP;
			CLOSE c_tab;
			COMMIT;

		END add_audit;
	/*---------------------------------*/
	PROCEDURE add_archive AS 
		v_count NUMBER:= 0;
		CURSOR c_tab IS
			SELECT UNIQUE table_name FROM user_tab_columns WHERE table_name <> 'SPOOL' ORDER BY table_name;
		v_tab VARCHAR2(255);
		CURSOR c_col IS
			SELECT ':old.'||column_name||',' FROM user_tab_columns where table_name = v_tab ORDER BY column_id;
		v_col VARCHAR2(255);
		BEGIN

			DELETE spool;
			COMMIT;
	
			OPEN c_tab;
				LOOP
					FETCH c_tab INTO v_tab;
					EXIT WHEN (c_tab%NOTFOUND);

					INSERT INTO spool VALUES(v_count,'CREATE TABLE '||v_tab||'$ AS SELECT * FROM '||v_tab||';',seq.NEXTVAL);
					INSERT INTO spool VALUES(v_count,'ALTER TABLE '||v_tab||'$ ADD audit_archived TIMESTAMP;',seq.NEXTVAL);
					INSERT INTO spool VALUES(v_count,'COMMENT ON TABLE app$ IS ''Historical '||v_tab||'.'';',seq.NEXTVAL);
					INSERT INTO spool VALUES(v_count,'CREATE TRIGGER '||v_tab||'$'||v_tab||' BEFORE UPDATE OR DELETE ON '||v_tab||' FOR EACH ROW',seq.NEXTVAL);
					INSERT INTO spool VALUES(v_count,'BEGIN INSERT INTO '||v_tab||'$ VALUES(',seq.NEXTVAL);
					OPEN c_col;
						LOOP
							FETCH c_col INTO v_col;
							EXIT WHEN (c_col%NOTFOUND);
							INSERT INTO spool VALUES(v_count,v_col,seq.NEXTVAL);
						END LOOP;
					CLOSE c_col;
					INSERT INTO spool VALUES(v_count,'CURRENT_TIMESTAMP);',seq.NEXTVAL);
					INSERT INTO spool VALUES(v_count,'END '||v_tab||'$'||v_tab||';',seq.NEXTVAL);
					INSERT INTO spool VALUES(v_count,'/',seq.NEXTVAL);
					INSERT INTO spool VALUES(v_count,'SHOW ERRORS TRIGGER '||v_tab||'$'||v_tab||';',seq.NEXTVAL);
					INSERT INTO spool VALUES(v_count,'ALTER TRIGGER '||v_tab||'$'||v_tab||' ENABLE;',seq.NEXTVAL);

					v_count:= v_count + 1;

				END LOOP;
			CLOSE c_tab;
			COMMIT;

		END add_archive;
	/*---------------------------------*/
END audit_ddl;
/
SHOW ERRORS PACKAGE BODY audit_ddl

/*------------------------------------------------------------------------*/

spool off
