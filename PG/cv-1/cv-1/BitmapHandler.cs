using System;
using OpenTK;
using OpenTK.Graphics;
using OpenTK.Graphics.OpenGL;
using System.Drawing;
using System.Drawing.Imaging;
using System.Windows.Forms;

namespace cv_1 {
    class BitmapHandler : GameWindow {
        private int imageTexture1;
        private int imageTexture2;
        private int imageTexture3;
        private int imageTexture4;
        private Bitmap bitmap1;
        private float inchDiag;
        private string pathToImage;

        public BitmapHandler (float inchDiag, string pathToImage) : base(800, 600, GraphicsMode.Default, "CV-1") {
            this.inchDiag = inchDiag;
            this.pathToImage = pathToImage;
            VSync = VSyncMode.On;
        }

        protected override void OnLoad (EventArgs e) {
            base.OnLoad(e);
            bitmap1 = LoadBitmap(pathToImage);
            imageTexture1 = CreateTexture(bitmap1);
            Bitmap bitmap2 = LoadBitmap(pathToImage, "R");
            imageTexture2 = CreateTexture(bitmap2);
            Bitmap bitmap3 = LoadBitmap(pathToImage, "G");
            imageTexture3 = CreateTexture(bitmap3);
            Bitmap bitmap4 = LoadBitmap(pathToImage, "B");
            imageTexture4 = CreateTexture(bitmap4);
            Console.WriteLine("Image bitmap size: " + bitmap1.Size);
            Console.WriteLine("Monitor PPI: " + GetPPI(inchDiag));
            Console.WriteLine("Image size on screen:"
                + Math.Round(GetImageRealSize(bitmap1, GetPPI(inchDiag)).Item2, 2) + "inches x "
                + Math.Round(GetImageRealSize(bitmap1, GetPPI(inchDiag)).Item1, 2) + "inches");
            Console.WriteLine("Image size on paper (150DPI): " + Math.Round(GetImageRealSize(bitmap1, 150).Item2 * 2.54, 2) + "cm x "
                                                               + Math.Round(GetImageRealSize(bitmap1, 150).Item1 * 2.54, 2) + "cm");
            Console.WriteLine("Image size on paper (300DPI): " + Math.Round(GetImageRealSize(bitmap1, 300).Item2 * 2.54, 2) + "cm x "
                                                               + Math.Round(GetImageRealSize(bitmap1, 300).Item1 * 2.54, 2) + "cm");
            Console.WriteLine("Image size on paper (600DPI): " + Math.Round(GetImageRealSize(bitmap1, 600).Item2 * 2.54, 2) + "cm x "
                                                               + Math.Round(GetImageRealSize(bitmap1, 600).Item1 * 2.54, 2) + "cm");
            Console.WriteLine("Image MPix: " + bitmap1.Height * bitmap1.Width / 1000f / 1000f);
        }

        private Tuple<float, float> GetImageRealSize (Bitmap bitmap, int dpi) {
            return new Tuple<float, float>(bitmap.Height / (float)dpi, bitmap.Width / (float)dpi);
        }

        private int GetPPI (float inches) {
            int pxHeight = SystemInformation.PrimaryMonitorSize.Height;
            int pxWight = SystemInformation.PrimaryMonitorSize.Width;
            return (int)Math.Round(Math.Sqrt(pxHeight * pxHeight + pxWight * pxWight) / inches);
        }

        protected override void OnUpdateFrame (FrameEventArgs e) {
            base.OnUpdateFrame(e);
            GL.Enable(EnableCap.Texture2D);
        }

        private int CreateTexture (Bitmap bitmap) {
            int tex = GL.GenTexture();

            GL.BindTexture(TextureTarget.Texture2D, tex);
            GL.TexParameter(TextureTarget.Texture2D, TextureParameterName.TextureWrapS, (int)TextureWrapMode.Clamp);
            GL.TexParameter(TextureTarget.Texture2D, TextureParameterName.TextureWrapT, (int)TextureWrapMode.Clamp);
            GL.TexParameter(TextureTarget.Texture2D, TextureParameterName.TextureMinFilter, (int)TextureMinFilter.Linear);
            GL.TexParameter(TextureTarget.Texture2D, TextureParameterName.TextureMagFilter, (int)TextureMagFilter.Linear);

            BitmapData data = bitmap.LockBits(new System.Drawing.Rectangle(0, 0, bitmap.Width, bitmap.Height),
                ImageLockMode.ReadOnly, System.Drawing.Imaging.PixelFormat.Format32bppArgb);

            GL.TexImage2D(TextureTarget.Texture2D, 0, PixelInternalFormat.Rgba, data.Width, data.Height, 0,
                OpenTK.Graphics.OpenGL.PixelFormat.Bgra, PixelType.UnsignedByte, data.Scan0);

            bitmap.UnlockBits(data);

            //GL.GenerateMipmap(GenerateMipmapTarget.Texture2D);
            GL.BindTexture(TextureTarget.Texture2D, 0);
            return tex;
        }

        private Bitmap LoadBitmap (string path, string channel = "FULL") {
            int tex = GL.GenTexture();
            Bitmap bitmap = new Bitmap(path);
            var rect = new Rectangle(0, 0, bitmap.Width, bitmap.Height);
            BitmapData data = bitmap.LockBits(rect, ImageLockMode.ReadOnly, bitmap.PixelFormat);

            var channelBitmap = new Bitmap(data.Width, data.Height, System.Drawing.Imaging.PixelFormat.Format32bppRgb);
            switch (channel) {
                case "R":
                    for (int y = 0; y < data.Height; y++) {
                        for (int x = 0; x < data.Width; x++) {
                            Color PixelColor = Color.FromArgb(System.Runtime.InteropServices.Marshal.ReadInt32(data.Scan0, (data.Stride * y) + (3 * x)));
                            if (PixelColor.R > 0 & PixelColor.R <= 255) {
                                channelBitmap.SetPixel(x, y, Color.FromArgb(PixelColor.R, 0, 0));
                            } else {
                                channelBitmap.SetPixel(x, y, Color.FromArgb(0, 0, 0));
                            }
                        }
                    }
                    return channelBitmap;
                case "G":
                    for (int y = 0; y < data.Height; y++) {
                        for (int x = 0; x < data.Width; x++) {
                            Color PixelColor = Color.FromArgb(System.Runtime.InteropServices.Marshal.ReadInt32(data.Scan0, (data.Stride * y) + (3 * x)));
                            if (PixelColor.G > 0 & PixelColor.G <= 255) {
                                channelBitmap.SetPixel(x, y, Color.FromArgb(0, PixelColor.G, 0));
                            } else {
                                channelBitmap.SetPixel(x, y, Color.FromArgb(0, 0, 0));
                            }
                        }
                    }
                    return channelBitmap;
                case "B":
                    for (int y = 0; y < data.Height; y++) {
                        for (int x = 0; x < data.Width; x++) {
                            Color PixelColor = Color.FromArgb(System.Runtime.InteropServices.Marshal.ReadInt32(data.Scan0, (data.Stride * y) + (3 * x)));
                            if (PixelColor.B > 0 & PixelColor.B <= 255) {
                                channelBitmap.SetPixel(x, y, Color.FromArgb(0, 0, PixelColor.B));
                            } else {
                                channelBitmap.SetPixel(x, y, Color.FromArgb(0, 0, 0));
                            }
                        }
                    }
                    return channelBitmap;
                default:
                    bitmap.UnlockBits(data);
                    return bitmap;
            }
        }


        protected override void OnRenderFrame (FrameEventArgs e) {
            base.OnRenderFrame(e);

            // Draw images
            GL.Clear(ClearBufferMask.ColorBufferBit | ClearBufferMask.DepthBufferBit);
            GL.LoadIdentity();

            GL.BindTexture(TextureTarget.Texture2D, imageTexture1);
            GL.Begin(BeginMode.Quads);

            GL.TexCoord2(1, 0);
            GL.Vertex2(0, 0);

            GL.TexCoord2(0, 0);
            GL.Vertex2(-1, 0);

            GL.TexCoord2(0, 1);
            GL.Vertex2(-1, -1);

            GL.TexCoord2(1, 1);
            GL.Vertex2(0, -1);

            GL.End();

            GL.BindTexture(TextureTarget.Texture2D, imageTexture3);
            GL.Begin(BeginMode.Quads);

            GL.TexCoord2(1, 0);
            GL.Vertex2(1, 1);

            GL.TexCoord2(0, 0);
            GL.Vertex2(0, 1);

            GL.TexCoord2(0, 1);
            GL.Vertex2(0, 0);

            GL.TexCoord2(1, 1);
            GL.Vertex2(1, 0);
            GL.End();

            GL.BindTexture(TextureTarget.Texture2D, imageTexture2);
            GL.Begin(BeginMode.Quads);

            GL.TexCoord2(1, 0);
            GL.Vertex2(0, 1);

            GL.TexCoord2(0, 0);
            GL.Vertex2(-1, 1);

            GL.TexCoord2(0, 1);
            GL.Vertex2(-1, 0);

            GL.TexCoord2(1, 1);
            GL.Vertex2(0, 0);
            GL.End();

            GL.BindTexture(TextureTarget.Texture2D, imageTexture4);
            GL.Begin(BeginMode.Quads);

            GL.TexCoord2(1, 0);
            GL.Vertex2(1, 0);

            GL.TexCoord2(0, 0);
            GL.Vertex2(0, 0);

            GL.TexCoord2(0, 1);
            GL.Vertex2(0, -1);

            GL.TexCoord2(1, 1);
            GL.Vertex2(1, -1);
            GL.End();

            GL.BindTexture(TextureTarget.Texture2D, 0);

            SwapBuffers();
        }
    }
}
