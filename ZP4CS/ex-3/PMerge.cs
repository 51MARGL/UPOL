using System;
using System.Threading;
using System.Threading.Tasks;

namespace cv_3
{
    class PMerge
    {
        public void ParalMergeSort(int[] A, int p, int r, int depth)
        {
            if (p < r && depth > 0)
            {
                int q = (p + r) / 2;

                depth--;
                Parallel.Invoke(
                    () => ParalMergeSort(A, p, q, depth),
                    () => ParalMergeSort(A, q + 1, r, depth)
                    );

                // Jsem precetl, ze je to stejne jako
                //
                // Thread t1 = new Thread(() => ParalMergeSort(A, p, q, depth));
                // Thread t2 = new Thread(() => ParalMergeSort(A, q + 1, r, depth));
                // t1.Start();
                // t2.Start();
                // t1.Join();
                // t2.Join();
                //
                // A stejne jako to
                //
                // Task t1 = Task.Run(() => ParalMergeSort(A, p, q, depth));
                // Task t2 = Task.Run(() => ParalMergeSort(A, q + 1, r, depth));
                // Task.WaitAll(t1, t2);


                Merge(A, p, q, r);
            }
            else if (p < r)
            {
                int q = (p + r) / 2;
                SeqMergeSort(A, p, q);
                SeqMergeSort(A, q + 1, r);
                Merge(A, p, q, r);
            }
        }

        private void SeqMergeSort(int[] A, int p, int r)
        {

            if (p < r)
            {
                int q = (p + r) / 2;
                SeqMergeSort(A, p, q);
                SeqMergeSort(A, q + 1, r);
                Merge(A, p, q, r);
            }
        }

        private void Merge(int[] A, int p, int q, int r)
        {
            int n1 = q - p + 1;
            int n2 = r - q;
            int[] L = new int[n1 + 1];
            int[] R = new int[n2 + 1];
            Array.Copy(A, p, L, 0, L.Length - 1);
            Array.Copy(A, q + 1, R, 0, R.Length - 1);
            
            L[n1] = int.MaxValue;
            R[n2] = int.MaxValue;
            
            int n = 0;
            int m = 0;
            for (int k = p; k <= r; k++)
            {
                if (L[n].CompareTo(R[m]) < 0 || L[n].CompareTo(R[m]) == 0)
                {
                    A[k] = L[n];
                    n++;
                }
                else
                {
                    A[k] = R[m];
                    m++;
                }
            }
        }
    }
}
