/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg8.pkg2;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.URL;
import java.util.ArrayList;
import java.util.Optional;
import java.util.ResourceBundle;
import java.util.concurrent.atomic.AtomicLong;
import javafx.application.Platform;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextArea;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.control.cell.TextFieldTableCell;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.Priority;
import javafx.stage.Modality;
import javafx.stage.Stage;

/**
 * FXML Controller class
 *
 * @author 97pib
 */
public class GradeTableController implements Initializable {

    private Stage stage;
    private Scene scene;
    private GradeReport gr;
    private GradeReport oldGr = new GradeReport();
    private ObservableList<Course> courseList = FXCollections.observableArrayList();

    @FXML
    private Button addButton;
    @FXML
    private Button deleteButton;
    @FXML
    private Button okButton;
    @FXML
    private TableView<Course> table;
    @FXML
    private Button cancelButton;

    /**
     * Initializes the controller class.
     */
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        table.setColumnResizePolicy((param) -> true);
        Platform.runLater(() -> customResize(table));

        addButton.setMaxSize(Double.MAX_VALUE, Double.MAX_VALUE);
        deleteButton.setMaxSize(Double.MAX_VALUE, Double.MAX_VALUE);
        okButton.setMaxSize(Double.MAX_VALUE, Double.MAX_VALUE);
        cancelButton.setMaxSize(Double.MAX_VALUE, Double.MAX_VALUE);

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

        deleteButton.setDisable(true);
        table.getSelectionModel().selectedItemProperty().addListener(e -> {
            deleteButton.setDisable(table.getSelectionModel().getSelectedIndex() == -1);
        });
    }

    public Stage getStage() {
        return stage;
    }

    public void setStage(Stage stage) {
        this.stage = stage;
    }

    public Scene getScene() {
        return scene;
    }

    public void setScene(Scene scene) {
        this.scene = scene;
        addResizeListeners();
    }

    public GradeReport getReport() {
        return gr;
    }

    public void setReport(GradeReport gr) {
        this.gr = gr;
        ArrayList<Course> oldC = new ArrayList<>();
        for (Course x : gr.getCourses()) {
            oldC.add(new Course(x.getName(), x.getCredits(), x.getDate(), x.getValue()));
        }
        oldGr.setCourses(oldC);
        oldGr.setName(gr.getName());
        oldGr.setProgram(gr.getProgram());
        courseList.setAll(gr.getCourses());
    }

    public ObservableList<Course> getCourseList() {
        return courseList;
    }

    public void setCourseList(ObservableList<Course> courseList) {
        this.courseList = courseList;
    }

    @FXML
    private void addAction(ActionEvent event) throws IOException {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("CourseDialog.fxml"));
            Parent root = loader.load();

            Stage stage = new Stage();
            CourseDialogController controller = loader.getController();
            controller.setStage(stage);
            controller.setCourseList(courseList);

            stage.initOwner(this.stage);
            stage.initModality(Modality.WINDOW_MODAL);
            stage.setTitle("Course dialog");
            stage.centerOnScreen();

            Scene scene = new Scene(root);
            stage.setScene(scene);
            stage.setMinHeight(250);
            stage.setMinWidth(320);
            stage.showAndWait();
        } catch (Exception e) {
            printError(e);
        }
    }

    @FXML
    private void deleteAction(ActionEvent event) {
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
    }

    @FXML
    private void okAction(ActionEvent event) {
        stage.close();
    }

    @FXML
    private void cancelAction(ActionEvent event) {
        gr.setCourses(oldGr.getCourses());
        stage.close();
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

    private static void printError(Exception e) {
        Alert alert = new Alert(Alert.AlertType.ERROR);
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
