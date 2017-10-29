using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;

namespace cv_5
{
    class RLE
    {
        private struct RleCompressedHeader
        {
            public int Width;

            public int Height;

            public byte[] ToBytes()
            {
                var result = new List<byte>();

                result.AddRange(BitConverter.GetBytes(Width));
                result.AddRange(BitConverter.GetBytes(Height));

                return result.ToArray();
            }
        }

        public Bitmap RunLengthDecodeBitmap(string path)
        {
            byte[] encodedData = File.ReadAllBytes(path);
            int width = BitConverter.ToInt32(encodedData, 0);
            int height = BitConverter.ToInt32(encodedData, 4);
            Console.WriteLine("Wigth: " + width + " Height: " + height);

            List<byte> result = new List<byte>();

            Bitmap bm = new Bitmap(width, height, PixelFormat.Format32bppRgb);
            for (int i = 8; i < encodedData.Length; i += 2)
            {
                int currentRead = encodedData[i];

                int repeat = currentRead;
                while (repeat > 0)
                {
                    repeat--;
                    result.Add(encodedData[i + 1]);
                }

            }

            for (int y = 0; y < height; y++)
            {
                for (int x = 0; x < width; x++)
                {
                    bm.SetPixel(x, y, Color.FromArgb(result.ElementAt(y * width + x),
                                                     result.ElementAt((y * width + x) + height),
                                                     result.ElementAt((y * width + x) + 2 * height)));
                }
            }
            return bm;
        }

        List<byte> result;
        public byte[] Encode(string path)
        {
            result = new List<byte>();
            Bitmap bmp = new Bitmap(path);

            Bitmap R = LoadBitmap(path, "R");
            var resultR = RunLengthEncodeBitmap(R);
            result.Concat(resultR);
            Bitmap G = LoadBitmap(path, "G");
            var resultG = RunLengthEncodeBitmap(G);
            result.Concat(resultG);
            Bitmap B = LoadBitmap(path, "B");
            var resultB = RunLengthEncodeBitmap(B);
            result.Concat(resultB);

            var header = new RleCompressedHeader
            {
                Width = bmp.Width,
                Height = bmp.Height
            };
            var headerBytes = header.ToBytes();
            result.Add(0x00);
            result.Add(0x01);
            return headerBytes.Concat(result).ToArray();
        }

        public unsafe List<byte> RunLengthEncodeBitmap(Bitmap bmp)
        {
            var data = bmp.LockBits(new Rectangle(0, 0, bmp.Width, bmp.Height), ImageLockMode.ReadOnly, PixelFormat.Format8bppIndexed);            

            for (var rowIndex = bmp.Height - 1; rowIndex >= 0; rowIndex--)
            {
                byte? storedPixel = null;
                var curPixelRepititions = 0;
                var imageRow = (byte*)data.Scan0.ToPointer() + (rowIndex * data.Stride);
                for (var pixelIndex = 0; pixelIndex < bmp.Width; pixelIndex++)
                {
                    var curPixel = imageRow[pixelIndex];
                    if (!storedPixel.HasValue)
                    {
                        curPixelRepititions = 1;
                        storedPixel = curPixel;
                    }
                    else if (storedPixel.Value != curPixel || curPixelRepititions == 255)
                    {
                        result.Add(Convert.ToByte(curPixelRepititions));
                        result.Add(storedPixel.Value);
                        curPixelRepititions = 1;
                        storedPixel = curPixel;
                    }
                    else
                    {
                        curPixelRepititions++;
                    }
                }

                if (curPixelRepititions > 0)
                {
                    result.Add(Convert.ToByte(curPixelRepititions));
                    result.Add(storedPixel.Value);
                }
            }

            bmp.UnlockBits(data);

            return result;
        }
        private Bitmap LoadBitmap(string path, string channel = "FULL")
        {
            Bitmap bitmap = new Bitmap(path);
            var rect = new Rectangle(0, 0, bitmap.Width, bitmap.Height);
            BitmapData data = bitmap.LockBits(rect, ImageLockMode.ReadOnly, bitmap.PixelFormat);

            var channelBitmap = new Bitmap(data.Width, data.Height, System.Drawing.Imaging.PixelFormat.Format32bppRgb);
            switch (channel)
            {
                case "R":
                    for (int y = 0; y < data.Height; y++)
                    {
                        for (int x = 0; x < data.Width; x++)
                        {
                            Color PixelColor = Color.FromArgb(System.Runtime.InteropServices.Marshal.ReadInt32(data.Scan0, (data.Stride * y) + (3 * x)));
                            if (PixelColor.R > 0 & PixelColor.R <= 255)
                            {
                                channelBitmap.SetPixel(x, y, Color.FromArgb(PixelColor.R, 0, 0));
                            }
                            else
                            {
                                channelBitmap.SetPixel(x, y, Color.FromArgb(0, 0, 0));
                            }
                        }
                    }
                    return channelBitmap;
                case "G":
                    for (int y = 0; y < data.Height; y++)
                    {
                        for (int x = 0; x < data.Width; x++)
                        {
                            Color PixelColor = Color.FromArgb(System.Runtime.InteropServices.Marshal.ReadInt32(data.Scan0, (data.Stride * y) + (3 * x)));
                            if (PixelColor.G > 0 & PixelColor.G <= 255)
                            {
                                channelBitmap.SetPixel(x, y, Color.FromArgb(0, PixelColor.G, 0));
                            }
                            else
                            {
                                channelBitmap.SetPixel(x, y, Color.FromArgb(0, 0, 0));
                            }
                        }
                    }
                    return channelBitmap;
                case "B":
                    for (int y = 0; y < data.Height; y++)
                    {
                        for (int x = 0; x < data.Width; x++)
                        {
                            Color PixelColor = Color.FromArgb(System.Runtime.InteropServices.Marshal.ReadInt32(data.Scan0, (data.Stride * y) + (3 * x)));
                            if (PixelColor.B > 0 & PixelColor.B <= 255)
                            {
                                channelBitmap.SetPixel(x, y, Color.FromArgb(0, 0, PixelColor.B));
                            }
                            else
                            {
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
    }
}