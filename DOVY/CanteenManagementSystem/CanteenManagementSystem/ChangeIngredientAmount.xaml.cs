using System;
using System.Collections.Generic;
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
    /// Interaction logic for ChangeIngredientAmount.xaml
    /// </summary>
    public partial class ChangeIngredientAmount : Window
    {
        public ChangeIngredientAmount()
        {
            InitializeComponent();
            using (var ctx = new Entities())
            {
                var query = ctx.Ingredients;
                IngredientList.ItemsSource = query.ToList(); 
            }
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }

        private void OkButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                using (var ctx = new Entities())
                {
                    if (IngredientList.SelectedIndex == -1)
                        throw new Exception("No ingredient selected");
                    var res = double.TryParse(AmountLeftBox.Text, out var newAmount);
                    if (!res || newAmount < 0)
                        throw new Exception("Wrong amount input");
                    
                    var selectedIngr = IngredientList.SelectedItem as Ingredient;                    
                    var war = ctx.Warehouses.First(w =>  w.IngredientId == selectedIngr.Id);

                    war.Amount = newAmount;
                    ctx.SaveChanges();
                    Close();
                }
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void IngredientList_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            using (var ctx = new Entities())
            {
                if (!(IngredientList.SelectedItem is Ingredient selectedIngr))
                    return;

                var amountLeft = ctx.Warehouses.First(w => w.IngredientId == selectedIngr.Id).Amount;
                AmountLeftBox.Text = amountLeft.ToString();
                UnitOfMeasure.Text = selectedIngr.UnitOfMeasure;
            }
        }
    }
}
