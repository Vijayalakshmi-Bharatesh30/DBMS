show databases;
use vijayalakshmi;

create table SUPPLIERS(sid integer(5) primary key, sname varchar(20), city varchar(20));
desc SUPPLIERS;
insert into SUPPLIERS values(10001,'acme widget','bangolore');
insert into SUPPLIERS values(10002,'johns','kolkota');
insert into SUPPLIERS values(10003,'vimal','mumbai');
insert into SUPPLIERS values(10004,'reliance','delhi');
commit;

create table PARTS(pid integer(5) primary key, pname varchar(20), color varchar(10));
insert into PARTS values(20001,'book','red');
insert into PARTS values(20002,'pen','red');
insert into PARTS values(20003,'pencil','green');
insert into PARTS values(20004,'mobile','green');
insert into PARTS values(20005,'charger','black');

create table CATALOG(sid integer(5),pid integer(5), foreign key(sid) references SUPPLIERS(sid), foreign key(pid) references PARTS(pid), cost float(6), primary key(sid, pid));
insert into CATALOG values(10001,20001,10);
insert into CATALOG values(10001,20002,10);
insert into CATALOG values(10001,20003,30);
insert into CATALOG values(10001,20004,10);
insert into CATALOG values(10001,20005,10);
insert into CATALOG values(10002,20001,10);
insert into CATALOG values(10002,20002,20);
insert into CATALOG values(10003,20003,30);
insert into CATALOG values(10004,20003,40);

SELECT DISTINCT P.pname
FROM Parts P, Catalog C
WHERE P.pid = C.pid;

SELECT S.sname
FROM Suppliers S
WHERE (( SELECT count(P.pid) FROM Parts P ) =( SELECT count(C.pid) FROM Catalog C WHERE C.sid = S.sid ));

SELECT S.sname
FROM Suppliers S
WHERE
(( SELECT count(P.pid)
FROM Parts P where color='red' ) =
( SELECT count(C.pid)
FROM Catalog C, Parts P
WHERE C.sid = S.sid AND
C.pid = P.pid AND P.color = 'red' ));

SELECT P.pname
FROM Parts P, Catalog C, Suppliers S
WHERE P.pid = C.pid AND C.sid = S.sid
AND S.sname = 'acme widget'
AND NOT EXISTS ( SELECT *
FROM Catalog C1, Suppliers S1
WHERE P.pid = C1.pid AND C1.sid = S1.sid AND
S1.sname1='acme widget');

SELECT DISTINCT C.sid FROM CATALOG C
 WHERE C.cost >( SELECT AVG (C1.cost)
FROM CATALOG C1
 WHERE C1.pid = C.pid );
 
SELECT P.pid, S.sname
FROM Parts P, Suppliers S, Catalog C
WHERE C.pid = P.pid
AND C.sid = S.sid
AND C.cost = (SELECT MAX (C1.cost)
FROM Catalog C1
WHERE C1.pid = P.pid);