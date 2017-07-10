/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg4;

import java.awt.*;

import javax.swing.*;

public class DialogShow extends JDialog {

    private static final long serialVersionUID = 75421423L;

    private JPanel buttonPanel = new JPanel();
    private JButton buttonOk;
    private JButton buttonAdd;
    private JButton buttonGrade;
    private JButton buttonDel;
    private JButton buttonEdit;
    private JPanel mainPanel;
    private JButton buttonCancel;

    private JList<Course> courseList;
    private DefaultListModel<Course> listModel;

    public DialogShow(GradeReport p) {
        setTitle("Courses");
        mainPanel = new JPanel();

        listModel = new DefaultListModel<Course>();
        for (Course a : p.getCourses()) {
            listModel.addElement(a);
        }
        courseList = new JList<Course>(listModel);

        buttonOk = new JButton("OK");
        buttonOk.addActionListener(e -> {
            setVisible(false);
        });

        buttonAdd = new JButton("Add");
        buttonAdd.addActionListener(e -> {
            DialogReport dlg = new DialogReport(p, null);
            dlg.setModal(true);
            dlg.setVisible(true);
            if (dlg.getResult()) {
                listModel.addElement(p.getCourses().get(p.getCourses().size() - 1));
            }
            dlg.dispose();
        });

        buttonEdit = new JButton("Edit");
        buttonEdit.addActionListener(e -> {
            if (courseList.getSelectedIndex() != -1) {
                DialogReport dlg = new DialogReport(p, courseList.getSelectedValue());
                dlg.setModal(true);
                dlg.setVisible(true);
                if (dlg.getResult()) {
                    listModel.remove(courseList.getSelectedIndex());
                    listModel.addElement(p.getCourses().get(p.getCourses().size() - 1));
                }
                dlg.dispose();
            } else {
                showSelectMessage();
            }
        });

        buttonGrade = new JButton("Graduate");
        buttonGrade.addActionListener(e -> {
            if (courseList.getSelectedIndex() != -1) {
                DialogGraduate dlg = new DialogGraduate(listModel.get(courseList.getSelectedIndex()));
                dlg.setModal(true);
                dlg.setVisible(true);
                dlg.dispose();
                if (dlg.getResult() != null) {
                    listModel.remove(courseList.getSelectedIndex());
                    listModel.addElement(dlg.getResult());
                }
            } else {
                showSelectMessage();
            }
        });

        buttonDel = new JButton("Remove");
        buttonDel.addActionListener(e -> {
            if (courseList.getSelectedIndex() != -1) {
                DialogConfirm dlg = new DialogConfirm();
                dlg.setModal(true);
                dlg.setVisible(true);
                dlg.dispose();
                if (dlg.getResult()) {
                    Course cr = listModel.get(courseList.getSelectedIndex());
                    p.getCourses().remove(cr);
                    listModel.remove(courseList.getSelectedIndex());
                }
            } else {
                showSelectMessage();
            }
        });

        buttonCancel = new JButton("Cancel");
        buttonCancel.addActionListener(e -> {
            setVisible(false);
        });

        GridLayout btnLayout = new GridLayout(3, 2);

        buttonPanel.setLayout(btnLayout);
        buttonPanel.add(buttonAdd);
        buttonPanel.add(buttonEdit);
        buttonPanel.add(buttonGrade);
        buttonPanel.add(buttonDel);
        buttonPanel.add(buttonOk);
        buttonPanel.add(buttonCancel);

        mainPanel.setLayout(new BorderLayout());
        mainPanel.add(buttonPanel, BorderLayout.SOUTH);
        JScrollPane listScroller = new JScrollPane(courseList);
        mainPanel.add(listScroller, BorderLayout.CENTER);

        setContentPane(mainPanel);
        setPreferredSize(new Dimension(400, 400));
        pack();
    }

    private void showSelectMessage() {
        JOptionPane.showMessageDialog(new JFrame(),
                "Select first",
                "Warning",
                JOptionPane.WARNING_MESSAGE);
    }
}
