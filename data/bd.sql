CREATE TABLE UTILISATEUR(
    username VARCHAR(32) PRIMARY KEY,
    mdp VARCHAR(100) NOT NULL,
    estadmin BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE REGION(
    coderegion VARCHAR(5) PRIMARY KEY,
    nomregion VARCHAR(32) NOT NULL
);

CREATE TABLE DEPARTEMENT(
    coderegion VARCHAR(5),
    codedepartement VARCHAR(5) PRIMARY KEY,
    nomdepartement VARCHAR(32) NOT NULL,

    FOREIGN KEY (coderegion) REFERENCES REGION (coderegion)
);

CREATE TABLE COMMUNE(
    codedepartement VARCHAR(5),
    codecommune VARCHAR(5) PRIMARY KEY,
    nomcommune VARCHAR(32) NOT NULL,

    FOREIGN KEY (codedepartement) REFERENCES DEPARTEMENT (codedepartement)
);

CREATE TABLE RESTAURANT(
    osmid VARCHAR(40) PRIMARY KEY,
    nomrestaurant VARCHAR(100),
    telephone VARCHAR(32),
    siret VARCHAR(40),
    etoiles SMALLINT CHECK (etoiles >= 0 AND etoiles <=5),
    siteinternet VARCHAR(100),

    codecommune VARCHAR(5),
    
    vegetarien VARCHAR(32),
    vegan VARCHAR(32),
    livraison VARCHAR(32),
    aemporter VARCHAR(32),
    drive VARCHAR(32),
    accessinternet VARCHAR(32),

    capacite INT,

    marque VARCHAR(32),
    operateur VARCHAR(32),
    type VARCHAR(32),
    wikidata VARCHAR(32),
    marquewikidata VARCHAR(32),

    espacefumeur VARCHAR(32),
    fauteuilroulant VARCHAR(32),
    facebook VARCHAR(100),

    longitude VARCHAR(32),
    latitude VARCHAR(32),

    FOREIGN KEY (codecommune) REFERENCES COMMUNE (codecommune)
);

CREATE TABLE HEURE_OUVERTURE(
    osmid VARCHAR(32),
    jourouverture VARCHAR(3) CHECK (jourouverture in ('Mo','Tu','We','Th','Fr','Sa','Su', 'PH')),
    heuredebut TIME,
    heurefin TIME,

    PRIMARY KEY (osmid, jourouverture, heuredebut),
    FOREIGN KEY (osmid) REFERENCES RESTAURANT(osmid)
);

CREATE TABLE CUISINE(
    idcuisine INT PRIMARY KEY,
    nomcuisine VARCHAR(32)
);

CREATE TABLE PROPOSE(
    osmid VARCHAR(32),
    idcuisine INT,

    PRIMARY KEY (osmid, idCuisine),
    FOREIGN KEY (osmid) REFERENCES RESTAURANT(osmid),
    FOREIGN KEY (idCuisine) REFERENCES CUISINE(idCuisine)
);

CREATE TABLE CUISINE_FAVORITES(
    username VARCHAR(32),
    idcuisine INT,

    PRIMARY KEY (username, idcuisine),
    FOREIGN KEY (username) REFERENCES UTILISATEUR(username),
    FOREIGN KEY (idcuisine) REFERENCES CUISINE(idcuisine)
);

CREATE TABLE AVIS(
    username VARCHAR(32),
    osmid VARCHAR(32),
    note SMALLINT CHECK (note <= 0 AND note >= 5),
    commentaire VARCHAR(255),

    PRIMARY KEY (username, osmid),
    FOREIGN KEY (username) REFERENCES UTILISATEUR(username),
    FOREIGN KEY (osmid) REFERENCES RESTAURANT(osmid)
);

CREATE TABLE RESTAURANT_FAVORIS(
    username VARCHAR(32),
    osmid VARCHAR(32),

    PRIMARY KEY (username, osmid),
    FOREIGN KEY (username) REFERENCES UTILISATEUR(username),
    FOREIGN KEY (osmid) REFERENCES RESTAURANT(osmid)
);