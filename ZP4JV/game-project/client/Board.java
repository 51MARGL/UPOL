/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package maze.client;

import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.TexturePaint;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;
import javax.swing.JPanel;

/**
 *
 * @author 97pib
 */
class Board extends JPanel { 

    private final int OFFSET = 50;
    private final int SPACE = 50;
    private final int LEFT_COLLISION = 1;
    private final int RIGHT_COLLISION = 2;
    private final int TOP_COLLISION = 3;
    private final int BOTTOM_COLLISION = 4;
    private PrintWriter out;

    private ArrayList walls = new ArrayList();
    private Area area;
    private ArrayList floors = new ArrayList();
    public Player player1;
    public Player player2;
    public Player you;
    public Player opponent;
    private int w = 0;
    private int h = 0;
    private boolean completed = false;
    public boolean youCanMove = false;
    
    private final String level =
              "                         # \n"
            + "#########################2## \n"
            + "#        #   #             # \n"
            + "###### #  #  # ###### ###### \n"
            + "#       # #  #  ##  #      # \n"
            + "# ##### # #   #     #####  # \n"
            + "##    # # # # ##### #    # # \n"
            + "#  ## # #   # .   #   #  # # \n"
            + "#   # #  ###  ###  ##### # # \n"
            + "#   # ##   # #           # # \n"
            + "##  #      #  #  ## ### ## # \n"
            + "#  ##### ####  ###  #    # # \n"
            + "#     #          #  #      # \n"
            + "#1########################## \n"
            + " #\n";

    public Board(PrintWriter out) {
        this.out = out;
        addKeyListener(new TAdapter());
        setFocusable(true);
        
        initWorld();
    }

    public int getBoardWidth() {
        return this.w;
    }

    public int getBoardHeight() {
        return this.h;
    }

    public final void initWorld() {
        
        int x = OFFSET;
        int y = OFFSET;
        
        Wall wall;
        Floor f;


        for (int i = 0; i < level.length(); i++) {

            char item = level.charAt(i);

            switch (item) {
                case '\n':
                    y += SPACE;
                    if (this.w < x) {
                        this.w = x;
                    }   x = OFFSET;
                    break;
                case '#':
                    wall = new Wall(x, y);
                    walls.add(wall);
                    x += SPACE;
                    break;
                case '.':
                    area = new Area(x, y);
                    x += SPACE;
                    break;
                case '1':
                    player1 = new Player(x, y, item);
                    x += SPACE;
                    break;
                case '2':
                    player2 = new Player(x, y, item);
                    x += SPACE;
                    break;    
                default:
                    f = new Floor(x,y);
                    floors.add(f);
                    x += SPACE;
                    break;
            }
            h = y;
        }
    }

    public void buildWorld(Graphics g) throws IOException {
        BufferedImage floor;
        floor = ImageIO.read(this.getClass()
                .getClassLoader().getResource("floor.gif"));
        Graphics2D g2d = (Graphics2D) g.create();

        TexturePaint floorTP = new TexturePaint(floor, 
                new Rectangle(0, 0, 50, 50));
        g2d.setPaint(floorTP);
        g2d.fillRect(0, 0, this.getBoardWidth(), this.getBoardHeight());

        ArrayList world = new ArrayList();
        world.addAll(walls);
        world.add(area);
        world.add(player1);
        world.add(player2);

        for (int i = 0; i < world.size(); i++) {
            Actor item = (Actor) world.get(i);
            g.drawImage(item.getImage(), item.x(), item.y(), this);
        }
    }

    @Override
    public void paint(Graphics g) {
        super.paint(g);
        try {
            buildWorld(g);
        } catch (IOException ex) {
            Logger.getLogger(Board.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void moveOpponent(int location) {
        switch (location) {
            case 1:
                opponent.move(-SPACE, 0);
                break;
            case 2:
                opponent.move(SPACE, 0);
                break;
            case 3:
                opponent.move(0, -SPACE);
                break;
            case 4:
                opponent.move(0, SPACE);
                break;
            default:
                break;
        }
        repaint();
    }
    class TAdapter extends KeyAdapter {

        @Override
        public void keyPressed(KeyEvent e) {

            if (!youCanMove) {
                return;
            }

            int key = e.getKeyCode();
            switch (key) {
                case KeyEvent.VK_LEFT:
                    if (checkWallCollision(you,
                            LEFT_COLLISION)) {
                        return;
                    }   
                    you.move(-SPACE, 0);
                    out.println("MOVE " + 1);
                    break;
                case KeyEvent.VK_RIGHT:
                    if (checkWallCollision(you,
                            RIGHT_COLLISION)) {
                        return;
                    }   
                    you.move(SPACE, 0);
                    out.println("MOVE " + 2);
                    break;
                case KeyEvent.VK_UP:
                    if (checkWallCollision(you,
                            TOP_COLLISION)) {
                        return;
                    }   
                    you.move(0, -SPACE);
                    out.println("MOVE " + 3);
                    break;
                case KeyEvent.VK_DOWN:
                    if (checkWallCollision(you,
                            BOTTOM_COLLISION)) {
                        return;
                    }   
                    you.move(0, SPACE);
                    out.println("MOVE " + 4);
                    break;
                default:
                    break;
            }
            isCompleted();
            if (completed) {
                out.println("WINNER");
            }
            repaint();
        }
    }

    private boolean checkWallCollision(Actor actor, int type) {

        switch (type) {
            case LEFT_COLLISION:
                for (int i = 0; i < walls.size(); i++) {
                    Wall wall = (Wall) walls.get(i);
                    if (actor.isLeftCollision(wall)) {
                        return true;
                    }
                }
                return false;
            case RIGHT_COLLISION:
                for (int i = 0; i < walls.size(); i++) {
                    Wall wall = (Wall) walls.get(i);
                    if (actor.isRightCollision(wall)) {
                        return true;
                    }
                }
                return false;
            case TOP_COLLISION:
                for (int i = 0; i < walls.size(); i++) {
                    Wall wall = (Wall) walls.get(i);
                    if (actor.isTopCollision(wall)) {
                        return true;
                    }
                }
                return false;
            case BOTTOM_COLLISION:
                for (int i = 0; i < walls.size(); i++) {
                    Wall wall = (Wall) walls.get(i);
                    if (actor.isBottomCollision(wall)) {
                        return true;
                    }
                }
                return false;
            default:
                break;
        }
        return false;
    }


    public void isCompleted() {
        if (you.x() == area.x()
                && you.y() == area.y()) {
            completed = true;
            repaint();
        }
    }

    public void restartLevel() {
        floors.clear();
        walls.clear();
        initWorld();
        if (completed) {
            completed = false;
        }
    }
}