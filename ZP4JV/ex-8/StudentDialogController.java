/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg8.pkg2;

import java.net.URL;
import java.util.ResourceBundle;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.ListView;
import javafx.scene.control.MenuItem;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;
import javafx.scene.text.Text;
import javafx.stage.Stage;

/**
 * FXML Controller class
 *
 * @author 97pib
 */
public class StudentDialogController implements Initializable {

    private Stage stage;
    private ObservableList<GradeReport> sList;
    private GradeReport gr = null;

    @FXML
    private TextField txtName;
    @FXML
    private TextField txtProgram;
    @FXML
    private Text lbNotification;
    @FXML
    private Button okButton;

    /**
     * Initializes the controller class.
     */
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        okButton.setDisable(true);

        txtName.textProperty().addListener((t0, t, t1) -> {
            okButton.setDisable(t1.trim().isEmpty());
        });

        txtProgram.textProperty().addListener((t0, t, t1) -> {
            okButton.setDisable(t1.trim().isEmpty());
        });
    }

    public ObservableList<GradeReport> getsList() {
        return sList;
    }

    public void setsList(ObservableList<GradeReport> sList) {
        this.sList = sList;
    }

    public Stage getStage() {
        return stage;
    }

    public void setStage(Stage stage) {
        this.stage = stage;
    }

    public GradeReport getReport() {
        return gr;
    }

    public void setReport(GradeReport gr) {
        txtName.setText(gr.getName());
        txtProgram.setText(gr.getProgram());
        this.gr = gr;
    }

    @FXML
    private void okAction(ActionEvent event) {
        if (txtName.getText().trim().equals("") || txtProgram.getText().trim().equals("")) {
            lbNotification.setText("Something is missing");
        } else {
            if (gr != null) {
                gr.setName(txtName.getText());
                gr.setProgram(txtProgram.getText());
            } else {
                sList.add(new GradeReport(txtName.getText(), txtProgram.getText()));
            }
            stage.close();
        }
    }

    @FXML
    private void cancelAction(ActionEvent event) {
        stage.close();
    }

}
