/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cv.pkg7;

import java.util.Optional;
import javafx.geometry.Insets;
import javafx.scene.Node;
import javafx.scene.control.ButtonBar.ButtonData;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Dialog;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;
import javafx.scene.text.Text;
import javafx.util.Pair;

/**
 *
 * @author 97pib
 */
public class StudentDialog extends Dialog {

    GradeReport gr;

    public StudentDialog() {
        setTitle("Add Student");
        createForm();
    }

    public StudentDialog(GradeReport r) {
        setTitle("Edit Student");
        gr = r;
        createForm();
    }

    private void createForm() {
        ButtonType okButtonType = new ButtonType("Ok", ButtonData.OK_DONE);
        getDialogPane().getButtonTypes().addAll(okButtonType, ButtonType.CANCEL);

        GridPane grid = new GridPane();
        grid.setVgap(10);
        grid.setHgap(10);
        grid.setPadding(new Insets(20, 150, 10, 10));

        TextField nameField = new TextField();
        TextField programField = new TextField();
        if (gr != null) {
            nameField.setText(gr.getName());
            programField.setText(gr.getProgram());
        }

        grid.add(new Text("Name"), 0, 0);
        grid.add(nameField, 1, 0);
        grid.add(new Text("Program"), 0, 1);
        grid.add(programField, 1, 1);

        Node okButton = getDialogPane().lookupButton(okButtonType);
        okButton.setDisable(true);

        nameField.textProperty().addListener((obs, oldText, newText) -> {
            okButton.setDisable(newText.trim().isEmpty());
        });

        programField.textProperty().addListener((obs, oldText, newText) -> {
            okButton.setDisable(newText.trim().isEmpty());
        });

        getDialogPane().setContent(grid);

        setResultConverter(dialogButton -> {
            if (dialogButton == okButtonType) {
                return new Pair<>(nameField.getText(), programField.getText());
            }
            return null;
        });

        Optional<Pair<String, String>> result = showAndWait();

        result.ifPresent(r -> {
            if (gr != null) {
                gr.setName(r.getKey());
                gr.setProgram(r.getValue());
            } else {
                gr = new GradeReport(r.getKey(), r.getValue());
            }
        });
    }

    public GradeReport getResultReport() {
        return gr;
    }
}
