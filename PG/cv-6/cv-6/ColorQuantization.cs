using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;
using System.Drawing.Imaging;

namespace cv_6
{
    class ColorQuantization
    {
        public int[,] fixedPalette; //columns - R G B; raws - index
        public int[,] adaptivePalette;
        private object key = new object();

        public ColorQuantization()
        {
            FillFixedPallete();
        }

        private void FillFixedPallete()
        {
            fixedPalette = new int[256, 3];

            for (int i = 0; i < fixedPalette.GetLength(0); i++)
            {
                fixedPalette[i, 0] = (i >> 5) * 32;
                fixedPalette[i, 1] = ((i >> 2) & 7) * 32;
                fixedPalette[i, 2] = (i & 3) * 64;
            }
        }

        public Bitmap ReadFromFixed(byte[] encodedData)
        {
            int width = BitConverter.ToInt32(encodedData, 0);
            int height = BitConverter.ToInt32(encodedData, 4);

            Bitmap bm = new Bitmap(width, height, PixelFormat.Format32bppRgb);

            for (int y = 0; y < height; y++)
            {
                for (int x = 0; x < width; x++)
                {
                    bm.SetPixel(x, y, Color.FromArgb(fixedPalette[encodedData[y * width + x + 8], 0],
                                                     fixedPalette[encodedData[y * width + x + 8], 1],
                                                     fixedPalette[encodedData[y * width + x + 8], 2]));
                }
            }
            return bm;
        }

        public Bitmap ReadFromAdaptive(byte[] encodedData)
        {
            int width = BitConverter.ToInt32(encodedData, 0);
            int height = BitConverter.ToInt32(encodedData, 4);

            Bitmap bm = new Bitmap(width, height, PixelFormat.Format32bppRgb);
            adaptivePalette = new int[256, 3];
            for (int i = 0; i < 256; i++)
            {
                adaptivePalette[i, 0] = encodedData[i * 3 + 8];
                adaptivePalette[i, 1] = encodedData[i * 3 + 9];
                adaptivePalette[i, 2] = encodedData[i * 3 + 10];
            }

            for (int y = 0; y < height; y++)
            {
                for (int x = 0; x < width; x++)
                {
                    bm.SetPixel(x, y, Color.FromArgb(adaptivePalette[encodedData[y * width + x + (256 * 3 + 8)], 0],
                                                     adaptivePalette[encodedData[y * width + x + (256 * 3 + 8)], 1],
                                                     adaptivePalette[encodedData[y * width + x + (256 * 3 + 8)], 2]));
                }
            }
            return bm;
        }

        public byte[] ConvertWithPalette(Bitmap bitmap, int[,] palette, bool writePalette = false)
        {
            List<byte> resultByteList = new List<byte>();
            int bmWidth, bmHeight;
            lock (key)
            {
                bmWidth = bitmap.Width;
                bmHeight = bitmap.Height; 
            }
            var rect = new Rectangle(0, 0, bmWidth, bmHeight);
            resultByteList.AddRange(BitConverter.GetBytes(bmWidth));
            resultByteList.AddRange(BitConverter.GetBytes(bmHeight));

            if (writePalette)
            {
                for (int i = 0; i < palette.GetLength(0); i++)
                {
                    resultByteList.Add((byte)palette[i, 0]);
                    resultByteList.Add((byte)palette[i, 1]);
                    resultByteList.Add((byte)palette[i, 2]);
                }
            }

            for (int y = 0; y < bmHeight; y++)
            {
                for (int x = 0; x < bmWidth; x++)
                {
                    Color pixel;
                    lock (key)
                    {
                        pixel = bitmap.GetPixel(x, y); 
                    }

                    int leastDistance = int.MaxValue;
                    int red = pixel.R;
                    int green = pixel.G;
                    int blue = pixel.B;
                    byte? colorIndex = null;

                    for (int index = 0; index < palette.GetLength(0); index++)
                    {
                        int paletteColorR = palette[index, 0];
                        int paletteColorG = palette[index, 1];
                        int paletteColorB = palette[index, 2];

                        int redDistance = paletteColorR - red;
                        int greenDistance = paletteColorG - green;
                        int blueDistance = paletteColorB - blue;

                        int distance = (redDistance * redDistance) +
                                            (greenDistance * greenDistance) +
                                            (blueDistance * blueDistance);

                        if (distance < leastDistance)
                        {
                            colorIndex = (byte)index;
                            leastDistance = distance;

                            if (0 == distance)
                                break;
                        }
                    }

                    resultByteList.Add(colorIndex ?? 0);
                }
            }
            return resultByteList.ToArray();
        }

        public int[,] CreateAdaptivePallete(Bitmap bitmap)
        {
            adaptivePalette = new int[256, 3];
            Bucket mainBucket = new Bucket();
            int bmWidth, bmHeight;
            lock (key)
            {
                bmWidth = bitmap.Width;
                bmHeight = bitmap.Height;
            }
            for (int y = 0; y < bmHeight; y++)
            {
                for (int x = 0; x < bmWidth; x++)
                {
                    Color pixel;
                    lock (key)
                    {
                        pixel = bitmap.GetPixel(x, y);
                    }
                    mainBucket.colorList.Add(pixel);
                }
            }

            List<Bucket> bucketList = ProcessBucket(new List<Bucket> { mainBucket });

            int paletteIndex = 0;
            if (bucketList.Count > 0)
            {
                foreach (var bckt in bucketList)
                {
                    int averageR, averageG, averageB;
                    averageR = averageG = averageB = 0;
                    foreach (var color in bckt.colorList)
                    {
                        averageR += color.R;
                        averageG += color.G;
                        averageB += color.B;
                    }
                    averageR /= bckt.colorList.Count;
                    averageG /= bckt.colorList.Count;
                    averageB /= bckt.colorList.Count;
                    adaptivePalette[paletteIndex, 0] = averageR;
                    adaptivePalette[paletteIndex, 1] = averageG;
                    adaptivePalette[paletteIndex, 2] = averageB;
                    paletteIndex++;
                }
            }
            return adaptivePalette;
        }

        private List<Bucket> ProcessBucket(List<Bucket> buckets)
        {
            List<Bucket> resultList = new List<Bucket>();
            foreach (var bucket in buckets)
            {
                int minR = int.MaxValue, maxR = 0;
                int minG = int.MaxValue, maxG = 0;
                int minB = int.MaxValue, maxB = 0;
                foreach (var color in bucket.colorList)
                {
                    if (color.R < minR)
                        minR = color.R;
                    if (color.R > maxR)
                        maxR = color.R;

                    if (color.G < minG)
                        minG = color.G;
                    if (color.G > maxG)
                        maxG = color.G;

                    if (color.B < minB)
                        minB = color.B;
                    if (color.B > maxB)
                        maxB = color.B;
                }
                int differenceR = maxR - minR;
                int differenceG = maxG - minG;
                int differenceB = maxB - minB;

                int maxDiff = Math.Max(differenceR, Math.Max(differenceG, differenceB));

                if (maxDiff == differenceR)
                {
                    bucket.colorList.Sort((Color left, Color right) =>
                    {
                        return left.R.CompareTo(right.R);
                    });
                }
                else if (maxDiff == differenceG)
                {
                    bucket.colorList.Sort((Color left, Color right) =>
                    {
                        return left.G.CompareTo(right.G);
                    });
                }
                else if (maxDiff == differenceB)
                {
                    bucket.colorList.Sort((Color left, Color right) =>
                    {
                        return left.B.CompareTo(right.B);
                    });
                }

                int median = bucket.colorList.Count / 2;

                Bucket bucketLeft = new Bucket();
                bucketLeft.colorList = bucket.colorList.GetRange(0, median);
                Bucket bucketRight = new Bucket();
                bucketRight.colorList = bucket.colorList.GetRange(median, median -1);
                
                resultList.Add(bucketLeft);
                resultList.Add(bucketRight);
                if (resultList.Count == 256)
                    break;
            }
            buckets = null;
            if (resultList.Count < 256)
            {
                resultList = ProcessBucket(resultList);
            }
            return resultList;
        }

        private class Bucket
        {
            public List<Color> colorList;

            public Bucket()
            {
                colorList = new List<Color>();
            }
        }
    }
}
