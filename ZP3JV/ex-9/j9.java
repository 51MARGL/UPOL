    /*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package kudryashov.zp3jv.s09;
import java.io.*;
import java.util.Scanner;
import java.util.stream.Stream;
/**
 * <h1>9. Task of ZP3JV</h1>
 * The j9 program works with I/O streams
 * @author Serhiy Kudryashov
 * @version 1.0 16/11/2016
 */
public class j9 {

    /**
     * Prints matrix
     * @param m given matrix
     * @throws Exception if matrix is empty
     */
    public static void printMatrix(int[][] m) throws Exception {
        try{
            int rows = m.length;
            int columns = m[0].length;
            String str = "| ";
            for(int i = 0; i < rows; i++){
                for(int j = 0;j < columns; j++){
                    str += m[i][j] + " ";
                }
                System.out.println(str + "|");
                str = "| ";
            }

        } catch(Exception e){
            System.out.println("Matrix is empty!!");
        }
    }
    
    /**
     * Reads matrix from text file
     * @param r Reader
     * @return matrix from file
     * @throws IOException if reading error occurred
     */
    static public int[][] readTextMatrix(Reader r) throws IOException {
        int[][] matrix = null;
        try (BufferedReader buffer = new BufferedReader(r)) {
            matrix = buffer.lines()
                    .map((l)->l.trim().split("\\s+"))
                    .map((s)->Stream.of(s)
                            .mapToInt(Integer::parseInt)
                            .toArray())
                    .toArray(int[][]::new);
        } catch (Exception e) {
            System.out.println("Error:" + e.getMessage());
        }
        return matrix;
    }
    
    /**
     * Writes matrix to text file
     * @param w Writer
     * @param matrix given matrix
     * @throws IOException if writing error occurred
     */
    public static void writeTextMatrix(Writer w, int[][] matrix) 
            throws IOException {
        try (BufferedWriter buffer = new BufferedWriter(w)) {
            for (int i = 0; i < matrix.length; i++) {
		for (int j = 0; j < matrix[0].length; j++) {
                    buffer.write(matrix[i][j] + " ");
                }
                buffer.newLine();
            }
	} catch (Exception e) {
            System.out.print("Error:" + e.getMessage());
	}
    }
    
    /**
     * Writes matrix to binary file
     * @param s output stream
     * @param matrix given matrix
     * @throws IOException if writing error occurred
     */
    public static void writeBinaryMatrix(OutputStream s, int[][] matrix) 
            throws IOException {
	try (DataOutputStream out = new DataOutputStream(s)) {
            out.writeInt(matrix.length);
            out.writeInt(matrix[0].length);
            for (int i = 0; i < matrix.length; i++)
                for (int j = 0; j < matrix[i].length; j++)
                    out.writeInt(matrix[i][j]);
	} catch (Exception e) {
            System.out.println("Error:" + e.getMessage());
	}
    }
    
    /**
     * Reads matrix from binary file
     * @param s input stream
     * @return matrix from file
     * @throws IOException if reading error occurred
     */
    public static int[][] readBinaryMatrix(InputStream s) throws IOException {
	int[][] resmatrix = null;
        DataInputStream in = null;
        int rows = 0;
        int cols = 0;
	try {
            in = new DataInputStream(s);
            rows = in.readInt();
            cols = in.readInt();
            resmatrix = new int[rows][cols];
            for (int i = 0; i < rows; i++)
		for (int j = 0; j < cols; j++)
                    resmatrix[i][j] = in.readInt();
	} catch (Exception e) {
            System.out.println(e);
	} finally {
            if (in != null){
                in.close();   
            }
        }
        return resmatrix;
    }
    
    /**
     * Tests
     * @param args the command line arguments
     * @throws IOException if smth went wrong with file
     */
    public static void main(String[] args) throws IOException, Exception {
        int[][] m = {
            {1, 2, 3},
            {4, 5, 6},
            {7, 8, 9},
            {1, 1, 2}
        };
        
        FileReader inputStream = null;
        StringReader sr = null;
        FileWriter fw = null;
        StringWriter sw = null;
        try {
            fw = new FileWriter("src/kudryashov/myMatrix.txt");
            writeTextMatrix(fw, m);
            sw = new StringWriter();
            writeTextMatrix(sw, m);
            System.out.print("StringWriter:\n" + sw.toString());
            
            File f = new File("src/kudryashov/myMatrix.txt");
            inputStream = new FileReader(f);
            sr = new StringReader(new Scanner(f)
                    .useDelimiter("\\A")
                    .next());
            
            System.out.println("FileReader:");
            printMatrix(readTextMatrix(inputStream));
            System.out.println("SringReader:");
            printMatrix(readTextMatrix(sr));
        } catch (Exception e) {
            System.out.println("Error:" + e.getMessage());
        } finally {
            if (inputStream != null){
                inputStream.close();   
            }
            if (sr != null){
                sr.close();   
            }
            if (fw != null){
                fw.close();   
            }
            if (sw != null){
                sw.close();   
            }
        }
        
        FileOutputStream out = null;
        FileInputStream in = null;
        try {
            out = new FileOutputStream("src/kudryashov/myBinM.dat");
            writeBinaryMatrix(out, m);
            System.out.println("FromBinary:");
            in = new FileInputStream("src/kudryashov/myBinM.dat");
            printMatrix(readBinaryMatrix(in));
        } catch (Exception e){
            System.out.println(e.getMessage());
        } finally {
            if (out != null){
                out.close();   
            }
            if (in != null){
                in.close();   
            }
        }
    }
}
