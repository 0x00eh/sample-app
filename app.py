import sqlite3
from flask import Flask, render_template_string, request, redirect, url_for, session

app = Flask(__name__)
app.secret_key = "your_secret_key"

# HTML Templates
login_page = """
<!doctype html>
<html>
<head>
  <title>Login</title>
</head>
<body style="display:flex; justify-content:center; align-items:center; height:100vh; margin:0; background:#f4f6f8; font-family:Arial, sans-serif;">
  <div style="text-align:center; background:white; padding:30px; border-radius:10px; box-shadow:0px 4px 10px rgba(0,0,0,0.1); width:300px;">
    <h2 style="margin-bottom:20px;">Login Page V2</h2>
    <form method="POST">
      <label style="display:block; text-align:left; margin-bottom:5px;">Username:</label>
      <input type="text" name="username" style="width:100%; padding:10px; margin-bottom:15px; border:1px solid #ccc; border-radius:5px;"><br>
      <label style="display:block; text-align:left; margin-bottom:5px;">Password:</label>
      <input type="password" name="password" style="width:100%; padding:10px; margin-bottom:15px; border:1px solid #ccc; border-radius:5px;"><br>
      <button type="submit" style="width:100%; padding:10px; background:#007BFF; color:white; border:none; border-radius:5px; cursor:pointer;">Login</button>
    </form>
  </div>
</body>
</html>
"""

dashboard_page = """
<!doctype html>
<!doctype html>
<html>
<head>
  <title>Dashboard</title>
</head>
<body style="display:flex; justify-content:center; align-items:center; height:100vh; margin:0; background:#eef2f5; font-family:Arial, sans-serif;">
  <div style="text-align:center; background:white; padding:40px; border-radius:10px; box-shadow:0px 4px 10px rgba(0,0,0,0.1); width:400px;">
    <h2 style="margin-bottom:20px;">Welcome to Dashboard</h2>
    <p style="margin-bottom:20px;">You are logged in as {{ user }}</p>
    <a href="{{ url_for('logout') }}" style="display:inline-block; padding:10px 20px; background:#dc3545; color:white; text-decoration:none; border-radius:5px;">Logout</a>
  </div>
</body>
</html>`
"""

# ---------------- Database Setup ----------------
def init_db():
    conn = sqlite3.connect("users.db")
    c = conn.cursor()
    c.execute("""CREATE TABLE IF NOT EXISTS users (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    username TEXT UNIQUE NOT NULL,
                    password TEXT NOT NULL
                )""")
    c.execute("SELECT * FROM users WHERE username=?", ("admin",))
    if not c.fetchone():
        c.execute("INSERT INTO users (username, password) VALUES (?, ?)", ("admin", "1234"))
    conn.commit()
    conn.close()

# ---------------- Routes ----------------
@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        user = request.form["username"]
        pw = request.form["password"]
        conn = sqlite3.connect("users.db")
        c = conn.cursor()
        c.execute("SELECT * FROM users WHERE username=? AND password=?", (user, pw))
        result = c.fetchone()
        conn.close()
        if result:
            session["user"] = user
            return redirect(url_for("dashboard"))
        else:
            return "Invalid username or password. <a href='/login'>Try again</a>"
    return render_template_string(login_page)

@app.route("/dashboard")
def dashboard():
    if "user" in session:
        return render_template_string(dashboard_page, user=session["user"])
    return redirect(url_for("login"))

@app.route("/logout")
def logout():
    session.pop("user", None)
    return redirect(url_for("login"))

@app.route("/")
def index():
    return "Flask app is running!", 200

@app.route("/health")
def health():
    return "ok", 200

# ---------------- Main ----------------
if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=5000, debug=True)
