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
    age_client INT,
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
    achat_id int AUTO_INCREMENT,
    type_vetement_id INT,
    client_id INT,
    quantiter_achat DECIMAL(7, 2),
    date_heure_achat DATETIME,
    PRIMARY KEY (achat_id),
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
        age_client,
        adresse_client,
        email_client,
        categorie_id
    )
VALUES
    (
        'Marc Lefevre',
        23,
        '23 Rue du Faubourg Saint-Antoine, Paris',
        'marc.lefevre@example.com',
        3
    ),
    (
        'Julie Dupont',
        48,
        '56 Avenue des Ternes, Paris',
        'julie.dupont@example.com',
        2
    ),
    (
        'Antoine Moreau',
        32,
        '34 Rue de la Pompe, Paris',
        'antoine.moreau@example.com',
        5
    ),
    (
        'Isabelle Martin',
        22,
        '89 Boulevard Saint-Michel, Paris',
        'isabelle.martin@example.com',
        1
    ),
    (
        'Luc Dubois',
        20,
        '67 Avenue de Wagram, Paris',
        'luc.dubois@example.com',
        4
    ),
    (
        'Nathalie Leroy',
        35,
        '112 Rue du Faubourg Saint-Honoré, Paris',
        'nathalie.leroy@example.com',
        1
    ),
    (
        'Franck Richard',
        44,
        '78 Avenue des Gobelins, Paris',
        'franck.richard@example.com',
        2
    ),
    (
        'Catherine Blanc',
        50,
        '45 Quai de la Tournelle, Paris',
        'catherine.blanc@example.com',
        2
    ),
    (
        'Alexandre Leclerc',
        31,
        '21 Rue de la Roquette, Paris',
        'alexandre.leclerc@example.com',
        3
    ),
    (
        'Valérie Lambert',
        19,
        '98 Avenue de Clichy, Paris',
        'valerie.lambert@example.com',
        6
    ),
    (
        'Thierry Rousseau',
        25,
        '76 Rue de Belleville, Paris',
        'thierry.rousseau@example.com',
        1
    ),
    (
        'Caroline Robert',
        40,
        '32 Quai Branly, Paris',
        'caroline.robert@example.com',
        3
    ),
    (
        'Hugo Martin',
        28,
        '54 Rue du Cherche-Midi, Paris',
        'hugo.martin@example.com',
        2
    ),
    (
        'Sylvie Lemoine',
        33,
        '67 Avenue des Gobelins, Paris',
        'sylvie.lemoine@example.com',
        1
    ),
    (
        'Philippe Dubois',
        54,
        '43 Rue de la Pompe, Paris',
        'philippe.dubois@example.com',
        3
    ),
    ('Marc Lefevre', 23, '23 Rue du Faubourg Saint-Antoine, Paris', 'marc.lefevre@example.com', 3),
    ('Jeanne Dubois', 30, '15 Rue de la République, Lyon', 'jeanne.dubois@example.com', 2),
    ('Thomas Moreau', 28, '8 Rue des Lilas, Marseille', 'thomas.moreau@example.com', 1),
    ('Sophie Girard', 35, '42 Avenue des Champs-Élysées, Paris', 'sophie.girard@example.com', 3),
    ('Lucas Martin', 25, '5 Boulevard Haussmann, Paris', 'lucas.martin@example.com', 2),
    ('Emma Lambert', 29, '10 Place de la Concorde, Lyon', 'emma.lambert@example.com', 1),
    ('Antoine Roussel', 31, '18 Rue de la Paix, Marseille', 'antoine.roussel@example.com', 3),
    ('Camille Dupont', 27, '30 Avenue Montaigne, Paris', 'camille.dupont@example.com', 2),
    ('Hugo Gauthier', 26, '3 Rue Royale, Lyon', 'hugo.gauthier@example.com', 1),
    ('Manon Chevalier', 24, '12 Rue de Rivoli, Marseille', 'manon.chevalier@example.com', 3),
    ('Léa Petit', 32, '7 Avenue Foch, Paris', 'lea.petit@example.com', 2),
    ('Nicolas Bernard', 33, '20 Rue de la Liberté, Lyon', 'nicolas.bernard@example.com', 1),
    ('Julie Leroy', 22, '25 Place Vendôme, Marseille', 'julie.leroy@example.com', 3),
    ('Pierre Renault', 34, '9 Rue de la Madeleine, Paris', 'pierre.renault@example.com', 2),
    ('Elise Simon', 27, '14 Avenue des Champs-Élysées, Lyon', 'elise.simon@example.com', 1);

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
    (1, 1, '4444444444'),
    (2, 1, '8729461937'),
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
    (15, 3, '9012345678'),
    (16, 1, '0123456789'),
    (17, 2, '1234567890'),
    (18, 3, '2345678901'),
    (19, 1, '3456789012'),
    (20, 2, '4567890123'),
    (21, 3, '5678901234'),
    (22, 1, '6789012345'),
    (23, 2, '7890123456'),
    (24, 3, '8901234567'),
    (25, 1, '9012345678'),
    (26, 2, '0123456789'),
    (27, 3, '1234567890'),
    (28, 1, '2345678901'),
    (29, 2, '3456789012'),
    (30, 3, '4567890123');

INSERT INTO acheter (
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
    (15, 4, 7, '2023-11-16 22:30:00'),
    (4, 6, 7, '2023-11-18 11:00:00'),
    (4, 6, 5, '2023-11-20 13:45:00'),
    (5, 3, 4, '2023-11-19 10:30:00'),
    (5, 3, 6, '2023-11-22 17:15:00'),
    (6, 7, 8, '2023-11-23 09:00:00'),
    (7, 5, 5, '2023-11-24 10:30:00'),
    (8, 1, 3, '2023-11-25 12:00:00'),
    (9, 2, 7, '2023-11-26 14:15:00'),
    (10, 8, 4, '2023-11-27 16:30:00'),
    (11, 3, 6, '2023-11-28 18:45:00'),
    (12, 6, 2, '2023-11-29 20:00:00'),
    (13, 7, 9, '2023-11-30 09:30:00'),
    (14, 4, 5, '2023-12-01 11:45:00'),
    (15, 5, 3, '2023-12-02 13:00:00');

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
    ('ABC345'),
    ('ACD835');

INSERT INTO
    Deplacement (date_heure_collecte, imatriculation_camionette)
VALUES
    ('2023-11-15 14:00:00', 'JKL321'),
    ('2023-11-15 15:30:00', 'PQR789'),
    ('2023-11-15 16:45:00', 'RST456'),
    ('2023-11-15 18:15:00', 'ACD835'),
    ('2023-11-15 19:30:00', 'MNO456'),
    ('2023-11-15 21:00:00', 'STU012'),
    ('2023-11-16 08:00:00', 'EFG234'),
    ('2023-11-16 09:30:00', 'BCD901'),
    ('2023-11-16 10:45:00', 'YZA678'),
    ('2023-11-16 12:15:00', 'VWX345'),
    ('2023-11-16 13:30:00', 'HIJ567'),
    ('2023-11-16 15:00:00', 'OPQ123'),
    ('2023-11-16 16:15:00', 'LMN890'),
    ('2023-11-16 17:45:00', 'XYZ012'),
    ('2023-11-16 19:00:00', 'ABC345'),
    ('2023-11-17 08:30:00', 'JKL321'),
    ('2023-11-17 10:00:00', 'PQR789'),
    ('2023-11-17 11:15:00', 'UVW789'),
    ('2023-11-17 12:45:00', 'ACD835'),
    ('2023-11-17 14:00:00', 'MNO456'),
    ('2023-11-17 15:30:00', 'STU012'),
    ('2023-11-17 16:45:00', 'EFG234'),
    ('2023-11-17 18:15:00', 'BCD901'),
    ('2023-11-17 19:30:00', 'YZA678'),
    ('2023-11-18 08:00:00', 'VWX345'),
    ('2023-11-18 09:30:00', 'HIJ567'),
    ('2023-11-18 10:45:00', 'OPQ123'),
    ('2023-11-18 12:15:00', 'LMN890'),
    ('2023-11-18 13:30:00', 'XYZ012'),
    ('2023-11-18 15:00:00', 'ABC345'),
    ('2023-11-18 16:15:00', 'JKL321'),
    ('2023-11-18 17:45:00', 'PQR789'),
    ('2023-11-18 19:00:00', 'RST456'),
    ('2023-11-19 08:30:00', 'ACD835'),
    ('2023-11-19 10:00:00', 'MNO456'),
    ('2023-11-19 11:15:00', 'STU012'),
    ('2023-11-19 12:45:00', 'EFG234'),
    ('2023-11-19 14:00:00', 'BCD901'),
    ('2023-11-19 15:30:00', 'YZA678'),
    ('2023-11-19 16:45:00', 'VWX345');

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
    (4, 4, 12.50),
    (5, 5, 11.00),
    (6, 6, 20.00),
    (7, 7, 5.00),
    (8, 8, 7.50),
    (9, 1, 14.00),
    (10, 2, 10.00),
    (11, 3, 6.00),
    (12, 4, 8.75),
    (13, 5, 9.50),
    (14, 6, 18.00),
    (15, 7, 3.00),
    (16, 8, 5.25),
    (17, 1, 18.00),
    (18, 2, 22.00),
    (19, 3, 14.00),
    (20, 4, 20.00),
    (21, 5, 25.00),
    (22, 6, 19.00),
    (23, 7, 10.00),
    (24, 8, 12.50),
    (25, 1, 16.00),
    (26, 2, 18.00),
    (27, 3, 11.00),
    (28, 4, 15.00),
    (29, 5, 21.00),
    (30, 6, 17.00),
    (31, 7, 8.00),
    (32, 8, 10.00),
    (33, 1, 20.00),
    (34, 2, 25.00),
    (35, 3, 16.00),
    (36, 4, 22.00),
    (37, 5, 28.00),
    (38, 6, 23.00),
    (39, 7, 12.00),
    (40, 8, 15.00);

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
