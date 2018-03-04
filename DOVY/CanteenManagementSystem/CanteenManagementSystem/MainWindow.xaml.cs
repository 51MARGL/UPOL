using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Data.Entity;
namespace CanteenManagementSystem
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                using (var context = new Entities())
                {
                    var userId = context.Validate_User(UserName.Text, Password.Password).FirstOrDefault();                    
                    switch (userId)
                    {
                        case -1:
                            FailureText.Content = "Username and/or password is incorrect.";
                            break;
                        default:
                            var system = new CanteenSystem(context.Users.FirstOrDefault(u => u.Id == userId));
                            system.Show();
                            this.Close();
                            break;
                    }                                
                }
            }
            catch (Exception)
            {
                FailureText.Content = "Error occured while logging.";
            }
        }
    }
}
