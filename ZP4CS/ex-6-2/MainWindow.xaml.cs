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
using System.Xml.Serialization;

namespace cv_6 {
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window {
        public MainWindow () {
            InitializeComponent();


        }

        private void MenuItem_Click (object sender, RoutedEventArgs e) {
            try {
                OpenFileDialog dlg = new OpenFileDialog();
                dlg.DefaultExt = ".xml";
                dlg.Filter = "XML (*.xml)|*.xml";

                var result = dlg.ShowDialog();
                if (result == true) {
                    string filePath = dlg.FileName;
                    string fileContent = File.ReadAllText(filePath);
                    XmlSerializer serializer = new XmlSerializer(typeof(ordered_set));
                    FileStream fileStream = new FileStream(filePath, FileMode.Open);
                    ordered_set resultSet = (ordered_set)serializer.Deserialize(fileStream);

                    int dotSize = 10;
                    TextBlock tb = new TextBlock();
                    tb.Text = "";
                    Canvas1.Children.Add(tb);

                    foreach (var element in resultSet.elements) {

                        Ellipse currentDot = new Ellipse();
                        currentDot.Stroke = new SolidColorBrush(Colors.Purple);
                        currentDot.StrokeThickness = 3;
                        currentDot.Height = dotSize;
                        currentDot.Width = dotSize;
                        currentDot.Fill = new SolidColorBrush(Colors.Purple);
                        Canvas.SetZIndex(currentDot, 1);
                        Canvas.SetLeft(currentDot, element.x);
                        Canvas.SetTop(currentDot, element.y);
                        currentDot.Cursor = Cursors.Hand;

                        currentDot.MouseDown += delegate {
                            Canvas.SetLeft(tb, element.x + 5);
                            Canvas.SetTop(tb, element.y);
                            tb.Text = element.attributes + " |!| " + element.objects;
                        };
                        Canvas1.Children.Add(currentDot);
                    }

                    foreach (var order in resultSet.orders) {
                        int start = order.bigger;
                        int end = order.smaller;
                        Line line = new Line();
                        line.Stroke = Brushes.Red;
                        line.X1 = resultSet.elements.ElementAt(start - 1).x + dotSize/2;
                        line.Y1 = resultSet.elements.ElementAt(start - 1).y + dotSize / 2;
                        line.X2 = resultSet.elements.ElementAt(end - 1).x + dotSize / 2;
                        line.Y2 = resultSet.elements.ElementAt(end - 1).y + dotSize / 2;
                        line.StrokeThickness = 2;
                        Canvas.SetZIndex(line, 0);
                        Canvas1.Children.Add(line);
                    }
                }

            } catch (Exception exc) {
                MessageBoxResult res = MessageBox.Show(exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void MenuItem_Click_1 (object sender, RoutedEventArgs e) {
            try {
                SaveFileDialog sdlg = new SaveFileDialog();
                sdlg.DefaultExt = ".png";
                sdlg.Filter = "PNG (*.png)|*.png";
                if (sdlg.ShowDialog() == true) {
                    RenderTargetBitmap rtb = new RenderTargetBitmap((int)Canvas1.RenderSize.Width, 
                        (int)Canvas1.RenderSize.Height, 96, 96, PixelFormats.Default);
                    rtb.Render(Canvas1);
                    BitmapEncoder encoder = new PngBitmapEncoder();
                    encoder.Frames.Add(BitmapFrame.Create(rtb));
                    using (var fs = File.OpenWrite(sdlg.FileName)) {
                        encoder.Save(fs);
                    }

                }
            } catch (Exception exc) {
                MessageBoxResult res = MessageBox.Show(exc.Message, "Error", MessageBoxButton.OK);
            }
        }
    }
}
