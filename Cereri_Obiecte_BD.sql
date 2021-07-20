--CERINTA 11!
--1.Afisati informatii despre rezervarile care au fost facute pentru un numar de persoane mai mare decat 3, la un eveniment ce va avea loc dupa data de 01-08-2021 
--si are un numar de luni intre data rezervarii si data evenimentului mai mare decat 8, pentru clientii care au lungimea prenumelui mai mare decat 4. 
--Afisati ordonat descrescator dupa numarul de persoane pentru care se face rezervarea.
select c.nume_client as Nume_client_SAI, c.prenume_client as Prenume_client_SAI, r.nr_persoane as Nr_persoane_rezervare_SAI, r.data_rezervare as Data_rezervare_SAI, 
e.data_eveniment as Data_eveniment_SAI, res.nume_restaurant as Nume_restaurant_SAI
from CLIENT c, REZERVARE r, EVENIMENT e, RESTAURANT res, FACE f
where c.cod_client=f.cod_client and f.cod_rezervare=r.cod_rezervare and f.cod_restaurant=res.cod_restaurant 
and f.cod_eveniment=e.cod_eveniment and r.nr_persoane>3 and e.data_eveniment>to_date('01-08-2021','dd-mm-yyyy') and length(c.prenume_client)>4
and months_between(e.data_eveniment,r.data_rezervare)>8
order by 3 desc;
--4 rezultate

--2.Afisati codul, numele si numarul de angajati din restaurantul care are un numar maxim de angajati, capacitatea mai mare de 300 de persoane si se afla in orasul Ploiesti.
select r.cod_restaurant as Cod_restaurant_SAI, r.nume_restaurant as Nume_restaurant_SAI, count(*) as Numar_de_angajati_SAI
from RESTAURANT r, ANGAJAT a, ADRESA ad
where r.cod_restaurant=a.cod_restaurant and r.capacitate>300 and r.cod_adresa=ad.cod_adresa and lower(ad.oras)='ploiesti'
group by r.cod_restaurant,r.nume_restaurant
having count(*)=(select max(count(*))
                 from RESTAURANT r, ANGAJAT a, ADRESA ad
                 where r.cod_restaurant=a.cod_restaurant and r.capacitate>300 and r.cod_adresa=ad.cod_adresa and lower(ad.oras)='ploiesti'
                 group by r.cod_restaurant,r.nume_restaurant);
--1 rezultat: 104	Lazarini	5

--3.Sa se afiseze numele, prenumele, salariul, data angajarii si un mesaj corespunzator in cazul in care numele angajatilor are peste 4 litere, pentru salariatii angajati intr-o zi a lunii 
--mai mica decat urmatoarea zi de luni curenta, care sunt subalternii directi ai celui mai bine platit sef de sala si care au salariul mai mic decat
--media salariilor tuturor subalternilor acestui sef de sala. Ordonati crescator dupa salariu.
with SUBALTERNI_SEF_DE_SALA as (select nume_angajat, prenume_angajat, salariu, data_angajare, case when length(nume_angajat)>4 then 'Are peste 4 litere' else 'Nu are peste 4 litere' end as Litere
                                from ANGAJAT
                                where cod_sef=(select a.cod_angajat
                                               from ANGAJAT a, JOB j
                                               where a.cod_job=j.cod_job and initcap(j.nume_job)='Sef De Sala' and salariu=(select max(a.salariu)
                                                                                                                            from ANGAJAT a, JOB j
                                                                                                                            where a.cod_job=j.cod_job and upper(j.nume_job)='SEF DE SALA'))),
SALARIUL_MEDIU as (select avg(salariu) as medie
                   from ANGAJAT
                   where cod_sef=(select a.cod_angajat
                                  from ANGAJAT a, JOB j
                                  where a.cod_job=j.cod_job and initcap(j.nume_job)='Sef De Sala' and salariu=(select max(a.salariu)
                                                                                                               from ANGAJAT a, JOB j
                                                                                                               where a.cod_job=j.cod_job and upper(j.nume_job)='SEF DE SALA')))
select *
from SUBALTERNI_SEF_DE_SALA
where salariu<(select medie from SALARIUL_MEDIU) and extract(day from data_angajare)<extract(day from next_day(sysdate,'Monday'))
order by 3;
-- 3 rezultate; salariul mediu: 5099

--4.Afisati informatii despre clienti in formatul urmator: "Clientul x a facut y comenzi/nu a facut comenzi si a facut z rezervari/nu a facut rezervari.". Vom presupune ca 
--in momentul actual, nu exista clienti care au fost inregistrati in baza de date facand o rezervare si mai apoi au solicitat si comenzi.
select 'Clientul '|| c.nume_client || ' ' || c.prenume_client || decode(nvl(c.cod_comanda,0),0,' nu a facut comenzi',c.cod_comanda,
(select ' a facut '||case when count(*)=1 then 'o comanda' else count(*)||' comenzi' end
from ISTORIC_COMANDA k
where c.cod_client=k.cod_client))|| ' si '|| (select case when count(*)=1 then 'a facut o rezervare.' when count(*)=0 then 'nu a facut rezervari.' else 'a facut '||count(*)||' rezervari.' end
                                              from FACE f
                                              where f.cod_client=c.cod_client) as Informatii_clienti_SAI
from CLIENT c;
--11 rezultate (numarul total de clienti)

--5.Afisati numele si pretul preparatelor cu pretul mai mare de 15 lei si care sunt cuprinse intr-o comanda solicitata de un client care are in componenta numelui litera a. 
--Ordonati descrescator dupa pret.
select p.nume_preparat as Nume_preparat_SAI, p.pret as Pret_SAI
from PREPARAT p
where exists (select i.cod_client
              from ISTORIC_COMANDA i, COMANDA c, PREPARAT k, CUPRINDE cup, CLIENT cl
              where i.cod_comanda=c.cod_comanda and c.cod_comanda=cup.cod_comanda and cup.cod_preparat=k.cod_preparat and k.cod_preparat=p.cod_preparat 
              and i.cod_client=cl.cod_client and lower(cl.nume_client) like '%a%')
and p.pret>15
order by 2 desc;
--6 rezultate

--CERINTA 12!
-- 1.Mariti salariul cu 5% pentru salariatii care au fost angajati in anul 2020 si al caror prenume contine litera 'a'. Marirea se va aplica 
--doar in cazul in care limita superioara salariala setata in job pentru functia respectiva va permite acest lucru.
update ANGAJAT a
set a.salariu=a.salariu+a.salariu*0.05
where lower(a.prenume_angajat) like '%a%' and extract(year from a.data_angajare)=2020 and 
a.salariu+a.salariu*0.05<=(select j.salariu_maxim
                           from JOB j
                           where j.cod_job=a.cod_job);
--11	Gheorghe	Mihai	email2@yahoo.com	0728622839	10400	10-DEC-20	0.1	10	101	1005
--nu se modifica salariul deoarece limita este 10.400, iar marirea ar rezulta un salariu de 10.920

--2.Setati valorea corespunzatoare fiecarei comenzi in functie de preparatele pe care le cuprinde si de cantitatea acestora.
update COMANDA k
set k.valoare=(select (sum(p.pret*c.cantitate))
              from PREPARAT p, CUPRINDE c
              where c.cod_comanda=k.cod_comanda and p.cod_preparat=c.cod_preparat);
--comanda/valoare
--500	60
--501	47
--502	70
--503	35
--504	74
--505	65
--506	124

--3. In urma stergerii din baza de date a unor informatii legate de rezervari si comenzi (presupunem ca toate informatiile din istoric), au ramas clienti care initial 
--nu au plasat nicio comanda, dar au facut una din rezervarile sterse din baza de date. Eliminati clientii respectivi.
delete from CLIENT
where cod_client not in (select distinct cod_client
                         from FACE)
and cod_comanda is null;
--clientul 51 a fost eliminat din baza de date

--CERINTA 13!
create sequence secventa_comanda_id
start with 500
increment by 1
maxvalue 9999
nocycle
nocache; 

--CERINTA 14!
--OUTER-JOIN: Sa se afiseze numele angajatilor, prenumele, numele restaurantului in care lucreaza, orasul in care se afla restaurantul si programul de functionare pentru angajatii 
--care au lungimea numelui mai mare decat 5. Se vor afisa si salariatii care nu au asociat un restaurant. Afisarea se va face in ordine crescatoare dupa salariu.
select a.nume_angajat as Nume_angajat_SAI, a.prenume_angajat as Prenume_angajat_SAI, r.nume_restaurant as Nume_restaurant_SAI, ad.oras as Oras_restaurant_SAI,
p.ora_deschidere as Ora_deschidere_SAI, p.ora_inchidere as Ora_inchidere_SAI
from ANGAJAT a, RESTAURANT r, ADRESA ad, PROGRAM p
where a.cod_restaurant=r.cod_restaurant(+) and r.cod_adresa=ad.cod_adresa(+) and r.cod_program=p.cod_program(+) and length(nume_angajat)>5
order by a.salariu;
--15 rezultate
--Bojici	Matei	 null      null     null     null
--Dragomirescu	Laur	Trattoria	Sinaia		null    null
--Podariu	Ionel	Toscana	   null  	 08:30  	21:30

--DIVISION: Sa se afiseze codurile tuturor preparatelor cuprinse in toate comenzile pentru care valoarea se afla in multimea {65,124}.
select distinct a.cod_preparat as Cod_preparat_SAI
from CUPRINDE a
where not exists (select 1
                  from COMANDA c
                  where (c.valoare=65 or c.valoare=124) and not exists (select 1
                                                                        from CUPRINDE b
                                                                        where c.cod_comanda=b.cod_comanda and b.cod_preparat=a.cod_preparat));
--1 rezultat: 80 - comenzile 505 si 506 au valorile in multimea {65,124} si ambele cuprind preparatul 'tort de ciocolata'

--DIVISION: Sa se afiseze codurile tuturor evenimentelor realizate de toate restaurantele cu numele 'Best', 'Lazarini' si 'Toscana'.
select distinct a.cod_eveniment as Cod_eveniment_SAI
from REALIZEAZA a
where not exists (select 'x'
                  from RESTAURANT c
                  where (lower(c.nume_restaurant)='best' or upper(c.nume_restaurant)='LAZARINI' or initcap(c.nume_restaurant)='Toscana')
                  and not exists (select 1
                                  from REALIZEAZA b
                                  where c.cod_restaurant=b.cod_restaurant and b.cod_eveniment=a.cod_eveniment));
--1 rezultat: 303 - toate restaurantele mentionate realizeaza evenimentul 303

--CERINTA 15!
--initial
select ad.cod_adresa, ad.strada, ad.numar, r.nume_restaurant, r.capacitate
from (select cod_adresa, strada, numar, oras
      from adresa
      where lower(oras)='ploiesti') ad, restaurant r
where ad.cod_adresa=r.cod_adresa and r.capacitate>450 and r.capacitate<750;

--optim
select a.cod_adresa, a.strada, a.numar, r.nume_restaurant, r.capacitate
from adresa a, restaurant r
where a.cod_adresa=r.cod_adresa and lower(a.oras)='ploiesti' and r.capacitate>450 and r.capacitate<750;

