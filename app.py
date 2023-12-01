from flask import Flask, render_template, redirect, request,g
import pymysql.cursors
app = Flask(__name__)


def get_db():
    if 'db' not in g:
        g.db =  pymysql.connect(
            host="localhost",
            user="root",    
            password="",
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
    
    sql = '''SELECT COUNT(c.client_id) as nbr FROM Client c;'''
    cursor.execute(sql)
    nbr_client = cursor.fetchone()
    
    return render_template("show_client.html", client=clients, nbr_cli=nbr_client)


@app.route("/client/add", methods=["GET"])
def client_add():
    cursor = get_db().cursor()
    sql = ''' SELECT cc.categorie_id, cc.libelle
            FROM Categorie_client cc'''
    cursor.execute(sql)
    categorie_client = cursor.fetchall()
         
    return render_template("add_client.html", categories=categorie_client)

@app.route("/client/add", methods=["POST"])
def client_add_valid():
    if request.method == "POST":
        form = request.form
        nom = form.get("nom_client")
        adresse = form.get("adresse_client")
        email = form.get("email_client")
        categorie = form.get("categorie_id")
        tup_edit_client = (nom, adresse, email, categorie)
        
        cursor = get_db().cursor()
        sql = ''' INSERT INTO Client(nom_client, adresse_client, email_client, categorie_id)
                VALUES (%s, %s, %s, %s)'''
        cursor.execute(sql, tup_edit_client)
        get_db().commit()        
    return redirect("/client/show")



@app.route("/client/edit/<id>", methods=["GET"])
def edit_client(id):
    
    cursor = get_db().cursor()
    sql = '''SELECT *
            FROM Client c
            WHERE c.client_id = %s'''
    cursor.execute(sql, (id,))
    clients = cursor.fetchone()
    
    sql = ''' SELECT cc.categorie_id, cc.libelle
            FROM Categorie_client cc'''
    cursor.execute(sql)
    categorie_client = cursor.fetchall()        
    
    return render_template("edit_client.html", client=clients, categories=categorie_client)


@app.route("/client/edit", methods=["POST"])
def client_edit_valid():
    if request.method == "POST":
        form = request.form
        id = form.get("id_client")
        nom = form.get("nom_client")
        adresse = form.get("adresse_client")
        email = form.get("email_client")
        categorie = form.get("categorie_id")
        tup_edit_client = (nom, adresse, email, categorie, id)
        
        cursor = get_db().cursor()
        sql = ''' UPDATE Client c 
                SET c.nom_client = %s, c.adresse_client = %s, c.email_client = %s, c.categorie_id = %s
                WHERE c.client_id = %s '''
        cursor.execute(sql, tup_edit_client)
        get_db().commit()
        
        
        tup_edit_telephone = ()
        
    return redirect("/client/show")

@app.route("/client/delete/<id>")
def client_delete(id):
    cursor = get_db().cursor()
    sql = ''' DELETE FROM Client c WHERE c.client_id = %s '''
    cursor.execute(sql, (id,))
    get_db().commit()
    return redirect("/client/show")



# ----------------------------------------------------
# --------------- Catégorie client -------------------
# ----------------------------------------------------

@app.route("/categorie-client/show")
def categorie_client_show():
    cursor = get_db().cursor()
    sql = ''' SELECT cc.categorie_id, cc.libelle, COUNT(c.client_id) AS nombre_client
            FROM Categorie_client cc
            LEFT JOIN Client c ON cc.categorie_id = c.categorie_id
            GROUP BY cc.categorie_id, cc.libelle; '''
    cursor.execute(sql)
    categorie_client = cursor.fetchall()
    return render_template("show_categorie_client.html", categories=categorie_client)








if __name__ == "__main__":
    app.run(debug=True, port=5000)