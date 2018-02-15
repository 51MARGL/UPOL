/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg7;

import java.util.ArrayList;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicLong;
import javafx.application.Platform;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.ButtonType;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.control.cell.TextFieldTableCell;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Priority;
import javafx.stage.Stage;

/**
 *
 * @author 97pib
 */
public class GradeTable {

    private GradeReport gr;
    private ObservableList<Course> courseList;
    private BorderPane tablePane;
    private TableView<Course> table = new TableView<>();
    private Stage stage;
    private Scene scene;
    private Button addButton;
    private Button deleteButton;

    public GradeTable(GradeReport gr) {
        this.gr = gr;
        courseList = FXCollections.observableArrayList(gr.getCourses());
        stage = new Stage();
        tablePane = new BorderPane();

        stage.setTitle("Grade Table");
        scene = new Scene(tablePane, 350, 350);
        table.setColumnResizePolicy((param) -> true);
        Platform.runLater(() -> customResize(table));

        addResizeListeners();

        stage.setScene(scene);

        addTable();
        addButtons();
        stage.setMinWidth(370);
        stage.setMinHeight(350);
        stage.centerOnScreen();
        stage.show();
    }

    private void addResizeListeners() {
        scene.widthProperty().addListener(e -> {
            table.setColumnResizePolicy((param) -> true);
            Platform.runLater(() -> customResize(table));
        });
        scene.heightProperty().addListener(e -> {
            table.setColumnResizePolicy((param) -> true);
            Platform.runLater(() -> customResize(table));
        });
    }

    private void customResize(TableView<?> view) {
        AtomicLong width = new AtomicLong();
        view.getColumns().forEach(col -> {
            width.addAndGet((long) col.getWidth());
        });
        double tableWidth = view.getWidth();

        view.getColumns().forEach(col -> {
            col.setPrefWidth(col.getWidth()
                    + ((tableWidth - width.get()) / view.getColumns().size()));
        });

    }

    private void addTable() {
        table.setEditable(true);

        TableColumn<Course, String> nameCol
                = new TableColumn<>("Name");
        nameCol.setMinWidth(120);
        nameCol.setCellValueFactory(
                new PropertyValueFactory<>("name"));

        nameCol.setCellFactory(TextFieldTableCell.<Course>forTableColumn());
        nameCol.setOnEditCommit(e -> {
            if (e.getNewValue().length() > 0) {
                ((Course) e.getTableView().getItems().get(
                        e.getTablePosition().getRow())).setName(e.getNewValue());
            } else {
                e.getTableView().getColumns().get(0).setVisible(false);
                e.getTableView().getColumns().get(0).setVisible(true);
            }
        });

        TableColumn<Course, String> creditsCol
                = new TableColumn<>("Credits");
        creditsCol.setMinWidth(50);
        creditsCol.setCellValueFactory(
                new PropertyValueFactory<>("credits"));
        creditsCol.setCellFactory(TextFieldTableCell.<Course>forTableColumn());
        creditsCol.setOnEditCommit(e -> {
            if (e.getNewValue().length() > 0) {
                ((Course) e.getTableView().getItems().get(
                        e.getTablePosition().getRow())).setCredits(e.getNewValue());
            } else {
                e.getTableView().getColumns().get(0).setVisible(false);
                e.getTableView().getColumns().get(0).setVisible(true);
            }
        });

        TableColumn<Course, String> dateCol = new TableColumn<>("Date");
        dateCol.setMinWidth(100);
        dateCol.setCellValueFactory(
                new PropertyValueFactory<>("date"));

        dateCol.setCellFactory(TextFieldTableCell.<Course>forTableColumn());
        dateCol.setOnEditCommit(e -> {
            if (e.getNewValue().length() > 0) {
                ((Course) e.getTableView().getItems().get(
                        e.getTablePosition().getRow())).setDate(e.getNewValue());
            } else {
                e.getTableView().getColumns().get(0).setVisible(false);
                e.getTableView().getColumns().get(0).setVisible(true);
            }
        });

        TableColumn<Course, String> valueCol = new TableColumn<>("Mark");
        valueCol.setMinWidth(100);
        valueCol.setCellValueFactory(
                new PropertyValueFactory<>("value"));

        valueCol.setCellFactory(TextFieldTableCell.<Course>forTableColumn());
        valueCol.setOnEditCommit(e -> {
            if (e.getNewValue().length() > 0) {
                ((Course) e.getTableView().getItems().get(
                        e.getTablePosition().getRow())).setValue(e.getNewValue());
            } else {
                e.getTableView().getColumns().get(0).setVisible(false);
                e.getTableView().getColumns().get(0).setVisible(true);
            }
        });

        table.setItems(courseList);
        table.getColumns().addAll(nameCol, creditsCol, dateCol, valueCol);

        tablePane.setCenter(table);

        table.getSelectionModel().selectedItemProperty().addListener(e -> {
            deleteButton.setDisable(table.getSelectionModel().getSelectedIndex() == -1);
        });

    }

    private void addButtons() {
        addButton = new Button("Add");
        addButton.setMaxSize(Double.MAX_VALUE, Double.MAX_VALUE);
        addButton.setOnAction(e -> {
            CourseDialog dl = new CourseDialog();
            if (dl.getResultCourse() != null) {
                courseList.add(dl.getResultCourse());
                gr.addCourse(dl.getResultCourse());
                table.setItems(null);
                table.setItems(courseList);
            }
        });

        deleteButton = new Button("Delete");
        deleteButton.setDisable(true);
        deleteButton.setMaxSize(Double.MAX_VALUE, Double.MAX_VALUE);
        deleteButton.setOnAction(e -> {
            Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
            alert.setTitle("Confirmation Dialog");
            alert.setHeaderText("Are You sure?");

            Optional<ButtonType> result = alert.showAndWait();
            if (result.get() == ButtonType.OK) {
                courseList.remove(table.getSelectionModel().getSelectedIndex());
                gr.setCourses(new ArrayList(courseList));
                table.setItems(null);
                table.setItems(courseList);
            }
        });

        HBox buttons = new HBox();
        buttons.setPadding(new Insets(2, 1, 2, 0));
        HBox.setHgrow(addButton, Priority.ALWAYS);
        HBox.setHgrow(deleteButton, Priority.ALWAYS);
        buttons.getChildren().addAll(addButton, deleteButton);
        tablePane.setBottom(buttons);
    }
}
