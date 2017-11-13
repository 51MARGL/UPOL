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
        public Bitmap GrayImageMap { get; private set; }
        public Bitmap SimpleImageMap { get; set; }
        public Bitmap RandomImageMap { get; set; }
        public Bitmap MatrixImageMap { get; set; }

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
                    GrayImageMap = dithHandler.ProcessBitmap(sourceImage);
                    var copy1 = new Bitmap(GrayImageMap);
                    var copy2 = new Bitmap(GrayImageMap);
                    var copy3 = new Bitmap(GrayImageMap);
                    Parallel.Invoke(
                            () => SimpleImageMap = dithHandler.ProcessBitmap(copy1, "S"),
                            () => RandomImageMap = dithHandler.ProcessBitmap(copy2, "R"),
                            () => MatrixImageMap = dithHandler.MatrixDithering(copy3)
                            );

                    LoadImage(GrayImageMap, SourceImage);
                    LoadImage(SimpleImageMap, SimpleImage);
                    LoadImage(RandomImageMap, RandomImage);
                    LoadImage(MatrixImageMap, MatrixImage);
                    Application.Current.Dispatcher.Invoke(() =>
                    {
                        Mouse.OverrideCursor = null;
                    });
                }
            }
            catch (Exception exc)
            {
                var res = MessageBox.Show(exc.Message, "Image Processing Error", MessageBoxButton.OK);
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
                var res = MessageBox.Show(exc.Message, "Image Load Error", MessageBoxButton.OK);
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
                var res = MessageBox.Show(exc.Message, "Save Error", MessageBoxButton.OK);
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
            SaveImageDialog(GrayImageMap);
        }

        private void SaveSimple_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(SimpleImageMap);
        }

        private void SaveRandom_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(RandomImageMap);
        }

        private void SaveMatrix_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(MatrixImageMap);
        }
    }
}
