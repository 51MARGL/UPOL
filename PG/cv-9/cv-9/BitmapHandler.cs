using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

namespace cv_9
{
    class BitmapHandler
    {
        public unsafe Bitmap CreateGreyScale(Bitmap sourceBitmap)
        {
            int pixelSize = 3;

            var newBitmap = new Bitmap(sourceBitmap.Width, sourceBitmap.Height, PixelFormat.Format24bppRgb);
            var bitmapMatrix = new Matrix(sourceBitmap.Height, sourceBitmap.Width);
            bitmapMatrix.FillWithConst(0);

            var sourceData = sourceBitmap.LockBits(
                new Rectangle(0, 0, sourceBitmap.Width, sourceBitmap.Height),
                ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);

            var newData = newBitmap.LockBits(
                new Rectangle(0, 0, sourceBitmap.Width, sourceBitmap.Height),
                ImageLockMode.WriteOnly, PixelFormat.Format24bppRgb);

            for (int y = 0; y < sourceBitmap.Height; y++)
            {
                byte* originalByteData = (byte*)sourceData.Scan0 + (y * sourceData.Stride);
                byte* newByteData = (byte*)newData.Scan0 + (y * newData.Stride);

                for (int x = 0; x < sourceBitmap.Width; x++)
                {
                    byte grayColor;
                    if (originalByteData[x * pixelSize] != originalByteData[x * pixelSize + 1]
                        && originalByteData[x * pixelSize] != originalByteData[x * pixelSize + 1])
                    {
                        grayColor = (byte)(originalByteData[x * pixelSize] * 0.299 +
                                            originalByteData[x * pixelSize + 1] * 0.587 +
                                            originalByteData[x * pixelSize + 2] * 0.144);
                    }
                    else
                    {
                        grayColor = originalByteData[x * pixelSize];
                    }

                    newByteData[x * pixelSize] = grayColor;
                    newByteData[x * pixelSize + 1] = grayColor;
                    newByteData[x * pixelSize + 2] = grayColor;
                }
            }
            sourceBitmap.UnlockBits(sourceData);
            newBitmap.UnlockBits(newData);

            return newBitmap;
        }

        // Marshall.Copy taky vypada jako neco rychlejsiho ale casto zere pameti jeste vic nez pointery
        public Bitmap CreateConvolutionBitmap(Bitmap sourceBitmap, Matrix convolutiomMatrix)
        {
            int pixelSize = 3;
            var sourceData = sourceBitmap.LockBits(
                             new Rectangle(0, 0, sourceBitmap.Width, sourceBitmap.Height),
                             ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);

            byte[] pixelBuffer = new byte[sourceData.Stride * sourceData.Height];
            byte[] resultBuffer = new byte[sourceData.Stride * sourceData.Height];

            Marshal.Copy(sourceData.Scan0, pixelBuffer, 0, pixelBuffer.Length);

            sourceBitmap.UnlockBits(sourceData);

            int matrixSize = convolutiomMatrix.Width;

            int matrixOffset = (matrixSize - 1) / 2;

            for (int y = matrixOffset; y < sourceBitmap.Height - matrixOffset; y++)
            {
                for (int x = matrixOffset; x < sourceBitmap.Width - matrixOffset; x++)
                {
                    double color = 0;

                    var byteOffset = y * sourceData.Stride + x * pixelSize;

                    for (int matY = -matrixOffset; matY <= matrixOffset; matY++)
                    {
                        for (int matX = -matrixOffset; matX <= matrixOffset; matX++)
                        {
                            var calcOffset = byteOffset +
                                             (matX * pixelSize) +
                                             (matY * sourceData.Stride);


                            color += (double)(pixelBuffer[calcOffset]) *
                                     convolutiomMatrix[matY + matrixOffset,
                                     matX + matrixOffset];
                        }
                    }
                    color *= convolutiomMatrix.Factor;

                    if (color > 255)
                    { color = 255; }
                    else if (color < 0)
                    { color = 0; }

                    resultBuffer[byteOffset] = (byte)(color);
                    resultBuffer[byteOffset + 1] = (byte)(color);
                    resultBuffer[byteOffset + 2] = (byte)(color);
                }
            }

            Bitmap resultBitmap = new Bitmap(sourceBitmap.Width, sourceBitmap.Height);

            BitmapData resultData = resultBitmap.LockBits(new Rectangle(0, 0,
                                    resultBitmap.Width, resultBitmap.Height),
                                    ImageLockMode.WriteOnly, PixelFormat.Format24bppRgb);

            Marshal.Copy(resultBuffer, 0, resultData.Scan0, resultBuffer.Length);
            resultBitmap.UnlockBits(resultData);

            return resultBitmap;
        }

        public Bitmap CreateConvolutionBitmap(Bitmap sourceBitmap, Matrix matrixHorizontal, Matrix matrixVertical)
        {
            int pixelSize = 3;
            var sourceData = sourceBitmap.LockBits(
                             new Rectangle(0, 0, sourceBitmap.Width, sourceBitmap.Height),
                             ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);

            byte[] pixelBuffer = new byte[sourceData.Stride * sourceData.Height];

            byte[] resultBuffer = new byte[sourceData.Stride * sourceData.Height];

            Marshal.Copy(sourceData.Scan0, pixelBuffer, 0, pixelBuffer.Length);

            sourceBitmap.UnlockBits(sourceData);

            int matrixSize = matrixHorizontal.Width;

            int matrixOffset = (matrixSize - 1) / 2;

            for (int y = matrixOffset; y < sourceBitmap.Height - matrixOffset; y++)
            {
                for (int x = matrixOffset; x < sourceBitmap.Width - matrixOffset; x++)
                {
                    double colorX = 0;
                    double colorY = 0;
                    var colorTotal = 0.0;

                    var byteOffset = y * sourceData.Stride + x * pixelSize;

                    for (int matY = -matrixOffset; matY <= matrixOffset; matY++)
                    {
                        for (int matX = -matrixOffset; matX <= matrixOffset; matX++)
                        {
                            var calcOffset = byteOffset +
                                             (matX * pixelSize) +
                                             (matY * sourceData.Stride);

                            colorX += (double)(pixelBuffer[calcOffset]) *
                                      matrixHorizontal[matY + matrixOffset, matX + matrixOffset];

                            colorY += (double)(pixelBuffer[calcOffset]) *
                                      matrixVertical[matY + matrixOffset, matX + matrixOffset];
                        }
                    }

                    colorTotal = Math.Sqrt((colorX * colorX) + (colorY * colorY));

                    if (colorTotal > 255)
                    { colorTotal = 255; }
                    else if (colorTotal < 0)
                    { colorTotal = 0; }

                    resultBuffer[byteOffset] = (byte)(colorTotal);
                    resultBuffer[byteOffset + 1] = (byte)(colorTotal);
                    resultBuffer[byteOffset + 2] = (byte)(colorTotal);
                    resultBuffer[byteOffset + 3] = 255;
                }
            }

            Bitmap resultBitmap = new Bitmap(sourceBitmap.Width, sourceBitmap.Height);

            BitmapData resultData = resultBitmap.LockBits(new Rectangle(0, 0,
                                    resultBitmap.Width, resultBitmap.Height),
                                    ImageLockMode.WriteOnly, PixelFormat.Format24bppRgb);

            Marshal.Copy(resultBuffer, 0, resultData.Scan0, resultBuffer.Length);
            resultBitmap.UnlockBits(resultData);

            return resultBitmap;
        }

        public Bitmap CreateMedianBitmap(Bitmap sourceBitmap, int matrixSize)
        {
            int pixelSize = 3;
            var sourceData = sourceBitmap.LockBits(
                new Rectangle(0, 0, sourceBitmap.Width, sourceBitmap.Height),
                ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);

            byte[] pixelBuffer = new byte[sourceData.Stride * sourceData.Height];

            byte[] resultBuffer = new byte[sourceData.Stride * sourceData.Height];

            Marshal.Copy(sourceData.Scan0, pixelBuffer, 0, pixelBuffer.Length);

            sourceBitmap.UnlockBits(sourceData);

            int matrixOffset = (matrixSize - 1) / 2;

            List<byte> neighbourPixels = new List<byte>();

            for (int y = matrixOffset; y < sourceBitmap.Height - matrixOffset; y++)
            {
                for (int x = matrixOffset; x < sourceBitmap.Width - matrixOffset; x++)
                {
                    var byteOffset = y * sourceData.Stride + x * pixelSize;

                    neighbourPixels.Clear();

                    for (int matY = -matrixOffset; matY <= matrixOffset; matY++)
                    {
                        for (int matX = -matrixOffset; matX <= matrixOffset; matX++)
                        {
                            var calcOffset = byteOffset +
                                             (matX * pixelSize) +
                                             (matY * sourceData.Stride);


                            neighbourPixels.Add(pixelBuffer[calcOffset]);
                        }
                    }

                    neighbourPixels.Sort();

                    var middlePixel = (byte)neighbourPixels[neighbourPixels.Count / 2];

                    resultBuffer[byteOffset] = middlePixel;
                    resultBuffer[byteOffset + 1] = middlePixel;
                    resultBuffer[byteOffset + 2] = middlePixel;
                }
            }

            Bitmap resultBitmap = new Bitmap(sourceBitmap.Width, sourceBitmap.Height);

            BitmapData resultData = resultBitmap.LockBits(new Rectangle(0, 0,
                    resultBitmap.Width, resultBitmap.Height),
                    ImageLockMode.WriteOnly, PixelFormat.Format24bppRgb);

            Marshal.Copy(resultBuffer, 0, resultData.Scan0, resultBuffer.Length);

            resultBitmap.UnlockBits(resultData);

            return resultBitmap;
        }
    }
}
