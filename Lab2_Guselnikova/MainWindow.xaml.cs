using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using Lab2_Guselnikova.Models;
using Microsoft.EntityFrameworkCore;

namespace Lab2_Guselnikova
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void LoginButton_Click(object sender, RoutedEventArgs e)
        {
            string login = LoginTextBox.Text;
            string password = PasswordBox.Password;

            if (string.IsNullOrWhiteSpace(login) ||
                string.IsNullOrWhiteSpace(password))
            {
                MessageBox.Show("Введите логин и пароль.");
                return;
            }

            using (BookContext db = new BookContext())
            {
                var user = db.Users
                    .Include(u => u.Role)
                    .FirstOrDefault(u =>
                        u.Login == login &&
                        u.Password == password);

                if (user == null)
                {
                    MessageBox.Show(
                        "Неверный логин или пароль.",
                        "Ошибка",
                        MessageBoxButton.OK,
                        MessageBoxImage.Error);

                    return;
                }

                if (user.RoleId == 1)
                {
                    AdminWindow adminWindow = new AdminWindow();
                    adminWindow.Show();
                }
                else if (user.RoleId == 2)
                {
                    ManagerWindow managerWindow = new ManagerWindow();
                    managerWindow.Show();
                }
                else if (user.RoleId == 3)
                {
                    ClientWindow clientWindow = new ClientWindow();
                    clientWindow.Show();
                }

                this.Close();
            }
        }
    }
}