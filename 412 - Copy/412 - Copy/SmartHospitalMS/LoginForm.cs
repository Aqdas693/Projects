using System;
using System.Data;
using Microsoft.Data.SqlClient;
using System.Windows.Forms;

namespace SmartHospitalMS
{
    public partial class LoginForm : Form
    {
        private TextBox txtUsername;
        private TextBox txtPassword;
        private ComboBox cmbRole;
        private Button btnLogin;
        private Label lblMessage;

        public LoginForm()
        {
            InitializeComponent();
            SetupForm();
        }

        private void SetupForm()
        {
            this.Text = "MediCare Pro - Login";
            this.Size = new System.Drawing.Size(450, 500);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.FormBorderStyle = FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.BackColor = System.Drawing.Color.FromArgb(240, 240, 240);

            // Card Panel (Shadow simulation)
            Panel cardShadow = new Panel() { 
                Location = new System.Drawing.Point(42, 42), 
                Size = new System.Drawing.Size(350, 380), 
                BackColor = System.Drawing.Color.FromArgb(200, 200, 200) 
            };

            Panel card = new Panel() { 
                Location = new System.Drawing.Point(40, 40), 
                Size = new System.Drawing.Size(350, 380), 
                BackColor = System.Drawing.Color.White 
            };

            // Logo Panel
            Panel pnlLogo = new Panel() {
                Size = new System.Drawing.Size(80, 80),
                Location = new System.Drawing.Point(135, 20),
                BackColor = System.Drawing.Color.FromArgb(27, 94, 32)
            };
            Label lblLogo = new Label() {
                Text = "✚",
                ForeColor = System.Drawing.Color.White,
                Font = new System.Drawing.Font("Segoe UI", 30, System.Drawing.FontStyle.Bold),
                TextAlign = System.Drawing.ContentAlignment.MiddleCenter,
                Dock = DockStyle.Fill
            };
            pnlLogo.Controls.Add(lblLogo);

            Label lblTitle = new Label() { 
                Text = "MediCare Pro Login", 
                Font = new System.Drawing.Font("Segoe UI", 14, System.Drawing.FontStyle.Bold), 
                Location = new System.Drawing.Point(0, 110), 
                Size = new System.Drawing.Size(350, 30), 
                TextAlign = System.Drawing.ContentAlignment.MiddleCenter,
                ForeColor = System.Drawing.Color.FromArgb(33, 33, 33)
            };
            
            Label lblUser = new Label() { 
                Text = "Username", 
                Font = new System.Drawing.Font("Segoe UI", 10),
                Location = new System.Drawing.Point(40, 150), 
                Size = new System.Drawing.Size(270, 20),
                ForeColor = System.Drawing.Color.FromArgb(70, 70, 70)
            };
            txtUsername = new TextBox() { 
                Location = new System.Drawing.Point(40, 175), 
                Size = new System.Drawing.Size(270, 25),
                Font = new System.Drawing.Font("Segoe UI", 10)
            };

            Label lblPass = new Label() { 
                Text = "Password", 
                Font = new System.Drawing.Font("Segoe UI", 10),
                Location = new System.Drawing.Point(40, 210), 
                Size = new System.Drawing.Size(270, 20),
                ForeColor = System.Drawing.Color.FromArgb(70, 70, 70)
            };
            txtPassword = new TextBox() { 
                Location = new System.Drawing.Point(40, 235), 
                Size = new System.Drawing.Size(270, 25), 
                PasswordChar = '*',
                Font = new System.Drawing.Font("Segoe UI", 10)
            };

            Label lblRole = new Label() { 
                Text = "Access Level", 
                Font = new System.Drawing.Font("Segoe UI", 10),
                Location = new System.Drawing.Point(40, 270), 
                Size = new System.Drawing.Size(270, 20),
                ForeColor = System.Drawing.Color.FromArgb(70, 70, 70)
            };
            cmbRole = new ComboBox() { 
                Location = new System.Drawing.Point(40, 295), 
                Size = new System.Drawing.Size(270, 25), 
                DropDownStyle = ComboBoxStyle.DropDownList,
                Font = new System.Drawing.Font("Segoe UI", 10)
            };
            cmbRole.Items.AddRange(new string[] { "Admin", "Doctor", "Receptionist" });
            cmbRole.SelectedIndex = 0;

            btnLogin = new Button() { 
                Text = "LOGIN", 
                Location = new System.Drawing.Point(40, 335), 
                Size = new System.Drawing.Size(270, 40), 
                BackColor = System.Drawing.Color.FromArgb(27, 94, 32), 
                ForeColor = System.Drawing.Color.White,
                FlatStyle = FlatStyle.Flat,
                Font = new System.Drawing.Font("Segoe UI", 10, System.Drawing.FontStyle.Bold)
            };
            btnLogin.FlatAppearance.BorderSize = 0;
            btnLogin.Click += BtnLogin_Click;

            lblMessage = new Label() { 
                Text = "", 
                Location = new System.Drawing.Point(40, 430), 
                Size = new System.Drawing.Size(350, 20), 
                ForeColor = System.Drawing.Color.Red, 
                TextAlign = System.Drawing.ContentAlignment.MiddleCenter,
                Font = new System.Drawing.Font("Segoe UI", 9)
            };

            card.Controls.AddRange(new Control[] { pnlLogo, lblTitle, lblUser, txtUsername, lblPass, txtPassword, lblRole, cmbRole, btnLogin });
            this.Controls.AddRange(new Control[] { card, cardShadow, lblMessage });
        }

        private void InitializeComponent()
        {
            this.SuspendLayout();
            this.ClientSize = new System.Drawing.Size(384, 261);
            this.Name = "LoginForm";
            this.ResumeLayout(false);
        }

        private void BtnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text; 
            string role = cmbRole.SelectedItem.ToString();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "Please enter both username and password.";
                return;
            }

            try
            {
                // Requirement: Hash the input password before checking against the DB
                string hashedPassword = SecurityHelper.HashPassword(password);

                // SQL Query using Parameters to prevent SQL Injection
                string query = "SELECT * FROM Users WHERE Username = @user AND PasswordHash = @pass AND Role = @role";
                SqlParameter[] parameters = {
                    new SqlParameter("@user", username),
                    new SqlParameter("@pass", hashedPassword), // Now comparing against hash
                    new SqlParameter("@role", role)
                };

                DataTable dt = DatabaseHelper.ExecuteQuery(query, parameters);

                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    
                    Session.CurrentUser = new User {
                        ID = Convert.ToInt32(row["UserID"]),
                        Username = row["Username"].ToString(),
                        Role = row["Role"].ToString()
                    };

                    MessageBox.Show($"Welcome {Session.CurrentUser.Username}!", "Login Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    
                    this.Hide();
                    Dashboard dashboard = new Dashboard();
                    dashboard.Show();
                }
                else
                {
                    lblMessage.Text = "Invalid username, password, or role.";
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Security Error: " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}
