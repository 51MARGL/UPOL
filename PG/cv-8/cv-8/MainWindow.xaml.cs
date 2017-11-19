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
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
using Microsoft.Win32;

namespace cv_8
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
                Dithering dithHandler = new Dithering();                
                string filePath = OpenImageDialog();
                if (!string.IsNullOrWhiteSpace(filePath))
                {
                    Application.Current.Dispatcher.Invoke(() =>
                    {
                        Mouse.OverrideCursor = Cursors.Wait;
                    });

                    var sourceImage = new Bitmap(filePath);
                    
                    var grayMap = dithHandler.SimpleDithering(sourceImage);                  

                    LoadImage(dithHandler.SimpleDithering(grayMap, 1), FloydSteinbergImage);
                    LoadImage(dithHandler.SimpleDithering(grayMap, 2), SierraImage);
                    LoadImage(dithHandler.SimpleDithering(grayMap, 3), JjImage);
                    LoadImage(dithHandler.SimpleDithering(grayMap, 4), StuckiImage);
                    Application.Current.Dispatcher.Invoke(() =>
                    {
                        Mouse.OverrideCursor = null;
                    });
                }
            }
            catch (Exception exc)
            {
                MessageBox.Show(exc.Message, "Image Processing Error", MessageBoxButton.OK);
            }
        }

        private void OpenFileBtn_Click2(object sender, RoutedEventArgs e)
        {
            try
            {
                Palette paletteHandler = new Palette();
                string filePath = OpenImageDialog();
                if (!string.IsNullOrWhiteSpace(filePath))
                {
                    Application.Current.Dispatcher.Invoke(() =>
                    {
                        Mouse.OverrideCursor = Cursors.Wait;
                    });

                    Bitmap sourceImage = new Bitmap(filePath);

                    LoadImage(paletteHandler.CorrectImage(sourceImage), FloydSteinbergImage2);
                    LoadImage(paletteHandler.CorrectImage(sourceImage, 1), SierraImage2);
                    LoadImage(paletteHandler.CorrectImage(sourceImage, 2), JjImage2);
                    LoadImage(paletteHandler.CorrectImage(sourceImage, 3), StuckiImage2);

                    Application.Current.Dispatcher.Invoke(() =>
                    {
                        Mouse.OverrideCursor = null;
                    });
                }
            }
            catch (Exception exc)
            {
                MessageBox.Show(exc.Message, "Image Processing Error", MessageBoxButton.OK);
            }
        }

        private void LoadImage(Bitmap source, System.Windows.Controls.Image imageControl)
        {
            try
            {
                var ms = new MemoryStream();
                source.Save(ms, ImageFormat.Bmp);
                var image = new BitmapImage();
                image.BeginInit();
                ms.Seek(0, SeekOrigin.Begin);
                image.StreamSource = ms;
                image.EndInit();

                imageControl.Source = image;
            }
            catch (Exception exc)
            {
                MessageBox.Show(exc.Message, "Image Load Error", MessageBoxButton.OK);
            }
        }

        private string OpenImageDialog()
        {
            var dlg = new Microsoft.Win32.OpenFileDialog();
            var result = dlg.ShowDialog();
            return result == true ? dlg.FileName : "";
        }

        private void SaveImageDialog(Bitmap imageToSave)
        {
            try
            {
                var sdlg = new Microsoft.Win32.SaveFileDialog
                {
                    FileName = "ResImage",
                    DefaultExt = ".jpg",
                    Filter = "JPEG (*.jpg)|*.jpg|PNG (*.png)|*.png|BMP (*.bmp)|*.bmp"
                };
                if (sdlg.ShowDialog() != true) return;
                ImageFormat format;
                switch (sdlg.Filter)
                {
                    case "JPEG":
                        format = ImageFormat.Jpeg;
                        break;
                    case "PNG":
                        format = ImageFormat.Png;
                        break;
                    case "BMP":
                        format = ImageFormat.Bmp;
                        break;
                    default:
                        format = ImageFormat.Jpeg;
                        break;
                }
                File.WriteAllBytes(sdlg.FileName, ToByteArray(imageToSave, format));
            }
            catch (Exception exc)
            {
                MessageBox.Show(exc.Message, "Save Error", MessageBoxButton.OK);
            }
        }

        private byte[] ToByteArray(Bitmap image, ImageFormat format)
        {
            using (var ms = new MemoryStream())
            {
                image.Save(ms, format);
                return ms.ToArray();
            }
        }

        private Bitmap ImageSourceToBitmap(System.Windows.Controls.Image imageControl)
        {
            Bitmap bmpOut = null;

            using (var ms = new MemoryStream())
            {
                var encoder = new PngBitmapEncoder();
                encoder.Frames.Add(BitmapFrame.Create((BitmapSource)imageControl.Source));
                encoder.Save(ms);

                using (Bitmap bmp = new Bitmap(ms))
                {
                    bmpOut = new Bitmap(bmp);
                }
            }
            return bmpOut;
        }

        private void SaveSource_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(ImageSourceToBitmap(FloydSteinbergImage));
        }

        private void SaveSimple_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(ImageSourceToBitmap(SierraImage));
        }

        private void SaveRandom_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(ImageSourceToBitmap(JjImage));
        }

        private void SaveMatrix_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(ImageSourceToBitmap(StuckiImage));
        }

        private void SaveSource_Click2(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(ImageSourceToBitmap(FloydSteinbergImage2));
        }

        private void SaveSimple_Click2(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(ImageSourceToBitmap(SierraImage2));
        }

        private void SaveRandom_Click2(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(ImageSourceToBitmap(JjImage2));
        }

        private void SaveMatrix_Click2(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(ImageSourceToBitmap(StuckiImage2));
        }
    }
}
