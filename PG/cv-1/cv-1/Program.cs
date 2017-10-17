using System;

namespace cv_1 {
    class Program {
        static void Main (string[] args) {
            try {
                float inchDiag;
                string pathToImage;
                Console.Write("Enter monitor diagonal in inches: ");
                float.TryParse(Console.ReadLine(), out inchDiag);
                if (!(inchDiag > 0 && inchDiag < float.MaxValue))
                    throw new Exception("Wrong diagonal size!");
                Console.Write("Enter path to image: ");
                pathToImage = Console.ReadLine();
                using (BitmapHandler window = new BitmapHandler(inchDiag, pathToImage)) {
                    window.Run(30, 0);
                }
            } catch (Exception e) {
                Console.WriteLine("Error: " + e.Message);
                Console.WriteLine("Trace:\n" + e.StackTrace);
            } finally {
                Console.ReadLine();
            }
        }
    }
}
