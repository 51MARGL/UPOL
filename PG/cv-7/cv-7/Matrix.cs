using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cv_7
{
    class Matrix
    {
        private int[,] matrix;
        public int Size { get; private set; }

        public Matrix(int size)
        {
            this.Size = size;
            matrix = new int[size, size];
        }

        public void Set(int m, int n, int value)
        {
            matrix[m, n] = value;
        }

        public int Get(int m, int n)
        {
            return matrix[m, n];
        }

        public int GetSize()
        {
            return Size;
        }

        public static Matrix operator +(Matrix m1, Matrix m2)
        {
            Matrix result = new Matrix(m1.GetSize());
            for (int i = 0; i < result.GetSize(); i++)
            {
                for (int j = 0; j < result.GetSize(); j++)
                {
                    result.Set(i, j, m1.Get(i, j) + m2.Get(i, j));
                }
            }
            return result;
        }

        public static Matrix operator *(int constant, Matrix m2)
        {
            Matrix result = new Matrix(m2.GetSize());
            for (int i = 0; i < result.GetSize(); i++)
            {
                for (int j = 0; j < result.GetSize(); j++)
                {
                    result.Set(i, j, constant * m2.Get(i, j));
                }
            }
            return result;
        }

        public int this[int m, int n]
        {
            get
            {
                return Get(m, n);
            }
            set
            {
                matrix[m, n] = value;
            }
        }

        public override string ToString()
        {
            string outputMatrix = "";
            for (int i = 0; i < this.GetSize(); i++)
            {
                for (int j = 0; j < this.GetSize(); j++)
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
            for (int i = 0; i < this.GetSize(); i++)
            {
                for (int j = 0; j < this.GetSize(); j++)
                {
                    matrix[i, j] = constant;
                }
            }
        }
    }
}
