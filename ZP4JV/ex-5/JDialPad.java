/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg5;

import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import java.awt.event.KeyEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.ArrayList;
import javax.swing.AbstractAction;
import javax.swing.JComponent;
import javax.swing.KeyStroke;

/**
 *
 * @author 97pib
 */
public class JDialPad extends JComponent {

    private int padding = 1;
    private int displayHeight;
    private int displayWidth;
    private int numberHeight;
    private int numberWidth;
    private int numberBlankX = 0;
    private int numberBlankY;

    public JDialDisplay display;
    private JDialButton enter;
    private JDialButton clear;
    private ArrayList<JDialButton> buttonslist;
    private ArrayList<ActionListener> actionList;

    public JDialPad() {
        actionList = new ArrayList<>();
        buttonslist = new ArrayList<>();

        this.addComponentListener(new ComponentAdapter() {
            @Override
            public void componentResized(ComponentEvent e) {
                resize();
            }
        });
    }

    private void resize() {
        if (this.getComponentCount() == 0) {
            addComponents();
        } else {
            displayWidth = this.getWidth() + padding;
            displayHeight = this.getHeight() / 5 + padding;
            display.setBounds(0, 0, displayWidth, displayHeight);

            numberBlankY = display.getHeight() + padding;
            numberHeight = display.getBounds().height;
            numberWidth = display.getBounds().width / 3;

            for (int i = 9, row = 0, column = 2; i >= 0; i--, column--) {

                if (i == 0) {
                    column = 0;
                }

                buttonslist.get(buttonslist.size() - i - 1).setBounds(
                        numberBlankX + column * numberWidth,
                        numberBlankY + row * numberHeight,
                        numberWidth,
                        numberHeight
                );

                if ((i - 1) % 3 == 0) {
                    row++;
                    column = 3;
                }
            }
            clear.setBounds(
                    numberBlankX + numberWidth,
                    numberBlankY + 3 * numberHeight,
                    numberWidth,
                    numberHeight
            );
            enter.setBounds(
                    numberBlankX + 2 * numberWidth,
                    numberBlankY + 3 * numberHeight,
                    numberWidth,
                    numberHeight
            );
        }

    }

    public void addActionListener(ActionListener actionListener) {
        actionList.add(actionListener);
    }

    @Override
    public void paintComponent(Graphics g) {
        Graphics2D g2 = (Graphics2D) g;
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
    }

    public void addComponents() {
        display = new JDialDisplay();
        displayWidth = this.getWidth() + padding;
        displayHeight = this.getHeight() / 5 + padding;
        display.setBounds(0, 0, displayWidth, displayHeight);
        add(display);

        numberBlankY = display.getHeight() + padding;
        numberHeight = display.getBounds().height;
        numberWidth = display.getBounds().width / 3;

        addNumberButtons();
        addCancelButton();
        addEnterButton();

    }

    public void addCancelButton() {
        clear = new JDialButton("C");
        clear.setAction(new AbstractAction() {
            @Override
            public void actionPerformed(ActionEvent e) {
                display.print("");
            }
        });

        clear.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_ESCAPE, 0), "clear");
        clear.getActionMap().put("clear", new AbstractAction() {
            @Override
            public void actionPerformed(ActionEvent e) {
                clear.actionPerformed(null);
            }
        });

        clear.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent me) {
                clear.actionPerformed(null);
            }
        });

        clear.setBounds(
                numberBlankX + numberWidth,
                numberBlankY + 3 * numberHeight,
                numberWidth,
                numberHeight
        );
        add(clear);
    }

    public void addEnterButton() {
        enter = new JDialButton("E");
        enter.setAction(new AbstractAction() {
            @Override
            public void actionPerformed(ActionEvent e) {
                for (ActionListener a : actionList) {
                    a.actionPerformed(e);
                }
            }
        });
        enter.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_ENTER, 0), "enter");
        enter.getActionMap().put("enter", new AbstractAction() {
            @Override
            public void actionPerformed(ActionEvent e) {
                enter.actionPerformed(null);
            }
        });
        enter.addMouseListener(new MouseAdapter() {

            @Override
            public void mouseClicked(MouseEvent me) {
                enter.actionPerformed(null);
            }
        });

        enter.setBounds(
                numberBlankX + 2 * numberWidth,
                numberBlankY + 3 * numberHeight,
                numberWidth,
                numberHeight
        );
        add(enter);
    }

    public void addNumberButtons() {
        for (int i = 9, row = 0, column = 2; i >= 0; i--, column--) {

            if (i == 0) {
                column = 0;
            }

            JDialButton b = new JDialButton(String.valueOf(i));
            b.setAction(new AbstractAction() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    display.concat(b.getButonTxt());
                }
            });
            b.getInputMap(WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(Character.forDigit(i, 10)), "num");
            b.getActionMap().put("num", new AbstractAction() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    b.actionPerformed(new ActionEvent(b, 0, "num"));
                }
            });
            b.addMouseListener(new MouseAdapter() {
                @Override
                public void mouseClicked(MouseEvent me) {
                    b.actionPerformed(new ActionEvent(b, 0, "num"));
                }

            });
            b.setBounds(
                    numberBlankX + column * numberWidth,
                    numberBlankY + row * numberHeight,
                    numberWidth,
                    numberHeight
            );
            add(b);
            buttonslist.add(b);

            if ((i - 1) % 3 == 0) {
                row++;
                column = 3;
            }
        }
    }
}
