using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;
using System.Drawing.Imaging;

namespace cv_8
{
    class Palette
    {
        int[,] palette { get; set; }

        public Palette()
        {
            palette = new int[256, 3];
            for (var i = 0; i < 256; i++)
            {
                palette[i, 0] = (i >> 5) * 32;
                palette[i, 1] = ((i >> 2) & 7) * 32;
                palette[i, 2] = (i & 3) * 64;
            }
        }

        public unsafe Bitmap CorrectImage(Bitmap original, int switchAlgorithm = 0)
        {
            var newBitmap = new Bitmap(original.Width, original.Height, PixelFormat.Format24bppRgb);
            var redMatrix = new Matrix(original.Height, original.Width);
            var greenMatrix = new Matrix(original.Height, original.Width);
            var blueMatrix = new Matrix(original.Height, original.Width);
            blueMatrix.FillWithConst(0);
            greenMatrix.FillWithConst(0);
            redMatrix.FillWithConst(0);

            BitmapData originalData = original.LockBits(
               new Rectangle(0, 0, original.Width, original.Height),
               ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);

            BitmapData newData = newBitmap.LockBits(
               new Rectangle(0, 0, original.Width, original.Height),
               ImageLockMode.WriteOnly, PixelFormat.Format24bppRgb);

            int pixelSize = 3;
            for (int y = 0; y < original.Height; y++)
            {
                byte* originalByteData = (byte*)originalData.Scan0 + (y * originalData.Stride);
                byte* newByteData = (byte*)newData.Scan0 + (y * newData.Stride);

                for (int x = 0; x < original.Width; x++)
                {
                    var redColor = originalByteData[x * pixelSize];
                    var greenColor = originalByteData[x * pixelSize + 1];
                    var blueColor = originalByteData[x * pixelSize + 2];

                    redColor += (byte)redMatrix[y, x];
                    greenColor += (byte)greenMatrix[y, x];
                    blueColor += (byte)blueMatrix[y, x];

                    int tableIndex = ((redColor / 32) << 5)
                        | ((greenColor / 32) << 2)
                        | (blueColor / 64);

                    var errorRed = redColor - palette[tableIndex, 0];
                    var errorGreen = greenColor - palette[tableIndex, 1];
                    var errorBlue = blueColor - palette[tableIndex, 2];
                    switch (switchAlgorithm)
                    {
                        case 0:
                            FloydSteinberg(x, y, redMatrix, errorRed, greenMatrix, errorGreen, blueMatrix, errorBlue);
                            break;
                        case 1:
                            SierraAlgorithm(x, y, redMatrix, errorRed, greenMatrix, errorGreen, blueMatrix, errorBlue);
                            break;
                        case 2:
                            JjnAlgorithm(x, y, redMatrix, errorRed, greenMatrix, errorGreen, blueMatrix, errorBlue);
                            break;
                        case 3:
                            StuckiAlgorithm(x, y, redMatrix, errorRed, greenMatrix, errorGreen, blueMatrix, errorBlue);
                            break;
                    }

                    newByteData[x * pixelSize] = redColor;
                    newByteData[x * pixelSize + 1] = greenColor;
                    newByteData[x * pixelSize + 2] = blueColor;
                }
            }
            original.UnlockBits(originalData);
            newBitmap.UnlockBits(newData);

            return newBitmap;
        }

        private void FloydSteinberg(int x, int y, Matrix redMatrix, int errorRed, Matrix greenMatrix, int errorGreen, Matrix blueMatrix, int errorBlue)
        {
            if ((x + 1) < redMatrix.Width)
            {
                redMatrix[y, x + 1] += (int)((7 * errorRed) / 16f);
                greenMatrix[y, x + 1] += (int)((7 * errorGreen) / 16f);
                blueMatrix[y, x + 1] += (int)((7 * errorBlue) / 16f);
            }
            if ((y + 1) < redMatrix.Height)
            {
                if ((x - 1) > 0)
                {
                    redMatrix[y + 1, x - 1] += (int)((3 * errorRed) / 16f);
                    greenMatrix[y + 1, x - 1] += (int)((3 * errorGreen) / 16f);
                    blueMatrix[y + 1, x - 1] += (int)((3 * errorBlue) / 16f);
                }
                redMatrix[y + 1, x] += (int)((5 * errorRed) / 16f);
                greenMatrix[y + 1, x] += (int)((5 * errorGreen) / 16f);
                blueMatrix[y + 1, x] += (int)((5 * errorBlue) / 16f);
                if ((x + 1) < redMatrix.Width)
                {
                    redMatrix[y + 1, x + 1] += (int)(errorRed / 16f);
                    greenMatrix[y + 1, x + 1] += (int)(errorGreen / 16f);
                    blueMatrix[y + 1, x + 1] += (int)(errorBlue / 16f);
                }
            }
        }

        private void SierraAlgorithm(int x, int y, Matrix redMatrix, int errorRed, Matrix greenMatrix, int errorGreen, Matrix blueMatrix, int errorBlue)
        {
            if ((x + 1) < redMatrix.Width)
            {
                redMatrix[y, x + 1] += (int)(errorRed / 2f);
                greenMatrix[y, x + 1] += (int)(errorGreen / 2f);
                blueMatrix[y, x + 1] += (int)(errorBlue / 2f);
            }
            if ((y + 1) < redMatrix.Height)
            {
                if ((x - 1) > 0)
                {
                    redMatrix[y + 1, x - 1] += (int)(errorRed / 4f);
                    greenMatrix[y + 1, x - 1] += (int)(errorGreen / 4f);
                    blueMatrix[y + 1, x - 1] += (int)(errorBlue / 4f);
                }
                redMatrix[y + 1, x] += (int)(errorRed / 4f);
                greenMatrix[y + 1, x] += (int)(errorGreen / 4f);
                blueMatrix[y + 1, x] += (int)(errorBlue / 4f);
            }
        }

        private void JjnAlgorithm(int x, int y, Matrix redMatrix, int errorRed, Matrix greenMatrix, int errorGreen, Matrix blueMatrix, int errorBlue)
        {
            double divider = 48;
            if ((x + 1) < redMatrix.Width)
            {
                redMatrix[y, x + 1] += (int)(errorRed * 7 / divider);
                greenMatrix[y, x + 1] += (int)(errorGreen * 7 / divider);
                blueMatrix[y, x + 1] += (int)(errorBlue * 7 / divider);
            }
            if ((x + 2) < redMatrix.Width)
            {
                redMatrix[y, x + 2] += (int)(errorRed * 5 / divider);
                greenMatrix[y, x + 2] += (int)(errorGreen * 5 / divider);
                blueMatrix[y, x + 2] += (int)(errorBlue * 5 / divider);
            }
            if ((y + 1) < redMatrix.Height)
            {
                if ((x - 2) > 0)
                {
                    redMatrix[y + 1, x - 2] += (int)(errorRed / 16f);
                    greenMatrix[y + 1, x - 2] += (int)(errorGreen / 16f);
                    blueMatrix[y + 1, x - 2] += (int)(errorBlue / 16f);
                }
                if ((x - 1) > 0)
                {
                    redMatrix[y + 1, x - 1] += (int)(errorRed * 5 / divider);
                    greenMatrix[y + 1, x - 1] += (int)(errorGreen * 5 / divider);
                    blueMatrix[y + 1, x - 1] += (int)(errorBlue * 5 / divider);
                }

                redMatrix[y + 1, x] += (int)(errorRed * 7 / divider);
                greenMatrix[y + 1, x] += (int)(errorGreen * 7 / divider);
                blueMatrix[y + 1, x] += (int)(errorBlue * 7 / divider);

                if ((x + 1) < redMatrix.Width)
                {
                    redMatrix[y + 1, x + 1] += (int)(errorRed * 5 / divider);
                    greenMatrix[y + 1, x + 1] += (int)(errorGreen * 5 / divider);
                    blueMatrix[y + 1, x + 1] += (int)(errorBlue * 5 / divider);
                }
                if ((x + 2) < redMatrix.Width)
                {
                    redMatrix[y + 1, x + 2] += (int)(errorRed / 16f);
                    greenMatrix[y + 1, x + 2] += (int)(errorGreen / 16f);
                    blueMatrix[y + 1, x + 2] += (int)(errorBlue / 16f);
                }
            }
            if ((y + 2) < redMatrix.Height)
            {
                if ((x - 2) > 0)
                {
                    redMatrix[y + 2, x - 2] += (int)(errorRed / divider);
                    greenMatrix[y + 2, x - 2] += (int)(errorGreen / divider);
                    blueMatrix[y + 2, x - 2] += (int)(errorBlue / divider);
                }
                if ((x - 1) > 0)
                {
                    redMatrix[y + 2, x - 1] += (int)(errorRed / 16f);
                    greenMatrix[y + 2, x - 1] += (int)(errorGreen / 16f);
                    blueMatrix[y + 2, x - 1] += (int)(errorBlue / 16f);
                }

                redMatrix[y + 2, x] += (int)(errorRed * 5 / divider);
                greenMatrix[y + 2, x] += (int)(errorGreen * 5 / divider);
                blueMatrix[y + 2, x] += (int)(errorBlue * 5 / divider);

                if ((x + 1) < redMatrix.Width)
                {
                    redMatrix[y + 2, x + 1] += (int)(errorRed / 16f);
                    greenMatrix[y + 2, x + 1] += (int)(errorGreen / 16f);
                    blueMatrix[y + 2, x + 1] += (int)(errorBlue / 16f);
                }
                if ((x + 2) < redMatrix.Width)
                {
                    redMatrix[y + 2, x + 2] += (int)(errorRed / divider);
                    greenMatrix[y + 2, x + 2] += (int)(errorGreen / divider);
                    blueMatrix[y + 2, x + 2] += (int)(errorBlue / divider);
                }
            }
        }

        private void StuckiAlgorithm(int x, int y, Matrix redMatrix, int errorRed, Matrix greenMatrix, int errorGreen, Matrix blueMatrix, int errorBlue)
        {
            int divider = 42;
            if ((x + 1) < redMatrix.Width)
            {
                redMatrix[y, x + 1] += (int)(errorRed * 8 / divider);
                greenMatrix[y, x + 1] += (int)(errorGreen * 8 / divider);
                blueMatrix[y, x + 1] += (int)(errorBlue * 8 / divider);
            }
            if ((x + 2) < redMatrix.Width)
            {
                redMatrix[y, x + 2] += (int)(errorRed * 4 / divider);
                greenMatrix[y, x + 2] += (int)(errorGreen * 4 / divider);
                blueMatrix[y, x + 2] += (int)(errorBlue * 4 / divider);
            }
            if ((y + 1) < redMatrix.Height)
            {
                if ((x - 2) > 0)
                {
                    redMatrix[y + 1, x - 2] += (int)(errorRed / 21f);
                    greenMatrix[y + 1, x - 2] += (int)(errorGreen / 21f);
                    blueMatrix[y + 1, x - 2] += (int)(errorBlue / 21f);
                }
                if ((x - 1) > 0)
                {
                    redMatrix[y + 1, x - 1] += (int)(errorRed * 4 / divider);
                    greenMatrix[y + 1, x - 1] += (int)(errorGreen * 4 / divider);
                    blueMatrix[y + 1, x - 1] += (int)(errorBlue * 4 / divider);
                }
                redMatrix[y + 1, x] += (int)(errorRed * 8 / divider);
                greenMatrix[y + 1, x] += (int)(errorGreen * 8 / divider);
                blueMatrix[y + 1, x] += (int)(errorBlue * 8 / divider);
                if ((x + 1) < redMatrix.Width)
                {
                    redMatrix[y + 1, x + 1] += (int)(errorRed * 4 / divider);
                    greenMatrix[y + 1, x + 1] += (int)(errorGreen * 4 / divider);
                    blueMatrix[y + 1, x + 1] += (int)(errorBlue * 4 / divider);
                }
                if ((x + 2) < redMatrix.Width)
                {
                    redMatrix[y + 1, x + 2] += (int)(errorRed / 21f);
                    greenMatrix[y + 1, x + 2] += (int)(errorGreen / 21f);
                    blueMatrix[y + 1, x + 2] += (int)(errorBlue / 21f);
                }
            }
            if ((y + 2) < redMatrix.Height)
            {
                if ((x - 2) > 0)
                {
                    redMatrix[y + 2, x - 2] += (int)(errorRed / divider);
                    greenMatrix[y + 2, x - 2] += (int)(errorGreen / divider);
                    blueMatrix[y + 2, x - 2] += (int)(errorBlue / divider);
                }
                if ((x - 1) > 0)
                {
                    redMatrix[y + 2, x - 1] += (int)(errorRed / 21f);
                    greenMatrix[y + 2, x - 1] += (int)(errorGreen / 21f);
                    blueMatrix[y + 2, x - 1] += (int)(errorBlue / 21f);
                }

                redMatrix[y + 2, x] += (int)(errorRed * 4 / divider);
                greenMatrix[y + 2, x] += (int)(errorGreen * 4 / divider);
                blueMatrix[y + 2, x] += (int)(errorBlue * 4 / divider);

                if ((x + 1) < redMatrix.Width)
                {
                    redMatrix[y + 2, x + 1] += (int)(errorRed / 21f);
                    greenMatrix[y + 2, x + 1] += (int)(errorGreen / 21f);
                    blueMatrix[y + 2, x + 1] += (int)(errorBlue / 21f);
                }
                if ((x + 2) < redMatrix.Width)
                {
                    redMatrix[y + 2, x + 2] += (int)(errorRed / divider);
                    greenMatrix[y + 2, x + 2] += (int)(errorGreen / divider);
                    blueMatrix[y + 2, x + 2] += (int)(errorBlue / divider);
                }
            }
        }
    }
}
