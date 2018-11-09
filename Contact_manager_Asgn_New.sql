-- MySQL Workbench Forward Engineering

-- -----------------------------------------------------
-- Schema Contact_manager
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Contact_manager` ;

-- -----------------------------------------------------
-- Schema Contact_manager
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Contact_manager` DEFAULT CHARACTER SET utf8 ;
USE `Contact_manager` ;

-- -----------------------------------------------------
-- Table `Contact_manager`.`Contact`
-- -----------------------------------------------------
 DROP TABLE IF EXISTS `Contact` ;

CREATE TABLE IF NOT EXISTS `Contact` (
  `Contact_ID` INT NOT NULL AUTO_INCREMENT COMMENT 'Contact_ID is primary key.',
  `fname` VARCHAR(20) NOT NULL COMMENT 'Contact_Name can be a composite attribute.',
  `minit` VARCHAR(5) NULL,
  `lname` VARCHAR(20) NOT NULL,
  `Sex` CHAR(1) NULL COMMENT 'Assuming two values for sex: Male(M) and Female(F).',
  `Birthdate` DATE NULL check (datediff(curdate(),`Birthdate`) > '0' ), 
  -- COMMENT 'Birthdate has constraint that it should not be entered a future date.',
  PRIMARY KEY (`Contact_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Contact_manager`.`Family`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Family` ;

CREATE TABLE IF NOT EXISTS `Family` (
  `Family_Name` VARCHAR(30) NULL,
  `Family_ID` INT NOT NULL AUTO_INCREMENT COMMENT 'Family_ID & Member_ID form the primary key.',
  PRIMARY KEY (`Family_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Contact_manager`.`Phone`
-- -----------------------------------------------------
-- DROP TABLE IF EXISTS `Contact_manager`.`Phone` ;
DROP TABLE IF EXISTS `Phone` ;

CREATE TABLE IF NOT EXISTS `Phone` (
  `Phone_Number` varchar(10) UNIQUE NOT NULL,
  `Type` VARCHAR(15) NULL DEFAULT 'Primary' COMMENT 'Phone type can be \'Primary\', \'Secondary\',\'Tertiary\' for the same person with multiple phone numbers.',
  `Phone_ID` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`Phone_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Contact_manager`.`Email`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Email` ;

CREATE TABLE IF NOT EXISTS `Email` (
  `Email` VARCHAR(45) UNIQUE NOT NULL,
  `Type` VARCHAR(15) NULL DEFAULT 'Primary' COMMENT 'Type can be  \'Primary\', \'Secondary\',\'Tertiary\' for the same person with multiple email ID\'s.',
  `Email_ID` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`Email_ID`,`Email`))
ENGINE = InnoDB;

-- Table ADDRESS
DROP TABLE IF EXISTS `Address` ;
CREATE TABLE IF NOT EXISTS `Address` (
  `Add_ID` INT NOT NULL AUTO_INCREMENT,
  `City` varchar(20) NULL,
  `State` varchar(20) NULL,
  `PIN` varchar(5) NULL,
  `Address_Line` varchar(45) NULL,
  `P_ID` INT NOT NULL,
  PRIMARY KEY (`Add_ID`,`P_ID`),
  CONSTRAINT `FK_P_ID`
    FOREIGN KEY (`P_ID`)
    REFERENCES `Contact_manager`.`Contact` (`Contact_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Contact_manager`.`Call_Schedule`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Call_Schedule` ;

CREATE TABLE IF NOT EXISTS `Call_Schedule` (
  `Time_to_call` DATETIME NOT NULL COMMENT '1:N relationship in EMPLOYEE:Call_Schedule.',
  `Call_To` INT NULL COMMENT '\'Call_To\' column will refer to the Contact_ID of the person whom I want to call on time defined by \'Time_to_call\'.',
  PRIMARY KEY (`Time_to_call`),
  CONSTRAINT `FK_Call_To`
    FOREIGN KEY (`Call_To`)
    REFERENCES `Contact_manager`.`Contact` (`Contact_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `FK_Call_To_idx` ON `Call_Schedule` (`Call_To` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Contact_manager`.`HAS_PHONE`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `HAS_PHONE` ;

CREATE TABLE IF NOT EXISTS `HAS_PHONE` (
  `Per_id` INT NOT NULL COMMENT 'M:N relationship in HAS_PHONE and Phone.',
  `Ph_ID` INT NOT NULL,
  PRIMARY KEY (`Per_id`, `Ph_ID`),
  CONSTRAINT `FK_Per_ID`
    FOREIGN KEY (`Per_id`)
    REFERENCES `Contact_manager`.`Contact` (`Contact_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_Ph_ID`
    FOREIGN KEY (`Ph_ID`)
    REFERENCES `Contact_manager`.`Phone` (`Phone_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `FK_P_number_idx` ON `HAS_PHONE` (`Ph_ID` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Contact_manager`.`HAS_EMAIL`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `HAS_EMAIL` ;

CREATE TABLE IF NOT EXISTS `HAS_EMAIL` (
  `Person_id` INT NOT NULL COMMENT 'M:N relationship in HAS_EMAIL and Contact table.',
  `E_ID` INT NOT NULL,
  PRIMARY KEY (`Person_id`, `E_ID`),
  CONSTRAINT `FK_Person_ID`
    FOREIGN KEY (`Person_id`)
    REFERENCES `Contact_manager`.`Contact` (`Contact_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_E_ID`
    FOREIGN KEY (`E_ID`)
    REFERENCES `Contact_manager`.`Email` (`Email_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `FK_E_ID_idx` ON `HAS_EMAIL` (`E_ID` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Contact_manager`.`BELONGS_TO`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `BELONGS_TO` ;

CREATE TABLE IF NOT EXISTS `BELONGS_TO` (
  `Pers_ID` INT NOT NULL COMMENT 'M:N relationship in BELONGS_TO.',
  `F_ID` INT NOT NULL,
  PRIMARY KEY (`Pers_ID`, `F_ID`),
  CONSTRAINT `FK_Pers_ID`
    FOREIGN KEY (`Pers_ID`)
    REFERENCES `Contact_manager`.`Contact` (`Contact_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_F_ID`
    FOREIGN KEY (`F_ID`)
    REFERENCES `Contact_manager`.`Family` (`Family_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX `FK_F_ID_idx` ON `BELONGS_TO` (`F_ID` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Contact_manager`.`Address_Details`
-- -----------------------------------------------------
-- DROP TABLE IF EXISTS `Address_Details` ;

-- CREATE TABLE IF NOT EXISTS `Address_Details` (
--  `Detail_ID` INT NOT NULL AUTO_INCREMENT,
--  `City` VARCHAR(20) NULL,
--  `State` VARCHAR(20) NULL,
--  `PIN` INT(5) NULL,
--  `Country` VARCHAR(35) NULL,
--  PRIMARY KEY (`Detail_ID`))
-- ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `Contact_manager`.`Address`
-- -----------------------------------------------------
-- DROP TABLE IF EXISTS `Address` ;

-- CREATE TABLE IF NOT EXISTS `Address` (
--  `Add_ID` INT NOT NULL AUTO_INCREMENT, -- COMMENT 'Surrogate Key for address ID.',
--  `D_ID` INT NULL,
--  PRIMARY KEY (`Add_ID`),
--  CONSTRAINT `FK_D_ID`
--    FOREIGN KEY (`D_ID`)
--    REFERENCES `Contact_manager`.`Address_Details` (`Detail_ID`)
--    ON DELETE CASCADE
--    ON UPDATE CASCADE)
-- ENGINE = InnoDB;

-- CREATE INDEX `FK_D_ID_idx` ON `Address` (`D_ID` ASC) VISIBLE;
-- -----------------------------------------------------
-- Table `Contact_manager`.`STAYS_AT`
-- -----------------------------------------------------
-- DROP TABLE IF EXISTS `STAYS_AT` ;

-- CREATE TABLE IF NOT EXISTS `STAYS_AT` (
-- `P_ID` INT NOT NULL COMMENT 'M:N relationship in STAYS_AT and Contact.\nP_ID references Contact_ID in Contact.',
--  `A_ID` INT NOT NULL COMMENT 'References Add_ID from \'Address\' table.',
--  PRIMARY KEY (`P_ID`, `A_ID`),
--  CONSTRAINT `FK_P_ID`
-- FOREIGN KEY (`P_ID`)
-- REFERENCES `Contact_manager`.`Contact` (`Contact_ID`)
-- ON DELETE CASCADE
-- ON UPDATE CASCADE,
-- CONSTRAINT `FK_A_ID`
-- FOREIGN KEY (`A_ID`)
-- REFERENCES `Contact_manager`.`Address` (`Add_ID`)
-- ON DELETE CASCADE
-- ON UPDATE CASCADE)
-- ENGINE = InnoDB;
-- CREATE INDEX `FK_A_ID_idx` ON `STAYS_AT` (`A_ID` ASC) VISIBLE;

-- -----------------------------------------------------
-- Table `Contact_manager`.`Met_On`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Met_On` ;

CREATE TABLE IF NOT EXISTS `Met_On` (
  `Cont_ID` INT NOT NULL,
  `Met_On` DATE NOT NULL COMMENT 'It denotes the date I met this contact. It will also have a constraint that it can\'t be a future date.',
  PRIMARY KEY (`Cont_ID`, `Met_On`),
  CONSTRAINT `FK_Cont_ID`
    FOREIGN KEY (`Cont_ID`)
    REFERENCES `Contact_manager`.`Contact` (`Contact_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Contact_manager`.`Address_Lines`
-- -----------------------------------------------------
-- DROP TABLE IF EXISTS `Address_Lines` ;
-- CREATE TABLE IF NOT EXISTS `Address_Lines` (
 -- `Address_Line` VARCHAR(15) NOT NULL,
--  `Ad_ID` INT NOT NULL,
--  PRIMARY KEY (`Ad_ID`, `Address_Line`),
--  CONSTRAINT `FK_Ad_ID`
--    FOREIGN KEY (`Ad_ID`)
--    REFERENCES `Contact_manager`.`Address` (`Add_ID`)
--    ON DELETE CASCADE
--    ON UPDATE CASCADE)
-- ENGINE = InnoDB;
-- CREATE INDEX `FK_Ad_ID_idx` ON `Address_Lines` (`Ad_ID` ASC) VISIBLE;

------------------------------------------------------------------
-- Creating Stored Procedures ------------------------------------
USE `contact_manager`;
DROP procedure IF EXISTS `ADD_CONTACT_NAME`;
DELIMITER $$
USE `contact_manager`$$
CREATE PROCEDURE `ADD_CONTACT_NAME` (fname varchar(20),mname varchar(5),lname varchar(20),sex char(1),bdate date)
BEGIN
   insert into contact values (NULL, fname, mname, lname, NULL, bdate);
END$$
DELIMITER ;
-- -------
USE `contact_manager`;
DROP procedure IF EXISTS `ADD_EMAIL`;
DELIMITER $$
USE `contact_manager`$$
CREATE PROCEDURE `ADD_EMAIL` (email_add varchar(45), fn varchar(20),mn varchar(5),ln varchar(20))
BEGIN
   Declare e_ID int;
   Declare empID int;
   insert into email values (email_add, NULL, NULL);
   -- find the id generated for the email added above.
   set e_ID = (select Email_ID from Email where Email = email_add);
   -- find the contact id from name
   set empID = (select Contact_ID from Contact where fname=fn and minit=mn and lname=ln);
   -- store the contact id and email id number in the 'has_email' relationship relation.
   insert into has_email values (empID, e_ID);
END$$
DELIMITER ;
-- -------
USE `contact_manager`;
DROP procedure IF EXISTS `ADD_PHONE`;
DELIMITER $$
USE `contact_manager`$$
CREATE PROCEDURE `ADD_PHONE` (phone_no varchar(10), fn varchar(20),mn varchar(5),ln varchar(20))
BEGIN
   Declare phon_ID int;
   Declare empID int;
   insert into Phone values (phone_no, NULL, NULL);
   -- find the id generated for the phone added above.
   set phon_ID = (select Phone_ID from Phone where phone_no = Phone_Number);
   -- find the contact id from name
   set empID = (select Contact_ID from Contact where fname=fn and minit=mn and lname=ln);
   -- store the contact id and phone id number in the 'has_phone' relationship relation.
   insert into has_phone values (empID, phon_ID);
END$$
DELIMITER ;
-- ---------
USE `contact_manager`;
DROP procedure IF EXISTS `ADD_ADDRESS`;
DELIMITER $$
USE `contact_manager`$$
CREATE PROCEDURE `ADD_ADDRESS` (ad_city varchar(20), ad_state varchar(20), ad_pin varchar(5), fn varchar(20),mn varchar(5),ln varchar(20))
BEGIN
   Declare empID int;
   -- finding the contact id from name
   set empID = (select Contact_ID from Contact where fname=fn and minit=mn and lname=ln);
   -- Insert address for contact whose ID is found above
   insert into address values (NULL, ad_city, ad_state, ad_pin, NULL, empID);
END$$
DELIMITER ;
-- --------
USE `contact_manager`;
DROP procedure IF EXISTS `UPDATE_EMAIL`;
DELIMITER $$
USE `contact_manager`$$
CREATE PROCEDURE `UPDATE_EMAIL` (new_email varchar(45),fn varchar(20),mn varchar(5),ln varchar(20))
BEGIN
   -- Declare e_ID int;
   -- Declare empID int;
   -- find the contact id from name
   -- set empID = (select Contact_ID from Contact where fname = fn and minit = mn and lname = ln);
   -- find the email_ID for the contact id in above line
   -- set e_ID = (select E_ID from has_email where Person_id = empID);
   -- Now update the email using the email_ID found above
   update Email set Email = new_email where Email_ID 
   in (
       select E_ID from has_email where Person_id in (
                                                     select Contact_ID from Contact where fname=fn and minit=mn and lname=ln
													 )
       );
   -- select @e_ID;
   -- select @empID;
END$$
DELIMITER ;
-- --------
USE `contact_manager`;
DROP procedure IF EXISTS `UPDATE_PHONE`;
DELIMITER $$
USE `contact_manager`$$
CREATE PROCEDURE `UPDATE_PHONE` (new_phone varchar(10),fn varchar(20),mn varchar(5),ln varchar(20))
BEGIN
   Declare phon_ID int;
   Declare empID int;
   -- find the contact id from name
   set empID = (select Contact_ID from Contact where fname=fn and minit=mn and lname=ln);
   -- find the phone_ID for the contact id in above line
   set phon_ID = (select Ph_ID from has_phone where Per_id = empID);
   -- Now update the phone using the phone_ID found above
   update phone set Phone_Number = new_phone where Phone_ID = phon_ID;
END$$
DELIMITER ;
-- ---------
USE `contact_manager`;
DROP procedure IF EXISTS `UPDATE_ADDRESS`;
DELIMITER $$
USE `contact_manager`$$
CREATE PROCEDURE `UPDATE_ADDRESS` (ad_city varchar(20), ad_state varchar(20), ad_pin varchar(5), fn varchar(20),mn varchar(5),ln varchar(20))
BEGIN
   Declare empID int;
   -- find the contact id from name
   set empID = (select Contact_ID from Contact where fname=fn and minit=mn and lname=ln);
   -- find the phone_ID for the contact id in above line
   update address set City = ad_city, State = ad_state, PIN = ad_pin where P_ID = empID;
END$$
DELIMITER ;
-- ---------
USE `contact_manager`;
DROP procedure IF EXISTS `DELETE_CONTACT`;
DELIMITER $$
USE `contact_manager`$$
CREATE PROCEDURE `DELETE_CONTACT` (fn varchar(20),mn varchar(5),ln varchar(20))
BEGIN
   Declare empID int;
   -- find the contact id from name
   set empID = (select Contact_ID from Contact where fname=fn and minit=mn and lname=ln);
   -- Delete the contact using the contact ID found above
   delete from contact where Contact_ID = empID;
   
END$$
DELIMITER ;
-- -----------------------------------------------------------------
-- INSERTING SOME VALUES::
insert into Contact values (NULL,'Krishan',NULL,'Kumar','M','1993-05-14');
-- insert into Address_details values (NULL,'Dallas','Texas','75252','USA');
-- insert into Address values (NULL,'1');
-- insert into Address_Lines values ('R10202','1');
-- insert into Address_Lines values ('7815','1');
-- insert into stays_at values ('1','1');
insert into Address values (NULL, 'Dallas','Texas','75252', NULL, '1');
insert into email values ('testkk@gmail.com', NULL, NULL);
insert into has_email values ('1', '1');

insert into phone values ('4693959427',NULL, NULL);
insert into has_phone values('1','1');
-- -----------------------------------------------------
-- Table `Contact_manager`.``
-- -----------------------------------------------------


-- SET SQL_MODE=@OLD_SQL_MODE;
-- SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
-- SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
