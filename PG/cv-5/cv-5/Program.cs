using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;

namespace cv_5
{
    class Program
    {
        public static byte[] ToByteArray(Bitmap image, ImageFormat format)
        {
            using (MemoryStream ms = new MemoryStream())
            {
                image.Save(ms, format);
                return ms.ToArray();
            }
        }
        static void Main(string[] args)
        {            
            RLE rle = new RLE();
            byte[] result = rle.Encode(@"!!.jpg");
            File.WriteAllBytes("compressed.rle", result);
            Console.WriteLine("Done compression");
            Bitmap decoded = rle.RunLengthDecodeBitmap("compressed.rle");
            File.WriteAllBytes("decoded.jpg", ToByteArray(decoded, ImageFormat.Jpeg));
            Console.ReadLine();
        }
    }
}
