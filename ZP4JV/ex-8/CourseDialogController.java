/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg8.pkg2;

import java.net.URL;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ResourceBundle;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.DatePicker;
import javafx.scene.control.TextField;
import javafx.scene.text.Text;
import javafx.stage.Stage;
import javafx.util.StringConverter;

/**
 *
 * @author 97pib
 */
public class CourseDialogController implements Initializable {

    private Stage stage;
    private ObservableList<Course> courseList = FXCollections.observableArrayList();
    private final String pattern = "dd.mm.yyyy";

    @FXML
    private TextField txtName;
    @FXML
    private DatePicker datePicker;
    @FXML
    private ComboBox<String> comboBox;
    @FXML
    private Text lbNotification;
    @FXML
    private Button okButton;
    @FXML
    private TextField txtCredits;

    @Override
    public void initialize(URL location, ResourceBundle resources) {
        comboBox.getItems().setAll("-", "A", "B", "C", "D", "E", "F");
        comboBox.getSelectionModel().selectFirst();

        datePicker.setPromptText(pattern);
        datePicker.requestFocus();

        okButton.setDisable(true);

        txtName.textProperty().addListener((t0, t, t1) -> {
            okButton.setDisable(t1.trim().isEmpty());
        });

        txtCredits.textProperty().addListener((t0, t, t1) -> {
            okButton.setDisable(t1.trim().isEmpty());
        });
    }

    public ObservableList<Course> getCourseList() {
        return courseList;
    }

    public void setCourseList(ObservableList<Course> courseList) {
        this.courseList = courseList;
    }

    public Stage getStage() {
        return stage;
    }

    public void setStage(Stage stage) {
        this.stage = stage;
    }

    @FXML
    private void okAction(ActionEvent event) {
        if (txtName.getText().trim().equals("") || txtCredits.getText().trim().equals("")
                || (comboBox.getSelectionModel().getSelectedItem() != "-" && datePicker.getValue() == null)
                || comboBox.getSelectionModel().getSelectedItem() == "-" && datePicker.getValue() != null) {
            lbNotification.setText("Something is missing");
        } else {
            Course cr = null;
            if (comboBox.getSelectionModel().getSelectedItem().toString() == "-" && datePicker.getValue() == null) {
                cr = new Course(txtName.getText(), txtCredits.getText());
            } else if (comboBox.getSelectionModel().getSelectedItem() != "-" && datePicker.getValue() != null) {
                cr = new Course(txtName.getText(), txtCredits.getText());
                cr.setValue(comboBox.getSelectionModel().getSelectedItem());
                cr.setDate(datePicker.getValue().toString());
            }
            courseList.add(cr);
            stage.close();
        }
    }

    @FXML
    private void cancelAction(ActionEvent event) {
        stage.close();
    }

}
