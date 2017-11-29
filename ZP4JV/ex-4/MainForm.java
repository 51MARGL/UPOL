/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg4;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.KeyEvent;
import javax.swing.DefaultListModel;
import javax.swing.JFrame;
import javax.swing.JList;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.KeyStroke;

/**
 *
 * @author 97pib
 */
public class MainForm extends JFrame {

    private JPanel mainPanel;
    private JMenuBar mainMenu;

    private JList<GradeReport> mainList;
    private DefaultListModel<GradeReport> listModel;

    public MainForm() {
        super();
        setTitle("MySTAG");
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        mainPanel = new JPanel(new BorderLayout());
        listModel = new DefaultListModel<GradeReport>();
        mainList = new JList<GradeReport>(listModel);
        JScrollPane listScroller = new JScrollPane(mainList);
        mainPanel.add(listScroller, BorderLayout.CENTER);

        addMenu();
        addtTest();

        setContentPane(mainPanel);
        setPreferredSize(new Dimension(400, 200));
        pack();
    }

    private void addMenu() {
        mainMenu = new JMenuBar();
        JMenu menuFile = new JMenu("Student");
        menuFile.setMnemonic(KeyEvent.VK_S);

        JMenuItem menuItemAddS = new JMenuItem("Add");
        menuItemAddS.addActionListener((ActionEvent e) -> {
            DialogStudent dlg = new DialogStudent(this, null);
            dlg.setModal(true);
            dlg.setVisible(true);
            dlg.dispose();
            if (dlg.getResult() != null) {
                listModel.addElement(dlg.getResult());
            }
        });

        menuFile.add(menuItemAddS);
        JMenuItem menuItemEditS = new JMenuItem("Edit");
        menuItemEditS.addActionListener((ActionEvent e) -> {
            if (mainList.getSelectedIndex() != -1) {
                DialogStudent dlg = new DialogStudent(this, mainList.getSelectedValue());
                dlg.setModal(true);
                dlg.setVisible(true);
                dlg.dispose();
                if (dlg.getResult() != null) {
                    if (!mainList.getSelectedValue().equals(dlg.getResult())) {
                        listModel.addElement(dlg.getResult());
                    }
                }
            } else {
                showSelectMessage();
            }
        });
        menuFile.add(menuItemEditS);

        JMenuItem menuItemRemoveS = new JMenuItem("Remove");
        menuItemRemoveS.addActionListener((ActionEvent e) -> {
            if (mainList.getSelectedIndex() != -1) {
                DialogConfirm dlg = new DialogConfirm();
                dlg.setModal(true);
                dlg.setVisible(true);
                dlg.dispose();
                if (dlg.getResult()) {
                    listModel.remove(mainList.getSelectedIndex());
                }
            } else {
                showSelectMessage();
            }
        });
        menuFile.add(menuItemRemoveS);

        JMenuItem menuItemExit = new JMenuItem("Exit");
        menuItemExit.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_X, ActionEvent.CTRL_MASK));
        menuItemExit.addActionListener((ActionEvent e) -> {
            setVisible(false);
            dispose();
        });
        menuFile.add(menuItemExit);
        mainMenu.add(menuFile);

        JMenu menuReport = new JMenu("Grade Report");
        menuReport.setMnemonic(KeyEvent.VK_G);

        JMenuItem menuItemShow = new JMenuItem("Show/Edit...");
        menuItemShow.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_E, ActionEvent.CTRL_MASK));
        menuItemShow.addActionListener(e -> {
            if (mainList.getSelectedIndex() != -1) {
                DialogShow dlg = new DialogShow(listModel.get(mainList.getSelectedIndex()));
                dlg.setModal(true);
                dlg.setVisible(true);
                dlg.dispose();
            } else {
                showSelectMessage();
            }
        });
        menuReport.add(menuItemShow);
        mainMenu.add(menuReport);

        setJMenuBar(mainMenu);
    }

    private void showSelectMessage() {
        JOptionPane.showMessageDialog(new JFrame(),
                "Select first",
                "Warning",
                JOptionPane.WARNING_MESSAGE);
    }

    private void addtTest() {
        GradeReport test = new GradeReport();
        Course courseTest = new Course();
        courseTest.setName("UFO-technology");
        courseTest.setCredits("10");
        test.setName("Fox Mulder");
        test.setProgram("X-Files");
        test.addCourse(courseTest);
        listModel.addElement(test);
        GradeReport test2 = new GradeReport();
        test2.setName("Dana Scully");
        test2.setProgram("X-Files");
        listModel.addElement(test2);
    }
}
