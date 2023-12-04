from flask import Flask, render_template, redirect, request, session, g
import pymysql.cursors
app = Flask(__name__)
app.secret_key = "azerty123"


def get_db():
    if 'db' not in g:
        g.db = pymysql.connect(
            host="serveurmysql",
            user="aimmer",
            password="1608",
            database="BDD_aimmer",
            charset='utf8mb4',
            cursorclass=pymysql.cursors.DictCursor
        )
    return g.db


@app.teardown_appcontext
def teardown_db(exception):
    db = g.pop('db', None)
    if db is not None:
        db.close()


@app.route("/")
def home():
    cursor = get_db().cursor()
    sql = "SELECT * FROM Type_vetement"
    cursor.execute(sql)
    type_vetement = cursor.fetchall()
    return render_template("home.html", type=type_vetement)


# ----------------------------------------------------
# -------------------- Client ------------------------
# ----------------------------------------------------


@app.route("/client/show", methods=["GET"])
def show_client():
    cursor = get_db().cursor()
    sql = ''' SELECT 
                c.client_id, 
                c.nom_client, 
                c.age_client, 
                c.adresse_client, 
                c.email_client, 
                c.categorie_id, 
                cc.categorie_id, 
                cc.libelle AS categorie_client, 
                p.numero_telephone, 
                tt.libelle_type_telephone AS libelle_type_telephone
            FROM Client c
            JOIN Categorie_client cc ON c.categorie_id = cc.categorie_id
            LEFT JOIN possede p ON c.client_id = p.client_id
            LEFT JOIN Type_telephone tt ON p.id_type_telephone = tt.id_type_telephone
            ORDER BY c.client_id '''
    cursor.execute(sql)
    clients = cursor.fetchall()

    return render_template("show_client.html", client=clients)


@app.route("/client/add", methods=["GET"])
def client_add():
    cursor = get_db().cursor()
    sql = ''' SELECT cc.categorie_id, cc.libelle
            FROM Categorie_client cc'''
    cursor.execute(sql)
    categorie_client = cursor.fetchall()

    sql = ''' SELECT tt.id_type_telephone as id, tt.libelle_type_telephone as libelle 
            FROM Type_telephone tt '''
    cursor.execute(sql)
    telephones = cursor.fetchall()

    return render_template("add_client.html", categories=categorie_client, tel=telephones)


@app.route("/client/add", methods=["POST"])
def client_add_valid():
    if request.method == "POST":
        form = request.form
        nom = form.get("nom_client")
        age = form.get("age_client")
        adresse = form.get("adresse_client")
        email = form.get("email_client")
        categorie = form.get("categorie_id")
        id_type_telephone = form.get("id_type_telephone")
        numero_telephone = form.get("numero_telephone")

        cursor = get_db().cursor()
        sql = '''INSERT INTO Client(nom_client, age_client, adresse_client, email_client, categorie_id)
                            VALUES (%s, %s, %s, %s, %s)'''
        cursor.execute(sql, (nom, age, adresse, email, categorie))
        get_db().commit()

        last_client_id = cursor.lastrowid

        sql = '''INSERT INTO possede(client_id, id_type_telephone, numero_telephone)
                                VALUES (%s, %s, %s)'''
        cursor.execute(sql, (last_client_id, id_type_telephone, numero_telephone))
        get_db().commit()

    return redirect("/client/show")


@app.route("/client/edit/<id>", methods=["GET"])
def edit_client(id):
    cursor = get_db().cursor()

    sql_client = '''SELECT c.*, 
                    cc.categorie_id, cc.libelle AS categorie_libelle,
                    tt.id_type_telephone, tt.libelle_type_telephone AS libelle_type_tel,
                    p.numero_telephone as num_tel
            FROM Client c
            LEFT JOIN Categorie_client cc ON c.categorie_id = cc.categorie_id
            LEFT JOIN possede p ON c.client_id = p.client_id
            LEFT JOIN Type_telephone tt ON p.id_type_telephone = tt.id_type_telephone
            WHERE c.client_id = %s'''
    cursor.execute(sql_client, (id,))
    client_data = cursor.fetchone()

    sql_categories = '''SELECT categorie_id, libelle FROM Categorie_client'''
    cursor.execute(sql_categories)
    categories = cursor.fetchall()

    sql_telephone = '''SELECT id_type_telephone, libelle_type_telephone FROM Type_telephone'''
    cursor.execute(sql_telephone)
    telephones = cursor.fetchall()

    if client_data:
        client_info = {
            "client_id": client_data.get("client_id"),
            "nom_client": client_data.get("nom_client"),
            "age_client": client_data.get("age_client"),
            "adresse_client": client_data.get("adresse_client"),
            "email_client": client_data.get("email_client"),
            "numero_client": client_data.get("num_tel"),
            "categorie_id": client_data.get("categorie_id"),
            "categorie_libelle": client_data.get("categorie_libelle"),
            "type_telephone": []
        }

        if client_data.get("id_type_telephone"):
            client_info["type_telephone"].append({
                "id_type_telephone": client_data.get("id_type_telephone"),
                "libelle_type_telephone": client_data.get("libelle_type_telephone")
            })

    else:
        client_info = {}

    return render_template("edit_client.html", client=client_info, categories=categories, telephones=telephones)


@app.route("/client/edit", methods=["POST"])
def client_edit_valid():
    if request.method == "POST":
        form = request.form
        id_client = form.get("id_client")
        nom_client = form.get("nom_client")
        age_client = form.get("age_client")
        adresse_client = form.get("adresse_client")
        email_client = form.get("email_client")
        numero_telephone = form.get("numero_telephone")
        categorie_id = form.get("categorie_id")
        id_type_telephone = form.get("id_type_telephone")

        cursor = get_db().cursor()
        sql = '''UPDATE Client 
                            SET nom_client = %s, age_client = %s, adresse_client = %s, email_client = %s, categorie_id = %s 
                            WHERE client_id = %s'''
        cursor.execute(sql, (nom_client, age_client, adresse_client, email_client, categorie_id, id_client))

        sql = ''' UPDATE possede 
                        SET id_type_telephone = %s, numero_telephone = %s  
                        WHERE client_id = %s '''
        cursor.execute(sql, (id_type_telephone, numero_telephone, id_client))
        get_db().commit()

    return redirect("/client/show")


@app.route("/client/delete/<id>")
def client_delete(id):

    referrer = request.referrer
    referrer = referrer.split("/")

    cursor = get_db().cursor()
    sql = ''' SELECT c.categorie_id FROM Client c 
            WHERE c.client_id = %s '''
    cursor.execute(sql, (id,))
    id_categorie = cursor.fetchone()

    sql = ''' DELETE FROM possede p WHERE p.client_id = %s '''
    cursor.execute(sql, (id,))
    get_db().commit()  

    sql = ''' DELETE FROM Client c WHERE c.client_id = %s '''
    cursor.execute(sql, (id,))
    get_db().commit() 
    
    if "deleteCascade" in referrer:
        return redirect(f"/categorie-client/delete/{id_categorie.get('categorie_id')}")
    return redirect("/client/show")


@app.route("/client/deleteCascade/<id>")
def client_delete_cascade(id):

    cursor = get_db().cursor()
    sql = ''' SELECT 
                c.client_id, 
                c.nom_client, 
                c.age_client, 
                c.adresse_client, 
                c.email_client, 
                c.categorie_id, 
                cc.categorie_id, 
                cc.libelle AS categorie_client, 
                p.numero_telephone, 
                tt.libelle_type_telephone AS libelle_type_telephone
            FROM Client c
            JOIN Categorie_client cc ON c.categorie_id = cc.categorie_id
            LEFT JOIN possede p ON c.client_id = p.client_id
            LEFT JOIN Type_telephone tt ON p.id_type_telephone = tt.id_type_telephone
            WHERE c.categorie_id = %s
            ORDER BY c.client_id '''
    cursor.execute(sql, (id,))
    clients = cursor.fetchall()
    
    return render_template("delete_cascade_client.html", client=clients)


# ----------------------------------------------------
# ------------------ Etat client ---------------------
# ----------------------------------------------------

import random

@app.route("/client/etat", methods=["GET"])
def client_show_etat():

    cursor = get_db().cursor()
    sql = '''SELECT cc.categorie_id, cc.libelle, ROUND(AVG(c.age_client)) AS moyenne, cc.poid_necessaire, cc.reduction
            FROM Categorie_client cc
            JOIN Client c ON cc.categorie_id = c.categorie_id
            GROUP BY cc.categorie_id, cc.libelle'''
    cursor.execute(sql)
    moyenne_age = cursor.fetchall()

    libelles = []
    moyennes = []
    couleurs = []

    for dico in moyenne_age:
        libelle = dico.get("libelle")
        moyennes.append(int(dico.get("moyenne")))
        libelles.append(libelle)
        couleur = "#{:06x}".format(random.randint(0, 0xFFFFFF))
        couleurs.append(couleur)

    return render_template("etat_client.html", moyenne_age=moyenne_age, libelles=libelles, moyennes=moyennes, couleurs=couleurs)




@app.route("/client/etat", methods=["POST"])
def client_etat_valid():
    return redirect("/cleint/etat")


# ----------------------------------------------------
# --------------- Catégorie client -------------------
# ----------------------------------------------------

@app.route("/categorie-client/show")
def categorie_client_show():
    cursor = get_db().cursor()
    sql = ''' SELECT cc.categorie_id, cc.libelle, cc.poid_necessaire, cc.reduction, COUNT(c.client_id) AS nombre_client
            FROM Categorie_client cc
            LEFT JOIN Client c ON cc.categorie_id = c.categorie_id
            GROUP BY cc.categorie_id, cc.libelle; '''
    cursor.execute(sql)
    categorie_client = cursor.fetchall()
    return render_template("show_categorie_client.html", categories=categorie_client)


@app.route("/categorie-client/add")
def categorie_client_add():
    return render_template("add_categorie_client.html")

@app.route("/categorie-client/add", methods=["POST"])
def categorie_client_add_valid():
    if request.method == "POST":
        form = request.form
        libelle = form.get("libelle")
        poid_necessaire = form.get("poid_necessaire")
        reduction = form.get("reduction")

        cursor = get_db().cursor()
        sql = ''' INSERT INTO Categorie_client(libelle, poid_necessaire, reduction)
                VALUES (%s, %s, %s) '''
        cursor.execute(sql, (libelle, poid_necessaire, reduction))
        get_db().commit()

    return redirect("/categorie-client/show")


@app.route("/categorie-client/delete/<id>")
def categorie_client_delete(id):

    cursor = get_db().cursor()
    sql = ''' SELECT * FROM Client c
            WHERE c.categorie_id = %s '''
    cursor.execute(sql, (id,))
    client_associer = cursor.fetchone()

    if client_associer:
        return redirect(f"/client/deleteCascade/{id}")
    
    sql = ''' DELETE FROM Categorie_client cc WHERE cc.categorie_id = %s '''
    cursor.execute(sql, (id,))
    get_db().commit()

    return redirect("/categorie-client/show")



# ----------------------------------------------------
# --------------------- Achat ------------------------
# ----------------------------------------------------



@app.route("/client/achat/show")
def client_achat_show():

    cursor = get_db().cursor()
    sql = ''' SELECT c.client_id, c.nom_client, tv.libelle AS libelle_vetement, a.quantiter_achat, tv.prix_kg AS prix_unitaire, a.date_heure_achat
            FROM acheter a
            JOIN Client c ON a.client_id = c.client_id
            JOIN Type_vetement tv ON a.type_vetement_id = tv.type_vetement_id
            ORDER BY c.client_id '''
    cursor.execute(sql)
    achat = cursor.fetchall()

    sql = ''' SELECT c.client_id, c.nom_client, SUM(a.quantiter_achat * tv.prix_kg) AS montant_total_achat
            FROM acheter a
            JOIN Client c ON a.client_id = c.client_id
            JOIN Type_vetement tv ON a.type_vetement_id = tv.type_vetement_id
            GROUP BY c.client_id
            ORDER BY c.client_id; '''
    cursor.execute(sql)
    somme_achat = cursor.fetchall()

    return render_template("etat_achat_client.html", achat=achat, somme_achat=somme_achat)


if __name__ == "__main__":
    app.run(debug=True, port=5000)
