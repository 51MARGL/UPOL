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
using System.Windows.Navigation;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Windows.Media.Imaging;

namespace cv_4
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private Bitmap firstImage;
        private Bitmap sourceImage;
        public MainWindow()
        {
            InitializeComponent();
        }

        private void LoadImage()
        {
            try
            {
                MemoryStream ms = new MemoryStream();
                sourceImage.Save(ms, System.Drawing.Imaging.ImageFormat.Bmp);
                BitmapImage image = new BitmapImage();
                image.BeginInit();
                ms.Seek(0, SeekOrigin.Begin);
                image.StreamSource = ms;
                image.EndInit();

                ResImage.Source = image;
            }
            catch (Exception exc)
            {
                MessageBoxResult res = MessageBox.Show(exc.Message, "Image Load Error", MessageBoxButton.OK);
            }
        }

        private void CreateGreyBitmap(string SWaverage = "S")
        {
            var rect = new Rectangle(0, 0, firstImage.Width, firstImage.Height);
            BitmapData data = firstImage.LockBits(rect, ImageLockMode.ReadOnly, firstImage.PixelFormat);

            var greyBitmap = new Bitmap(data.Width, data.Height, System.Drawing.Imaging.PixelFormat.Format32bppRgb);

            for (int y = 0; y < data.Height; y++)
            {
                for (int x = 0; x < data.Width; x++)
                {
                    Color PixelColor = Color.FromArgb(System.Runtime.InteropServices.Marshal.ReadInt32(data.Scan0, (data.Stride * y) + (3 * x)));
                    int avg;
                    if (SWaverage == "S")
                    {
                        avg = GetSimpleAverageRGB(PixelColor.R, PixelColor.G, PixelColor.B);
                    }
                    else
                    {
                        avg = GetWeightedAverageRGB(PixelColor.R, PixelColor.G, PixelColor.B);
                    }
                    avg = avg > 255 ? 255 : avg;
                    greyBitmap.SetPixel(x, y, Color.FromArgb(avg, avg, avg));
                }
            }
            firstImage.UnlockBits(data);
            sourceImage = greyBitmap;
            LoadImage();
        }

        private int GetSimpleAverageRGB(int r, int g, int b)
        {
            return (r + g + b) / 3;
        }
        private int GetWeightedAverageRGB(int r, int g, int b)
        {
            return (int)(Rslider.Value * r + Gslider.Value * g + Bslider.Value * b);
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
                    firstImage = new Bitmap(SelectedFileTextBox.Text);
                    sourceImage = new Bitmap(firstImage);
                    LoadImage();
                    CreateGreyBitmap();
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
            CreateGreyBitmap("S");
            LoadImage();
        }

        private void WeightedAverageRadioBtn_Checked(object sender, RoutedEventArgs e)
        {
            WeightedAverageGroupBox.IsEnabled = true;
            CreateGreyBitmap("W");
            LoadImage();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            SimpleAverageRadioBtn.IsChecked = true;
            WeightedAverageGroupBox.IsEnabled = false;
            SimpleAverageRadioBtn.Checked += SimpleAverageRadioBtn_Checked;
            WeightedAverageRadioBtn.Checked += WeightedAverageRadioBtn_Checked;
        }

        private void RGBtextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (sourceImage == null)
                return;
            CreateGreyBitmap("W");
            LoadImage();
        }
    }
}
