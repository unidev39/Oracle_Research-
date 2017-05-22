/*
A CONSTRAINT clause is an optional part of a CREATE TABLE statement or ALTER TABLE statement.
A constraint is a rule to which data must conform. Constraint names are optional.

A CONSTRAINT can be one of the following:
a column-level constraint
Column-level constraints refer to a single column in the table
They refer to the column that they follow.

a table-level constraint
Table-level constraints refer to one or more columns in the table. Table-level constraints specify the names of the columns to which they apply.
Table-level CHECK constraints can refer to 0 or more columns in the table.

Column constraints include:
NOT NULL
Specifies that this column cannot hold NULL values . Can only be define in column level

PRIMARY KEY    (combination of NOT NULL and UNIQUE CONSTRAINT)
Specifies the column that uniquely identifies a row in the table. The identified columns must be defined as NOT NULL.

Note: If you attempt to add a primary key using ALTER TABLE and any of the columns included in the primary key contain null values,
an error will be generated and the primary key will not be added. See ALTER TABLE statement for more information.

UNIQUE
Specifies that values in the column must be unique.

CHECK
Specifies rules for values in the column.

FOREIGN KEY
Specifies that the values in the column must correspond to values in a referenced primary key or unique key column or that they are NULL.(manager_id in employees and departments table <<null>> value can be in foreing key constraint)
FOREIGN KEY Constraint Keywords:
.FOREIGN KEY : Defines the column in the child table at the table constraint level
.REFERENCES  : Identifies the table and column in the parent table
.ON DDELETE CASCADE : Deletes the dependent rows in the child table when a row in the parent table is deleted
.ON DELETE SET NULL : Converts dependent foreign key values to null
Note: If the foreign key consists of multiple columns, and any column is NULL, the whole key is considered NULL.
The insert is permitted no matter what is on the non-null columns.

Column constraints and table constraints have the same function; the difference is in where you specify them.
Table constraints allow you to specify more than one column in a PRIMARY KEY, UNIQUE, CHECK, or FOREIGN KEY constraint definition.

*/

--CREATE TBL_CONSTRAINT TO VIEW THE DIFFERENT CONSTRAINTS.
--Syntax:
CREATE TABLE [SCHEMA.]table_name
             (column_name datatype [DEFAULT expr]
             [column_constraint],
             ...
             [table_constraint][,...]);

--schema   : is the same as the owner's name.

--COLUMN LEVEL CONSTRAINTS
--Syntax:
column_name [CONSTRAINT constraint_name] constraint_type,
/

--If we do not define the constraint name then the system defines the constraint name itself as (sys_c0011626 (for PRIMARY KEY),sys_c0011625 (for NOT NULL) )
--If we need user define constraint name then we must use CONSTRAINT keyword and constraint name followed by constraint type as in example
--Syntax:
[ CONSTRAINT constraint_name ]
{ [ NOT ] NULL
| UNIQUE
| PRIMARY KEY
| references_clause
| CHECK (condition)
}
[ constraint_state ];

--With SYSTEM defined CONSTRAINT name
DROP TABLE tbl_con PURGE;
CREATE TABLE tbl_con
(
 dept_id       NUMBER       PRIMARY KEY,
 department_id VARCHAR2(10) NOT NULL
);

--with user defined CONSTRAINT name.
DROP TABLE tbl_con PURGE;

--ORA-02449: unique/primary keys in table referenced by foreign keys

--IF the table column is referenced to other table we cannot drop the parent table
--To DROP the parent table we should use CASCADE CONSTRAINT keywords.

DROP TABLE tbl_con CASCADE CONSTRAINT;

CREATE TABLE tbl_con
(
 dept_id         NUMBER        CONSTRAINT pk PRIMARY KEY,
 department_name VARCHAR2(200) CONSTRAINT nn NOT null
);

INSERT INTO tbl_con VALUES (1,'Engineering');

--PRIMARY KEY (dept_id column)
--We cannot use same value for the dept_id column of table tbl_con because dept_id column is PRIMARY KEY CONSTRAINT
INSERT INTO tbl_con VALUES (1,'Management');
--ORA-00001: unique constraint (SYS.PK) violated

INSERT INTO tbl_con VALUES (2,'Management');

--NOT NULL (department_name) : NOT NULL CONSTRAINT Can be defined only in column level
--If we try to insert in tbl_con we cannot insert the following value because department_name cannot be NULL
INSERT INTO tbl_con(dept_id) VALUES (3);
---ORA-01400: cannot insert NULL into ("SYS"."TBL_CON"."DEPARTMENT_NAME")

INSERT INTO tbl_con VALUES (3,'Arts');

SELECT * FROM tbl_con;

DROP TABLE tbl_constraint PURGE;
CREATE TABLE tbl_constraint
(
 id             NUMBER        CONSTRAINT pk_id_c  PRIMARY KEY,
 name           VARCHAR2(200) CONSTRAINT nn_name  NOT NULL,
 email          VARCHAR2(200) CONSTRAINT uk_email UNIQUE,
 salary         NUMBER        CONSTRAINT ck_sal   CHECK (salary >10000),
 dept_id        NUMBER        CONSTRAINT fk_dept_id REFERENCES tbl_con(dept_id)
);

SELECT * FROM tbl_constraint;

--CHECK CONSTRAINT (salary column): Here the inserted value is less than 10000 in salary column so the row cannot be inserted.
INSERT INTO tbl_constraint VALUES (101,'Devesh','unidev39@yahoo.com',5000,1);
--ORA-02290: check constraint (SYS.CK_SAL) violated

--Now we assign salary more than 10000 then the row is inserted. salary column value must be greater thtn 10000.
INSERT INTO tbl_constraint VALUES (101,'Devesh','unidev39@yahoo.com',50000,1);

SELECT * FROM tbl_constraint;

--UNIQUE CONSTRAINT (email column): The inserted value of the email duplicate so the value cannot be inserted because in 
--email column we have defined UNIQUE CONSTRAINT
INSERT INTO tbl_constraint VALUES (102,'Saroj','unidev39@yahoo.com',50000,1);
--ORA-00001: unique constraint (SYS.UK_EMAIL) violated

--unique email
INSERT INTO tbl_constraint VALUES (102,'Saroj','saroj@yahoo.com',20000,1);

SELECT * FROM tbl_constraint;

--FOREGIN KEY CONSTRAINT (dept_id  column) : Here the dept_id column of table tbl_constraint is a reference to the parent table tbl_con column dept_id.
--And the child table dept_id column can only have only the value present in dept_id of tbl_con
INSERT INTO tbl_constraint VALUES (103,'Devesh','devesh@yahoo.com',110000,4);
--ORA-02291: integrity constraint (SYS.FK_DEPT_ID) violated - parent key not found

--the dept_id value of child table is same as the dept_id value of parent table
INSERT INTO tbl_constraint VALUES (103,'Devesh','devesh@yahoo.com',110000,3);

SELECT * FROM tbl_constraint;


--TABLE LEVEL CONSTRAINTS
--Syntax:
column_name
     [CONSTRAINT constraint_name ] constraint_type
     (column_name,...),

--Syntax:
[ CONSTRAINT constraint_name ]
{ UNIQUE (column [, column ]...)
| PRIMARY KEY (column [, column ]...)
| FOREIGN KEY (column [, column ]...)
     references_clause
| CHECK (condition)
}
[ constraint_state ];


DROP TABLE tbl_constraint PURGE;
CREATE TABLE tbl_constraint
(
 id                   NUMBER,
 name                 VARCHAR2(200) CONSTRAINT nn_name  NOT NULL,
 email                VARCHAR2(200),
 salary               NUMBER,
 dept_id              NUMBER,
 CONSTRAINT pk_id_c   PRIMARY KEY(id),
 CONSTRAINT uk_email  UNIQUE (email),
 CONSTRAINT ck_sal    CHECK (salary >10000),
 CONSTRAINT fk_dep_id FOREIGN KEY(dept_id) REFERENCES tbl_con(dept_id)
);

INSERT INTO tbl_constraint VALUES (1,'Devesh','unidev39@hotmail.com',20000,2);

SELECT * FROM tbl_constraint;

--ADDING A CONSTRAINT
--Use the ALTER TABLE statement to :
--.Add or Drop a constraint, but not modify its structure
--.Enable or disable constraints
--.Add a NOT NULL constraint by using the MODIFY clause

--Syntax:
ALTER TABLE table_name
ADD [CONSTRAINT constraint_name] constraint_type (column_name);

DROP TABLE tbl_alter_constraint PURGE;
CREATE TABLE tbl_alter_constraint
(
 id             NUMBER,
 name           VARCHAR2(200),
 email          VARCHAR2(200),
 salary         NUMBER,
 department_id  NUMBER
);

SELECT * FROM tbl_alter_constraint ;

--Way to add PRIMARY KEY
ALTER TABLE tbl_alter_constraint
ADD CONSTRAINT pk_id_alter PRIMARY KEY (id);

--Way to add NOT NULL CONSTRAINT
ALTER TABLE tbl_alter_constraint
MODIFY name CONSTRAINT c_nn NOT NULL;

--Wat to add UNIQUE CONSTRAINT
ALTER TABLE tbl_alter_constraint
ADD CONSTRAINT uk_c UNIQUE (email);

--Way to add CHECK CONSTRAINT
ALTER TABLE tbl_alter_constraint
ADD CONSTRAINT ck_salary CHECK(salary > 5000);

--Way to add FOREIGN KEY CONSTRAINT
ALTER TABLE tbl_alter_constraint
ADD CONSTRAINT fk_depid FOREIGN KEY(department_id) REFERENCES tbl_con(dept_id);

--DROPPING A CONSTRAINT
--We can drop any CONSTRAINT from the table
--Syntax:
ALTER TABLE table_name
DROP CONSTRAINT constraint_name;

--EG:
--We drop CHECK CONSTRAINT ck_salary from the salary column of the tbl_alter_constraint table
ALTER TABLE tbl_alter_constraint
DROP CONSTRAINT ck_salary;

--DISABLING CONSTRAINT
--We can deactive an intrigrity constraint by executing DISABLE clause of the ALTER TABLE Statement
--Syntax:
ALTER TABLE table_name
DISABLE CONSTRAINT constraint_name CASCADE;

--EG:
ALTER TABLE tbl_alter_constraint
DISABLE CONSTRAINT c_nn CASCADE;

SELECT * FROM tbl_alter_constraint ;

--let us INSERT NULL value in name column  of tbl_alter_constraint table;
INSERT INTO tbl_alter_constraint(ID, EMAIL, SALARY, DEPARTMENT_ID)  VALUES (1,'unidev39@gmail.com',20000,1);

--ENABLING CONSTRAINTS
--Syntax:
ALTER TABLE table_name
ENABLE CONSTRAINT constraint_name;

--EG:
ALTER TABLE tbl_alter_constraint
ENABLE CONSTRAINT c_nn;

--If there is already NULL value in name column in table then cannot be alter
--After TRUNCATING we can alter the CONSTRAINT to ENABLE mode.
TRUNCATE TABLE tbl_alter_constraint;

ALTER TABLE tbl_alter_constraint
ENABLE CONSTRAINT c_nn;

--CASCADING CONSTRAINTS
--The CASCADE CONSTRAINTS clause is used along with the DROP COLUMN clause.
--The CASCADE CONSTRAINTS clause drops all referential integrity constraints that refer to the
--primary and unique keys defined on the dropped columns.
--The CASCADE CONSTRAINTS clause also drops all multicolumn constraints defined on the dropped columns.

--Syntax:
ALTER TABLE table_name
DROP (constraint_name) CASCADE CONSTRAINTS;

--Composit constraints
CREATE TABLE test_5
(
 col_1 NUMBER,
 col_2 NUMBER,
 col_3 VARCHAR2(10) NOT NULL,
 CONSTRAINT pk_col_1_2 PRIMARY KEY (col_1,col_2)
);

--VIEWING CONSTRAINTS
--Query the USER_CONSTRAINTS table to view all constraint definitions and names.

SELECT
      constraint_name,
      constraint_type,
      search_condition
FROM
      user_constraints
where
       table_name = 'EMPLOYEES';

--VIEWING THE COLUMNS ASSOCIATED WITH CONSTRAINTS
SELECT
      constraint_name,
      column_name
FROM
      user_cons_columns
where
       table_name = 'EMPLOYEES';
