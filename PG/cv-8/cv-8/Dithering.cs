using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;
using System.Drawing.Imaging;

namespace cv_8
{
    class Dithering
    {
        public unsafe Bitmap SimpleDithering(Bitmap original, int switchI = 0)
        {
            int pixelSize = 3;
            int pivot = 128;
            byte black = 0;
            byte white = 255;

            Bitmap newBitmap = new Bitmap(original.Width, original.Height, PixelFormat.Format24bppRgb);
            Matrix bitmapMatrix = new Matrix(original.Height, original.Width);
            bitmapMatrix.FillWithConst(0);

            BitmapData originalData = original.LockBits(
               new Rectangle(0, 0, original.Width, original.Height),
               ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);

            BitmapData newData = newBitmap.LockBits(
               new Rectangle(0, 0, original.Width, original.Height),
               ImageLockMode.WriteOnly, PixelFormat.Format24bppRgb);

            for (int y = 0; y < original.Height; y++)
            {
                byte* originalByteData = (byte*)originalData.Scan0 + (y * originalData.Stride);
                byte* newByteData = (byte*)newData.Scan0 + (y * newData.Stride);

                for (int x = 0; x < original.Width; x++)
                {
                    byte grayColor;

                    byte newColor;
                    if (switchI == 0)
                    {
                        grayColor = (byte)(originalByteData[x * pixelSize] * 0.299 +
                                           originalByteData[x * pixelSize + 1] * 0.587 +
                                           originalByteData[x * pixelSize + 2] * 0.144);
                        newColor = grayColor;
                    }
                    else
                    {

                        grayColor = originalByteData[x * pixelSize];
                        grayColor += (byte)bitmapMatrix[y, x];
                        newColor = grayColor >= pivot ? white : black;

                        var inOutDifference = grayColor - newColor;
                       
                        switch (switchI)
                        {
                            case 1:
                                FloydSteinberg(x, y, bitmapMatrix, inOutDifference);
                                break;
                            case 2:
                                SierraAlgorithm(x, y, bitmapMatrix, inOutDifference);
                                break;
                            case 3:
                                JjnAlgorithm(x, y, bitmapMatrix, inOutDifference);
                                break;
                            case 4:
                                StuckiAlgorithm(x, y, bitmapMatrix, inOutDifference);
                                break;
                        }   
                    }
                    newByteData[x * pixelSize] = newColor;
                    newByteData[x * pixelSize + 1] = newColor;
                    newByteData[x * pixelSize + 2] = newColor;
                }
            }
            original.UnlockBits(originalData);
            newBitmap.UnlockBits(newData);

            return newBitmap;
        }

        private void FloydSteinberg(int x, int y, Matrix bitmapMatrix, int error)
        {
            if ((x + 1) < bitmapMatrix.Width)
            {
                bitmapMatrix[y, x + 1] += (int)((7 * error) / 16f);
            }
            if ((y + 1) < bitmapMatrix.Height)
            {
                if ((x - 1) > 0)
                {
                    bitmapMatrix[y + 1, x - 1] += (int)((3 * error) / 16f);
                }
                bitmapMatrix[y + 1, x] += (int)((5 * error) / 16f);
                if ((x + 1) < bitmapMatrix.Width)
                {
                    bitmapMatrix[y + 1, x + 1] += (int)(error/ 16f);
                }

            }
        }

        private void SierraAlgorithm(int x, int y, Matrix bitmapMatrix, int error)
        {
            if ((x + 1) < bitmapMatrix.Width)
            {
                bitmapMatrix[y, x + 1] += (int)(error / 2f);
            }
            if ((y + 1) < bitmapMatrix.Height)
            {
                if ((x - 1) > 0)
                {
                    bitmapMatrix[y + 1, x - 1] += (int)(error / 2f);
                }
                bitmapMatrix[y + 1, x] += (int)(error / 16f);
            }
        }

        private void JjnAlgorithm(int x, int y, Matrix bitmapMatrix, int error)
        {
            double divider = 48;
            if ((x + 1) < bitmapMatrix.Width)
            {
                bitmapMatrix[y, x + 1] += (int)(error * 7 / divider);
            }
            if ((x + 2) < bitmapMatrix.Width)
            {
                bitmapMatrix[y, x + 2] += (int)(error * 5 / divider);
            }
            if ((y + 1) < bitmapMatrix.Height)
            {
                if ((x - 2) > 0)
                {
                    bitmapMatrix[y + 1, x - 2] += (int)(error / 16f);
                }
                if ((x - 1) > 0)
                {
                    bitmapMatrix[y + 1, x - 1] += (int)(error * 5 / divider);
                }
                bitmapMatrix[y + 1, x] += (int)(error * 7 / divider);
                if ((x + 1) < bitmapMatrix.Width)
                {
                    bitmapMatrix[y + 1, x + 1] += (int)(error * 5 / divider);
                }
                if ((x + 2) < bitmapMatrix.Width)
                {
                    bitmapMatrix[y + 1, x + 2] += (int)(error / 16f);
                }
            }
            if ((y + 2) < bitmapMatrix.Height)
            {
                if ((x - 2) > 0)
                {
                    bitmapMatrix[y + 2, x - 2] += (int)(error / divider);
                }
                if ((x - 1) > 0)
                {
                    bitmapMatrix[y + 2, x - 1] += (int)(error / 16f);
                }
                bitmapMatrix[y + 2, x] += (int)(error * 5 / divider);
                if ((x + 1) < bitmapMatrix.Width)
                {
                    bitmapMatrix[y + 2, x + 1] += (int)(error / 16f);
                }
                if ((x + 2) < bitmapMatrix.Width)
                {
                    bitmapMatrix[y + 2, x + 2] += (int)(error / divider);
                }
            }
        }

        private void StuckiAlgorithm(int x, int y, Matrix bitmapMatrix, int error)
        {
            double divider = 42;
            if ((x + 1) < bitmapMatrix.Width)
            {
                bitmapMatrix[y, x + 1] += (int)(error * 8 / divider);
            }
            if ((x + 2) < bitmapMatrix.Width)
            {
                bitmapMatrix[y, x + 2] += (int)(error * 4 / divider);
            }
            if ((y + 1) < bitmapMatrix.Height)
            {
                if ((x - 2) > 0)
                {
                    bitmapMatrix[y + 1, x - 2] += (int)(error / 21f);
                }
                if ((x - 1) > 0)
                {
                    bitmapMatrix[y + 1, x - 1] += (int)(error * 4 / divider);
                }
                bitmapMatrix[y + 1, x] += (int)(error * 8 / divider);
                if ((x + 1) < bitmapMatrix.Width)
                {
                    bitmapMatrix[y + 1, x + 1] += (int)(error * 4 / divider);
                }
                if ((x + 2) < bitmapMatrix.Width)
                {
                    bitmapMatrix[y + 1, x + 2] += (int)(error / 21f);
                }
            }
            if ((y + 2) < bitmapMatrix.Height)
            {
                if ((x - 2) > 0)
                {
                    bitmapMatrix[y + 2, x - 2] += (int)(error / divider);
                }
                if ((x - 1) > 0)
                {
                    bitmapMatrix[y + 2, x - 1] += (int)(error / 21f);
                }
                bitmapMatrix[y + 2, x] += (int)(error * 4 / divider);
                if ((x + 1) < bitmapMatrix.Width)
                {
                    bitmapMatrix[y + 2, x + 1] += (int)(error / 21f);
                }
                if ((x + 2) < bitmapMatrix.Width)
                {
                    bitmapMatrix[y + 2, x + 2] += (int)(error / divider);
                }
            }
        }

    }
}
