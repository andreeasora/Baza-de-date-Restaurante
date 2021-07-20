create table PROGRAM (
cod_program number(2),
ora_deschidere varchar2(6),
ora_inchidere varchar2(6),
constraint program_cod_pk primary key (cod_program),
constraint program_in_des_ck check(ora_inchidere>ora_deschidere)
);

create table ADRESA (
cod_adresa number(4),
strada varchar2(30) constraint null_strada not null,
numar number(3) constraint null_numar not null,
oras varchar2(30) constraint null_oras not null,
judet varchar2(30),
constraint adresa_cod_pk primary key (cod_adresa)
);

create table RESTAURANT (
cod_restaurant number(4),
nume_restaurant varchar2(30) constraint null_nume_res not null,
capacitate number(4),
cod_adresa number(4),
cod_program number(2),
constraint restaurant_cod_pk primary key (cod_restaurant),
constraint fk_res_adresa foreign key (cod_adresa) references ADRESA(cod_adresa),
constraint fk_res_program foreign key (cod_program) references PROGRAM(cod_program)
);

create table TIP_EVENIMENT (
cod_tip number(2),
descriere varchar2(30) constraint null_descriere not null,
constraint tip_pk primary key (cod_tip)
);

create table EVENIMENT (
cod_eveniment number(4),
data_eveniment date,
nr_maxim_persoane number(4),
cod_tip number(2),
constraint eveniment_cod_pk primary key (cod_eveniment),
constraint fk_ev_tip foreign key (cod_tip) references TIP_EVENIMENT(cod_tip)
);

create table REALIZEAZA (
cod_restaurant number(4),
cod_eveniment number(4),
constraint real_pk primary key (cod_restaurant, cod_eveniment),
constraint fk_real_res foreign key (cod_restaurant) references RESTAURANT(cod_restaurant),
constraint fk_real_ev foreign key (cod_eveniment) references EVENIMENT(cod_eveniment)
);

create table FACILITATE (
cod_tip number(2),
cod_facilitate number(2),
denumire varchar2(50),
constraint facilitati_pk primary key (cod_tip, cod_facilitate),
constraint fk_fac_tip foreign key (cod_tip) references TIP_EVENIMENT(cod_tip)
);

create table JOB (
cod_job number(4),
nume_job varchar2(35) constraint null_nume_job not null,
salariu_minim number(6),
salariu_maxim number(6),
constraint job_pk primary key (cod_job)
);

create table ANGAJAT (
cod_angajat number(4),
nume_angajat varchar2(25) constraint null_nume_ang not null,
prenume_angajat varchar2(25),
email varchar2(25) constraint null_email not null,
nr_telefon varchar2(15) constraint null_nr_tel not null,
salariu number(8,2),
data_angajare date default sysdate,
comision number(2,2),
cod_sef number(4),
cod_restaurant number(4),
cod_job number(4) constraint null_fk_job not null,
constraint ang_pk primary key (cod_angajat),
constraint fk_ang_ang foreign key (cod_sef) references ANGAJAT(cod_angajat),
constraint fk_ang_res foreign key (cod_restaurant) references RESTAURANT(cod_restaurant),
constraint fk_ang_job foreign key (cod_job) references JOB(cod_job),
constraint unq_nume_prenume unique (nume_angajat,prenume_angajat),
constraint unq_email unique (email),
constraint unq_nr_tel unique (nr_telefon),
constraint ck_sal check (salariu>0)
);

create table ISTORIC_JOB (
cod_angajat number(4),
data_start date default sysdate,
data_final date,
cod_job number(4) constraint null_job_istoric not null,
constraint istoric_job_pk primary key (cod_angajat, data_start),
constraint fk_istoric_job foreign key (cod_job) references JOB(cod_job),
constraint fk_istoric_ang foreign key (cod_angajat) references ANGAJAT(cod_angajat)
);

create table REZERVARE (
cod_rezervare number(6),
data_rezervare date default sysdate,
nr_persoane number(3),
constraint rez_pk primary key (cod_rezervare)
);

create table COMANDA (
cod_comanda number(4),
tip_plata varchar2(20),
valoare number(8,2),
data_comanda date,
cod_restaurant number(4),
cod_angajat number(4),
constraint pk_comanda primary key (cod_comanda),
constraint fk_comanda_res foreign key (cod_restaurant) references RESTAURANT(cod_restaurant),
constraint fk_comanda_ang foreign key (cod_angajat) references ANGAJAT(cod_angajat)
);

create table CLIENT (
cod_client number(4),
nume_client varchar2(25) constraint null_nume_client not null,
prenume_client varchar2(25),
telefon varchar2(15) constraint null_telefon_client not null,
cod_adresa number(4),
cod_comanda number(4),
constraint client_pk primary key (cod_client),
constraint unq_nume_prenume_cl unique (nume_client,prenume_client),
constraint fk_cl_adresa foreign key (cod_adresa) references ADRESA(cod_adresa),
constraint fk_cl_comanda foreign key (cod_comanda) references COMANDA(cod_comanda),
constraint unq_tel unique (telefon)
);

create table FACE (
cod_client number(4),
cod_rezervare number(6),
cod_eveniment number(4),
cod_restaurant number(4),
constraint face_pk primary key (cod_client, cod_rezervare, cod_eveniment, cod_restaurant),
constraint fk_face_client foreign key (cod_client) references CLIENT(cod_client),
constraint fk_face_rez foreign key (cod_rezervare) references REZERVARE(cod_rezervare),
constraint fk_face_ev foreign key (cod_eveniment) references EVENIMENT(cod_eveniment),
constraint fk_face_res foreign key (cod_restaurant) references RESTAURANT(cod_restaurant)
);

create table ISTORIC_COMANDA (
cod_client number(4),
data_plasare date default sysdate,
nota_oferita number(2),
cod_comanda number(4) constraint null_comanda_istoric not null,
constraint istoric_comanda_pk primary key (cod_client, data_plasare),
constraint fk_istoric_comanda foreign key (cod_comanda) references COMANDA(cod_comanda),
constraint fk_istoric_cl foreign key (cod_client) references CLIENT(cod_client)
);


create table PREPARAT (
cod_preparat number(4),
nume_preparat varchar2(25) constraint null_preparat not null,
pret number(8,2) constraint null_pret not null,
constraint pk_preparat primary key (cod_preparat)
);

create table CUPRINDE (
cod_preparat number(4),
cod_comanda number(4),
cantitate number(2) constraint null_cantitate not null,
constraint pk_cuprinde primary key (cod_preparat, cod_comanda),
constraint fk_cup_prep foreign key (cod_preparat) references PREPARAT(cod_preparat),
constraint fk_cup_com foreign key (cod_comanda) references COMANDA(cod_comanda)
);

commit;

insert into PROGRAM
values (1,'08:00','22:00');

insert into PROGRAM
values (2,'08:30','21:30');

insert into PROGRAM
values (3,'07:00','20:00');

insert into PROGRAM
values (4,'07:30','22:30');

insert into PROGRAM
values (5,'08:00','23:00');

commit;

insert into ADRESA
values (8,'Str. Mihai Eminescu',23,'Ploiesti','Prahova');

insert into ADRESA
values (9,'Str. Cuza Voda',5,'Campina',null);

insert into ADRESA
values (10,'Str. Nicolae Balcescu',250,'Sinaia','Prahova');

insert into ADRESA
values (11,'Str. 1 Decembrie',109,'Ploiesti','Prahova');

insert into ADRESA
values (12,'Str. Ion Creanga',7,'Busteni',null);

insert into ADRESA
values (13,'Str. Ion Luca Caragiale',108,'Ploiesti','Prahova');

insert into ADRESA
values (14,'Str. 25 Decembrie',148,'Ploiesti','Prahova');

insert into ADRESA
values (15,'Str. Mihai Bravu',89,'Ploiesti','Prahova');

insert into ADRESA
values (16,'Str. Matei Basarab',657,'Ploiesti',null);

insert into ADRESA
values (17,'Str. Nicolae Balcescu',128,'Ploiesti','Prahova');

insert into ADRESA
values (18,'Str. Carol I',12,'Ploiesti',null);

insert into ADRESA
values (19,'Str. Unirii',349,'Ploiesti','Prahova');

commit;

insert into RESTAURANT
values (101,'Da Vinci',400,12,1);

insert into RESTAURANT
values (102,'Best',500,8,5);

insert into RESTAURANT
values (103,'Mamaliguta',350,9,3);

insert into RESTAURANT
values (104,'Lazarini',600,11,1);

insert into RESTAURANT
values (105,'Trattoria',600,10,null);

insert into RESTAURANT
values (106,'Toscana',450,null,2);

commit;

insert into TIP_EVENIMENT
values (1,'Nunta');

insert into TIP_EVENIMENT
values (2,'Botez');

insert into TIP_EVENIMENT
values (3,'Majorat');

insert into TIP_EVENIMENT
values (4,'Petreceri 8 Martie');

insert into TIP_EVENIMENT
values (5,'Petreceri Weekend');

commit;

insert into EVENIMENT
values (300,to_date('02-10-2021','dd-mm-yyyy'),100,1);

insert into EVENIMENT
values (301,to_date('12-05-2022','dd-mm-yyyy'),200,1);

insert into EVENIMENT
values (302,to_date('17-07-2021','dd-mm-yyyy'),70,5);

insert into EVENIMENT
values (303,to_date('08-03-2022','dd-mm-yyyy'),200,4);

insert into EVENIMENT
values (304,to_date('23-02-2022','dd-mm-yyyy'),null,3);

insert into EVENIMENT
values (305,to_date('30-04-2022','dd-mm-yyyy'),300,2);

insert into EVENIMENT
values (306,to_date('08-06-2022','dd-mm-yyyy'),200,2);

insert into EVENIMENT
values (307,to_date('24-07-2021','dd-mm-yyyy'),70,5);

insert into EVENIMENT
values (308,to_date('01-08-2021','dd-mm-yyyy'),70,5);

commit;

insert into REALIZEAZA
values (101,307);

insert into REALIZEAZA
values (102,307);

insert into REALIZEAZA
values (104,303);

insert into REALIZEAZA
values (106,303);

insert into REALIZEAZA
values (102,303);

insert into REALIZEAZA
values (102,300);

insert into REALIZEAZA
values (103,301);

insert into REALIZEAZA
values (103,306);

insert into REALIZEAZA
values (101,305);

insert into REALIZEAZA
values (106,302);

insert into REALIZEAZA
values (105,302);

insert into REALIZEAZA
values (104,304);

insert into REALIZEAZA
values (101,308);

commit;

insert into FACILITATE
values (1,1,'aranjament floral');

insert into FACILITATE
values (4,2,'candy bar');

insert into FACILITATE
values (5,3,'o cafea gratis/invitat');

insert into FACILITATE
values (3,4,'baloane cu heliu');

insert into FACILITATE
values (3,5,'o sticla de apa/masa');

insert into FACILITATE
values (3,6,null);

commit;

insert into JOB
values (1000,'manager',10000,30000);

insert into JOB
values (1001,'bucatar',2500,15000);

insert into JOB
values (1002,'casier',1500,4000);

insert into JOB
values (1003,'personal curatenie',1000,2000);

insert into JOB
values (1004,'ospatar',1500,4000);

insert into JOB
values (1005,'sef de sala',null,10400);

insert into JOB
values (1006,'ajutor bucatar',2000,9000);

commit;

insert into ANGAJAT
values (10,'Popescu','Ion','email1@yahoo.com','0728647839',25000,to_date('02-10-2020','dd-mm-yyyy'),null,null,101,1000);

insert into ANGAJAT
values (11,'Gheorghe','Mihai','email2@yahoo.com','0728622839',10400,to_date('10-12-2020','dd-mm-yyyy'),0.1,10,101,1005);

insert into ANGAJAT
values (12,'Ionescu','Ana','email3@yahoo.com','0738689839',3000,to_date('02-01-2021','dd-mm-yyyy'),null,11,101,1002);

insert into ANGAJAT
values (13,'Neagu','Marian','email4@yahoo.com','0728647009',2500,to_date('12-03-2021','dd-mm-yyyy'),0.1,11,101,1004);

insert into ANGAJAT
values (14,'Toma','Daniela','email5@yahoo.com','0728678901',1900,to_date('02-09-2020','dd-mm-yyyy'),null,11,101,1003);

insert into ANGAJAT
values (15,'Petrescu','Marius','email6@yahoo.com','0712345678',9000,to_date('12-01-2021','dd-mm-yyyy'),0.35,11,101,1001);

insert into ANGAJAT
values (16,'Lazar','Nicoleta','email7@yahoo.com','0711223344',9000,to_date('01-02-2021','dd-mm-yyyy'),0.2,11,101,1001);

insert into ANGAJAT
values (17,'Ion','Dan','email8@yahoo.com','0701234985',5000,to_date('18-04-2021','dd-mm-yyyy'),null,15,101,1006);

insert into ANGAJAT
values (18,'Pop','Vlad','email9@yahoo.com','0789634185',20000,to_date('29-10-2020','dd-mm-yyyy'),null,null,104,1000);

insert into ANGAJAT
values (19,'Trandafir','Corina','email10@yahoo.com','0798765432',10300,to_date('02-01-2021','dd-mm-yyyy'),0.12,18,104,1005);

insert into ANGAJAT
values (20,'Dragos','Cristina','email11@yahoo.com','0798765431',14800,to_date('09-01-2021','dd-mm-yyyy'),null,19,104,1001);

insert into ANGAJAT
values (21,'Sorescu','Flavius','email12@yahoo.com','0798765435',4600,to_date('22-01-2021','dd-mm-yyyy'),null,20,104,1006);

insert into ANGAJAT
values (22,'Popescu','Ioana','email13@yahoo.com','0798765439',3300,to_date('10-06-2020','dd-mm-yyyy'),0.11,19,104,1002);

insert into ANGAJAT
values (23,'Ifrim','George','email14@yahoo.com','0789634188',20300,to_date('29-11-2020','dd-mm-yyyy'),0.3,null,102,1000);

insert into ANGAJAT
values (24,'Vasile','Tudor','email15@yahoo.com','0798765430',9080,to_date('02-03-2021','dd-mm-yyyy'),null,23,102,1005);

insert into ANGAJAT
values (25,'Dragos','Gheorghe','email16@yahoo.com','0798765400',8000,to_date('24-01-2021','dd-mm-yyyy'),null,24,102,1001);

insert into ANGAJAT
values (26,'Sora','George','email17@yahoo.com','0789634100',20900,to_date('02-11-2020','dd-mm-yyyy'),0.1,null,106,1000);

insert into ANGAJAT
values (27,'Podariu','Ionel','email18@yahoo.com','0798765411',9100,to_date('24-02-2021','dd-mm-yyyy'),null,26,106,1001);

insert into ANGAJAT
values (28,'Sandu','Tiberiu','email20@yahoo.com','0789000000',7900,to_date('06-09-2020','dd-mm-yyyy'),null,26,106,1001);

insert into ANGAJAT
values (29,'Dragomirescu','Laur','email21@yahoo.com','0781111111',21900,to_date('03-10-2020','dd-mm-yyyy'),0.1,null,105,1000);

insert into ANGAJAT
values (30,'Ion','Mihail','email22@yahoo.com','0781111112',9900,to_date('23-02-2021','dd-mm-yyyy'),null,29,105,1001);

insert into ANGAJAT
values (31,'Petrescu','Laurentiu','email23@yahoo.com','0781111113',18000,to_date('13-12-2020','dd-mm-yyyy'),0.12,null,103,1000);

insert into ANGAJAT (cod_angajat,nume_angajat,prenume_angajat,email,nr_telefon,salariu,comision,cod_sef,cod_restaurant,cod_job)
values (32,'Branescu','Ionut','email24@yahoo.com','0781111117',8700,null,31,103,1001);
--data_angajare este by default data curenta

insert into ANGAJAT
values (33,'Bojici','Matei','email25@yahoo.com','0781111129',18000,to_date('13-10-2020','dd-mm-yyyy'),null,null,null,1000);

commit;

insert into ISTORIC_JOB
values (23,to_date('29-11-2020','dd-mm-yyyy'),to_date('10-02-2021','dd-mm-yyyy'),1005);

insert into ISTORIC_JOB
values (23,to_date('11-02-2021','dd-mm-yyyy'),null,1000);

insert into ISTORIC_JOB
values (16,to_date('01-02-2021','dd-mm-yyyy'),to_date('29-03-2021','dd-mm-yyyy'),1006);

insert into ISTORIC_JOB
values (16,to_date('30-03-2021','dd-mm-yyyy'),null,1001);

insert into ISTORIC_JOB
values (26,to_date('02-11-2020','dd-mm-yyyy'),to_date('10-02-2021','dd-mm-yyyy'),1005);

insert into ISTORIC_JOB
values (26,to_date('11-02-2021','dd-mm-yyyy'),null,1000);

insert into ISTORIC_JOB
values (10,to_date('02-10-2020','dd-mm-yyyy'),null,1000);

insert into ISTORIC_JOB
values (11,to_date('10-12-2020','dd-mm-yyyy'),null,1005);

insert into ISTORIC_JOB
values (12,to_date('02-01-2021','dd-mm-yyyy'),null,1002);

insert into ISTORIC_JOB
values (13,to_date('12-03-2021','dd-mm-yyyy'),null,1004);

insert into ISTORIC_JOB
values (14,to_date('02-09-2020','dd-mm-yyyy'),null,1003);

insert into ISTORIC_JOB
values (15,to_date('12-01-2021','dd-mm-yyyy'),null,1001);

insert into ISTORIC_JOB
values (17,to_date('18-04-2021','dd-mm-yyyy'),null,1006);

insert into ISTORIC_JOB
values (18,to_date('29-10-2020','dd-mm-yyyy'),null,1000);

insert into ISTORIC_JOB
values (19,to_date('02-01-2021','dd-mm-yyyy'),null,1005);

insert into ISTORIC_JOB
values (20,to_date('09-01-2021','dd-mm-yyyy'),null,1001);

insert into ISTORIC_JOB
values (21,to_date('22-01-2021','dd-mm-yyyy'),null,1006);

insert into ISTORIC_JOB
values (22,to_date('10-06-2020','dd-mm-yyyy'),null,1002);

insert into ISTORIC_JOB
values (24,to_date('02-03-2021','dd-mm-yyyy'),null,1005);

insert into ISTORIC_JOB
values (25,to_date('24-01-2021','dd-mm-yyyy'),null,1001);

insert into ISTORIC_JOB
values (27,to_date('24-02-2021','dd-mm-yyyy'),null,1001);

insert into ISTORIC_JOB
values (28,to_date('06-09-2020','dd-mm-yyyy'),null,1001);

insert into ISTORIC_JOB
values (29,to_date('03-10-2020','dd-mm-yyyy'),null,1000);

insert into ISTORIC_JOB
values (30,to_date('23-02-2021','dd-mm-yyyy'),null,1001);

insert into ISTORIC_JOB
values (31,to_date('13-12-2020','dd-mm-yyyy'),null,1000);

insert into ISTORIC_JOB
values (32,to_date('18-05-2021','dd-mm-yyyy'),null,1001);

commit;

insert into REZERVARE
values (700,to_date('02-04-2021','dd-mm-yyyy'),2);

insert into REZERVARE
values (701,to_date('02-05-2021','dd-mm-yyyy'),1);

insert into REZERVARE
values (702,to_date('05-01-2021','dd-mm-yyyy'),2);

insert into REZERVARE
values (703,to_date('23-02-2021','dd-mm-yyyy'),4);

insert into REZERVARE (cod_rezervare,nr_persoane)
values (704,2);
--data_rezervare este by default data curenta

insert into REZERVARE
values (705,to_date('14-03-2021','dd-mm-yyyy'),2);

insert into REZERVARE
values (706,to_date('25-01-2021','dd-mm-yyyy'),3);

insert into REZERVARE
values (707,to_date('13-01-2021','dd-mm-yyyy'),150);

insert into REZERVARE
values (708,to_date('21-01-2021','dd-mm-yyyy'),200);

insert into REZERVARE
values (709,to_date('10-02-2021','dd-mm-yyyy'),90);

insert into REZERVARE
values (710,to_date('16-01-2021','dd-mm-yyyy'),90);

insert into REZERVARE
values (711,to_date('28-01-2021','dd-mm-yyyy'),95);

insert into REZERVARE
values (712,to_date('28-04-2021','dd-mm-yyyy'),5);

insert into REZERVARE
values (713,to_date('01-04-2021','dd-mm-yyyy'),2);

commit;

insert into COMANDA
values (secventa_comanda_id.nextval,'card',null,to_date('23-04-2021','dd-mm-yyyy'),101,15);

insert into COMANDA
values (secventa_comanda_id.nextval,'cash',null,to_date('10-04-2021','dd-mm-yyyy'),101,15);

insert into COMANDA
values (secventa_comanda_id.nextval,'card',null,to_date('13-05-2021','dd-mm-yyyy'),106,28);

insert into COMANDA
values (secventa_comanda_id.nextval,'card',null,to_date('09-01-2021','dd-mm-yyyy'),102,25);

insert into COMANDA
values (secventa_comanda_id.nextval,'cash',null,to_date('01-02-2021','dd-mm-yyyy'),103,32);

insert into COMANDA
values (secventa_comanda_id.nextval,'card',null,to_date('19-04-2021','dd-mm-yyyy'),105,30);

insert into COMANDA
values (secventa_comanda_id.nextval,'cash',null,to_date('03-04-2021','dd-mm-yyyy'),104,20);

commit;

insert into CLIENT
values (40,'Rapeanu','Adrian','0722334455',16,500);

insert into CLIENT
values (41,'Dragomir','Elena','0722334467',17,503);

insert into CLIENT
values (42,'Frusinoiu','Andrei','0700334467',19,501);

insert into CLIENT
values (43,'Mares','Catalin','0722330101',18,505);

insert into CLIENT
values (44,'Petre','Mihaela','0722339898',null,null);

insert into CLIENT
values (45,'Sorescu','Ana','0766339898',null,null);

insert into CLIENT
values (46,'Soare','Mihaela','0755539898',null,null);

insert into CLIENT
values (47,'Ristoiu','Rares','0766777898',null,null);

insert into CLIENT
values (48,'Ciurea','Claudia','0722355558',null,null);

insert into CLIENT
values (49,'Vulpe','Alin','07653980786',null,null);

insert into CLIENT
values (50,'Negoita','Eduard','07653980090',null,null);

insert into CLIENT
values (51,'Neagu','David','07653980091',null,null);

commit;

insert into FACE
values (44,709,300,102);

insert into FACE
values (44,705,303,104);

insert into FACE
values (45,702,303,102);

insert into FACE
values (46,708,305,101);

insert into FACE
values (47,707,306,103);

insert into FACE
values (48,700,303,106);

insert into FACE
values (49,711,301,103);

insert into FACE
values (50,701,302,105);

insert into FACE
values (48,710,304,104);

insert into FACE
values (47,703,302,106);

insert into FACE
values (45,704,302,106);

insert into FACE
values (44,706,302,105);

insert into FACE
values (41,712,303,104);

insert into FACE
values (50,713,302,106);

commit;

insert into ISTORIC_COMANDA
values (40,to_date('23-04-2021','dd-mm-yyyy'),10,500);

insert into ISTORIC_COMANDA
values (40,to_date('13-05-2021','dd-mm-yyyy'),9,502);

insert into ISTORIC_COMANDA
values (41,to_date('09-01-2021','dd-mm-yyyy'),10,503);

insert into ISTORIC_COMANDA
values (41,to_date('01-02-2021','dd-mm-yyyy'),10,504);

insert into ISTORIC_COMANDA
values (41,to_date('03-04-2021','dd-mm-yyyy'),10,506);

insert into ISTORIC_COMANDA
values (42,to_date('10-04-2021','dd-mm-yyyy'),8,501);

insert into ISTORIC_COMANDA
values (43,to_date('19-04-2021','dd-mm-yyyy'),10,505);

commit;

insert into PREPARAT
values (70,'ciorba de legume',10);

insert into PREPARAT
values (71,'ciorba de burta',15);

insert into PREPARAT
values (72,'pui la cuptor cu cartofi',23.5);

insert into PREPARAT
values (73,'paste cu ton',25);

insert into PREPARAT
values (74,'paste carbonara',26);

insert into PREPARAT
values (75,'pizza capriciosa',28);

insert into PREPARAT
values (76,'pizza casei',29);

insert into PREPARAT
values (77,'mix fructe de mare',35);

insert into PREPARAT
values (78,'somon file',37);

insert into PREPARAT
values (79,'papanasi',12);

insert into PREPARAT
values (80,'tort cu ciocolata',20);

commit;

insert into CUPRINDE
values (70,500,1);

insert into CUPRINDE
values (73,500,2);

insert into CUPRINDE
values (72,501,2);

insert into CUPRINDE
values (76,502,2);

insert into CUPRINDE
values (79,502,1);

insert into CUPRINDE
values (77,503,1);

insert into CUPRINDE
values (78,504,2);

insert into CUPRINDE
values (71,505,3);

insert into CUPRINDE
values (80,505,1);

insert into CUPRINDE
values (74,506,4);

insert into CUPRINDE
values (80,506,1);

commit;