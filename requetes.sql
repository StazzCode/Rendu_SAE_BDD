--EX4
--Q1.
\echo ''Nombre de colonnes dans la table import''
Select Count(column_name) From information_schema.columns Where table_name = 'import';

--Q2.
\echo ''Nombre de lignes dans la table import:''
Select Count(*) From import;

--Q3.
\echo ''Nombre de codes dans la table noc:''
Select Count(noc) From noc;

--Q4.
\echo ''Nombre d athletes différents dans la table import:''
Select Count(Distinct name) From import;

--Q5.
\echo ''Nombre de médailles d or dans la table import:''
Select Count(Medal) From import Where Medal = 'Gold';

--Q6.
\echo ''Nombre de lignes référençant Carl Lewis:''
Select Count(*) From import Where name Like '%Carl%Lewis';

--EX5
--Q1.
Select noc,Count(*) From resultat Group By noc Order By Count(*) Desc; 

--Q2.
Select noc,Count(medal) From resultat Where medal = 'Gold'Group By noc Order By Count(*) Desc;

--Q3.
Select noc,Count(*) From resultat Where medal is not null Group By noc Order By Count(*) Desc;

--Q4.
Select name,sex,Count(*) From resultat as r, athlete as a Where r.ano = a.ano And medal = 'Gold' Group By name,sex Order By Count(*) Desc;

--Q5.
Select noc,Count(*) From resultat as r,edition as ed Where r.edno = ed.edno And city = 'Albertville' Group by noc Order By Count(*) Desc;

--Q6.
Select Count(*) From (
Select r1.ano
From resultat as r1, resultat as r2
Where r1.ano = r2.ano
And r1.noc > r2.noc
And r2.noc = 'FRA'
Group By r1.ano
Having Count(*) = 1) as liste;

--Q7.
Select Count(*) From (
Select r1.ano
From resultat as r1, resultat as r2
Where r1.ano = r2.ano
And r1.noc > r2.noc
And r1.noc = 'FRA'
Group By r1.ano
Having Count(*) = 1) as liste;

--Q8.
Select ano,age From resultat Where medal = 'Gold' Group by ano,age Order by age asc;

--Q9.
Select sport,age From resultat as r, event as e Where e.evno = r.evno And age > 50 And medal is not null Group by sport,age Order by sport Desc;

--Q10.
Select year,season,Count(*) From (Select Distinct evno, edno from resultat) as r, edition as e Where r.edno=e.edno Group By season,year Order By year asc;

--Q11.
Select year,Count(*)
From resultat as r, athlete as a, edition as e
Where r.ano = a.ano
And r.edno = e.edno
And sex = 'F'
And season = 'Summer'
And medal is not null
Group by year
Order by year asc;

--EX6

--Affiche le premier et le troisième sur le podium du 200 mètres homme au JO de 1968 au Mexique.
Select * from import
Where Sport = "Athletics"
And Noc = "USA"
And Year = 1968
And medal = 'Gold'
And Season = 'Summer'
And event Like '%200%'

--Affiche les 10 athlètes ayant le plus de médailles d'or en athlétisme.
Select name,sex,Count(*) From import 
Where NOC = 'USA' 
And Sport = 'Athletics' 
And medal = 'Gold' 
Group by name,sex 
Order by Count(*) desc 
Limit 10;

--Affiche l'évolution du nombre d'athlètes aux USA en athlétisme depuis 1920 à 2016.
Select year,Count(*) From import 
Where NOC = 'USA' 
And Sport = 'Athletics' 
Group by year 
Order by year desc;

--Affiche le pourcentage d'athlètes américains, homme et femme durant les épreuves d'athlétisme des JO 2016.
Select sex, (Count(*)*100)/(Select Count(*) From import Where NOC = 'USA' And Sport = 'Athletics' And Year = 2016) as total From import 
Where NOC = 'USA' 
And Sport = 'Athletics' 
And Year = 2016 
Group by sex;
