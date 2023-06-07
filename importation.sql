--EX2--

-- Supression de la table import existante
Drop Table import;

-- Creation de la table import
Create Table import(

       	     ID int,
	     Name text,
	     Sex char(1),
	     Age int,
	     Heigth int ,
	     Weight float,
	     Team text,
	     NOC char(3),
	     Games text,
	     Year int,
	     Season text,
	     City text,
	     Sport text,
	     Event text,
	     Medal text

);

-- Importation des données du fichier athlete_events.csv dans la table import
\echo ''Importation des données du fichier athlete_events.csv dans la table import''

\Copy import from 'athlete_events.csv' with csv delimiter ',' header null as 'NA';

-- Affichage du nombre de ligne initial dans la table import
Select Count(*) From import;

-- Supression des données antérieur à 1920

Delete From import Where year < 1920;
Delete From import Where Sport = 'Art Competitions';

-- Affichage du nombre de ligne dans la table import

Select Count(*) From import;

-- Supression de la table noc existante
Drop table noc Cascade;

-- Creation de la table noc
Create Table noc(

       NOC char(3),
       region text,
       notes text Default NULL,

       Constraint pk_noc Primary Key (NOC)

);

-- Importation des données du fichier noc_regions.csv dans la table noc
\echo ''Importation des données du fichier noc_regions.csv dans la table noc''

\Copy noc from 'noc_regions.csv' with csv delimiter ',' header;

--EX4--

--Q1

--Supression des tables à créer, correspondant au MLD
Drop Table  athlete Cascade;
Drop Table edition Cascade;
Drop Table event Cascade;
Drop Table resultat Cascade;

--Création des tables correspondant au MLD
Create Table athlete(

       ano serial,
       Name text,
       Sex char(1),

       Constraint pk_athlete Primary Key (ano)
);

Create Table edition(

       edno serial,
       year int,
       season text,
       city text,

       Constraint pk_edition Primary Key (edno)

);

Create Table event(

       evno serial,
       sport text,
       event text,

       Constraint pk_event Primary Key (evno)

);

Create Table resultat(

       ano int,
       noc char(3),
       evno int,
       edno int,
       age int,
       heigth int,
       weight int,
       medal text,

       Constraint pk_resultat Primary Key (ano,noc,evno,edno,age,heigth,weight),

       Constraint fk_ano Foreign Key (ano)
       References athlete(ano)
       On Update Cascade,

       Constraint fk_noc Foreign Key (noc)
       References noc(NOC)
       On Update Cascade,

       Constraint fk_evno Foreign Key (evno)
       References event(evno)
       On Update Cascade,

       Constraint fk_edno Foreign Key (edno)
       References edition(edno)
       On Update Cascade

);
--Insertion des données dans les tables créées précedemment
Insert Into athlete (Name,Sex)
       Select Distinct Name,Sex
       From import
       Where Name is not NULL
       And Sex is not NULL;

Insert Into edition (year,season,city)
       Select Distinct Year,Season,City
       From import
       Where Year is not NULL
       And Season is not NULL
       And City is not NULL;

Insert Into event (sport,event)
       Select Distinct Sport,Event
       From import
       Where Sport is not NULL
       And Event is not NULL;

Insert Into resultat (ano,noc,evno,edno,age,heigth,weight,medal)
       Select ano,noc.noc,evno,edno,age,heigth,weight,medal
       From athlete as a, edition as ed, event as ev, noc, import as i
       Where a.name = i.Name
       And a.sex = i.Sex
       And ed.year = i.Year
       And ed.season = i.Season
       And ed.city = i.City
       And ev.sport = i.Sport
       And ev.event = i.Event
       And noc.noc = i.NOC
       And age is not null
       And heigth is not null
       And weight is not null;
