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
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;

namespace cv_9
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
                var bmpHandler = new BitmapHandler();
                var filePath = OpenImageDialog();
                if (!string.IsNullOrWhiteSpace(filePath))
                {
                    Application.Current.Dispatcher.Invoke(() =>
                    {
                        Mouse.OverrideCursor = Cursors.Wait;
                    });

                    var sourceImage = new Bitmap(filePath);
                    var grayMap = bmpHandler.CreateGreyScale(sourceImage);

                    LoadImage(bmpHandler.CreateConvolutionBitmap(grayMap, Matrix.ConvolutionH1), ConvolutionImage);
                    LoadImage(bmpHandler.CreateConvolutionBitmap(grayMap, Matrix.ConvolutionH2), ConvolutionImage2);
                    //Pro median da se pouzivat i vetsi matice (treba 9x9)
                    LoadImage(bmpHandler.CreateMedianBitmap(grayMap, 3), MedianImage);
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
                var bmpHandler = new BitmapHandler();
                string filePath = OpenImageDialog();
                if (!string.IsNullOrWhiteSpace(filePath))
                {
                    Application.Current.Dispatcher.Invoke(() =>
                    {
                        Mouse.OverrideCursor = Cursors.Wait;
                    });

                    Bitmap sourceImage = new Bitmap(filePath);
                    var grayMap = bmpHandler.CreateGreyScale(sourceImage);

                    LoadImage(bmpHandler.CreateConvolutionBitmap(grayMap, Matrix.RobertsMatrixH, Matrix.RobertsMatrixV), RobertsImage);
                    LoadImage(bmpHandler.CreateConvolutionBitmap(grayMap, Matrix.SobelMatrixH, Matrix.SobelMatrixV), SobelImage);
                    LoadImage(bmpHandler.CreateConvolutionBitmap(grayMap, Matrix.LaplacianH1), LaplacianImage1);
                    LoadImage(bmpHandler.CreateConvolutionBitmap(grayMap, Matrix.LaplacianH2), LaplacianImage2);

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

        private void SaveMedian_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(ImageSourceToBitmap(MedianImage));
        }

        private void SaveConvolution_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(ImageSourceToBitmap(ConvolutionImage));
        }

        private void SaveConvolution2_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(ImageSourceToBitmap(ConvolutionImage2));
        }

        private void SaveRoberts_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(ImageSourceToBitmap(RobertsImage));
        }

        private void SaveSobel_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(ImageSourceToBitmap(SobelImage));
        }

        private void SaveLaplacian1_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(ImageSourceToBitmap(LaplacianImage1));
        }

        private void SaveLaplacian2_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(ImageSourceToBitmap(LaplacianImage2));
        }
    }
}
