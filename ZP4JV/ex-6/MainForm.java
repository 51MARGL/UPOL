/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg6;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.util.ArrayList;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JSlider;
import javax.swing.SwingConstants;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

/**
 *
 * @author 97pib
 */
public class MainForm extends JFrame implements SortListener {

    public static int ARRAY_SIZE = 1000;

    public JPanel btnPanel;
    public JButton ShuffleBtn;
    public JButton ResumeBtn;
    public JButton PauseBtn;
    public SortThread sortT;
    public SortPaint sortP;
    JSlider sliderSpeed;

    public MainForm() {
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setLayout(new BorderLayout());
        setTitle("SortApp");
        setMinimumSize(new Dimension(400, 300));
        setPreferredSize(new Dimension(500, 400));

        sortP = new SortPaint(ARRAY_SIZE);
        sortT = new SortThread();
        sortT.addListener(this);

        btnPanel = new JPanel(new GridLayout(2, 3));

        addButtons();

        add(btnPanel, BorderLayout.SOUTH);
        add(sortP, BorderLayout.CENTER);

        pack();
    }

    public void addButtons() {
        sliderSpeed = new JSlider(JSlider.HORIZONTAL,
                0, 100, 5);
        sliderSpeed.addChangeListener(sortT);
        sliderSpeed.setMinorTickSpacing(1);
        sliderSpeed.setPaintTicks(true);

        ShuffleBtn = new JButton("Shuffle");
        ShuffleBtn.addActionListener((ActionEvent e) -> {
            PauseBtn.setEnabled(false);
            ResumeBtn.setEnabled(true);
            sortT.Shuffle();
            sortP.repaint();
        });

        ResumeBtn = new JButton("Resume");
        ResumeBtn.addActionListener((ActionEvent e) -> {
            ResumeBtn.setEnabled(false);
            PauseBtn.setEnabled(true);
            ShuffleBtn.setEnabled(false);
            if (sortT.isAlive()) {
                sortT.resumeThread();
            } else {
                sortT.start();
            }
        });
        (PauseBtn = new JButton("Pause")).setEnabled(false);
        PauseBtn.addActionListener((ActionEvent e) -> {
            ResumeBtn.setEnabled(true);
            PauseBtn.setEnabled(false);
            ShuffleBtn.setEnabled(false);
            try {
                sortT.pauseThread();
            } catch (InterruptedException ex) {
            }
        });

        btnPanel.add(ShuffleBtn);
        btnPanel.add(ResumeBtn);
        btnPanel.add(PauseBtn);
        btnPanel.add(new JLabel("Slowdown:", SwingConstants.RIGHT));
        btnPanel.add(sliderSpeed);
    }

    @Override
    public void Sorted() {
        PauseBtn.setEnabled(false);
        ResumeBtn.setEnabled(false);
        ShuffleBtn.setEnabled(true);
        int[] sorted = sortT.getArray();
        sortT = new SortThread(sorted);
        sortT.addListener(this);
        sliderSpeed.addChangeListener(sortT);
    }

    public class SortThread extends Thread implements ChangeListener {

        private final ArrayList<SortListener> listeners;

        private int[] array;
        private int timeToWait = 5;
        private final Object pauseMonitor = new Object();
        private boolean pauseThreadFlag = false;

        public SortThread() {
            try{
                timeToWait = (int) sliderSpeed.getValue();
            } catch (Exception e){
                timeToWait = 5;
            }
            this.listeners = new ArrayList<>();
            array = new int[ARRAY_SIZE];
            Random r = new Random();
            for (int i = 0; i < array.length - 1; i++) {
                array[i] = r.nextInt(array.length);
            }
            sortP.setArray(array);
        }
        
        public SortThread(int[] array) {
            try{
                timeToWait = (int) sliderSpeed.getValue();
            } catch (Exception e){
                timeToWait = 5;
            }
            this.listeners = new ArrayList<>();
            this.array = array;
            sortP.setArray(array);
        }

        public synchronized void addListener(SortListener listener) {
            listeners.add(listener);
        }

        public synchronized void Shuffle() {
            Random r = new Random();
            for (int i = 0; i < array.length - 1; i++) {
                int newIndex = r.nextInt(i + 1);
                int a = array[i];
                array[i] = array[newIndex];
                array[newIndex] = a;
            }
        }

        @Override
        public void run() {
            SelectSort();
        }

        private void checkForPaused() {
            synchronized (pauseMonitor) {
                while (pauseThreadFlag) {
                    try {
                        pauseMonitor.wait();
                    } catch (Exception e) {
                    }
                }
            }
        }

        public synchronized void pauseThread() throws InterruptedException {
            pauseThreadFlag = true;
        }

        public synchronized void resumeThread() {
            synchronized (pauseMonitor) {
                pauseThreadFlag = false;
                pauseMonitor.notify();
            }
        }

        void SelectSort() {
            for (int i = 0; i < array.length - 1; i++) {
                int maxIndex = i;
                for (int j = i + 1; j < array.length; j++) {
                    checkForPaused();

                    if (array[j] > array[maxIndex]) {
                        maxIndex = j;
                    }
                }
                int temp = array[i];
                array[i] = array[maxIndex];
                array[maxIndex] = temp;
                try {
                    Thread.sleep(timeToWait);
                } catch (InterruptedException ex) {
                    Logger.getLogger(MainForm.class.getName()).log(Level.SEVERE, null, ex);
                }
                sortP.repaint();
            }
            
            for (SortListener listener : listeners) {
                listener.Sorted();
            }
        }

        @Override
        public synchronized void stateChanged(ChangeEvent e) {
            JSlider source = (JSlider) e.getSource();
            timeToWait = (int) source.getValue();
        }
        
        public synchronized int[] getArray(){
            return array;
        }
    }
}
