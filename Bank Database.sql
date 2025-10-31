show databases;
create database if not exists vijayalakshmi;
show databases;
use vijayalakshmi;
create table branch(
Branch_name varchar(30),
Branch_city varchar(25),
assets int,
PRIMARY KEY (Branch_name));
desc branch

create table bankaccount(
Accno int,
Branch_name varchar(20),
Balance int,
PRIMARY KEY(Accno),
foreign key (Branch_name)references branch(Branch_name));
desc bankaccount

create table bankcustomer(
Customername varchar(20),
Customer_street varchar(30),
CustomerCity varchar (35),
PRIMARY KEY(Customername));
desc bankcustomer

create table depositer(
Customername varchar(20),
Accno int,
PRIMARY KEY(Customername,Accno),
foreign key (Accno) references bankaccount(Accno),
foreign key (Customername) references bankcustomer(Customername));
desc depositer

create table loan(
Loan_number int,
Branch_name varchar(20),
Amount int,
PRIMARY KEY(Loan_number),
foreign key (Branch_name) references branch(Branch_name));
desc loan

insert into branch values('Chamrajpet','Bangalore',50000);
insert into branch values('SBI_ResidencyRoad','Bangalore',10000);
insert into branch values('SBI_ShivajiRoad','Bombay',20000);
insert into branch values('SBI_ParlimentRoad','Delhi',10000);
insert into branch values('SBI_Jantarmantar','Delhi',20000);

insert into bankaccount values(1,'Chamrajpet',2000);
insert into bankaccount values(2,'SBI_ResidencyRoad',5000);
insert into bankaccount values(3,'SBI_ShivajiRoad',6000);
insert into bankaccount values(4,'SBI_ParlimentRoad',9000);
insert into bankaccount values(5,'SBI_Jantarmantar',8000);
insert into bankaccount values(6,'SBI_ShivajiRoad',4000);
insert into bankaccount values(8,'SBI_ResidencyRoad',4000);
insert into bankaccount values(9,'SBI_ParlimentRoad',3000);

insert into bankcustomer values('Avinash','Bull_Temple_Road','Bangalore');
insert into bankcustomer values('Dinesh','Bannergatta_Road','Bangalore');
insert into bankcustomer values('Mohan','NationalCollege_Road','Bangalore');
insert into bankcustomer values('Nikil','Akbar_Road','Delhi');
insert into bankcustomer values('Ravi','Prithviraj_Road','Delhi');

insert into depositer values('Avinash',1);
insert into depositer values('Dinesh',2);
insert into depositer values('Nikil',4);
insert into depositer values('Ravi',5);
insert into depositer values('Avinash',8);
insert into depositer values('Nikil',9);


insert into loan values(1,'Chamrajpet',1000);
insert into loan values(2,'SBI_ResidencyRoad',2000);
insert into loan values(3,'SBI_ShivajiRoad',3000);
insert into loan values(4,'SBI_ParlimentRoad',4000);
insert into loan values(5,'SBI_Jantarmantar',5000);
select* from branch;
select*from bankaccount;
select*from bankcustomer;
select*from depositer;
select*from loan;
commit;

select Branch_name,CONCAT(assets/100000,'lakhs')assets_in_lakhs from branch;

Select d.Customername 
from depositer d,bankaccount b where b.Branch_name='SBI_ResidencyRoad' and d.Accno=b.Accno
group by d.Customername having count(d.Accno)>=2;

create view sum_of_loan
as select Branch_name,SUM(Balance)
from bankaccount
group by Branch_name;
select*from sum_of_loan;

select bc.Customername, CONCAT(Balance+1000,'rupees')
UPDATED_BALANCE from bankaccount b, bankcustomer bc, depositer d
where bc.Customername=d.Customername and b.Accno=d.Accno and
bc.Customercity='Bangalore';

...........//Additional queries//........

select*from loan order by Amount desc;

(select Customername from depositer)
union (select Customername from borrower);

update bankaccount set Balance=Balance+Balance*0.05;

