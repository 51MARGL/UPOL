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
    class Dithering
    {
        public int ditheringMatrixSize;
        public unsafe Bitmap ProcessBitmap(Bitmap original, string switchString = "G")
        {
            Bitmap newBitmap;
            if (switchString == "G")
                newBitmap = new Bitmap(original.Width, original.Height, PixelFormat.Format24bppRgb);
            else
                newBitmap = new Bitmap(original.Width, original.Height, PixelFormat.Format1bppIndexed);

            var originalData = original.LockBits(
               new Rectangle(0, 0, original.Width, original.Height),
               ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);

            var newData = newBitmap.LockBits(
               new Rectangle(0, 0, original.Width, original.Height),
               ImageLockMode.WriteOnly, PixelFormat.Format24bppRgb);

            int pixelSize = 3;
            int pivot = 96;
            Random rand = new Random();
            for (int y = 0; y < original.Height; y++)
            {
                byte* oRow = (byte*)originalData.Scan0 + (y * originalData.Stride);

                byte* nRow = (byte*)newData.Scan0 + (y * newData.Stride);

                for (int x = 0; x < original.Width; x++)
                {
                    byte grayColor;

                    if (switchString == "G")
                    {
                        grayColor =
                            (byte)((oRow[x * pixelSize] * .114) + //B
                            (oRow[x * pixelSize + 1] * .587) +  //G
                            (oRow[x * pixelSize + 2] * .299)); //R

                        nRow[x * pixelSize] = grayColor; //B
                        nRow[x * pixelSize + 1] = grayColor; //G
                        nRow[x * pixelSize + 2] = grayColor; //R
                    }
                    else if (switchString == "S")
                    {
                        byte black = 0;
                        byte white = 255;
                        grayColor = oRow[x * pixelSize];
                        if (grayColor >= pivot)
                        {
                            nRow[x * pixelSize] = white; //B
                            nRow[x * pixelSize + 1] = white; //G
                            nRow[x * pixelSize + 2] = white; //R
                        }
                        else
                        {
                            nRow[x * pixelSize] = black; //B
                            nRow[x * pixelSize + 1] = black; //G
                            nRow[x * pixelSize + 2] = black; //R
                        }
                    }
                    else if (switchString == "R")
                    {
                        pivot = rand.Next(0, 256);
                        byte black = 0;
                        byte white = 255;
                        grayColor = oRow[x * pixelSize];
                        if (grayColor >= pivot)
                        {
                            nRow[x * pixelSize] = white; //B
                            nRow[x * pixelSize + 1] = white; //G
                            nRow[x * pixelSize + 2] = white; //R
                        }
                        else
                        {
                            nRow[x * pixelSize] = black; //B
                            nRow[x * pixelSize + 1] = black; //G
                            nRow[x * pixelSize + 2] = black; //R
                        }
                    }
                }
            }

            newBitmap.UnlockBits(newData);
            original.UnlockBits(originalData);

            return newBitmap;

        }

        public unsafe Bitmap MatrixDithering(Bitmap gray)
        {
            Bitmap matrixBmp = new Bitmap(gray.Width * ditheringMatrixSize, gray.Height * ditheringMatrixSize, PixelFormat.Format1bppIndexed);
            int pixelSize = 3;
            Matrix ditheringMatrix = CreateDitheringMatrix(ditheringMatrixSize);

            BitmapData originalData = gray.LockBits(
               new Rectangle(0, 0, gray.Width, gray.Height),
               ImageLockMode.ReadOnly, PixelFormat.Format24bppRgb);

            BitmapData matrixData = matrixBmp.LockBits(
              new Rectangle(0, 0, matrixBmp.Width, matrixBmp.Height),
              ImageLockMode.ReadWrite, PixelFormat.Format24bppRgb);

            for (int y = 0; y < gray.Height; y++)
            {
                byte* oRow = (byte*)originalData.Scan0 + (y * originalData.Stride);

                for (int x = 0; x < gray.Width; x++)
                {
                    var color = oRow[x * pixelSize];
                    Matrix current = ResultDitheringMatrix(color, ditheringMatrix);

                    for (int j = 0; j < current.Size; j++)
                    {
                        byte* nRow = (byte*)matrixData.Scan0 + ((j + y * ditheringMatrixSize) * matrixData.Stride);                        
                        for (int i = 0; i < current.Size; i++)
                        {
                            nRow[(i + x * ditheringMatrixSize) * pixelSize] = (byte)current[i, j];
                            nRow[(i + x * ditheringMatrixSize) * pixelSize + 1] = (byte)current[i, j];
                            nRow[(i + x * ditheringMatrixSize) * pixelSize + 2] = (byte)current[i, j];
                        }
                    }
                }
            }
            
            gray.UnlockBits(originalData);
            matrixBmp.UnlockBits(matrixData);
            return matrixBmp;
        }

        private Matrix ResultDitheringMatrix(int inputValue, Matrix matrix)
        {
            Matrix result = new Matrix(matrix.Size);
            for (int i = 0; i < matrix.Size; i++)
            {
                for (int j = 0; j < matrix.Size; j++)
                {
                    if (inputValue <= matrix[i, j])
                    {
                        result[i, j] = 0;
                    }
                    else result[i, j] = 255;
                }
            }
            return result;
        }

        private Matrix CreateDitheringMatrix(int n)
        {
            var m = new Matrix(2)
            {
                [0, 0] = 0,
                [0, 1] = 2,
                [1, 0] = 3,
                [1, 1] = 1
            };
            return CreateMatrix(m, n);
        }


        private Matrix CreateMatrix(Matrix m, int n)
        {
            while (true)
            {
                if (m.GetSize() < n)
                {
                    int mSize = m.GetSize();
                    Matrix result = new Matrix(mSize * 2);
                    Matrix mx4 = 4 * m;
                    Matrix singleMatrix = new Matrix(mSize);
                    singleMatrix.FillWithConst(1);
                    for (int i = 0; i < mSize; i++)
                    {
                        for (int j = 0; j < mSize; j++)
                        {
                            result[i, j] = mx4[i, j];
                        }
                    }
                    Matrix secondQuarter = mx4 + 2 * singleMatrix;
                    for (int i = 0; i < mSize; i++)
                    {
                        for (int j = mSize; j < mSize * 2; j++)
                        {
                            result[i, j] = secondQuarter[i, j - mSize];
                        }
                    }
                    Matrix thirdQuarter = mx4 + 3 * singleMatrix;
                    for (int i = mSize; i < mSize * 2; i++)
                    {
                        for (int j = 0; j < mSize; j++)
                        {
                            result[i, j] = thirdQuarter[i - mSize, j];
                        }
                    }
                    Matrix fourthQuarter = mx4 + singleMatrix;
                    for (int i = mSize; i < mSize * 2; i++)
                    {
                        for (int j = mSize; j < mSize * 2; j++)
                        {
                            result[i, j] = fourthQuarter[i - mSize, j - mSize];
                        }
                    }
                    m = result;
                }
                else return m;
            }
        }
    }
}
