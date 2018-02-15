/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg3;

import java.awt.BorderLayout;

import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextField;
import javax.swing.KeyStroke;

/**
 *
 * @author 97pib
 */
public class Savings extends JFrame {

    private JPanel mainPanel;
    private JMenuBar mainMenu;
    private JMenu menuFile;
    private JTextField txtTop1;
    private JTextField txtTop2;
    private JTextField txtTop3;
    private JTextField txtTop4;
    private JButton calcBtn;
    private JButton clearButton;
    private JScrollPane pane;
    private JPanel results;

    public Savings() {

        this.setTitle("Výpočet spoření");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        mainPanel = new JPanel(new BorderLayout());
        mainPanel.setBackground(java.awt.Color.WHITE);
        addMenuBar();
        addEnterLines();
        addPaneResult();
        setContentPane(mainPanel);
        setSize(400, 450);
        setVisible(true);
    }

    private void addPaneResult() {
        results = new JPanel();
        results.setLayout(new BoxLayout(results, BoxLayout.Y_AXIS));
        pane = new JScrollPane(results);
        mainPanel.add(pane, BorderLayout.CENTER);
        
        clearButton = new JButton("Smazat");
        clearButton.addActionListener((ActionEvent e) -> {
            results.removeAll();
            setContentPane(mainPanel);
        });
        
        mainPanel.add(clearButton, BorderLayout.SOUTH);
    }

    private void addMenuBar() {
        mainMenu = new JMenuBar();
        menuFile = new JMenu("Operace");
        menuFile.setMnemonic(KeyEvent.VK_F);

        JMenuItem menuItem = new JMenuItem("Výpočitat");
        menuItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_W, ActionEvent.CTRL_MASK));
        menuItem.addActionListener((ActionEvent e) -> {
            calculate(txtTop1.getText(), txtTop2.getText(), txtTop3.getText(), txtTop4.getText());
        });
        menuFile.add(menuItem);

        JMenuItem menuItemClear = new JMenuItem("Smazat");
        menuItemClear.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_S, ActionEvent.CTRL_MASK));
        menuItemClear.addActionListener((ActionEvent e) -> {
            results.removeAll();
            setContentPane(mainPanel);
        });
        menuFile.add(menuItemClear);

        JMenuItem menuItemExit = new JMenuItem("Exit");
        menuItemExit.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_X, ActionEvent.CTRL_MASK));
        menuItemExit.addActionListener((ActionEvent e) -> {
            setVisible(false);
            dispose();
        });
        menuFile.add(menuItemExit);
        mainMenu.add(menuFile);
        setJMenuBar(mainMenu);

    }

    private void addEnterLines() {
        txtTop1 = new JTextField("0");
        JLabel labelTop1 = new JLabel("Počáteční zůstatek na účtu");
        txtTop2 = new JTextField("0");
        JLabel labelTop2 = new JLabel("Urok p.a. (celoroční)");
        txtTop3 = new JTextField("0");
        JLabel labelTop3 = new JLabel("Měsíční úložka");
        txtTop4 = new JTextField("0");
        JLabel labelTop4 = new JLabel("Počet měsíců spoření");

        calcBtn = new JButton("Výpočitat");
        calcBtn.addActionListener((ActionEvent e) -> {
            calculate(txtTop1.getText(), txtTop2.getText(), txtTop3.getText(), txtTop4.getText());
        });

        JPanel topPanel = new JPanel(new BorderLayout());
        topPanel.add(calcBtn, BorderLayout.EAST);
        JPanel lines = new JPanel(new GridLayout(4, 2));

        lines.add(labelTop1);
        lines.add(txtTop1);
        lines.add(labelTop2);
        lines.add(txtTop2);
        lines.add(labelTop3);
        lines.add(txtTop3);
        lines.add(labelTop4);
        lines.add(txtTop4);
        topPanel.add(lines, BorderLayout.NORTH);

        mainPanel.add(topPanel, BorderLayout.NORTH);
    }

    private void addResults(double a, double b, double c, int i) {

        DecimalFormat df = new DecimalFormat("#.##");
        df.setRoundingMode(RoundingMode.CEILING);

        JLabel labelRes11 = new JLabel("Aktuální zůstatek: " + df.format(a));
        JLabel labelRes12 = new JLabel("Připsané úroky za daný měsíc: " + df.format(b));
        JLabel labelRes13 = new JLabel("Zaplacená daň za daný měsíc: " + df.format(c));

        results.add(new JLabel("Měsíc №: " + String.valueOf(i)));
        results.add(labelRes11);
        results.add(labelRes12);
        results.add(labelRes13);
        results.add(new JLabel(new String(new char[80]).replace('\0', '-')));

        setContentPane(mainPanel);
    }

    private void calculate(String startValue, String perc, 
            String perMonth, String monthCount) {
        try {
            double startV = Double.valueOf(startValue);
            double per = Double.valueOf(perc);
            double perM = Double.valueOf(perMonth);
            double monthC = Double.valueOf(monthCount);
            double currentBalance = startV;

            for (int i = 0; i < monthC; i++) {
                currentBalance += perM;
                double urok = (currentBalance * per * 30) / (100 * 365);
                double dan = urok * 0.15;
                urok -= dan;
                currentBalance += urok;
                addResults(currentBalance, urok, dan, i + 1);
            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(this,
                    "Wrong values\n"
                    + e.getMessage(),
                    "Calculating error",
                    JOptionPane.ERROR_MESSAGE);
        }

    }
}
