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
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

/**
 *
 * @author 97pib
 */
public class DialogStudent extends JDialog {

    private JPanel buttonPanel = new JPanel();
    private JPanel inputPanel = new JPanel();
    private JButton btnOk;
    private JButton btnCancel;

    private JTextField txtFirst;
    private JTextField txtSecond;
    private JLabel lbFirst;
    private JLabel lbSecond;

    private GradeReport result;

    public DialogStudent(JFrame parentFrame, GradeReport p) {
        super(parentFrame);
        setTitle("Student");

        lbFirst = new JLabel("Name");
        lbSecond = new JLabel("Program");
        txtFirst = new JTextField();
        txtFirst.setColumns(20);
        txtSecond = new JTextField();
        txtSecond.setColumns(20);

        if (p != null) {
            result = p;
            txtFirst.setText(p.getName());
            txtSecond.setText(p.getProgram());
        } else {
            result = null;
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
            if (result != null
                    && txtFirst.getText().length() != 0
                    && txtSecond.getText().length() != 0) {
                result.setName(txtFirst.getText());
                result.setProgram(txtSecond.getText());
            } else if (txtFirst.getText().length() != 0
                    && txtSecond.getText().length() != 0) {
                result = new GradeReport(txtFirst.getText(), txtSecond.getText());
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

    public GradeReport getResult() {
        return result;
    }
}
