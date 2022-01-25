CREATE TABLE IF NOT EXISTS PUBLIC.CATEGORY
(
    ID   INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    NAME VARCHAR(255)       NOT NULL
);

CREATE TABLE IF NOT EXISTS PUBLIC.USER
(
    ID         INT                 NOT NULL AUTO_INCREMENT PRIMARY KEY,
    FIRST_NAME VARCHAR(255)        NOT NULL,
    LAST_NAME  VARCHAR(255)        NOT NULL,
    ROLE_ID    VARCHAR(100)        NOT NULL,
    EMAIL      VARCHAR(255) UNIQUE NOT NULL,
    PASSWORD   VARCHAR(255)        NOT NULL
);

CREATE TABLE IF NOT EXISTS PUBLIC.TICKET
(
    ID                      INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    NAME                    VARCHAR(255)       NOT NULL,
    DESCRIPTION             VARCHAR(255)       NOT NULL,
    CREATED_ON              DATETIME           NOT NULL,
    DESIRED_RESOLUTION_DATE DATE               NOT NULL,
    ASSIGNEE_ID             INT                NOT NULL,
    OWNER_ID                INT                NOT NULL,
    STATE_ID                VARCHAR(255)       NOT NULL,
    CATEGORY_ID             INT                NOT NULL,
    URGENCY_ID              VARCHAR(100)       NOT NULL,
    APPROVE_ID              INT                NOT NULL,
    CONSTRAINT ASSIGNEE_ID_FOREIGN_KEY FOREIGN KEY (ASSIGNEE_ID) REFERENCES USER (ID),
    CONSTRAINT OWNER_ID_FOREIGN_KEY FOREIGN KEY (OWNER_ID) REFERENCES USER (ID),
    CONSTRAINT APPROVE_ID_FOREIGN_KEY FOREIGN KEY (APPROVE_ID) REFERENCES USER (ID),
    CONSTRAINT CATEGORY_FOREIGN_KEY FOREIGN KEY (CATEGORY_ID) REFERENCES CATEGORY (ID)

);


CREATE TABLE IF NOT EXISTS PUBLIC.ATTACHMENT
(
    ID        INT AUTO_INCREMENT PRIMARY KEY,
    BLOB      BLOB,
    TICKET_ID INTEGER      NOT NULL,
    NAME      VARCHAR(255) NOT NULL,
    CONSTRAINT TICKET_FOREIGN_KEY_ATTACHMENT FOREIGN KEY (TICKET_ID) REFERENCES TICKET (ID)
);

CREATE TABLE IF NOT EXISTS PUBLIC.HISTORY
(
    ID          INT AUTO_INCREMENT PRIMARY KEY,
    TICKET_ID   INT          NOT NULL,
    DATE        DATE         NOT NULL,
    ACTION      VARCHAR(255) NOT NULL,
    USER_ID     INTEGER      NOT NULL,
    DESCRIPTION VARCHAR(255) NOT NULL,
    CONSTRAINT TICKET_FOREIGN_KEY_HISTORY FOREIGN KEY (TICKET_ID) REFERENCES TICKET (ID),
    CONSTRAINT USER_FOREIGN_KEY_HISTORY FOREIGN KEY (USER_ID) REFERENCES USER (ID)
);

CREATE TABLE IF NOT EXISTS PUBLIC.COMMENT
(
    ID        INT AUTO_INCREMENT PRIMARY KEY,
    USER_ID   INT          NOT NULL,
    TEXT      VARCHAR(255) NOT NULL,
    TICKET_ID INT          NOT NULL,
    CONSTRAINT USER_FOREIGN_KEY_COMMENT FOREIGN KEY (USER_ID) REFERENCES USER (ID),
    CONSTRAINT TICKET_FOREIGN_KEY_COMMENT FOREIGN KEY (TICKET_ID) REFERENCES TICKET (ID)
);

CREATE TABLE IF NOT EXISTS PUBLIC.FEEDBACK
(
    ID        INT AUTO_INCREMENT PRIMARY KEY,
    USER_ID   INT      NOT NULL,
    RATE      INT      NOT NULL,
    DATE      DATE     NOT NULL,
    TEXT      LONGTEXT NOT NULL,
    TICKET_ID INTEGER  NOT NULL,
    CONSTRAINT FEEDBACK_PRIMARY_KEY PRIMARY KEY (ID),
    CONSTRAINT USER_FOREIGN_KEY_FEEDBACK FOREIGN KEY (USER_ID) REFERENCES USER (ID),
    CONSTRAINT TICKET_FOREIGN_KEY_FEEDBACK FOREIGN KEY (TICKET_ID) REFERENCES TICKET (ID)
);

INSERT INTO USER (FIRST_NAME, LAST_NAME, ROLE_ID, EMAIL, PASSWORD)
VALUES ('John', 'Doe', 'EMPLOYEE', 'user1_mogilev@yopmail.com', 'qwerty123');
INSERT INTO USER (FIRST_NAME, LAST_NAME, ROLE_ID, EMAIL, PASSWORD)
VALUES ('Jane', 'Doe', 'EMPLOYEE', 'user2_mogilev@yopmail.com', 'qwerty123');
INSERT INTO USER (FIRST_NAME, LAST_NAME, ROLE_ID, EMAIL, PASSWORD)
VALUES ('Elvis', 'Presley', 'MANAGER', 'manager1_mogilev@yopmail.com', 'qwerty123');
INSERT INTO USER (FIRST_NAME, LAST_NAME, ROLE_ID, EMAIL, PASSWORD)
VALUES ('Pope', 'Ofrome', 'MANAGER', 'manager2_mogilev@yopmail.com', 'qwerty123');
INSERT INTO USER (FIRST_NAME, LAST_NAME, ROLE_ID, EMAIL, PASSWORD)
VALUES ('Papa', 'Carlo', 'ENGINEER', 'engineer1_mogilev@yopmail.com', 'qwerty123');
INSERT INTO USER (FIRST_NAME, LAST_NAME, ROLE_ID, EMAIL, PASSWORD)
VALUES ('Ella', 'Cinder', 'ENGINEER', 'engineer2_mogilev@yopmail.com', 'qwerty123');

INSERT INTO CATEGORY(NAME)
VALUES ('OFFICE');
INSERT INTO CATEGORY (NAME)
VALUES ('ACCESSORIES');
INSERT INTO CATEGORY(NAME)
VALUES ('FURNITURE');
INSERT INTO CATEGORY(NAME)
VALUES ('COMMUNICATIONS');

INSERT INTO TICKET (NAME, DESCRIPTION, CREATED_ON, DESIRED_RESOLUTION_DATE, ASSIGNEE_ID, OWNER_ID, STATE_ID,
                    CATEGORY_ID, URGENCY_ID, APPROVE_ID)
VALUES ('TASK1', 'COMPUTER BROKEN', '2021-03-25', '2021-03-30', 5, 1, 'APPROVED', 1, 'LOW', 4);
INSERT INTO TICKET (NAME, DESCRIPTION, CREATED_ON, DESIRED_RESOLUTION_DATE, ASSIGNEE_ID, OWNER_ID, STATE_ID,
                    CATEGORY_ID, URGENCY_ID, APPROVE_ID)
VALUES ('TASK2', 'NEED NEW TABLE', '2022-01-04', '2022-01-10', 5, 2, 'NEW', 3, 'HIGH', 4);
INSERT INTO TICKET(NAME, DESCRIPTION, CREATED_ON, DESIRED_RESOLUTION_DATE, ASSIGNEE_ID, OWNER_ID, STATE_ID, CATEGORY_ID,
                   URGENCY_ID, APPROVE_ID)
VALUES ('TASK3', 'INTERNET NOT WORKING! I CANT GOOGLE!', '2022-01-24', '2022-01-25', 6, 3, 'NEW', 4, 'CRITICAL', 3);
INSERT INTO TICKET(NAME, DESCRIPTION, CREATED_ON, DESIRED_RESOLUTION_DATE, ASSIGNEE_ID, OWNER_ID, STATE_ID, CATEGORY_ID,
                   URGENCY_ID, APPROVE_ID)
VALUES ('TASK4', 'PRINTER IS NOT WORKING', '2021-12-31', '2022-01-01', 6, 4, 'APPROVED', 1, 'CRITICAL', 3);
INSERT INTO TICKET(NAME, DESCRIPTION, CREATED_ON, DESIRED_RESOLUTION_DATE, ASSIGNEE_ID, OWNER_ID, STATE_ID, CATEGORY_ID,
                   URGENCY_ID, APPROVE_ID)
VALUES ('TASK5', 'HEADPHONES', '2022-01-11', '2022-02-01', 5, 1, 'IN_PROGRESS', 1, 'LOW', 3);
