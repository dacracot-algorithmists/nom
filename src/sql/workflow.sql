set echo on
spool workflow.sql.err
------------
exec session_context_api.set_key_value('clientKey','0');
------------
insert into client (key, name, describe) values (0, 'som', 'Semantic Ontology Model Application Owner');
insert into client (key, name,username) values (37, 'Joe Admin', 'joe1');
insert into client (key, name,username) values (38, 'Mary Host', 'mary1');
insert into client (key, name,username) values (39, 'Jane Czar', 'jane1');
insert into client (key, name,username) values (40, 'Joe SME', 'joe2');
insert into client (key, name,username) values (41, 'Bob SME', 'bob1');
insert into client (key, name,username) values (42, 'Harry SME', 'harry1');
------------
-- insert into workflow (key, name, describe) values (0, 'LLNL-VTS', 'Livermore Visitor Tracking');
------------
insert into event (key, name) values (1, 'new');
insert into event (key, name) values (2, 'edit');
insert into event (key, name) values (3, 'submit');
insert into event (key, name) values (4, 'acknowledge');
insert into event (key, name) values (5, 'proceed');
insert into event (key, name) values (6, 'final');
insert into event (key, name) values (7, 'reject');
insert into event (key, name) values (8, 'cancel');
insert into event (key, name) values (9, 'approve');
insert into event (key, name) values (12, 'arrive');
insert into event (key, name) values (13, 'exit');
insert into event (key, name) values (14, 'exit(early)');
------------
insert into state (key, name) values (-1, 'ERROR');
insert into state (key, name) values (15, 'draft');
insert into state (key, name) values (16, 'submitted');
insert into state (key, name) values (17, 'acknowledged');
insert into state (key, name) values (18, 'proceeding');
insert into state (key, name) values (19, 'rejected');
insert into state (key, name) values (20, 'cancelled');
insert into state (key, name) values (21, 'arrived');
insert into state (key, name) values (22, 'exited');
insert into state (key, name) values (23, 'exited(early)');
insert into state (key, name) values (24, 'finalized');
insert into state (key, name) values (25, 'approved1');
insert into state (key, name) values (26, 'approved2');
insert into state (key, name) values (27, 'approved3');
------------
-- new
insert into switch (eventKey, stateKey, stateKeyNext) values (1,15,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (1,16,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (1,17,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (1,18,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (1,19,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (1,20,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (1,21,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (1,22,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (1,23,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (1,24,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (1,25,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (1,26,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (1,27,-1);
-- edit
insert into switch (eventKey, stateKey, stateKeyNext) values (2,15,15);
insert into switch (eventKey, stateKey, stateKeyNext) values (2,16,16);
insert into switch (eventKey, stateKey, stateKeyNext) values (2,17,17);
insert into switch (eventKey, stateKey, stateKeyNext) values (2,18,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (2,19,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (2,20,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (2,21,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (2,22,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (2,23,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (2,24,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (2,25,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (2,26,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (2,27,-1);
-- submit
insert into switch (eventKey, stateKey, stateKeyNext) values (3,15,16);
insert into switch (eventKey, stateKey, stateKeyNext) values (3,16,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (3,17,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (3,18,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (3,19,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (3,20,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (3,21,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (3,22,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (3,23,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (3,24,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (3,25,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (3,26,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (3,27,-1);
-- acknowledge
insert into switch (eventKey, stateKey, stateKeyNext) values (4,15,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (4,16,17);
insert into switch (eventKey, stateKey, stateKeyNext) values (4,17,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (4,18,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (4,19,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (4,20,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (4,21,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (4,22,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (4,23,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (4,24,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (4,25,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (4,26,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (4,27,-1);
-- proceed
insert into switch (eventKey, stateKey, stateKeyNext) values (5,15,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (5,16,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (5,17,18);
insert into switch (eventKey, stateKey, stateKeyNext) values (5,18,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (5,19,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (5,20,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (5,21,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (5,22,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (5,23,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (5,24,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (5,25,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (5,26,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (5,27,-1);
-- final
insert into switch (eventKey, stateKey, stateKeyNext) values (6,15,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (6,16,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (6,17,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (6,18,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (6,19,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (6,20,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (6,21,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (6,22,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (6,23,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (6,24,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (6,25,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (6,26,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (6,27,24);
-- reject
insert into switch (eventKey, stateKey, stateKeyNext) values (7,15,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (7,16,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (7,17,19);
insert into switch (eventKey, stateKey, stateKeyNext) values (7,18,19);
insert into switch (eventKey, stateKey, stateKeyNext) values (7,19,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (7,20,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (7,21,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (7,22,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (7,23,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (7,24,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (7,25,19);
insert into switch (eventKey, stateKey, stateKeyNext) values (7,26,19);
insert into switch (eventKey, stateKey, stateKeyNext) values (7,27,19);
-- cancel
insert into switch (eventKey, stateKey, stateKeyNext) values (8,15,20);
insert into switch (eventKey, stateKey, stateKeyNext) values (8,16,20);
insert into switch (eventKey, stateKey, stateKeyNext) values (8,17,20);
insert into switch (eventKey, stateKey, stateKeyNext) values (8,18,20);
insert into switch (eventKey, stateKey, stateKeyNext) values (8,19,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (8,20,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (8,21,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (8,22,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (8,23,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (8,24,20);
insert into switch (eventKey, stateKey, stateKeyNext) values (8,25,20);
insert into switch (eventKey, stateKey, stateKeyNext) values (8,26,20);
insert into switch (eventKey, stateKey, stateKeyNext) values (8,27,20);
-- approve
insert into switch (eventKey, stateKey, stateKeyNext) values (9,15,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (9,16,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (9,17,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (9,18,25);
insert into switch (eventKey, stateKey, stateKeyNext) values (9,19,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (9,20,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (9,21,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (9,22,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (9,23,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (9,24,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (9,25,26);
insert into switch (eventKey, stateKey, stateKeyNext) values (9,26,27);
insert into switch (eventKey, stateKey, stateKeyNext) values (9,27,-1);
-- arrive
insert into switch (eventKey, stateKey, stateKeyNext) values (12,15,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (12,16,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (12,17,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (12,18,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (12,19,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (12,20,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (12,21,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (12,22,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (12,23,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (12,24,21);
insert into switch (eventKey, stateKey, stateKeyNext) values (12,25,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (12,26,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (12,27,-1);
-- exit
insert into switch (eventKey, stateKey, stateKeyNext) values (13,15,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (13,16,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (13,17,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (13,18,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (13,19,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (13,20,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (13,21,22);
insert into switch (eventKey, stateKey, stateKeyNext) values (13,22,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (13,23,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (13,24,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (13,25,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (13,26,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (13,27,-1);
-- exit(early)
insert into switch (eventKey, stateKey, stateKeyNext) values (14,15,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (14,16,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (14,17,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (14,18,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (14,19,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (14,20,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (14,21,23);
insert into switch (eventKey, stateKey, stateKeyNext) values (14,22,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (14,23,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (14,24,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (14,25,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (14,26,-1);
insert into switch (eventKey, stateKey, stateKeyNext) values (14,27,-1);
------------
insert into elem (key, name, elemHier) values (28,'visit',null);
------------
-- insert into trip (key, objKey, predKey, subjKey) values (29,28,28,28);
------------
-- insert into gather (eventKey, tripKey) values (1,29);
------------
insert into role (key, name) values (30,'admin');
insert into role (key, name) values (31,'host');
insert into role (key, name) values (32,'CZAR');
insert into role (key, name) values (33,'SME1');
insert into role (key, name) values (34,'SME2');
insert into role (key, name) values (35,'SME3');
------------
insert into duty (clientKey, roleKey) values (37,30);
insert into duty (clientKey, roleKey) values (38,31);
insert into duty (clientKey, roleKey) values (39,32);
insert into duty (clientKey, roleKey) values (40,33);
insert into duty (clientKey, roleKey) values (41,34);
insert into duty (clientKey, roleKey) values (42,35);
------------
-- admin
insert into perm (eventKey, roleKey) values (1,30);
insert into perm (eventKey, roleKey) values (2,30);
insert into perm (eventKey, roleKey) values (3,30);
insert into perm (eventKey, roleKey) values (8,30);
insert into perm (eventKey, roleKey) values (12,30);
insert into perm (eventKey, roleKey) values (13,30);
insert into perm (eventKey, roleKey) values (14,30);
-- host
insert into perm (eventKey, roleKey) values (1,31);
insert into perm (eventKey, roleKey) values (2,31);
insert into perm (eventKey, roleKey) values (3,31);
insert into perm (eventKey, roleKey) values (4,31);
insert into perm (eventKey, roleKey) values (8,31);
insert into perm (eventKey, roleKey) values (12,31);
insert into perm (eventKey, roleKey) values (13,31);
insert into perm (eventKey, roleKey) values (14,31);
-- CZAR
insert into perm (eventKey, roleKey) values (2,32);
insert into perm (eventKey, roleKey) values (5,32);
insert into perm (eventKey, roleKey) values (6,32);
insert into perm (eventKey, roleKey) values (7,32);
-- SME1
insert into perm (eventKey, roleKey) values (7,33);
insert into perm (eventKey, roleKey) values (9,33);
-- SME2
insert into perm (eventKey, roleKey) values (7,34);
insert into perm (eventKey, roleKey) values (9,34);
-- SME3
insert into perm (eventKey, roleKey) values (7,35);
insert into perm (eventKey, roleKey) values (9,35);
------------
spool off