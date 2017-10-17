using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Forms;
using OpenTK;
using OpenTK.Graphics;
using OpenTK.Graphics.OpenGL;
using System.Drawing;

namespace cv_3
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {

        private GLControl glc;
        private bool RGBinput = false;
        private bool CMYKInput = false;
        int R, G, B;
        float C, M, Y, K;

        public MainWindow()
        {
            R = G = B = 0;
            InitializeComponent();
            RGBtoCMYK();
        }

        //CONVER RGB TO CMYK AND SET TEXTBOXES
        private void RGBtoCMYK()
        {
            R = int.Parse(textBoxR.Text == "" ? "0" : textBoxR.Text);
            G = int.Parse(textBoxG.Text == "" ? "0" : textBoxG.Text);
            B = int.Parse(textBoxB.Text == "" ? "0" : textBoxB.Text);
            if (R < 0 || R > 255
                || G < 0 || G > 255
                || B < 0 || B > 255)
            {
                System.Windows.MessageBox.Show("Wrong RGB Input(Range 0-255)", "Warning", MessageBoxButton.OK);
                R = G = B = 0;
                textBoxR.Text = textBoxG.Text = textBoxB.Text = "0";
                return;
            }

            int J = Math.Max(Math.Max(R, G), B);
            if (J == 0)
            {
                C = M = Y = 0;
                K = 1;
            }
            else
            {
                C = 1 - (float)R / J;
                M = 1 - (float)G / J;
                Y = 1 - (float)B / J;
                K = 1 - (float)J / 255;
            }

            textBoxC.Text = Math.Round(C, 3).ToString();
            textBoxM.Text = Math.Round(M, 3).ToString();
            textBoxY.Text = Math.Round(Y, 3).ToString();
            textBoxK.Text = Math.Round(K, 3).ToString();
        }

        //CONVER CMYK TO RGB AND SET TEXTBOXES
        private void CMYKtoRGB()
        {
            C = float.Parse(textBoxC.Text == "" ? "0" : textBoxC.Text);
            M = float.Parse(textBoxM.Text == "" ? "0" : textBoxM.Text);
            Y = float.Parse(textBoxY.Text == "" ? "0" : textBoxY.Text);
            K = float.Parse(textBoxK.Text == "" ? "0" : textBoxK.Text);
            if (C < 0 || C > 1
                || M < 0 || M > 1
                || Y < 0 || Y > 1
                || K < 0 || K > 1)
            {
                System.Windows.MessageBox.Show("Wrong CMYK Input(Range 0-1)", "Warning", MessageBoxButton.OK);
                C = M = Y = 0;
                K = 1;
                textBoxC.Text = textBoxM.Text = textBoxY.Text = "0";
                textBoxC.Text = "1";
                return;
            }

            R = (int)Math.Round(255 * (1 - C) * (1 - K), 0);
            G = (int)Math.Round(255 * (1 - M) * (1 - K), 0);
            B = (int)Math.Round(255 * (1 - Y) * (1 - K), 0);

            textBoxR.Text = R.ToString();
            textBoxG.Text = G.ToString();
            textBoxB.Text = B.ToString();
        }

        //OPEN IMAGE DIALOG
        private void buttonOpen_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                Microsoft.Win32.OpenFileDialog dlg = new Microsoft.Win32.OpenFileDialog();
                var result = dlg.ShowDialog();
                if (result == true)
                {
                    string filePath = dlg.FileName;
                    imageText.Text = filePath;
                }

            }
            catch (Exception exc)
            {
                MessageBoxResult res = System.Windows.MessageBox.Show(exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        //VIEW DISTANCE CALULATION
        private void button_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                Bitmap bitmap = new Bitmap(imageText.Text);
                int dpi = int.Parse(textBoxDPI.Text);
                var resultCM = (int)Math.Round((((double)bitmap.Width / dpi) * 2.54 / 2.0 / Math.Tan((double)bitmap.Width / 60 / 2 * Math.PI / 180.0)));
                MessageBoxResult res = System.Windows.MessageBox.Show("Result: " + resultCM + "cm", "Result", MessageBoxButton.OK);
            }
            catch (Exception exc)
            {
                MessageBoxResult res = System.Windows.MessageBox.Show(exc.Message, "Error", MessageBoxButton.OK);
            }
        }

        private void WindowsFormsHost_Initialized(object sender, EventArgs e)
        {
            glc = new GLControl();
            glc.Load += new EventHandler(glc_Load);
            glc.Paint += new PaintEventHandler(glc_Paint);
            Host.Child = glc;
        }

        //RECTANGLE COLOR REDRAW
        void glc_Paint(object sender, System.Windows.Forms.PaintEventArgs e)
        {
            GL.ClearColor(Color.FromArgb(1, R, G, B));
            GL.Clear(ClearBufferMask.ColorBufferBit | ClearBufferMask.DepthBufferBit);
            glc.SwapBuffers();
        }

        void glc_Load(object sender, EventArgs e)
        {
            GL.ClearColor(Color.FromArgb(1, R, G, B));
        }

        //RGB INPUT
        private void textRGB_Changed(object sender, TextChangedEventArgs e)
        {
            if (!CMYKInput)
            {
                RGBinput = true;
                System.Windows.Controls.TextBox box = sender as System.Windows.Controls.TextBox;
                if (box.Text.Length > 3)
                {
                    System.Windows.MessageBox.Show("Wrong RGB Input(Range 0-255)", "Warning", MessageBoxButton.OK);
                    Dispatcher.BeginInvoke(new Action(() => box.Undo()));
                    return;
                }
                else if (IsLoaded)
                {
                    RGBtoCMYK();
                    glc.Invalidate();
                }
                RGBinput = false;
            }
        }

        //CMYK INPUT
        private void textCMY_Changed(object sender, TextChangedEventArgs e)
        {
            if (!RGBinput)
            {
                CMYKInput = true;
                System.Windows.Controls.TextBox box = sender as System.Windows.Controls.TextBox;
                float res;
                float.TryParse(box.Text, out res);
                if (res < 0 || res > 1)
                {
                    System.Windows.MessageBox.Show("Wrong CMYK Input(Range 0-1)", "Warning", MessageBoxButton.OK);
                    Dispatcher.BeginInvoke(new Action(() => box.Undo()));
                    return;
                }
                else if (IsLoaded)
                {
                    CMYKtoRGB();
                    glc.Invalidate();
                }
                CMYKInput = false;
            }
        }
    }
}
