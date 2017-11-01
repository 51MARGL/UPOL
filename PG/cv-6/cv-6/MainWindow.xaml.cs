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

namespace cv_6
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        ColorQuantization bmHandler;
        Bitmap sourceImage;
        Bitmap fixedImage;
        Bitmap adaptiveImage;

        public MainWindow()
        {
            InitializeComponent();
            bmHandler = new ColorQuantization();
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

        private void OpenFileBtn_Click(object sender, RoutedEventArgs e)
        {

            try
            {
                string filePath = OpenImageDialog();
                sourceImage = new Bitmap(filePath);
                LoadImage(sourceImage, SourceImage);
                Parallel.Invoke(
                    () => ProcessFixedImage(),
                    () => ProcessAdaptiveImage()
                    );
                LoadImage(adaptiveImage, AdaptivePaletteImage);
                LoadImage(fixedImage, FixedPaletteImage);
            }
            catch (Exception exc)
            {
                MessageBoxResult res = MessageBox.Show(exc.Message, "Image Processing Error", MessageBoxButton.OK);
            }
        }

        private void ProcessAdaptiveImage()
        {
            bmHandler.CreateAdaptivePallete(sourceImage);
            File.WriteAllBytes("indexedAdaptive.kek", bmHandler.ConvertWithPalette(sourceImage, bmHandler.adaptivePalette, true));
            adaptiveImage = bmHandler.ReadFromAdaptive(File.ReadAllBytes("indexedAdaptive.kek"));
        }

        private void ProcessFixedImage()
        {
            File.WriteAllBytes("indexedFixed.lol", bmHandler.ConvertWithPalette(sourceImage, bmHandler.fixedPalette));
            fixedImage = bmHandler.ReadFromFixed(File.ReadAllBytes("indexedFixed.lol"));
        }

        private byte[] ToByteArray(Bitmap image, ImageFormat format)
        {
            using (MemoryStream ms = new MemoryStream())
            {
                image.Save(ms, format);
                return ms.ToArray();
            }
        }


        private void SaveFixedBtn_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(fixedImage);
        }

        private void SaveAdaptiveBtn_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(adaptiveImage);
        }
    }
}
