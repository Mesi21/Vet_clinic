/*Queries that provide answers to the questions from all projects.*/
SELECT * FROM animals WHERE name LIKE '%mon';
SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT * FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT name, date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

BEGIN TRANSACTION;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
BEGIN TRANSACTION;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT TRANSACTION;
SELECT * FROM animals;
BEGIN TRANSACTION;
DELETE FROM animals;
ROLLBACK;

BEGIN TRANSACTION;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT save_point;
UPDATE animals SET weight_kg = weight_kg * -1;
SELECT * FROM animals;
ROLLBACK TO save_point;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
SELECT * FROM animals;
COMMIT TRANSACTION;

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT neutered, SUM(escape_attempts) FROM animals GROUP BY neutered;
SELECT species, MAX(weight_kg) as Max_weight, MIN(weight_kg) as Max_weight  FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) as Average_escape_attempts FROM animals WHERE date_of_birth <= '2000-12-31' AND date_of_birth >= '1990-01-01' GROUP BY species;

SELECT full_name AS owner, name AS animal FROM owners JOIN animals ON owners.id = animals.owner_id WHERE owners.full_name = 'Melody Pond';
SELECT animals.name AS animal, species.name AS species FROM species S JOIN animals A ON S.id = A.species_id WHERE S.name = 'Pokemon';
SELECT O.full_name AS Owner, A.name AS Animals FROM owners O LEFT JOIN animals A ON O.id = A.owner_id;
SELECT S.name AS Species, COUNT(A.name) AS Total_number FROM species S JOIN animals A ON S.id = A.species_id GROUP BY S.name;
SELECT O.full_name as owner, A.name as animal, S.name as type FROM owners O JOIN animals A ON O.id = A.owner_id JOIN species S ON S.id = A.species_id WHERE O.full_name = 'Jennifer Orwell' AND S.name = 'Digimon';
SELECT O.full_name as owner, A.name as animal FROM owners O JOIN animals A ON O.id = A.owner_id WHERE O.full_name = 'Dean Winchester' AND A.escape_attempts = 0;
SELECT agg.full_name as owner, count as Total_number FROM (
  SELECT full_name, count(a.owner_id) FROM owners O
  JOIN animals A ON O.id = A.owner_id GROUP BY O.full_name) AS agg 
  WHERE count = (SELECT MAX(count) FROM (SELECT full_name, count(a.owner_id) FROM owners O
  JOIN animals A ON O.id = A.owner_id GROUP BY O.full_name) AS agg
  );
SELECT WT.Vet_name, WT.date_of_visit, WT.animal FROM 
(SELECT Vt.name AS Vet_name, Vs.date_of_visit, A.name AS animal FROM vets Vt
JOIN visits Vs ON Vt.id = Vs.vet_id
JOIN animals A ON Vs.animal_id = A.id
WHERE Vt.name = 'William Tatcher') AS WT
WHERE date_of_visit = (SELECT MAX(WT.date_of_visit) FROM (SELECT Vt.name AS Vet_name, Vs.date_of_visit, A.name AS animal FROM vets Vt
JOIN visits Vs ON Vt.id = Vs.vet_id
JOIN animals A ON Vs.animal_id = A.id
WHERE Vt.name = 'William Tatcher') AS WT);
SELECT COUNT(SM.animal) FROM (SELECT Count(Vt.name) AS No_of_Vet_name, A.name AS animal FROM vets Vt
JOIN visits Vs ON Vt.id = Vs.vet_id JOIN animals A ON Vs.animal_id = A.id
WHERE Vt.name = 'Stephanie Mendez'
GROUP BY A.name) AS SM;
SELECT Vt.id, Vt.name AS Vet_name, Sp.name AS specialty FROM vets Vt
LEFT JOIN specializations Sn ON Vt.id = Sn.vet_id
LEFT JOIN species Sp ON Sn.species_id = Sp.id; 
SELECT Vt.name AS Vet_name, A.name AS animal, Vs.date_of_visit FROM vets Vt
JOIN visits Vs ON Vt.id = Vs.vet_id
JOIN animals A ON Vs.animal_id = A.id
WHERE Vt.name = 'Stephanie Mendez' 
AND (Vs.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30');
SELECT AL.animal, AL.Vet_visits FROM
(SELECT A.name AS animal, COUNT(Vt.name) AS Vet_visits FROM vets Vt
  JOIN visits Vs ON Vt.id = Vs.vet_id
  JOIN animals A ON Vs.animal_id = A.id
  GROUP BY A.name
) as AL
WHERE AL.Vet_visits = (SELECT MAX(AL.Vet_visits) FROM (SELECT A.name AS animal, COUNT(Vt.name) AS Vet_visits FROM vets Vt
JOIN visits Vs ON Vt.id = Vs.vet_id
JOIN animals A ON Vs.animal_id = A.id
GROUP BY A.name) as AL);
SELECT MS.Vet_name, MS.animal, MS.date_of_visit FROM
(SELECT Vt.name AS Vet_name, A.name AS animal, Vs.date_of_visit FROM vets Vt
  JOIN visits Vs ON Vt.id = Vs.vet_id
  JOIN animals A ON Vs.animal_id = A.id
  WHERE Vt.name = 'Maisy Smith'
) AS MS
WHERE MS.date_of_visit = (SELECT MIN(MS.date_of_visit) FROM 
(SELECT Vt.name AS Vet_name, A.name AS animal, Vs.date_of_visit FROM vets Vt
  JOIN visits Vs ON Vt.id = Vs.vet_id
  JOIN animals A ON Vs.animal_id = A.id
  WHERE Vt.name = 'Maisy Smith'
) AS MS);
SELECT A.*, Vt.*, Vs.date_of_visit FROM vets Vt
  JOIN visits Vs ON Vt.id = Vs.vet_id
  JOIN animals A ON Vs.animal_id = A.id
WHERE date_of_visit = (SELECT MAX(MD.date_of_visit) FROM (SELECT Vt.*, A.*, Vs.date_of_visit FROM vets Vt
  JOIN visits Vs ON Vt.id = Vs.vet_id
  JOIN animals A ON Vs.animal_id = A.id) As MD);
SELECT COUNT(MS.Vet_name) AS visits FROM 
(SELECT  Vt.name AS Vet_name, A.name AS animal, Vs.date_of_visit, Sp.name as specialty FROM vets Vt
  LEFT JOIN specializations Sz ON Vt.id = Sz.vet_id
  LEFT JOIN species Sp ON Sz.species_id = Sp.id
  JOIN visits Vs ON Vt.id = Vs.vet_id
  JOIN animals A ON Vs.animal_id = A.id
  WHERE Sp.name IS NULL) as MS;
SELECT S.name AS Species_name, MS2.species_id, MS2.Total_number AS Total_number_of_species FROM species S
JOIN (SELECT MS.species_id, MS.Total_number FROM 
(SELECT A.species_id, COUNT(A.species_id) AS Total_number FROM vets Vt
  LEFT JOIN specializations Sz ON Vt.id = Sz.vet_id
  LEFT JOIN species Sp ON Sz.species_id = Sp.id
  JOIN visits Vs ON Vt.id = Vs.vet_id
  JOIN animals A ON Vs.animal_id = A.id
  WHERE Vt.name = 'Maisy Smith'
  GROUP BY A.species_id) as MS
WHERE MS.Total_number = (SELECT MAX(MS.Total_number) FROM
(SELECT A.species_id, COUNT(A.species_id) AS Total_number FROM vets Vt
  LEFT JOIN specializations Sz ON Vt.id = Sz.vet_id
  LEFT JOIN species Sp ON Sz.species_id = Sp.id
  JOIN visits Vs ON Vt.id = Vs.vet_id
  JOIN animals A ON Vs.animal_id = A.id
  WHERE Vt.name = 'Maisy Smith'
  GROUP BY A.species_id) as MS)) AS MS2
  ON S.id = MS2.species_id; 