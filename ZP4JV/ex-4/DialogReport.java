/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg4;

import java.awt.BorderLayout;
import java.awt.GridLayout;
import javax.swing.GroupLayout;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

/**
 *
 * @author 97pib
 */
public class DialogReport extends JDialog {

    private JPanel buttonPanel = new JPanel();
    private JPanel inputPanel = new JPanel();
    private JButton btnOk;
    private JButton btnCancel;

    private JTextField txtFirst;
    private JTextField txtSecond;
    private JLabel lbFirst;
    private JLabel lbSecond;

    private boolean result = false;

    public DialogReport(GradeReport p, Course c) {
        setTitle("Courses");

        lbFirst = new JLabel("Course Name");
        lbSecond = new JLabel("Credits");
        txtFirst = new JTextField();
        txtFirst.setColumns(20);
        txtSecond = new JTextField();
        txtSecond.setColumns(20);
        
        if (c != null) {
            txtFirst.setText(c.getName());
            txtSecond.setText(c.getCredits());
        }
        GroupLayout layout = new GroupLayout(inputPanel);
        inputPanel.setLayout(layout);
        layout.setAutoCreateContainerGaps(true);
        layout.setAutoCreateGaps(true);
        layout.setHorizontalGroup(
                layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup()
                        .addComponent(lbFirst)
                        .addComponent(lbSecond))
                .addGroup(layout.createParallelGroup()
                        .addComponent(txtFirst)
                        .addComponent(txtSecond)));

        layout.setVerticalGroup(
                layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup()
                        .addComponent(lbFirst)
                        .addComponent(txtFirst))
                .addGroup(layout.createParallelGroup()
                        .addComponent(lbSecond)
                        .addComponent(txtSecond)));

        inputPanel.add(lbFirst);
        inputPanel.add(txtFirst);

        GridLayout btnLayout = new GridLayout(1, 2);

        btnOk = new JButton("Ok");
        btnOk.addActionListener(e -> {
            if (p != null
                    && txtFirst.getText().length() != 0
                    && txtSecond.getText().length() != 0) {
                p.getCourses().remove(c);
                p.addCourse(new Course(txtFirst.getText(), txtSecond.getText()));
                result = true;
            }
            setVisible(false);
        });

        btnCancel = new JButton("Cancel");
        btnCancel.addActionListener(e -> {
            setVisible(false);
        });
        buttonPanel.setLayout(btnLayout);
        buttonPanel.add(btnOk);
        buttonPanel.add(btnCancel);

        getContentPane().setLayout(new BorderLayout());
        getContentPane().add(inputPanel, BorderLayout.CENTER);
        getContentPane().add(buttonPanel, BorderLayout.SOUTH);

        pack();
    }

    public boolean getResult() {
        return result;
    }
}
