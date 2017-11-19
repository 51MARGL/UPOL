using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cv_8
{
    class Matrix
    {
        private int[,] matrix;
        public int Height { get; private set; }
        public int Width { get; private set; }

        public Matrix(int Height, int Width)
        {
            this.Height = Height;
            this.Width = Width;
            matrix = new int[Height, Width];
        }

        public static Matrix operator +(Matrix m1, Matrix m2)
        {
            var result = new Matrix(m1.Width, m1.Height);
            for (var i = 0; i < result.Height; i++)
            {
                for (var j = 0; j < result.Width; j++)
                {
                    result[i, j] = m1[i, j] + m2[i, j];
                }
            }
            return result;
        }

        public static Matrix operator *(int constant, Matrix m2)
        {
            var result = new Matrix(m2.Height, m2.Width);
            for (var i = 0; i < result.Height; i++)
            {
                for (var j = 0; j < result.Width; j++)
                {
                    result[i, j] = constant * m2[i, j];
                }
            }
            return result;
        }

        public int this[int m, int n]
        {
            get => matrix[m, n];
            set => matrix[m, n] = value;
        }

        public override string ToString()
        {
            var outputMatrix = "";
            for (var i = 0; i < Height; i++)
            {
                for (var j = 0; j < Width; j++)
                {
                    outputMatrix += matrix[i, j];
                    outputMatrix += " ";
                }
                outputMatrix += "\n";
            }
            return outputMatrix;
        }

        public void FillWithConst(int constant)
        {
            for (var i = 0; i < Height; i++)
            {
                for (var j = 0; j < Width; j++)
                {
                    matrix[i, j] = constant;
                }
            }
        }
    }
}
