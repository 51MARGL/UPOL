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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace cv_4
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

        private void OpenFileBtn_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                Microsoft.Win32.OpenFileDialog dlg = new Microsoft.Win32.OpenFileDialog();
                var result = dlg.ShowDialog();
                if (result == true)
                {
                    string filePath = dlg.FileName;
                    SelectedFileTextBox.Text = filePath;
                    SelectMethodGroup.IsEnabled = true;
                }

            }
            catch (Exception exc)
            {
                MessageBoxResult res = MessageBox.Show(exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void SimpleAverageRadioBtn_Checked(object sender, RoutedEventArgs e)
        {            
            WeightedAverageGroupBox.IsEnabled = false;
        }

        private void WeightedAverageRadioBtn_Checked(object sender, RoutedEventArgs e)
        {
            WeightedAverageGroupBox.IsEnabled = true;
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            SimpleAverageRadioBtn.IsChecked = true;
            SimpleAverageRadioBtn.Checked += SimpleAverageRadioBtn_Checked;
            WeightedAverageRadioBtn.Checked += WeightedAverageRadioBtn_Checked;
        }
    }
}
