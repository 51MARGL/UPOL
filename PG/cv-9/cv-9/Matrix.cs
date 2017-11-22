using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cv_9
{
    class Matrix : IEnumerable
    {
        private int[,] matrix;
        public static readonly Matrix ConvolutionH1 = new Matrix(3, 3);
        public static readonly Matrix ConvolutionH2 = new Matrix(3, 3);
        public static readonly Matrix RobertsMatrixH = new Matrix(3, 3);
        public static readonly Matrix RobertsMatrixV = new Matrix(3, 3);
        public static readonly Matrix SobelMatrixH = new Matrix(3, 3);
        public static readonly Matrix SobelMatrixV = new Matrix(3, 3);
        public static readonly Matrix LaplacianH1 = new Matrix(3, 3);
        public static readonly Matrix LaplacianH2 = new Matrix(3, 3);

        private float factor;
        public float Factor
        {
            get => factor == 0 ? 1 : factor;
            private set => factor = value;
        }

        public int Height { get; private set; }
        public int Width { get; private set; }

        static Matrix()
        {
            ConvolutionH1.matrix = new int[3, 3]
            {
                {1, 1, 1 },
                {1, 1, 1 },
                {1, 1, 1 }
            };
            ConvolutionH1.Factor = 1 / 9f;
            ConvolutionH2.matrix = new int[3, 3]
            {
                {1, 2, 1 },
                {2, 4, 2 },
                {1, 2, 1 }
            };
            ConvolutionH2.factor = 1 / 16f;

            RobertsMatrixH.matrix = new int[3, 3]
            {
                {0, 0, 0 },
                {0, 0, 1 },
                {0, -1, 0}
            };

            RobertsMatrixV.matrix = new int[3, 3]
            {
                {0, 0, 0 },
                {0, 1, 0 },
                {0, 0, -1}
            };

            SobelMatrixH.matrix = new int[3, 3]
            {
                {-1, 0, 1 },
                {-2, 0, 2 },
                {-1, 0, 1 }
            };

            SobelMatrixV.matrix = new int[3, 3]
            {
                {1, 2, 1 },
                {0, 0, 0 },
                {-1,-2,-1}
            };

            LaplacianH1.matrix = new int[3, 3]
            {
                {0, 1, 0 },
                {1,-4, 1 },
                {0, 1, 0 }
            };

            LaplacianH2.matrix = new int[3, 3]
            {
                {1, 1, 1 },
                {1,-8, 1 },
                {1, 1, 1 }
            };
        }
        public Matrix(int height, int width)
        {
            this.Height = height;
            this.Width = width;
            matrix = new int[height, width];
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

        public IEnumerator GetEnumerator()
        {
            foreach (var i in matrix)
            {
                yield return i;
            }
        }
    }
}
