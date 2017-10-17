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
        public MainWindow()
        {
            InitializeComponent();
        }

        #region AppLogic
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

        private Bitmap ProcessBitmap(Bitmap defBitmap, string SWaverage = "S")
        {
            Bitmap resBitmap = defBitmap.Clone(new Rectangle(0, 0, defBitmap.Width, defBitmap.Height), defBitmap.PixelFormat);
            Rectangle rect = new Rectangle(0, 0, resBitmap.Width, resBitmap.Height);
            BitmapData bmpData = resBitmap.LockBits(rect, ImageLockMode.ReadWrite, resBitmap.PixelFormat);
            IntPtr ptr = bmpData.Scan0;

            int bytes = Math.Abs(bmpData.Stride) * resBitmap.Height;
            byte[] rgbValues = new byte[bytes];
            System.Runtime.InteropServices.Marshal.Copy(ptr, rgbValues, 0, bytes);

            for (int i = 0; i < rgbValues.Length; i += 3)
            {
                if (SWaverage == "S")
                {
                    byte gray = GetSimpleAverageRGB(rgbValues[i], rgbValues[i + 1], rgbValues[i + 2]);
                    rgbValues[i] = rgbValues[i + 1] = rgbValues[i + 2] = gray;
                }
                else if (SWaverage == "D")
                {
                    byte gray = GetSimpleAverageRGB(rgbValues[i], rgbValues[i + 1], rgbValues[i + 2]);
                    GetDesaturatedRGB(rgbValues, gray, i);
                }
                else if (SWaverage == "W")
                {
                    byte gray = GetWeightedAverageRGB(rgbValues[i], rgbValues[i + 1], rgbValues[i + 2]);
                    rgbValues[i] = rgbValues[i + 1] = rgbValues[i + 2] = gray;
                }
            }
            System.Runtime.InteropServices.Marshal.Copy(rgbValues, 0, ptr, bytes);

            resBitmap.UnlockBits(bmpData);
            return resBitmap;
        }

        private byte GetSimpleAverageRGB(byte r, byte g, byte b)
        {
            return (byte)((r + g + b) / 3);
        }

        private byte GetWeightedAverageRGB(byte r, byte g, byte b)
        {
            return (byte)(Rslider.Value * r + Gslider.Value * g + Bslider.Value * b);
        }

        private void GetDesaturatedRGB(byte[] values, byte gray, int index)
        {
            byte r = values[index];
            byte g = values[index + 1];
            byte b = values[index + 2];
            byte commonCoef = (byte)((1 - Sslider.Value) * gray);
            values[index] = (byte)(commonCoef + Sslider.Value * r);
            values[index + 1] = (byte)(commonCoef + Sslider.Value * g);
            values[index + 2] = (byte)(commonCoef + Sslider.Value * b);
        }

        public byte[] ToByteArray(Bitmap image, ImageFormat format)
        {
            using (MemoryStream ms = new MemoryStream())
            {
                image.Save(ms, format);
                return ms.ToArray();
            }
        }

        private string OpenImageDialog(Bitmap defImage, Bitmap sourceImage)
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
        #endregion AppLogic

        #region GreyScaleTab
        private Bitmap firstImage;
        private Bitmap firstSourceImage;
        private bool sliderDragging = false;

        private void OpenFileBtn_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                SelectedFileTextBox.Text = OpenImageDialog(firstImage, firstSourceImage);
                SelectMethodGroup.IsEnabled = true;
                ImageGroup.IsEnabled = true;
                firstImage = new Bitmap(SelectedFileTextBox.Text);
                firstSourceImage = ProcessBitmap(firstImage, "S");
                LoadImage(firstSourceImage, ResImage);
            }
            catch (Exception exc)
            {
                MessageBoxResult res = MessageBox.Show(exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void SimpleAverageRadioBtn_Checked(object sender, RoutedEventArgs e)
        {
            WeightedAverageGroupBox.IsEnabled = false;
            firstSourceImage = ProcessBitmap(firstImage, "S");
            LoadImage(firstSourceImage, ResImage);
        }

        private void WeightedAverageRadioBtn_Checked(object sender, RoutedEventArgs e)
        {
            WeightedAverageGroupBox.IsEnabled = true;
            firstSourceImage = ProcessBitmap(firstImage, "W");
            LoadImage(firstSourceImage, ResImage);
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            SimpleAverageRadioBtn.IsChecked = true;
            WeightedAverageGroupBox.IsEnabled = false;
            ImageGroup.IsEnabled = false;
            DesaturationGroupBox.IsEnabled = false;
            ImageGroup2.IsEnabled = false;
            SimpleAverageRadioBtn.Checked += SimpleAverageRadioBtn_Checked;
            WeightedAverageRadioBtn.Checked += WeightedAverageRadioBtn_Checked;
        }

        private void RGBtextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (firstSourceImage == null || sliderDragging)
                return;
            firstSourceImage = ProcessBitmap(firstImage, "W");
            LoadImage(firstSourceImage, ResImage);
        }

        private void RGBslider_PreviewMouseDown(object sender, MouseButtonEventArgs e)
        {
            sliderDragging = true;
        }

        private void RGBslider_PreviewMouseUp(object sender, MouseButtonEventArgs e)
        {
            sliderDragging = false;
            firstSourceImage = ProcessBitmap(firstImage, "W");
            LoadImage(firstSourceImage, ResImage);
        }

        private void SaveImageButton_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(firstSourceImage);
        }
        #endregion GreyScaleTab

        #region DesaturationTab        
        private Bitmap secondImage;
        private Bitmap secondSourceImage;
        private bool sliderDragging2 = false;        

        private void OpenFileBtn2_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                SelectedFileTextBox2.Text = OpenImageDialog(secondImage, secondSourceImage);
                DesaturationGroupBox.IsEnabled = true;
                ImageGroup2.IsEnabled = true;
                secondImage = new Bitmap(SelectedFileTextBox2.Text);
                secondSourceImage = ProcessBitmap(secondImage, "D");
                LoadImage(secondSourceImage, ResImage2);
            }
            catch (Exception exc)
            {
                MessageBoxResult res = MessageBox.Show(exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void StextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (secondSourceImage == null || sliderDragging2)
                return;
            secondSourceImage = ProcessBitmap(secondImage, "D");
            LoadImage(secondSourceImage, ResImage2);
        }

        private void Sslider_PreviewMouseUp(object sender, MouseButtonEventArgs e)
        {
            sliderDragging2 = false;
            secondSourceImage = ProcessBitmap(secondImage, "D");
            LoadImage(secondSourceImage, ResImage2);
        }

        private void Sslider_PreviewMouseDown(object sender, MouseButtonEventArgs e)
        {
            sliderDragging2 = true;
        }

        private void SaveImageButton2_Click(object sender, RoutedEventArgs e)
        {
            SaveImageDialog(secondSourceImage);
        }
        #endregion DesaturationTab
    }
}
