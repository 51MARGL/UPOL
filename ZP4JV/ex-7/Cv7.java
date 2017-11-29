/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg7;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Optional;
import javafx.application.Application;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.Button;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import javafx.scene.control.Menu;
import javafx.scene.control.MenuBar;
import javafx.scene.control.MenuItem;
import javafx.scene.control.SeparatorMenuItem;
import javafx.scene.control.TextArea;
import javafx.scene.input.KeyCode;
import javafx.scene.input.KeyCodeCombination;
import javafx.scene.input.KeyCombination;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Priority;
import javafx.stage.Stage;

/**
 *
 * @author 97pib
 */
public class Cv7 extends Application {

    private ObservableList<GradeReport> sList;
    private ListView<GradeReport> sListView;
    private Button addButton;
    private Button editButton;
    private Button deleteButton;
    private MenuItem menuAdd;
    private MenuItem menuEdit;
    private MenuItem menuDelete;
    private MenuItem menuOpen;
    private BorderPane root;
    private Stage stage;

    public static void main(String[] args) {
        try {
            launch(args);
        } catch (Exception e) {
            printError(e);
        }
    }

    @Override
    public void start(Stage stage) throws Exception {
        try {
            this.stage = stage;
            root = new BorderPane();

            addMenu();
            addStudentList();
            addButtons();

            stage.setTitle("GradeReport");
            stage.setScene(new Scene(root, 400, 200));
            stage.show();
        } catch (Exception e) {
            printError(e);
        }
    }

    private void addMenu() {
        Menu menuFile = new Menu("_Student");
        menuFile.setMnemonicParsing(true); // pro menu defaultne true

        menuAdd = new MenuItem("_Add");
        menuAdd.setAccelerator(new KeyCodeCombination(KeyCode.A, KeyCombination.CONTROL_DOWN));
        menuAdd.setOnAction(e -> {
            StudentDialog dl = new StudentDialog();
            if (dl.getResultReport() != null) {
                sList.add(dl.getResultReport());
                sListView.setItems(null);
                sListView.setItems(sList);
            }
        });

        menuEdit = new MenuItem("_Edit");
        menuEdit.setDisable(true);
        menuEdit.setAccelerator(new KeyCodeCombination(KeyCode.E, KeyCombination.CONTROL_DOWN));
        menuEdit.setOnAction(e -> {
            StudentDialog dl = new StudentDialog(sListView.getSelectionModel().getSelectedItem());
            if (dl.getResultReport() != null) {
                sListView.setItems(null);
                sListView.setItems(sList);
            }
        });

        menuDelete = new MenuItem("_Delete");
        menuDelete.setDisable(true);
        menuDelete.setAccelerator(new KeyCodeCombination(KeyCode.D, KeyCombination.CONTROL_DOWN));
        menuDelete.setOnAction(e -> {
            Alert alert = new Alert(AlertType.CONFIRMATION);
            alert.setTitle("Confirmation Dialog");
            alert.setHeaderText("Are You sure?");

            Optional<ButtonType> result = alert.showAndWait();
            if (result.get() == ButtonType.OK) {
                sList.remove(sListView.getSelectionModel().getSelectedIndex());
                sListView.setItems(null);
                sListView.setItems(sList);
            }
        });

        MenuItem mnuExit = new MenuItem("E_xit");
        mnuExit.setAccelerator(new KeyCodeCombination(KeyCode.X, KeyCombination.CONTROL_DOWN));
        mnuExit.setOnAction(e -> stage.close());

        menuFile.getItems().addAll(menuAdd, menuEdit, menuDelete, new SeparatorMenuItem(), mnuExit);

        Menu menuReport = new Menu("_Grade Report");
        menuReport.setMnemonicParsing(true);

        menuOpen = new MenuItem("_Open");
        menuOpen.setDisable(true);
        menuOpen.setAccelerator(new KeyCodeCombination(KeyCode.O, KeyCombination.CONTROL_DOWN));
        menuOpen.setOnAction(e -> {
            GradeTable tbl = new GradeTable(sListView.getSelectionModel().getSelectedItem());
        });
        menuReport.getItems().add(menuOpen);
        MenuBar menuBar = new MenuBar();
        menuBar.getMenus().addAll(menuFile, menuReport);

        root.setTop(menuBar);
    }

    private void addButtons() {
        HBox buttons = new HBox();
        buttons.setPadding(new Insets(2, 1, 2, 0));

        addButton = new Button("Add");
        addButton.setMaxSize(Double.MAX_VALUE, Double.MAX_VALUE);
        addButton.setOnAction(e -> {
            StudentDialog dl = new StudentDialog();
            if (dl.getResultReport() != null) {
                sList.add(dl.getResultReport());
                sListView.setItems(null);
                sListView.setItems(sList);
            }
        });

        editButton = new Button("Edit");
        editButton.setMaxSize(Double.MAX_VALUE, Double.MAX_VALUE);
        editButton.setDisable(true);
        editButton.setOnAction(e -> {
            StudentDialog dl = new StudentDialog(sListView.getSelectionModel().getSelectedItem());
            if (dl.getResultReport() != null) {
                sListView.setItems(null);
                sListView.setItems(sList);
            }
        });

        deleteButton = new Button("Delete");
        deleteButton.setDisable(true);
        deleteButton.setMaxSize(Double.MAX_VALUE, Double.MAX_VALUE);
        deleteButton.setOnAction(e -> {
            Alert alert = new Alert(AlertType.CONFIRMATION);
            alert.setTitle("Confirmation Dialog");
            alert.setHeaderText("Are You sure?");

            Optional<ButtonType> result = alert.showAndWait();
            if (result.get() == ButtonType.OK) {
                sList.remove(sListView.getSelectionModel().getSelectedIndex());
                sListView.setItems(null);
                sListView.setItems(sList);
            }
        });

        HBox.setHgrow(addButton, Priority.ALWAYS);
        HBox.setHgrow(editButton, Priority.ALWAYS);
        HBox.setHgrow(deleteButton, Priority.ALWAYS);
        buttons.getChildren().addAll(addButton, editButton, deleteButton);
        root.setBottom(buttons);
    }

    private void addStudentList() {
        sList = FXCollections.observableArrayList();
        addtTest();
        sListView = new ListView<>(sList);

        sListView.getSelectionModel().selectedItemProperty().addListener(e -> {
            editButton.setDisable(sListView.getSelectionModel().getSelectedIndex() == -1);
            deleteButton.setDisable(sListView.getSelectionModel().getSelectedIndex() == -1);
            menuEdit.setDisable(sListView.getSelectionModel().getSelectedIndex() == -1);
            menuDelete.setDisable(sListView.getSelectionModel().getSelectedIndex() == -1);
            menuOpen.setDisable(sListView.getSelectionModel().getSelectedIndex() == -1);
        });

        sListView.setOnMouseClicked((MouseEvent e) -> {
            if (e.getClickCount() > 1 && sListView.getSelectionModel().getSelectedIndex() != -1) {
                GradeTable tbl = new GradeTable(sListView.getSelectionModel().getSelectedItem());
            }
        });

        root.setCenter(sListView);
    }

    private void addtTest() {
        GradeReport test = new GradeReport();
        Course courseTest = new Course();
        courseTest.setName("UFO-technology");
        courseTest.setCredits("10");
        courseTest.setDate("10-10-10");
        courseTest.setValue("A+");
        test.setName("Fox Mulder");
        test.setProgram("X-Files");
        test.addCourse(courseTest);
        sList.add(test);
        GradeReport test2 = new GradeReport();
        test2.setName("Dana Scully");
        test2.setProgram("X-Files");
        sList.add(test2);
    }

    private static void printError(Exception e) {
        Alert alert = new Alert(AlertType.ERROR);
        alert.setTitle("Error");
        alert.setHeaderText("Error occured!");
        alert.setContentText(e.getLocalizedMessage());

        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        e.printStackTrace(pw);
        String exceptionText = sw.toString();

        Label label = new Label("Error tracing:");

        TextArea textArea = new TextArea(exceptionText);
        textArea.setEditable(false);
        textArea.setWrapText(true);

        textArea.setMaxWidth(Double.MAX_VALUE);
        textArea.setMaxHeight(Double.MAX_VALUE);
        GridPane.setVgrow(textArea, Priority.ALWAYS);
        GridPane.setHgrow(textArea, Priority.ALWAYS);

        GridPane expContent = new GridPane();
        expContent.setMaxWidth(Double.MAX_VALUE);
        expContent.add(label, 0, 0);
        expContent.add(textArea, 0, 1);

        alert.getDialogPane().setExpandableContent(expContent);

        alert.showAndWait();
    }
}
