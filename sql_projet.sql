DROP TABLE IF EXISTS recolte;

DROP TABLE IF EXISTS visite;

DROP TABLE IF EXISTS contient;

DROP TABLE IF EXISTS deposer;

DROP TABLE IF EXISTS acheter;

DROP TABLE IF EXISTS possede;

DROP TABLE IF EXISTS Client;

DROP TABLE IF EXISTS Type_vetement;

DROP TABLE IF EXISTS Type_telephone;

DROP TABLE IF EXISTS Categorie_client;

DROP TABLE IF EXISTS Deplacement;

DROP TABLE IF EXISTS Camionette;

DROP TABLE IF EXISTS Conteneur;

CREATE TABLE Conteneur (
    conteneur_id INT AUTO_INCREMENT,
    adresse_conteneur VARCHAR(50),
    distance_magasin DECIMAL(6, 2),
    PRIMARY KEY (conteneur_id)
);

CREATE TABLE Camionette (
    imatriculation_camionette VARCHAR(50),
    PRIMARY KEY (imatriculation_camionette)
);

CREATE TABLE Deplacement (
    deplacement_id INT AUTO_INCREMENT,
    date_heure_collecte DATETIME,
    imatriculation_camionette VARCHAR(50) NOT NULL,
    PRIMARY KEY (deplacement_id),
    FOREIGN KEY (imatriculation_camionette) REFERENCES Camionette (imatriculation_camionette)
);

CREATE TABLE Categorie_client (
    categorie_id INT AUTO_INCREMENT,
    libelle VARCHAR(50),
    poid_necessaire DECIMAL(6, 2),
    reduction INT,
    PRIMARY KEY (categorie_id)
);

CREATE TABLE Type_telephone (
    id_type_telephone INT AUTO_INCREMENT,
    libelle_type_telephone VARCHAR(30),
    PRIMARY KEY (id_type_telephone)
);

CREATE TABLE Type_vetement (
    type_vetement_id INT AUTO_INCREMENT,
    libelle VARCHAR(50),
    prix_kg DECIMAL(6, 2),
    PRIMARY KEY (type_vetement_id)
);

CREATE TABLE Client (
    client_id INT AUTO_INCREMENT,
    nom_client VARCHAR(50),
    adresse_client VARCHAR(50),
    email_client VARCHAR(50),
    categorie_id INT NOT NULL,
    PRIMARY KEY (client_id),
    FOREIGN KEY (categorie_id) REFERENCES Categorie_client (categorie_id)
);

CREATE TABLE possede (
    client_id INT,
    id_type_telephone INT,
    numero_telephone VARCHAR(15),
    PRIMARY KEY (client_id, id_type_telephone),
    FOREIGN KEY (client_id) REFERENCES Client (client_id),
    FOREIGN KEY (id_type_telephone) REFERENCES Type_telephone (id_type_telephone)
);

CREATE TABLE acheter (
    client_id INT,
    type_vetement_id INT,
    quantiter_achat DECIMAL(7, 2),
    date_heure_achat DATETIME,
    PRIMARY KEY (client_id, type_vetement_id),
    FOREIGN KEY (client_id) REFERENCES Client (client_id),
    FOREIGN KEY (type_vetement_id) REFERENCES Type_vetement (type_vetement_id)
);

CREATE TABLE deposer (
    deposer_id INT AUTO_INCREMENT,
    client_id INT,
    type_vetement_id INT,
    quantiter_depot DECIMAL(7, 2),
    date_heure_depot DATETIME,
    PRIMARY KEY (deposer_id),
    FOREIGN KEY (client_id) REFERENCES Client (client_id),
    FOREIGN KEY (type_vetement_id) REFERENCES Type_vetement (type_vetement_id)
);

CREATE TABLE contient (
    conteneur_id INT,
    type_vetement_id INT,
    PRIMARY KEY (conteneur_id, type_vetement_id),
    FOREIGN KEY (conteneur_id) REFERENCES Conteneur (conteneur_id),
    FOREIGN KEY (type_vetement_id) REFERENCES Type_vetement (type_vetement_id)
);

CREATE TABLE visite (
    conteneur_id INT,
    deplacement_id INT,
    PRIMARY KEY (conteneur_id, deplacement_id),
    FOREIGN KEY (conteneur_id) REFERENCES Conteneur (conteneur_id),
    FOREIGN KEY (deplacement_id) REFERENCES Deplacement (deplacement_id)
);

CREATE TABLE recolte (
    deplacement_id INT,
    type_vetement_id INT,
    quantite_recoltée DECIMAL(6, 2),
    PRIMARY KEY (deplacement_id, type_vetement_id),
    FOREIGN KEY (deplacement_id) REFERENCES Deplacement (deplacement_id),
    FOREIGN KEY (type_vetement_id) REFERENCES Type_vetement (type_vetement_id)
);





INSERT INTO
    Categorie_client (libelle, poid_necessaire, reduction)
VALUES
    ("aucun", 0.00, 0),
    ("faible", 5.00, 5),
    ("petit", 15.00, 8),
    ("moyen", 35.00, 15),
    ("lourd", 60.00, 20),
    ("énorme", 100.00, 35);

INSERT INTO
    Type_telephone (libelle_type_telephone)
VALUES
    ('Fixe'),
    ('Mobile'),
    ('Pro');

INSERT INTO
    Client (
        nom_client,
        adresse_client,
        email_client,
        categorie_id
    )
VALUES
    (
        'Marc Lefevre',
        '23 Rue du Faubourg Saint-Antoine, Paris',
        'marc.lefevre@example.com',
        3
    ),
    (
        'Julie Dupont',
        '56 Avenue des Ternes, Paris',
        'julie.dupont@example.com',
        2
    ),
    (
        'Antoine Moreau',
        '34 Rue de la Pompe, Paris',
        'antoine.moreau@example.com',
        3
    ),
    (
        'Isabelle Martin',
        '89 Boulevard Saint-Michel, Paris',
        'isabelle.martin@example.com',
        1
    ),
    (
        'Luc Dubois',
        '67 Avenue de Wagram, Paris',
        'luc.dubois@example.com',
        2
    ),
    (
        'Nathalie Leroy',
        '112 Rue du Faubourg Saint-Honoré, Paris',
        'nathalie.leroy@example.com',
        1
    ),
    (
        'Franck Richard',
        '78 Avenue des Gobelins, Paris',
        'franck.richard@example.com',
        3
    ),
    (
        'Catherine Blanc',
        '45 Quai de la Tournelle, Paris',
        'catherine.blanc@example.com',
        2
    ),
    (
        'Alexandre Leclerc',
        '21 Rue de la Roquette, Paris',
        'alexandre.leclerc@example.com',
        1
    ),
    (
        'Valérie Lambert',
        '98 Avenue de Clichy, Paris',
        'valerie.lambert@example.com',
        2
    ),
    (
        'Thierry Rousseau',
        '76 Rue de Belleville, Paris',
        'thierry.rousseau@example.com',
        1
    ),
    (
        'Caroline Robert',
        '32 Quai Branly, Paris',
        'caroline.robert@example.com',
        3
    ),
    (
        'Hugo Martin',
        '54 Rue du Cherche-Midi, Paris',
        'hugo.martin@example.com',
        2
    ),
    (
        'Sylvie Lemoine',
        '67 Avenue des Gobelins, Paris',
        'sylvie.lemoine@example.com',
        1
    ),
    (
        'Philippe Dubois',
        '43 Rue de la Pompe, Paris',
        'philippe.dubois@example.com',
        3
    );

INSERT INTO
    Type_vetement (libelle, prix_kg)
VALUES
    ('Chemise', 20.00),
    ('Short', 19.00),
    ('Jupe', 15.00),
    ('Veste', 20.00),
    ('Pull', 20.00),
    ('Chaussures', 15.00),
    ('Ceinture', 12.00),
    ('Cravate', 10.00);

INSERT INTO
    possede (client_id, id_type_telephone, numero_telephone)
VALUES
    (4, 3, '5555555555'),
    (1, 1, '4444444444'),
    (3, 2, '6666666666'),
    (4, 2, '7777777777'),
    (5, 1, '8888888888'),
    (6, 3, '9999999999'),
    (7, 1, '1234567890'),
    (8, 2, '2345678901'),
    (9, 3, '3456789012'),
    (10, 1, '4567890123'),
    (11, 2, '5678901234'),
    (12, 3, '6789012345'),
    (13, 1, '7890123456'),
    (14, 2, '8901234567'),
    (15, 3, '9012345678');

INSERT INTO
    acheter (
        client_id,
        type_vetement_id,
        quantiter_achat,
        date_heure_achat
    )
VALUES
    (4, 5, 10, '2023-11-15 14:45:00'),
    (1, 6, 5, '2023-11-15 16:00:00'),
    (3, 7, 8, '2023-11-15 17:30:00'),
    (4, 8, 3, '2023-11-15 19:15:00'),
    (5, 2, 6, '2023-11-15 21:00:00'),
    (6, 3, 4, '2023-11-15 22:30:00'),
    (7, 4, 7, '2023-11-16 08:00:00'),
    (8, 4, 9, '2023-11-16 10:15:00'),
    (9, 8, 2, '2023-11-16 12:30:00'),
    (10, 2, 5, '2023-11-16 14:45:00'),
    (11, 5, 8, '2023-11-16 16:00:00'),
    (12, 1, 3, '2023-11-16 17:30:00'),
    (13, 2, 6, '2023-11-16 19:15:00'),
    (14, 3, 4, '2023-11-16 21:00:00'),
    (15, 4, 7, '2023-11-16 22:30:00');

INSERT INTO
    deposer (
        client_id,
        type_vetement_id,
        quantiter_depot,
        date_heure_depot
    )
VALUES
    (4, 1, 8, '2023-11-15 16:45:00'),
    (1, 2, 4, '2023-11-15 18:30:00'),
    (3, 3, 7, '2023-11-15 20:15:00'),
    (4, 4, 5, '2023-11-15 22:00:00'),
    (5, 6, 3, '2023-11-15 23:30:00'),
    (6, 6, 6, '2023-11-16 08:30:00'),
    (7, 7, 8, '2023-11-16 10:45:00'),
    (8, 8, 5, '2023-11-16 12:30:00'),
    (9, 2, 4, '2023-11-16 14:45:00'),
    (10, 4, 7, '2023-11-16 16:00:00'),
    (11, 6, 9, '2023-11-16 18:30:00'),
    (12, 1, 2, '2023-11-16 20:15:00'),
    (13, 2, 5, '2023-11-16 22:00:00'),
    (14, 3, 6, '2023-11-16 23:30:00'),
    (15, 4, 3, '2023-11-17 08:30:00');

INSERT INTO
    Conteneur (adresse_conteneur, distance_magasin)
VALUES
    ('Avenue Opéra, Paris', 11.2),
    ('Quai des Orfèvres, Paris', 14.8),
    ('Rue Saint-Antoine, Paris', 9.6),
    ('Avenue Montaigne, Paris', 13.4),
    ('Rue de la Paix, Paris', 12.1),
    ('Place Vendôme, Paris', 8.3),
    ('Rue du Faubourg Saint-Antoine, Paris', 10.9),
    ('Boulevard Montmartre, Paris', 14.2),
    ('Place de la Concorde, Paris', 15.9),
    ('Avenue Marceau, Paris', 9.0),
    ('Rue de la Pompe, Paris', 11.7),
    ('Rue du Cherche-Midi, Paris', 16.5),
    ('Avenue de Clichy, Paris', 12.6),
    ('Rue de la Roquette, Paris', 7.8),
    ('Quai de la Tournelle, Paris', 14.0);

INSERT INTO
    Camionette (imatriculation_camionette)
VALUES
    ('JKL321'),
    ('MNO456'),
    ('PQR789'),
    ('STU012'),
    ('VWX345'),
    ('YZA678'),
    ('BCD901'),
    ('EFG234'),
    ('HIJ567'),
    ('LMN890'),
    ('OPQ123'),
    ('RST456'),
    ('UVW789'),
    ('XYZ012'),
    ('ABC345');

INSERT INTO
    Deplacement (date_heure_collecte, imatriculation_camionette)
VALUES
    ('2023-11-15 14:00:00', 'JKL321'),
    ('2023-11-15 15:30:00', 'MNO456'),
    ('2023-11-15 16:45:00', 'PQR789'),
    ('2023-11-15 18:15:00', 'STU012'),
    ('2023-11-15 19:30:00', 'VWX345'),
    ('2023-11-15 21:00:00', 'YZA678'),
    ('2023-11-16 08:00:00', 'BCD901'),
    ('2023-11-16 09:30:00', 'EFG234'),
    ('2023-11-16 10:45:00', 'HIJ567'),
    ('2023-11-16 12:15:00', 'LMN890'),
    ('2023-11-16 13:30:00', 'OPQ123'),
    ('2023-11-16 15:00:00', 'RST456'),
    ('2023-11-16 16:15:00', 'UVW789'),
    ('2023-11-16 17:45:00', 'XYZ012'),
    ('2023-11-16 19:00:00', 'ABC345');

INSERT INTO
    recolte (
        deplacement_id,
        type_vetement_id,
        quantite_recoltée
    )
VALUES
    (1, 1, 10.00),
    (2, 2, 15.00),
    (3, 3, 8.00),
    (4, 4, 12.50);

INSERT INTO
    contient (conteneur_id, type_vetement_id)
VALUES
    (5, 1),
    (6, 2),
    (7, 3),
    (8, 4),
    (9, 5),
    (10, 6),
    (11, 7),
    (12, 8),
    (13, 2),
    (14, 3),
    (15, 1),
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4);

INSERT INTO
    visite (conteneur_id, deplacement_id)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6),
    (7, 7),
    (8, 8),
    (9, 9),
    (10, 10),
    (11, 11),
    (12, 12),
    (13, 13),
    (14, 14),
    (15, 15);




SELECT
    *
FROM
    Client;

SELECT
    *
FROM
    Categorie_client;

SELECT
    *
FROM
    Type_telephone;

SELECT
    *
FROM
    Type_vetement;

SELECT
    c.client_id,
    c.nom_client,
    cc.*
FROM
    Client c
    JOIN Categorie_client cc ON c.categorie_id = cc.categorie_id;

SELECT
    c.nom_client,
    t.libelle_type_telephone as type_telephone,
    p.numero_telephone
FROM
    possede p
    JOIN Type_telephone t ON p.id_type_telephone = t.id_type_telephone
    JOIN Client c on p.client_id = c.client_id;

SELECT
    c.nom_client,
    tv.libelle,
    tv.prix_kg,
    a.quantiter_achat,
    SUM(tv.prix_kg * a.quantiter_achat) as prix_totale
FROM
    acheter a
    JOIN Client c ON a.client_id = c.client_id
    JOIN Type_vetement tv ON a.type_vetement_id = tv.type_vetement_id
GROUP BY
    c.nom_client,
    tv.libelle,
    tv.prix_kg,
    a.quantiter_achat;

SELECT v.deplacement_id, c.adresse_conteneur, c.distance_magasin, d.imatriculation_camionette
FROM visite v
JOIN Conteneur c on v.conteneur_id = c.conteneur_id
JOIN Deplacement d on v.deplacement_id = d.deplacement_id;

SELECT c.conteneur_id, MIN(c.distance_magasin) as distance_minimal FROM Conteneur c;

SELECT c.conteneur_id, MAX(c.distance_magasin) as distance_maximal FROM Conteneur c;

SELECT
    c.client_id,
    c.nom_client,
    SUM(tv.prix_kg * a.quantiter_achat) as total_all_time
FROM
    acheter a
    JOIN Client c ON a.client_id = c.client_id
    JOIN Type_vetement tv ON a.type_vetement_id = tv.type_vetement_id
GROUP BY
    c.client_id
ORDER BY SUM(tv.prix_kg * a.quantiter_achat) DESC;

