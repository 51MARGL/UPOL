/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg6;


import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import javax.swing.JComponent;

public class SortPaint extends JComponent {

	private int length;
	private int[] array;
	private int pointSize = 5;
	
	public SortPaint(int length) {
		this.length = length;
	}

	public synchronized void setArray(int[] array) {
		this.array = array;
	}

	@Override
	public synchronized void paintComponent(Graphics g) {
		Graphics2D g2 = (Graphics2D) g;
		g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
		g2.setColor(Color.RED);
		
		for (int i = 0; i < array.length; i++)
			g2.fillOval(i * this.getWidth() / length, array[i] * this.getHeight() / length, pointSize, pointSize);
	}
}
