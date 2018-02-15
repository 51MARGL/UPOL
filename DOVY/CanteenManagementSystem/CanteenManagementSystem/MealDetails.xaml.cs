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
    /// Interaction logic for MealDetails.xaml
    /// </summary>
    public partial class MealDetails : Window
    {
        private Meal SelectedMeal { get; set; }
        public MealDetails(Meal meal)
        {
            try
            {
                InitializeComponent();
                SelectedMeal = meal;
                MealNameLabel.Content += SelectedMeal.Name;
                MealPriceLabel.Content += SelectedMeal.Price.ToString() + "$";
                FillIngedientTable(SelectedMeal);
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void FillIngedientTable(Meal selectedMeal)
        {
            try
            {
                using (var ctx = new Entities())
                {
                    var query = ctx.MealConsistsOfs.Where(m => m.MealId == selectedMeal.Id).Select(x => new
                    {
                        IngredientName = x.Ingredient.Name,
                        Required = x.AmountRequired,
                        Unit = x.Ingredient.UnitOfMeasure
                    });
                    MealWeightLabel.Content += ctx.MealConsistsOfs.Where(m => m.MealId == selectedMeal.Id && m.Ingredient.UnitOfMeasure == "Kg")
                        .Sum(x => x.AmountRequired).ToString();
                    IngredientsDataGrid.ItemsSource = query.ToList();
                }
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }
    }
}
