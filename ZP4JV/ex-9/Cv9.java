/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg9;

import java.util.Random;
import javafx.animation.Animation;
import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.effect.InnerShadow;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;
import javafx.scene.text.Text;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyEvent;
import javafx.scene.layout.Pane;
import javafx.scene.layout.StackPane;
import javafx.scene.text.Font;
import javafx.stage.Stage;
import javafx.util.Duration;

public class Cv9 extends Application implements Measures {

    Bullet bulletc;
    EnemyBullet bullete;
    Timeline tl;
    Timeline tl2;
    Pane pane = new Pane();
    Ship ship;
    Image enemiesV = new Image(
            "invasore1.gif");
    Image enemiesVI = new Image(
            "invasore2.gif");

    static Rectangle pointer;
    String statusMP;
    ImageView[] enemies;
    static int enemiesCount = 28;
    public int MOV = 0;

    boolean rightEnemy = true;
    boolean bulletIsAlive = false;
    static boolean gameover = false;

    int score = 0;
    int updateTime = 28;
    double speed;
    Text punt = new Text("Score: " + score);

    Text over = new Text("    Game Over \nPress R to Replay");

    public void again() {
        speed = SPEED;
        score = 0;
        over.setVisible(false);
        pane.setOpacity(1);
        gameover = false;
        pointer = new Rectangle();
        if (enemies != null && enemiesCount > 0) {
            for (int i = 0; i < enemies.length; i++) {
                if (enemies[i] != null) {
                    enemies[i].setVisible(false);
                    enemies[i] = null;
                }
            }
        }
        enemiesCount = 28;
        enemies = new ImageView[ENEMY_COLUMN * ENEMY_ROW];
        for (int j = 0; j < ENEMY_ROW; j++) {
            for (int i = 0; i < ENEMY_COLUMN; i++) {
                enemies[j * ENEMY_COLUMN + i] = new ImageView(enemiesV);
                enemies[j * ENEMY_COLUMN + i].setPreserveRatio(true);
                enemies[j * ENEMY_COLUMN + i].setX(i * 50);
                enemies[j * ENEMY_COLUMN + i].setY(j * 50);
                enemies[j * ENEMY_COLUMN + i].setFitWidth(ENEMY_EDGE);
                pane.getChildren().add(enemies[j * ENEMY_COLUMN + i]);
                if (i == ENEMY_COLUMN - 1 && j == 0) {
                    pointer.setWidth(ENEMY_EDGE);
                    pointer.setHeight(ENEMY_EDGE);
                    pointer.setFill(Color.TRANSPARENT);
                    pointer.setX(enemies[i].getX() + ENEMY_EDGE);
                }
            }
        }
        if (tl != null) {
            tl.play();
        }
        if (tl2 != null) {
            tl2.play();
        }
    }

    @Override
    public void start(Stage primaryStage) {
        ship = new Ship(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 10);
        ship.setX(100);
        ship.setY(680);
        Rectangle sh = createShip(ship);
        pane.getChildren().add(sh);
        pane.getChildren().add(punt);
        pane.setStyle("-fx-background-color: #000000");

        StackPane gameStack = new StackPane();
        gameStack.getChildren().addAll(pane, over);
        gameStack.setStyle("-fx-background-color: #696969");

        punt.setFont(Font.font("Verdana", 20));
        punt.setFill(Color.YELLOW);

        over.setFont(Font.font("Verdana", 50));
        over.setFill(Color.RED);
        again();

        punt.setX(10);
        punt.setY(20);

        over.setX(SCREEN_WIDTH / 3);
        over.setY(SCREEN_HEIGHT / 2);

        Duration dI = new Duration(updateTime);
        KeyFrame f = new KeyFrame(dI, e -> {
            if (gameover) {
                gameOver();
            }
            movementCore();
        });
        tl = new Timeline(f);
        tl.setCycleCount(Animation.INDEFINITE);

        tl.play();
        
        Duration dI2 = Duration.seconds(1);
        KeyFrame f2 = new KeyFrame(dI2, e -> {
            enemyShoot();
        });
        tl2 = new Timeline(f2);
        tl2.setCycleCount(Animation.INDEFINITE);

        tl2.play();
        
        Scene scene = new Scene(gameStack, SCREEN_WIDTH, SCREEN_HEIGHT);
        scene.setOnKeyPressed(e -> movementManage(e));
        scene.setOnKeyReleased(e -> shootManage(e));

        primaryStage.setTitle("SpaceInvaders");
        primaryStage.setScene(scene);
        primaryStage.show();

    }

    private Rectangle createShip(Ship sh) {
        Rectangle rect = new Rectangle(sh.getX(), sh.getY(), 30, 50);

        if ((sh.getY() + sh.getX()) % 2 == 0) {
            rect.setFill(Color.DARKRED);
        } else {
            rect.setFill(Color.RED);
        }

        rect.xProperty().bind(sh.getXIntegerProperty());
        rect.yProperty().bind(sh.getYIntegerProperty());

        InnerShadow is = new InnerShadow();
        is.setOffsetY(1.0);
        is.setOffsetX(1.0);
        is.setColor(Color.GRAY);
        rect.setEffect(is);

        return rect;
    }

    public void movementManage(KeyEvent ke) {
        if (ke.getCode() == KeyCode.D && ship.getX() != SCREEN_WIDTH - 40) {
            int x = ship.getX();
            x += 20;
            ship.setX(x);
        } else if (ke.getCode() == KeyCode.A && ship.getX() != 0) {
            int x = ship.getX();
            x -= 20;
            ship.setX(x);
        }
        if (ke.getCode() == KeyCode.R && gameover) {
            again();
        }
    }

    public void shootManage(KeyEvent ke) {
        if (ke.getCode() == KeyCode.SPACE) {
            if (bulletc == null) {
                bulletc = new Bullet(10, 50, ship.getX() - 20, enemies, pane);
            } else if (bulletc != null && !bulletc.bulletIsAlive) {
                bulletc = new Bullet(10, 50, ship.getX() - 20, enemies, pane);
            }
        }
    }

    public void movementCore() {
        speed += 0.01;
        if (rightEnemy) {
            if (pointer.getX() + ENEMY_EDGE >= SCREEN_WIDTH) {
                rightEnemy = false;
                for (ImageView enemie : enemies) {
                    if (enemie != null) {
                        enemie.setY(enemie.getY() + 50);
                        pointer.setY(pointer.getY() + 60 / 18);
                    }
                }
            }
            for (ImageView enemie : enemies) {
                if (enemie != null) {
                    enemie.setX(enemie.getX() + speed); //move the enemy 
                }
            }
            pointer.setX(pointer.getX() + speed); //move the pointer
        } else {
            if (pointer.getX() - ((ENEMY_EDGE * (ENEMY_COLUMN + 2))) <= 0) {
                rightEnemy = true;
                for (ImageView enemie : enemies) {
                    if (enemie != null) {
                        enemie.setY(enemie.getY() + 50);
                        pointer.setY(pointer.getY() + 60 / 18);
                    }
                }
            }
            for (ImageView enemie : enemies) {
                if (enemie != null) {
                    enemie.setX(enemie.getX() - speed);
                }
            }
            pointer.setX(pointer.getX() - speed);
        }
        MOV++;
        if (MOV == 20) {
            for (ImageView enemie : enemies) {
                if (enemie != null) {
                    enemie.setImage(enemiesVI);
                }
            }
        } else if (MOV == 40) { //second frame
            for (ImageView enemie : enemies) {
                if (enemie != null) {
                    enemie.setImage(enemiesV);
                }
            }
            MOV = 0;
        }
        if (bulletc != null) {
            score += bulletc.getScore();
            punt.setText("Score: " + score);
        }

        for (ImageView enemie : enemies) {
            if (enemie != null) {
                if (enemie.getY() - 10 >= ship.getY()) {
                    gameOver();
                }
            }
        }
        if (enemiesCount == 0) {
            gameOver();
        }
    }

    private void gameOver() {
        tl.stop();
        tl2.stop();
        gameover = true;
        pane.setOpacity(0.2);
        over.setVisible(true);
        over.setOpacity(1);
    }

    public static void main(String[] args) {
        launch(args);

    }

    private void enemyShoot() {
        Random r = new Random();
        int randomEnemy = r.nextInt(enemies.length - 1);
        for (int i = randomEnemy; i >= 0; i--) {
            if (enemies[i] != null && ((i <= enemies.length - 1 && i >= enemies.length - 7)
                    || enemies[i + ENEMY_COLUMN] == null)) {
                if (bullete == null) {
                    bullete = new EnemyBullet(10, 50, enemies[i].getX(), enemies[i].getY() + 10, ship, pane);
                } else if (bullete != null && !bullete.bulletIsAlive) {
                    bullete = new EnemyBullet(10, 50, enemies[i].getX(), enemies[i].getY() + 10, ship, pane);
                }
            }
        }
    }
}
