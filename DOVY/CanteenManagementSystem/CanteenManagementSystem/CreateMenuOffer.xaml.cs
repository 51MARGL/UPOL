using System;
using System.Data.Entity.Migrations;
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
using System.Windows.Shapes;

namespace CanteenManagementSystem
{
    /// <summary>
    /// Interaction logic for CreateMenuOffer.xaml
    /// </summary>
    public partial class CreateMenuOffer : Window
    {
        public CreateMenuOffer(DateTime date)
        {
            try
            {
                InitializeComponent();
                using (var ctx = new Entities())
                {
                    var query = ctx.Meals;
                    MealsList.ItemsSource = query.ToList();
                    ServingDatePicker.SelectedDate = date;
                }
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

        private void AddButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (ServingDatePicker.SelectedDate == null)
                    throw new Exception("No date selected");
                if (MealsList.SelectedIndex == -1)
                    throw new Exception("No meals selected");

                using (var ctx = new Entities())
                {
                    if (ctx.Menus.Any(m =>
                        m.MealId == (int) MealsList.SelectedValue &&
                        m.ServeDate == ServingDatePicker.SelectedDate.Value))
                        throw new Exception("This meal is already serving at this date");
                    if(ServingDatePicker.SelectedDate < DateTime.Today)
                        throw new Exception("Date Error. Already expired");

                    var selectedMeal = MealsList.SelectedItem as Meal;
                    var newMenu = new Menu
                    {
                        Meal = ctx.Meals.FirstOrDefault(x => x.Id == selectedMeal.Id),
                        ServeDate = ServingDatePicker.SelectedDate.Value
                    };
                    ctx.Menus.Add(newMenu);
                    ctx.SaveChanges();
                }
                this.DialogResult = true;
                this.Close();
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }
    }
}
