using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.IO;
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

namespace cv_6 {
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window {
        public MainWindow() {
            InitializeComponent();
        }

        private void MenuItem_Click(object sender, RoutedEventArgs e) {
            try {
                OpenFileDialog dlg = new OpenFileDialog();
                dlg.DefaultExt = ".xml";
                dlg.Filter = "XML (*.xml)|*.xml|Txt (*.txt)|*.txt|Json (*json)|*.json";
                var result = dlg.ShowDialog();
                if (result == true) {
                    string filePath = dlg.FileName;
                    label.Content = "File Path:" + filePath;
                    string fileContent = File.ReadAllText(filePath);
                    textBox.Text = fileContent;
                    label1.Content = "Symbols: " + fileContent.Length;
                }

            } catch (Exception exc) {
                MessageBoxResult res = MessageBox.Show(exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void MenuItem_Click_1(object sender, RoutedEventArgs e) {
            if (textBox.Text.Length > 0) {
                try {
                    SaveFileDialog sdlg = new SaveFileDialog();
                    sdlg.DefaultExt = ".xml";
                    sdlg.Filter = "XML (*.xml)|*.xml|Txt (*.txt)|*.txt|Json (*json)|*.json";
                    if (sdlg.ShowDialog() == true) {
                        File.WriteAllText(sdlg.FileName, textBox.Text);
                    }
                } catch (Exception exc) {
                    MessageBoxResult res = MessageBox.Show(exc.Message, "Error", MessageBoxButton.OK);
                }
            }
        }

        private void MenuItem_Click_2(object sender, RoutedEventArgs e) {
            if (textBox.Text.Length > 0) {
                MessageBoxResult result = MessageBox.Show("Want to Save?", "Confirming", MessageBoxButton.YesNo, MessageBoxImage.Question);
                if (result == MessageBoxResult.Yes) {
                    try {
                        SaveFileDialog sdlg = new SaveFileDialog();
                        sdlg.DefaultExt = ".xml";
                        sdlg.Filter = "XML (*.xml)|*.xml|Txt (*.txt)|*.txt|Json (*json)|*.json";
                        if (sdlg.ShowDialog() == true)
                            File.WriteAllText(sdlg.FileName, textBox.Text);

                    } catch (Exception exc) {
                        MessageBoxResult res = MessageBox.Show(exc.Message, "Error", MessageBoxButton.OK);
                    }
                } else {
                    Application.Current.Shutdown();
                }            }
        }

        private void textBox_TextChanged(object sender, TextChangedEventArgs e) {
            label1.Content = "Symbols: " + textBox.Text.Length;
        }

        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e) {
            if (textBox.Text.Length > 0) {
                MessageBoxResult result = MessageBox.Show("Want to Save?", "Confirming", MessageBoxButton.YesNo, MessageBoxImage.Question);
                if (result == MessageBoxResult.Yes) {
                    try {
                        SaveFileDialog sdlg = new SaveFileDialog();
                        sdlg.DefaultExt = ".xml";
                        sdlg.Filter = "XML (*.xml)|*.xml|Txt (*.txt)|*.txt|Json (*json)|*.json";
                        if (sdlg.ShowDialog() == true)
                            File.WriteAllText(sdlg.FileName, textBox.Text);

                    } catch (Exception exc) {
                        MessageBoxResult res = MessageBox.Show(exc.Message, "Error", MessageBoxButton.OK);
                    }
                } else {
                    Application.Current.Shutdown();
                }
            }
        }

        private void Window_Closed(object sender, EventArgs e) {

        }
    }
}
