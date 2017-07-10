/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg4;

import java.awt.BorderLayout;
import java.awt.GridLayout;

import javax.swing.*;

public class DialogConfirm extends JDialog {

    private JPanel buttonPanel = new JPanel();
    private JButton btnOk;
    private JButton btnCancel;
    private JLabel labelText;

    private boolean result;

    public DialogConfirm() {
        setTitle("Delete");

        labelText = new JLabel("Are you sure?", SwingConstants.CENTER);

        GridLayout btnLayout = new GridLayout(1, 2);

        btnOk = new JButton("Ok");
        btnOk.addActionListener(e -> {
            result = true;
            setVisible(false);
        });

        btnCancel = new JButton("Cancel");
        btnCancel.addActionListener(e -> {
            result = false;
            setVisible(false);
        });
        buttonPanel.setLayout(btnLayout);
        buttonPanel.add(btnOk);
        buttonPanel.add(btnCancel);

        getContentPane().setLayout(new BorderLayout());
        getContentPane().add(labelText, BorderLayout.CENTER);
        getContentPane().add(buttonPanel, BorderLayout.SOUTH);

        pack();
    }

    public boolean getResult() {
        return result;
    }
}
