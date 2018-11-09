/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package contactmanagerapp;
import java.sql.*;

import javafx.application.Application; 
import javafx.collections.FXCollections; 
import javafx.collections.ObservableList; 
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.input.KeyEvent;
import javafx.geometry.Insets; 
import javafx.geometry.Pos; 
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.SimpleIntegerProperty;
        
import javafx.scene.Scene; 
import javafx.scene.control.Button; 
import javafx.scene.control.CheckBox; 
import javafx.scene.control.ChoiceBox; 
import javafx.scene.control.DatePicker; 
import javafx.scene.control.ListView; 
import javafx.scene.control.RadioButton; 
import javafx.scene.layout.GridPane; 
import javafx.scene.text.Text; 
import javafx.scene.control.TextField; 
import javafx.scene.control.ToggleGroup;  
import javafx.scene.control.ToggleButton; 
import javafx.stage.Stage; 


/**
 *
 * @author Krishan Kumar
 */
public class ContactManagerApp extends Application {
    //credentials to access MySQL in my PC.
    private static final String USERNAME = "root";
    private static final String PASSWORD = "krish045@";
    private static final String CONN_STRING = "jdbc:mysql://localhost:3306/?user=root/contact_manager";
    //copy from MySQL connection page by right click: jdbc:mysql://localhost:3306/?user=root
    static Connection conn = null;
    //Creating tableview to show 'search' results
    private TableView<Contact> contact_info = new TableView<Contact>();
    
    @Override
    public void start(Stage primaryStage) {
        // Declarations of javafx nodes(everything that appears on UI)
        Text fname_label = new Text("Fname*");       //Lable for First name of contact
        TextField fname_field = new TextField();     //Textfield for user to enter values
        Text mname_label = new Text("Midname");      // Middle name
        TextField mname_field = new TextField();
        Text lname_label = new Text("Lname*");       // Last name
        TextField lname_field = new TextField();
        Text phone_label = new Text("Phone");
        TextField phone_field = new TextField();
        Text gender_label = new Text("Gender");
        ChoiceBox gender = new ChoiceBox();
        gender.getItems().addAll ("M", "F");
        Text email_label = new Text("Email");
        TextField email_field = new TextField();
        Text city_label = new Text("City");
        TextField city_field = new TextField();
        Text state_label = new Text("State");
        TextField state_field = new TextField();
        Text pin_label = new Text("PIN");
        TextField pin_field = new TextField();
        Button search = new Button("Search");
        Button update = new Button("Update");
        Button add_contact = new Button("Add Contact");
        Button delete_contact = new Button("Delete Contact");

        //Adding columns to contact_info tableview to show 'search' result of a contact.
        contact_info.setEditable(true);
        TableColumn fname_col = new TableColumn("Fname");
        TableColumn mname_col = new TableColumn("Mname");
        TableColumn lname_col = new TableColumn("Lname");
        TableColumn phone_col = new TableColumn("Phone");
        TableColumn email_col = new TableColumn("Email");
        TableColumn city_col = new TableColumn("City");
        TableColumn state_col = new TableColumn("State");
        TableColumn zip_col = new TableColumn("ZIP");
         
        /* Event handlers for the nodes(what action will correspond to user action on UI)
        -- phonefield_ehandle checks that only a number is entered in the 'Phone' field and not any other data
           type. 'IsInteger' function is used to keep this check for the inputs entered by the user at UI.
        -- Added below event handlers for the buttons 'Search','Update','Add Contact' and 'Delete Contact'.
        */
        EventHandler<KeyEvent> phonefield_ehandle = new EventHandler<KeyEvent>(){
            @Override
            public void handle(KeyEvent ev){
                IsInteger(phone_field, phone_field.getText());
            }
        };
        phone_field.addEventHandler(KeyEvent.KEY_TYPED,phonefield_ehandle);
        
        //'Add Contact' button is to add a new contact in the database based on input provided by user at UI.
        add_contact.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                try{
                // In the if condition, we check to make sure there is no insertion of blank name inputs to the database.
                //if(fname_field.getText() != null && mname_field.getText()!= null && lname_field.getText() != null ){
                if(fname_field.getText().length() > 0 || mname_field.getText().length() > 0 || lname_field.getText().length() > 0){
                  // Prepare a callable statement to call the stored proc 'ADD_CONTACT_NAME' in our database.
                  CallableStatement s = conn.prepareCall("{call contact_manager.ADD_CONTACT_NAME(?,?,?,?,?)}");
                  // Now set the arguments to the stored proc which will be the user inputs from our UI.
                  s.setString(1, fname_field.getText());
                  s.setString(2, mname_field.getText());
                  s.setString(3, lname_field.getText());
                  s.setString(4, "M");
                  s.setString(5, "0000-00-00");
                  // Now execute the statement to add contact info in our database via the stored proc.
                  s.execute();
                }
                
                //Similarly for Email, use the stored proc ADD_EMAIL
                if(email_field.getText().length() > 0){
                    CallableStatement s2 = conn.prepareCall("{call contact_manager.ADD_EMAIL(?,?,?,?)}");
                    s2.setString(1, email_field.getText());
                    s2.setString(2, fname_field.getText());
                    s2.setString(3, mname_field.getText());
                    s2.setString(4, lname_field.getText());
                    s2.execute();
                }
                //Similarly for phone, use the stored proc 'ADD_PHONE'
                if(phone_field.getText().length() > 0){
                    //  phone_field.getText() != "''"
                    System.out.println("Entering phone field" + " " + phone_field.getText());
                    CallableStatement s3 = conn.prepareCall("{call contact_manager.ADD_PHONE(?,?,?,?)}");
                    s3.setString(1, phone_field.getText());
                    s3.setString(2, fname_field.getText());
                    s3.setString(3, mname_field.getText());
                    s3.setString(4, lname_field.getText());
                    s3.execute();
                }
                //Similarly, adding address info of the contact
                if(city_field.getText().length() > 0 || state_field.getText().length() > 0 || pin_field.getText().length() > 0){
                    CallableStatement s4 = conn.prepareCall("{call contact_manager.ADD_ADDRESS(?,?,?,?,?,?)}");
                    s4.setString(1, city_field.getText());
                    s4.setString(2, state_field.getText());
                    s4.setString(3, pin_field.getText());
                    s4.setString(4, fname_field.getText());
                    s4.setString(5, mname_field.getText());
                    s4.setString(6, lname_field.getText());
                    s4.execute();
                }
                System.out.println("Contact Info added:");
                }catch(SQLException e){
                    System.err.println(e);
                }
            }
        });
        
        
        //'Update' button will be used to modify a contact details based on contact name. 
        update.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                try {
                    /*
                  // Update contact name via stored proc
                  CallableStatement s5 = conn.prepareCall("{call contact_manager.UPDATE_CONTACT_NAME(?,?,?)}");
                  // Now set the arguments to the stored proc which will be the user inputs from our UI.
                  s5.setString(1, fname_field.getText());
                  s5.setString(2, mname_field.getText());
                  s5.setString(3, lname_field.getText());
                  // Execute the update on the database.
                  s5.execute();
                  */
                    
                  //Update email via stored proc
                  if(email_field.getText() != null){
                      CallableStatement s6 = conn.prepareCall("{call contact_manager.UPDATE_EMAIL(?,?,?,?)}");
                      // Now set the arguments to the stored proc which will be the user inputs from our UI.
                      s6.setString(1, email_field.getText());
                      s6.setString(2, fname_field.getText());
                      s6.setString(3, mname_field.getText());
                      s6.setString(4, lname_field.getText());
                      // Execute the update on the database.
                      s6.execute();
                  }
                  
                  //Similarly, Update phone via stored proc
                  if(phone_field.getText().length() > 0){
                      CallableStatement s7 = conn.prepareCall("{call contact_manager.UPDATE_PHONE(?,?,?,?)}");
                      // Now set the arguments to the stored proc which will be the user inputs from our UI.
                      s7.setString(1, phone_field.getText());
                      s7.setString(2, fname_field.getText());
                      s7.setString(3, mname_field.getText());
                      s7.setString(4, lname_field.getText());
                      // Execute the update on the database.
                      s7.execute();
                  }
                  
                  // Similarly, update address via stored proc
                  if(city_field.getText().length() > 0 || state_field.getText().length() > 0 || pin_field.getText().length() > 0){
                      CallableStatement s8 = conn.prepareCall("{call contact_manager.UPDATE_ADDRESS(?,?,?,?,?,?)}");
                      // Now set the arguments to the stored proc which will be the user inputs from our UI.
                      s8.setString(1, city_field.getText());
                      s8.setString(2, state_field.getText());
                      s8.setString(3, pin_field.getText());
                      s8.setString(4, fname_field.getText());
                      s8.setString(5, mname_field.getText());
                      s8.setString(6, lname_field.getText());
                      // Execute the update on the database.
                      s8.execute();
                  }
                }catch(SQLException e){
                    System.err.println(e);
                }
                System.out.println("Contact Updated");
            }
        });
        
        //'Delete Contact' button is to delete a contact from the database based on input provided by user at UI.
        delete_contact.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                try{
                  // Delete a contact via stored proc
                  CallableStatement s9 = conn.prepareCall("{call contact_manager.DELETE_CONTACT(?,?,?)}");
                  // Now set the arguments to the stored proc which will be the user inputs from our UI.
                  s9.setString(1, fname_field.getText());
                  s9.setString(2, mname_field.getText());
                  s9.setString(3, lname_field.getText());
                  // Execute the update on the database.
                  s9.execute();
                  System.out.println("Contact Deleted");
                }catch(SQLException e){
                    System.err.println(e);
                }
            }
        });
        
        //'search' button is to find a contact based on input provided by user at UI. Since search functionality was not requirement of this assignment, its not fully implemented here.
        search.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                System.out.println(fname_field.getText() + mname_field.getText() + lname_field.getText() + phone_field.getText() + email_field.getText());
            }
        });
        
        //Gridpane creation and its settings:
        GridPane root = new GridPane();
        root.setMinSize(700, 700); //shows min size of window seen with gridpane
        root.setPadding(new Insets(10, 10, 10, 10)); 
        root.setAlignment(Pos.CENTER);
        root.setVgap(5);
        root.setHgap(5);
        
        //Adding nodes to the gridpane:
        root.add(fname_label, 0, 0);
        root.add(fname_field, 1, 0);
        root.add(mname_label, 2, 0);
        root.add(mname_field, 3, 0);
        root.add(lname_label, 4, 0);
        root.add(lname_field, 5, 0);
        root.add(phone_label, 6, 0);
        root.add(phone_field, 7, 0);
        //root.add(gender_label, 0, 1);
        //root.add(gender, 1, 1);
        root.add(email_label, 0, 1);
        root.add(email_field, 1, 1);
        root.add(city_label, 2, 1);
        root.add(city_field, 3, 1);
        root.add(state_label, 4, 1);
        root.add(state_field, 5, 1);
        root.add(pin_label, 6, 1);
        root.add(pin_field, 7, 1);
        //root.add(search, 1, 3);
        root.add(update, 2, 3);
        root.add(add_contact, 3, 3);
        root.add(delete_contact, 4, 3);
        
        
        Scene scene = new Scene(root);
        
        primaryStage.setTitle("Krishan's Contact Manager");
        primaryStage.setScene(scene);
        primaryStage.show();
    }
    
    // Contact class will be used for the 'Contact_info' tableview.
    public static class Contact{
        private final SimpleStringProperty finame;
        private final SimpleStringProperty miname;
        private final SimpleStringProperty laname;
        private final SimpleStringProperty email; 
        private final SimpleIntegerProperty phone;
        
        private Contact(String fname, String mname, String lname, int phone_no, String Email){
                this.finame = new SimpleStringProperty(fname);
                this.miname = new SimpleStringProperty(mname);
                this.laname = new SimpleStringProperty(lname);
                this.email = new SimpleStringProperty(Email);
                this.phone = new SimpleIntegerProperty(phone_no);
        }
    }
    
    // IsInteger function checks whether its argument 'in_field' is integer or not.
    private boolean IsInteger(TextField in_field, String input_str){
        try{
            int phone_num = Integer.parseInt(in_field.getText());
            return true;
        }catch(NumberFormatException e) {
            System.out.println("Error: " + input_str + " is not a number");
            return false;
        }
    } 
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        try {
            // Creating connection to our database
            conn = DriverManager.getConnection(CONN_STRING,USERNAME,PASSWORD);
            System.out.println("Connected!");
        } catch(SQLException e) {
            System.err.println(e);
        }
        launch(args);
    }
    
}
