CREATE TABLE IF NOT EXISTS PUBLIC.CATEGORY
(
    ID   INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    NAME VARCHAR(255)       NOT NULL
);

CREATE TABLE IF NOT EXISTS PUBLIC.USERS
(
    ID         INT                 NOT NULL AUTO_INCREMENT PRIMARY KEY,
    FIRST_NAME VARCHAR(255)        NOT NULL,
    LAST_NAME  VARCHAR(255)        NOT NULL,
    ROLE_ID    VARCHAR(100)        NOT NULL,
    EMAIL      VARCHAR(255) UNIQUE NOT NULL,
    PASSWORT   VARCHAR(255)        NOT NULL
);

CREATE TABLE IF NOT EXISTS PUBLIC.TICKET
(
    ID                      INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    NAME                    VARCHAR(100)       NOT NULL,
    DESCRIPTION             VARCHAR(500)       ,
    CREATED_ON              DATETIME           NOT NULL,
    DESIRED_RESOLUTION_DATE DATE               NOT NULL,
    ASSIGNEE_ID             INT                ,
    OWNER_ID                INT                NOT NULL,
    STATE_ID                VARCHAR(255)       NOT NULL,
    CATEGORY_ID             INT                NOT NULL,
    URGENCY_ID              VARCHAR(100)       NOT NULL,
    APPROVE_ID              INT                ,
    CONSTRAINT ASSIGNEE_ID_FOREIGN_KEY FOREIGN KEY (ASSIGNEE_ID) REFERENCES USERS (ID),
    CONSTRAINT OWNER_ID_FOREIGN_KEY FOREIGN KEY (OWNER_ID) REFERENCES USERS (ID),
    CONSTRAINT APPROVE_ID_FOREIGN_KEY FOREIGN KEY (APPROVE_ID) REFERENCES USERS (ID),
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
    DATE        DATETIME         NOT NULL,
    ACTION      VARCHAR(255) NOT NULL,
    USER_ID     INTEGER      NOT NULL,
    DESCRIPTION VARCHAR(255) NOT NULL,
    CONSTRAINT TICKET_FOREIGN_KEY_HISTORY FOREIGN KEY (TICKET_ID) REFERENCES TICKET (ID),
    CONSTRAINT USER_FOREIGN_KEY_HISTORY FOREIGN KEY (USER_ID) REFERENCES USERS (ID)
);

CREATE TABLE IF NOT EXISTS PUBLIC.COMMENT
(
    ID        INT AUTO_INCREMENT PRIMARY KEY,
    USER_ID   INT          NOT NULL,
    TEXT      VARCHAR(255) NOT NULL,
    TICKET_ID INT          NOT NULL,
    CONSTRAINT USER_FOREIGN_KEY_COMMENT FOREIGN KEY (USER_ID) REFERENCES USERS (ID),
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
    CONSTRAINT USER_FOREIGN_KEY_FEEDBACK FOREIGN KEY (USER_ID) REFERENCES USERS (ID),
    CONSTRAINT TICKET_FOREIGN_KEY_FEEDBACK FOREIGN KEY (TICKET_ID) REFERENCES TICKET (ID)
);