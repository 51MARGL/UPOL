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
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;

namespace cv_7
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public Bitmap grayImageMap;
        public Bitmap simpleImageMap;
        public Bitmap randomImageMap;
        public Bitmap matrixImageMap;

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

                    Bitmap sourceImage = new Bitmap(filePath);
                    dithHandler.ditheringMatrixSize = 16;
                    grayImageMap = dithHandler.ProcessBitmap(sourceImage);
                    var copy1 = new Bitmap(grayImageMap);
                    var copy2 = new Bitmap(grayImageMap);
                    var copy3 = new Bitmap(grayImageMap);
                    Parallel.Invoke(
                            () => simpleImageMap = dithHandler.ProcessBitmap(copy1, "S"),
                            () => randomImageMap = dithHandler.ProcessBitmap(copy2, "R"),
                            () => matrixImageMap = dithHandler.MatrixDithering(copy3)
                            );

                    LoadImage(grayImageMap, SourceImage);
                    LoadImage(simpleImageMap, SimpleImage);
                    LoadImage(randomImageMap, RandomImage);
                    LoadImage(matrixImageMap, MatrixImage);
                    Application.Current.Dispatcher.Invoke(() =>
                    {
                        Mouse.OverrideCursor = null;
                    });
                }
            }
            catch (Exception exc)
            {
                MessageBoxResult res = MessageBox.Show(exc.Message, "Image Processing Error", MessageBoxButton.OK);
            }
        }

        private void LoadImage(Bitmap source, System.Windows.Controls.Image imageControl)
        {
            try
            {
                MemoryStream ms = new MemoryStream();
                source.Save(ms, ImageFormat.Bmp);
                BitmapImage image = new BitmapImage();
                image.BeginInit();
                ms.Seek(0, SeekOrigin.Begin);
                image.StreamSource = ms;
                image.EndInit();

                imageControl.Source = image;
            }
            catch (Exception exc)
            {
                MessageBoxResult res = MessageBox.Show(exc.Message, "Image Load Error", MessageBoxButton.OK);
            }
        }

        private string OpenImageDialog()
        {
            Microsoft.Win32.OpenFileDialog dlg = new Microsoft.Win32.OpenFileDialog();
            var result = dlg.ShowDialog();
            if (result == true)
            {
                return dlg.FileName;
            }
            else
            {
                return "";
            }
        }

        private void SaveImageDialog(Bitmap imageToSave)
        {
            try
            {
                Microsoft.Win32.SaveFileDialog sdlg = new Microsoft.Win32.SaveFileDialog();
                sdlg.FileName = "ResImage";
                sdlg.DefaultExt = ".jpg";
                sdlg.Filter = "JPEG (*.jpg)|*.jpg|PNG (*.png)|*.png|BMP (*.bmp)|*.bmp";
                if (sdlg.ShowDialog() == true)
                {
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
            }
            catch (Exception exc)
            {
                MessageBoxResult res = MessageBox.Show(exc.Message, "Save Error", MessageBoxButton.OK);
            }
        }
        
        private byte[] ToByteArray(Bitmap image, ImageFormat format)
        {
            using (MemoryStream ms = new MemoryStream())
            {
                image.Save(ms, format);
                return ms.ToArray();
            }
        }

        private void SaveSource_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(grayImageMap);
        }

        private void SaveSimple_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(simpleImageMap);
        }

        private void SaveRandom_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(randomImageMap);
        }

        private void SaveMatrix_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(matrixImageMap);
        }
    }
}
