using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cv_4
{
    class Mycmd
    {
        public void Start()
        {
            Console.Write("Enter starting position: ");
            string position = Console.ReadLine();
            DirectoryInfo di = new DirectoryInfo(@position);
            while (!di.Exists)
            {
                Console.WriteLine("Can't find path");
                Console.Write("Enter starting position: ");
                position = Console.ReadLine();
                di = new DirectoryInfo(@position);
            }
            while (true)
            {
                Console.Write(position + '>');
                string command = Console.ReadLine().ToLower();
                if (command.StartsWith("drives"))
                {
                    foreach (var disk in DriveInfo.GetDrives())
                    {
                        if (disk.IsReady == true)
                        {
                            Console.WriteLine("Drive: " + disk.Name + " Total size: " + disk.TotalSize + " Av space: " + disk.AvailableFreeSpace);
                        }
                    }

                }
                else if (command.StartsWith("dir"))
                {
                    Console.WriteLine("Directories");
                    foreach (var dir in di.EnumerateDirectories())
                    {
                        Console.WriteLine("Name: " + dir.Name + " Time: " + dir.CreationTime);
                    }
                    Console.WriteLine();
                    Console.WriteLine("Files");
                    foreach (var file in di.EnumerateFiles())
                    {
                        Console.WriteLine("Name: " + file.Name + " Time: " + file.CreationTime + " Size: " + file.Length);
                    }
                }
                else if (command.StartsWith("cd"))
                {
                    position = command.Substring(3);
                    di = new DirectoryInfo(@position);
                    while (!di.Exists)
                    {
                        Console.WriteLine("Can't find path");
                        Console.Write("Enter starting position: ");
                        position = Console.ReadLine();
                        di = new DirectoryInfo(@position);
                    }
                }
                else if (command.StartsWith("exit"))
                {
                    break;
                }
            }
        }
    }
}
