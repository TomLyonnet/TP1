#Exercice n°1

#On créé un Namespace "elections"
cqlsh> CREATE KEYSPACE elections with replication={‘class’:’SimpleStrategie’,’replication_factor’:1} AND durable_writes=’true’;

#On créé une table "administre"
#avant chaque commande on est sensé mettre " cqlsh> ", pour plus de lisibiliter je ne le mettrai plus ici
use elections;
cqlsh:elections> CREATE TABLE administre (numero_id_nationale int PRIMARY KEY, name text, surname text, addresse text);

#On créé une table "candidat"
CREATE TABLE candidat (name text PRIMARY KEY, surname text, parti_politique text);

#On peut vérifier que la table est bien créé avec: DESCRIBE TABLES
#On obtient alors ici: administre  candidat

#On ajoute des valeurs aux tableaux
#On commmence par "adminitre"
INSERT INTO administre (numero_id_nationale, name, surname, adresse) VALUES ( 123,'Gangand', 'Louison',' Paris');
#On peut afficher les données du tableau avec: SELECt* FROM administre;
 numero_id_nationale | adresse | name    | surname
---------------------+---------+---------+---------
                 123 |   Paris | Gangand | Louison
#On ajoute d'autres administre                
cqlsh:elections> INSERT INTO administre (numero_id_nationale, name, surname, adresse) VALUES ( 109,'BD', 'Louis','Ivry');
cqlsh:elections> INSERT INTO administre (numero_id_nationale, name, surname, adresse) VALUES ( 912,'Farenc', 'Lucas','RICHE');
cqlsh:elections> INSERT INTO administre (numero_id_nationale, name, surname, adresse) VALUES ( 112,'Lyonnet', 'Tom','ASSE');
cqlsh:elections> INSERT INTO administre (numero_id_nationale, name, surname, adresse) VALUES ( 001,'Couble', 'Nono','OL');

#On ajoute à présent des valeurs à "candidat"
cqlsh:elections> INSERT INTO candidat (name, surname, parti_politique) VALUES('Lyonnet','Alain','FCL');
#On ajoute une colonne pour le "nb_voix" et mettons 1001 pour le candidat Alain Lyonnet du FCL
cqlsh:elections> ALTER TABLE candidat ADD nb_voix int;
cqlsh:elections> UPDATE candidat set nb_voix=1001 WHERE name='Lyonnet';
cqlsh:elections> INSERT INTO candidat (name, surname, parti_politique,nb_voix) VALUES('Sarko','Nico','UMP',999);
cqlsh:elections> INSERT INTO candidat (name, surname, parti_politique,nb_voix) VALUES('Hidalgo','Anne','FC LOOSE',1001);
cqlsh:elections> INSERT INTO candidat (name, surname, parti_politique,nb_voix) VALUES('Lassalle','Jean','BAR',503);
INSERT INTO candidat (name, surname, parti_politique,nb_voix) VALUES('AA','A','FC LOOSE',52);
cqlsh:elections> INSERT INTO candidat (name, surname, parti_politique,nb_voix) VALUES('TEK','PAF','BAR',58);

#De même on peut afficher les données du tableau avec: SELECt* FROM candidat; 

 name     | nb_voix | parti_politique | surname
----------+---------+-----------------+---------
  Hidalgo |    1001 |        FC LOOSE |    Anne
      TEK |      58 |             BAR |     PAF
       AA |      52 |        FC LOOSE |       A
  Lyonnet |     111 |             FCL |   Alain
    Sarko |     999 |             UMP |    Nico
 Lassalle |     503 |             BAR |    Jean

(6 rows)

#On met a jour le "parti_politique" des candidats afin qu'ils appartiennent soit à A, B ou C
update candidat set parti_politique=A WHERE name=Hidalgo;
cqlsh:elections> UPDATE candidat set parti_politique='B' WHERE name='TEK';
cqlsh:elections> UPDATE candidat set parti_politique='C' WHERE name='AA';
cqlsh:elections> UPDATE candidat set parti_politique='A' WHERE name='Lyonnet';
cqlsh:elections> UPDATE candidat set parti_politique='B' WHERE name='Sarko';
cqlsh:elections> UPDATE candidat set parti_politique='C' WHERE name='Lassalle';
#Ainsi avec la commande: cqlsh:elections> select * from candidat ;
#On obtient
 name     | nb_voix | parti_politique | surname
----------+---------+-----------------+---------
  Hidalgo |    1001 |               A |    Anne
      TEK |      58 |               B |     PAF
       AA |      52 |               C |       A
  Lyonnet |     111 |               A |   Alain
    Sarko |     999 |               B |    Nico
 Lassalle |     503 |               C |    Jean


Cette modélisation devra vous permettre de répondre au moins aux questions suivantes :

"""1. Quel parti politique a réuni le plus de voix ?"""
#On va créer un INDEX pour les parti_politique des candidat afin de simplifier la recherche
cqlsh:elections> create INDEX  ipp on candidat (parti_politique) ;
#On peut maintenant voir les résulats des partis
SELECT SUM(nb_voix) from candidat WHERE parti_politique='A';
 system.sum(nb_voix)
---------------------
                1112

SELECT SUM(nb_voix) from candidat WHERE parti_politique='B';
 system.sum(nb_voix)
---------------------
                1057


SELECT SUM(nb_voix) from candidat WHERE parti_politique='C';
 system.sum(nb_voix)
---------------------
                 555
#On conclue donc que le parti A a réuni le plus de voix

"""2. Quel candidat a gagné les élections ?"""
cqlsh:elections> SELECT name,surname,MAX(nb_voix) FROM candidat;
#On obtient
 surname | name    | system.max(nb_voix)
---------+---------+---------------------
    Anne | Hidalgo |                1001

# Le candidat Anne Hidalgo avec 1001 voix a gagné les élections

"""3. Le candidat ayant gagné les élections vient-il du parti politique ayant eu la majorité des voix ?"""
cqlsh:elections> SELECT parti_politique,surname,name,MAX(nb_voix) FROM candidat;

 parti_politique | surname | name    | system.max(nb_voix)
-----------------+---------+---------+---------------------
               A |    Anne | Hidalgo |                1001

#Anne Hidalgo est du parti_politique A donc 
#Oui

#Exercice 2
"""1. Quel est le parti politique ayant eu le plus de voix ?"""
#La question a été répondu lors de l'exercice 1 
"""2. Quel est le parti politique ayant eu le moins de voix ?"""
#De même pour la question 2


