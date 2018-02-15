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
import java.util.Optional;
import java.util.ResourceBundle;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
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
import javafx.scene.control.ListView;
import javafx.scene.control.MenuItem;
import javafx.scene.control.TextArea;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.Priority;
import javafx.stage.Modality;
import javafx.stage.Stage;

/**
 *
 * @author 97pib
 */
public class MainFormController implements Initializable {

    private Stage primaryStage;
    private ObservableList<GradeReport> sList = FXCollections.observableArrayList();

    @FXML
    private ListView<GradeReport> sListView;

    @FXML
    private MenuItem menuEdit;
    @FXML
    private MenuItem menuDelete;
    @FXML
    private Button btnEdit;
    @FXML
    private Button btnDelete;
    @FXML
    private MenuItem menuOpen;
    @FXML
    private Button btnAdd;

    @Override
    public void initialize(URL url, ResourceBundle rb) {
        addTest();
        sListView.setItems(sList);

        btnEdit.setMaxSize(Double.MAX_VALUE, Double.MAX_VALUE);
        btnDelete.setMaxSize(Double.MAX_VALUE, Double.MAX_VALUE);
        btnAdd.setMaxSize(Double.MAX_VALUE, Double.MAX_VALUE);

        menuEdit.setDisable(true);
        menuDelete.setDisable(true);
        menuOpen.setDisable(true);
        btnEdit.setDisable(true);
        btnDelete.setDisable(true);

        sListView.getSelectionModel().selectedIndexProperty().addListener(e -> {
            menuEdit.setDisable(sListView.getSelectionModel().getSelectedIndex() == -1);
            menuDelete.setDisable(sListView.getSelectionModel().getSelectedIndex() == -1);
            menuOpen.setDisable(sListView.getSelectionModel().getSelectedIndex() == -1);
            btnEdit.setDisable(sListView.getSelectionModel().getSelectedIndex() == -1);
            btnDelete.setDisable(sListView.getSelectionModel().getSelectedIndex() == -1);
        });

    }

    public Stage getPrimaryStage() {
        return primaryStage;
    }

    public void setPrimaryStage(Stage stage) {
        this.primaryStage = stage;
    }

    private void addTest() {
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

    @FXML
    private void addStudentAction(ActionEvent event) throws IOException {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("StudentDialog.fxml"));
            Parent root = (Parent) loader.load();

            Stage stage = new Stage();
            StudentDialogController controller = loader.getController();
            controller.setStage(stage);
            controller.setsList(sList);

            stage.initOwner(this.primaryStage);
            stage.initModality(Modality.WINDOW_MODAL);
            stage.setTitle("Student dialog");
            stage.centerOnScreen();

            Scene scene = new Scene(root);
            stage.setScene(scene);
            stage.setMinHeight(160);
            stage.setMinWidth(280);
            stage.show();
        } catch (Exception e) {
            printError(e);
        }
    }

    @FXML
    private void editStudentAction(ActionEvent event) throws IOException {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("StudentDialog.fxml"));
            Parent root = loader.load();

            Stage stage = new Stage();
            StudentDialogController controller = loader.getController();
            controller.setStage(stage);
            controller.setsList(sList);
            controller.setReport(sListView.getSelectionModel().getSelectedItem());

            stage.initOwner(this.primaryStage);
            stage.initModality(Modality.WINDOW_MODAL);
            stage.setTitle("Student dialog");
            stage.centerOnScreen();

            Scene scene = new Scene(root);
            stage.setScene(scene);
            stage.setMinHeight(160);
            stage.setMinWidth(280);
            stage.showAndWait();
            sListView.setItems(null);
            sListView.setItems(sList);
        } catch (Exception e) {
            printError(e);
        }
    }

    @FXML
    private void deleteStudentAction(ActionEvent event) {
        Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
        alert.setTitle("Confirmation Dialog");
        alert.setHeaderText("Are You sure?");

        Optional<ButtonType> result = alert.showAndWait();
        if (result.get() == ButtonType.OK) {
            sList.remove(sListView.getSelectionModel().getSelectedIndex());
            sListView.setItems(null);
            sListView.setItems(sList);
        }
    }

    @FXML
    private void exitAction(ActionEvent event) {
        primaryStage.close();
    }

    @FXML
    private void openReport(ActionEvent event) throws IOException {
        if (sListView.getSelectionModel().getSelectedIndex() != -1) {
            openTable();
        }
    }

    @FXML
    private void openReportMouse(MouseEvent event) throws IOException {
        if (event.getClickCount() > 1 && sListView.getSelectionModel().getSelectedIndex() != -1) {
            openTable();
        }
    }

    private void openTable() throws IOException {
        try {
            FXMLLoader loader = new FXMLLoader(getClass().getResource("GradeTable.fxml"));
            Parent root = loader.load();

            Stage stage = new Stage();
            GradeTableController controller = loader.getController();
            controller.setStage(stage);
            controller.setReport(sListView.getSelectionModel().getSelectedItem());

            stage.initOwner(this.primaryStage);
            stage.initModality(Modality.WINDOW_MODAL);
            stage.setTitle("Student dialog");
            stage.centerOnScreen();

            Scene scene = new Scene(root);
            stage.setScene(scene);
            controller.setScene(scene);
            stage.setMinHeight(200);
            stage.setMinWidth(320);
            stage.showAndWait();
        } catch (Exception e) {
            printError(e);
        }
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
