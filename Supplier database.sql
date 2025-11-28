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


SELECT P.pname, S.sname, C.cost
FROM PARTS P, SUPPLIERS S, CATALOG C
WHERE P.pid = C.pid
AND S.sid = C.sid
AND C.cost = (SELECT MAX(cost) FROM CATALOG);

SELECT S.sname
FROM Suppliers S
WHERE S.sid NOT IN (
    SELECT DISTINCT C.sid
    FROM Catalog C, Parts P
    WHERE C.pid = P.pid
    AND P.color = 'red');
        
SELECT S.sname, SUM(C.cost) AS total_value
FROM Suppliers S, Catalog C
WHERE S.sid = C.sid
GROUP BY S.sname;

SELECT S.sname
FROM Suppliers S, Catalog C
WHERE S.sid = C.sid
AND C.cost < 20
GROUP BY S.sname
HAVING COUNT(DISTINCT C.pid) >= 2;



SELECT P.pname, S.sname, C.cost
FROM Parts P, Suppliers S, Catalog C
WHERE P.pid = C.pid
AND S.sid = C.sid
AND C.cost = (
    SELECT MIN(C1.cost)
    FROM Catalog C1
    WHERE C1.pid = P.pid);
    
    
CREATE VIEW Supplier_Part_Count AS
SELECT S.sid, S.sname, COUNT(DISTINCT C.pid) AS total_parts
FROM Suppliers S
LEFT JOIN Catalog C ON S.sid = C.sid
GROUP BY S.sid, S.sname;

SELECT * FROM Supplier_Part_Count;

CREATE VIEW Most_Expensive_Supplier_Per_Part AS
SELECT P.pid, P.pname, S.sid, S.sname, C.cost
FROM Parts P
JOIN Catalog C ON P.pid = C.pid
JOIN Suppliers S ON S.sid = C.sid
WHERE C.cost = (
    SELECT MAX(C1.cost)
    FROM Catalog C1
    WHERE C1.pid = P.pid);
SELECT * FROM Most_Expensive_Supplier_Per_Part;


DELIMITER $$

CREATE TRIGGER trg_check_catalog_cost
BEFORE INSERT ON Catalog
FOR EACH ROW
BEGIN
    IF NEW.cost < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cost cannot be less than 1';
    END IF;
END$$

DELIMITER ;

INSERT INTO Catalog VALUES(10001,20001,5);


DELIMITER $$

CREATE TRIGGER trg_set_default_cost
BEFORE INSERT ON Catalog
FOR EACH ROW
BEGIN
    IF NEW.cost IS NULL THEN
        SET NEW.cost = 10;
    END IF;
END$$
                                                                                                             
DELIMITER ;
INSERT INTO Catalog(sid, pid) VALUES (10002, 20005);
SELECT *FROM CATALOG;


