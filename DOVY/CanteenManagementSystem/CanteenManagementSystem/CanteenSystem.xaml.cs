using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
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
using System.Data.Entity;
using System.Data.Entity.Core.EntityClient;
using System.Data.Entity.Core.Objects;
using System.Data.Entity.Infrastructure;
using System.Data.Entity.SqlServer;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq.Expressions;
using Calendar = System.Windows.Controls.Calendar;

namespace CanteenManagementSystem
{
    /// <summary>
    /// Interaction logic for CanteenSystem.xaml
    /// </summary>
    public partial class CanteenSystem : Window
    {
        public User CurrentUser { get; set; }

        public CanteenSystem(User user)
        {
            try
            {
                InitializeComponent();
                Calendar.SelectedDate = DateTime.Today;
                CurrentUser = user;
                CurrentLogUser.Content = "Current User: " + CurrentUser.UserName;
                if (CurrentUser.PermissionGroup == "admin")
                {
                    MenuDataGrid.SetValue(Grid.RowSpanProperty, 2);
                    WarehouseDataGrid.SetValue(Grid.RowSpanProperty, 2);
                    RemoveMenuOffer.Visibility = Visibility.Visible;
                    AddMenuOffer.Visibility = Visibility.Visible;
                    ChangeIngAmount.Visibility = Visibility.Visible;
                }
                else
                {
                    MenuDataGrid.SetValue(Grid.RowSpanProperty, 3);
                    WarehouseDataGrid.SetValue(Grid.RowSpanProperty, 3);
                    RemoveMenuOffer.Visibility = Visibility.Collapsed;
                    AddMenuOffer.Visibility = Visibility.Collapsed;
                    ChangeIngAmount.IsEnabled = false;
                    ChangeIngAmount.Visibility = Visibility.Collapsed;
                    WarehouseTab.IsEnabled = false;
                    WarehouseTab.Visibility = Visibility.Collapsed;
                    StatisticsTab.IsEnabled = false;
                    StatisticsTab.Visibility = Visibility.Collapsed;
                }
                FillMealDataGrid(DateTime.Today);
                FillWarehouseDataGrid(new List<Expression<Func<Warehouse, bool>>> { x => true });
                FillOrderDataGrid(new List<Expression<Func<Order, bool>>> { x => true });
            }
            catch (Exception)
            {
                MessageBox.Show("Error occured on initialization.", "Error", MessageBoxButton.OK);
            }
        }

        private void FillMealDataGrid(DateTime dateToShow)
        {
            try
            {
                using (var ctx = new Entities())
                {
                    var query = ctx.MenuViews.Where(x => x.ServeDate.Equals(dateToShow.Date) && x != null);
                    MenuDataGrid.ItemsSource = query.ToList();
                }
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void FillWarehouseDataGrid(List<Expression<Func<Warehouse, bool>>> wrhsWhere)
        {
            try
            {
                using (var ctx = new Entities())
                {
                    if (Calendar.SelectedDate == null)
                        return;

                    var wrhs = ctx.Warehouses;
                    var wrhsList = ctx.Warehouses.ToList();
                    var ingr = ctx.IngredientAmountReqByDates.Where(i => i.ServeDate.Equals(Calendar.SelectedDate.Value));
                    var wrhsIdList = new List<int>();
                    if (wrhsWhere != null)
                    {
                        foreach (var whereLambda in wrhsWhere)
                        {
                            wrhsList = wrhsList.Where(whereLambda.Compile()).ToList();

                            wrhsIdList.RemoveAll(x => true);
                            wrhsList.ForEach(x => wrhsIdList.Add(x.Id));
                        }
                    }

                    var query = from w in wrhs.Where(t => wrhsIdList.Contains(t.Id))
                                join i in ingr
                                on w.IngredientId equals i.IngredientId into wi
                                from x in wi.DefaultIfEmpty()
                                select new
                                {
                                    w.Id,
                                    w.Ingredient.Name,
                                    w.Amount,
                                    RequiredSumAmount = x.RequiredSumAmount ?? 0,
                                    w.Ingredient.UnitOfMeasure
                                };

                    WarehouseDataGrid.ItemsSource = query.ToList();
                }
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void FillOrderDataGrid(List<Expression<Func<Order, bool>>> orderWhere)
        {
            try
            {
                using (var ctx = new Entities())
                {
                    var ordersList = ctx.Orders.ToList();
                    var ordersIdList = new List<int>();
                    if (orderWhere != null)
                    {
                        foreach (var whereLambda in orderWhere)
                        {
                            ordersList = ordersList.Where(whereLambda.Compile()).ToList();

                            ordersIdList.RemoveAll(x => true);
                            ordersList.ForEach(x => ordersIdList.Add(x.Id));
                        }
                    }

                    if (CurrentUser.PermissionGroup == "admin")
                    {
                        var query = ctx.Orders.Where(t => ordersIdList.Contains(t.Id)).Select(o => new
                        {
                            o.Id,
                            o.User.UserName,
                            o.MenuId,
                            MealName = o.Menu.Meal.Name,
                            o.Menu.Meal.Price,
                            OrderDate = o.OrderTime,
                            o.Menu.ServeDate
                        });
                        OrdersDataGrid.ItemsSource = query.ToList();
                        CountTextOrder.Text = "Count: " + query.Count();
                    }
                    else
                    {
                        var query = ctx.Orders.Where(t => ordersIdList.Contains(t.Id) && t.UserId == CurrentUser.Id).Select(o => new
                        {
                            o.Id,
                            o.User.UserName,
                            o.MenuId,
                            MealName = o.Menu.Meal.Name,
                            o.Menu.Meal.Price,
                            OrderDate = o.OrderTime,
                            o.Menu.ServeDate
                        });
                        OrdersDataGrid.ItemsSource = query.ToList();
                        CountTextOrder.Text = "Count: " + query.Count();
                    }
                }
            }
            catch (Exception)
            {
                // ignored
            }
        }
        private void LogoutBtn_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var loginWindow = new MainWindow();
                loginWindow.Show();
                Close();
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void Calendar_SelectedDatesChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                var selectedDate = ((Calendar)sender).SelectedDate;
                if (selectedDate != null)
                {
                    FillMealDataGrid(selectedDate.Value);
                    FillWarehouseDataGrid(new List<Expression<Func<Warehouse, bool>>> { x => true });
                    FillOrderDataGrid(new List<Expression<Func<Order, bool>>> { x => true });
                }
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void BrowseMenuDetails_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var selectedMenu = MenuDataGrid.SelectedItem as MenuView;
                using (var ctx = new Entities())
                {
                    var meal = ctx.Meals.FirstOrDefault(m => m.Id == selectedMenu.MealId);
                    var detailsWindow = new MealDetails(meal);
                    detailsWindow.Show();
                }
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void AddMenuOffer_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (Calendar.SelectedDate == null)
                    return;

                var addMenuDialog = new CreateMenuOffer(Calendar.SelectedDate.Value);
                addMenuDialog.ShowDialog();
                FillMealDataGrid(Calendar.SelectedDate.Value);
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void RemoveMenuOffer_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (MenuDataGrid.SelectedItem == null)
                    return;

                var res = MessageBox.Show("Delete selected menu offer?", "Confirmation",
                    MessageBoxButton.YesNo, MessageBoxImage.Question);
                if (res != MessageBoxResult.Yes)
                    return;

                using (var ctx = new Entities())
                {
                    var selectedMenu = MenuDataGrid.SelectedItem as MenuView;
                    if (selectedMenu != null && selectedMenu.ServeDate.Date.CompareTo(DateTime.Now.Date) < 0)
                        throw new Exception("You can not remove this menu offer. Serving date already expired");

                    var menuItem =
                        ctx.Menus.FirstOrDefault(m => m.Id == selectedMenu.Id);

                    if (menuItem == null || Calendar.SelectedDate == null)
                        return;

                    ctx.Menus.Remove(menuItem);
                    ctx.SaveChanges();
                    FillMealDataGrid(Calendar.SelectedDate.Value);
                    FillOrderDataGrid(new List<Expression<Func<Order, bool>>> { x => true });
                }
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void PlaceMenuOrder_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (MenuDataGrid.SelectedItem == null)
                    return;

                var res = MessageBox.Show("Place new order?", "Confirmation",
                    MessageBoxButton.YesNo, MessageBoxImage.Question);
                if (res != MessageBoxResult.Yes)
                    return;

                using (var ctx = new Entities())
                {
                    if (!(MenuDataGrid.SelectedItem is MenuView selectedMenu))
                        return;

                    CheckOrderConsistence(ctx, selectedMenu);

                    var order = new Order
                    {
                        UserId = CurrentUser.Id,
                        MenuId = selectedMenu.Id,
                        OrderTime = DateTime.Now
                    };

                    ctx.Orders.Add(order);
                    SubIngredientAmountFromWarehouse(ctx, selectedMenu);
                    ctx.SaveChanges();
                    FillOrderDataGrid(new List<Expression<Func<Order, bool>>> { x => true });
                    FillWarehouseDataGrid(new List<Expression<Func<Warehouse, bool>>> { x => true });
                    MessageBox.Show("New order successfully placed", "Success",
                        MessageBoxButton.OK, MessageBoxImage.Information);
                }
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private static void SubIngredientAmountFromWarehouse(Entities ctx, MenuView selectedMenu)
        {
            try
            {
                foreach (var ingredient in ctx.MealConsistsOfs.Where(p => p.MealId == selectedMenu.MealId).Select(x => x.Ingredient))
                {
                    var amountRequired = ctx.MealConsistsOfs
                        .First(p => p.MealId == selectedMenu.MealId && p.IngredientId == ingredient.Id)
                        .AmountRequired;

                    var warehouse = ctx.Warehouses
                        .First(w => w.IngredientId == ingredient.Id);

                    warehouse.Amount -= (double)amountRequired;
                }
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private static void CheckOrderConsistence(Entities ctx, MenuView selectedMenu)
        {
            if (selectedMenu.ServeDate.Date.CompareTo(DateTime.Now.Date) < 0)
                throw new Exception("You can not place order on this menu. Serving date already expired");

            foreach (var ingredient in ctx.MealConsistsOfs.Where(p => p.MealId == selectedMenu.MealId).Select(x => x.Ingredient))
            {
                var amountLeft = ctx.Warehouses
                    .First(w => w.IngredientId == ingredient.Id)
                    .Amount;
                var amountRequired = ctx.MealConsistsOfs
                    .First(p => p.MealId == selectedMenu.MealId && p.IngredientId == ingredient.Id)
                    .AmountRequired;

                if (amountLeft < amountRequired)
                    throw new Exception("There is no " + ingredient.Name + " left on the warehouse");
            }
        }

        private void ChangeIngAmount_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                using (var ctx = new Entities())
                {
                    var changeDialog = new ChangeIngredientAmount();
                    changeDialog.ShowDialog();
                    FillWarehouseDataGrid(new List<Expression<Func<Warehouse, bool>>> { x => true });
                }
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void Filter_TextChanged(object sender, TextChangedEventArgs e)
        {
            try
            {
                var warehouseLambdaList = new List<Expression<Func<Warehouse, bool>>>();
                if (IdFilter.Text != "Id")
                    warehouseLambdaList.Add(x => x.Id.ToString().IndexOf(IdFilter.Text.Trim(), StringComparison.OrdinalIgnoreCase) >= 0);
                if (NameFilter.Text != "Name")
                    warehouseLambdaList.Add(x => x.Ingredient.Name.ToString().IndexOf(NameFilter.Text.Trim(), StringComparison.OrdinalIgnoreCase) >= 0);
                if (AmountFilter.Text != "Amount")
                    warehouseLambdaList.Add(x => x.Amount.ToString().IndexOf(AmountFilter.Text.Trim(), StringComparison.OrdinalIgnoreCase) >= 0);
                if (UnitFilter.Text != "Unit")
                    warehouseLambdaList.Add(x => x.Ingredient.UnitOfMeasure.ToString().IndexOf(UnitFilter.Text.Trim(), StringComparison.OrdinalIgnoreCase) >= 0);

                if (warehouseLambdaList.Any())
                    FillWarehouseDataGrid(warehouseLambdaList);
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                IdFilter.TextChanged += Filter_TextChanged;
                NameFilter.TextChanged += Filter_TextChanged;
                AmountFilter.TextChanged += Filter_TextChanged;
                UnitFilter.TextChanged += Filter_TextChanged;

                using (var ctx = new Entities())
                {
                    var query = ctx.Meals;
                    MealsListFilter.ItemsSource = query.ToList();
                }

                var americanCulture = new CultureInfo("en-US");
                MonthPicker.ItemsSource = americanCulture.DateTimeFormat.MonthNames.Take(12);
                MonthPicker.SelectedIndex = DateTime.Now.Month - 1;
                YearPicker.ItemsSource = Enumerable.Range(2000, 100).ToList();
                YearPicker.SelectedItem = DateTime.Now.Year;
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void ResetFilter_Click(object sender, RoutedEventArgs e)
        {
            IdFilter.Text = "Id";
            NameFilter.Text = "Name";
            AmountFilter.Text = "Amount";
            UnitFilter.Text = "Unit";
            FillWarehouseDataGrid(new List<Expression<Func<Warehouse, bool>>> { x => true });
        }

        private void ResetFilterOrder_Click(object sender, RoutedEventArgs e)
        {
            MealsListFilter.SelectedItem = null;
            DateFromOrder.SelectedDate = null;
            DateTillOrder.SelectedDate = null;
            FillOrderDataGrid(new List<Expression<Func<Order, bool>>> { x => true });
        }

        private void FilterOrderChanged()
        {
            try
            {
                var orderLambdaList = new List<Expression<Func<Order, bool>>>();

                if (MealsListFilter.SelectedItem != null)
                {
                    orderLambdaList.Add(x => x.Menu.Meal.Name == (MealsListFilter.SelectedItem as Meal).Name);
                }

                if (DateFromOrder.SelectedDate != null)
                {
                    orderLambdaList.Add(x => x.Menu.ServeDate >= DateFromOrder.SelectedDate);
                }
                if (DateTillOrder.SelectedDate != null)
                {
                    orderLambdaList.Add(x => x.Menu.ServeDate <= DateTillOrder.SelectedDate);
                }

                FillOrderDataGrid(orderLambdaList);
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void MealsListFilter_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (((ComboBox)sender).SelectedIndex != -1)
                FilterOrderChanged();
        }

        private void DateFromOrder_SelectedDateChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                if (DateTillOrder.SelectedDate < DateFromOrder.SelectedDate)
                    throw new Exception("Date From can not be greater than Date Till");

                FilterOrderChanged();
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void DateTillOrder_SelectedDateChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                if (DateTillOrder.SelectedDate < DateFromOrder.SelectedDate)
                    throw new Exception("Date From can not be greater than Date Till");

                FilterOrderChanged();
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void MonthPicker_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                if (YearPicker?.SelectedItem != null && MonthPicker?.SelectedItem != null)
                {
                    CalculateStatistics();
                }
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void CalculateStatistics()
        {
            using (var ctx = new Entities())
            {
                AverageOrders.Text =
                    ((double)ctx.Orders.Count(x => x.Menu.ServeDate.Month == MonthPicker.SelectedIndex + 1 && x.Menu.ServeDate.Year == (int)YearPicker.SelectedItem) /
                 DateTime.DaysInMonth((int)YearPicker.SelectedItem, MonthPicker.SelectedIndex - 1)).ToString("F");

                var orderPerDay = ctx.Orders.Where(x => x.Menu.ServeDate.Month == MonthPicker.SelectedIndex + 1 && x.Menu.ServeDate.Year == (int)YearPicker.SelectedItem)
                    .GroupBy(x => x.Menu.ServeDate).Select(x => new
                    {
                        Date = x.Key,
                        Total = x.Count()
                    });

                if (orderPerDay.Any())
                {
                    MaxOrdersText.Text =
                                "Count: " + orderPerDay.OrderByDescending(x => x.Total).First().Total.ToString() + "; Date: " +
                                orderPerDay.OrderByDescending(x => x.Total).First().Date.ToString("d");

                    MinOrdersText.Text =
                        "Count: " + orderPerDay.OrderBy(x => x.Total).First().Total.ToString() + "; Date: " +
                        orderPerDay.OrderBy(x => x.Total).First().Date.ToString("d");
                }
                else
                {
                    MaxOrdersText.Text = "0";
                    MinOrdersText.Text = "0";
                }

                var orderDates = ctx.Orders.Select(x => x.Menu.ServeDate);
                var notOrdered = ctx.Menus
                    .Where(x => x.ServeDate.Month == MonthPicker.SelectedIndex + 1 &&
                                x.ServeDate.Year == (int) YearPicker.SelectedItem)
                    .FirstOrDefault(x => !orderDates.Contains(x.ServeDate));
                if (notOrdered != null)
                    NoOrdersText.Text = "Date: " + notOrdered.ServeDate.ToString("d");
                else
                    NoOrdersText.Text = "NaN";
            }
        }        

        private void YearPicker_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                if (YearPicker?.SelectedItem != null && MonthPicker?.SelectedItem != null)
                {
                    CalculateStatistics();
                }
            }
            catch (Exception exc)
            {
                MessageBox.Show("Error occured: " + exc.Message, "Error", MessageBoxButton.OK);
            }
        }
    }
}
