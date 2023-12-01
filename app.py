from flask import Flask, render_template, redirect, g
import pymysql.cursors
app = Flask(__name__)


def get_db():
    if 'db' not in g:
        g.db =  pymysql.connect(
            host="localhost",
            user="root",    
            password="",
            database="FripCycle",
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
    sql = '''SELECT c.client_id, c.nom_client, c.adresse_client, c.email_client, c.categorie_id, cc.categorie_id, cc.libelle as categorie_client
            FROM Client c
            JOIN categorie_client cc ON c.categorie_id = cc.categorie_id'''
    cursor.execute(sql)
    clients = cursor.fetchall()
    
    sql = '''SELECT COUNT(c.client_id) as nbr FROM client c;'''
    cursor.execute(sql)
    nbr_client = cursor.fetchone()
    
    return render_template("show_client.html", client=clients, nbr_cli=nbr_client)



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


@app.route("/client/edit/valid", methods=["POST"])
def valid_edit_client():
    return redirect("/client/show")















if __name__ == "__main__":
    app.run(debug=True, port=5000)