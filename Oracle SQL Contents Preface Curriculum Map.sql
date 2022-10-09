--Oracle SQL Contents Preface Curriculum Map
A. Introduction - (Overview)
   1. Objectives
   2. Oracle Versioning
   3. Oracle Database Architecture
   4. Oracle Wearhouse Architecture
   5. ELT vs ETL

B. Writing Basic SQL SELECT Statements
   1.  Basic SELECT Statement
   2.  Selecting All Columns
   3.  Selecting Specific Columns Writing SQL Statements
   4.  What is Dual Table
   5.  The SET Operators
   6.  Tables Used in This Lesson
   7.  The UNION SET Operator
   8.  The UNION ALL Operator
   9.  The INTERSECT Operator
   10. The MINUS Operator
   11. Using With clause
   12. Column Heading Defaults Arithmetic Expressions
   13. Using Arithmetic Operators
   14. Operator Precedence 
   15. Using Parentheses 
   16. Defining a Null Value
   17. Null Values in Arithmetic Expressions
   18. Defining a Column Alias 
   19. Using Column Aliases  Concatenation Operator 
   20. Using the Concatenation Operator  Literal Character Strings 
   21. Using Literal Character Strings 
   22. Duplicate Rows 
   23. Eliminating Duplicate Rows 
   24. Displaying Table Structure 

C. Restricting and Sorting Data
   1.  Limiting Rows Using a Selection  Limiting the Rows Selected 
   2.  Using the WHERE Clause
   3.  Character Strings and Dates 
   4.  Comparison Conditions 
   5.  Using Comparison Conditions 
   6.  Other Comparison Conditions 
   7.  Using the BETWEEN Condition  Using the IN Condition 
   8.  Using the LIKE Condition 
   9.  Using the NULL Conditions  Logical Conditions 
   10. Using the AND Operator 
   11. Using the OR Operator 
   12. Using the NOT Operator 
   13. Rules of Precedence
   14. ORDER BY Clause
   15. Sorting in Descending Order
   16. Sorting by Column Alias
   17. Sorting by Multiple Columns

D. Single-Row Functions
   1.  SQL Functions
   2.  Two Types of SQL Functions
   3.  Single-Row Functions
   4.  Character Functions
   5.  Case Manipulation Functions
   6.  Using Case Manipulation Functions
   7.  Character-Manipulation Functions
   8.  Using the Character-Manipulation Functions
   9.  Number Functions
   10. Using the ROUND Function
   11. Using the TRUNC Function
   12. Using the MOD Function
   13. Working with Dates
   14. Arithmetic with Dates
   15. Using Arithmetic Operators with Dates
   16. Date Functions
   17. Using Date Functions
   18. Conversion Functions
   19. Implicit Data-Type Conversion
   20. Explicit Data-Type Conversion
   21. Using the TO_CHAR Function with Dates
   22. Elements of the Date Format Model
   23. Using the TO_CHAR Function with Dates
   24. Using the TO_CHAR Function with Numbers
   25. Using the TO_NUMBER and TO_DATE Functions
   26. RR Date Format
   27. Nesting Functions
   28. General Functions
   29. NVL Function
   30. Using the NVL Function
   31. Using the NVL2 Function
   32. Using the NULLIF Function
   33. Using the COALESCE Function
   34. Conditional Expressions
   35. The CASE Expression
   36. Using the CASE Expression
   37. The DECODE Function
   38. Using the DECODE Function
   39. Oracle Datetime Functions
   40. TIME ZONES
   41. CURRENT_DATE
   42. CURRENT_TIMESTAMP
   43. LOCALTIMESTAMP
   44. DBTIMEZONE and SESSIONTIMEZONE
   45. EXTRACT


E. Displaying Data from Multiple Tables
   1.  Obtaining Data from Multiple Tables
   2.  Cartesian Products
   3.  Generating a Cartesian Product
   4.  Types of Joins
   5.  Use of an Equijoin
   6.  Retrieving Records with Equijoins.
   7.  Additional Search Conditions Using the AND Operator.
   8.  Qualifying Ambiguous Column Names
   9.  Using Table Aliases
   10. Joining More than Two Tables
   11. Use of Nonequijoins
   12. Retrieving Records with Nonequijoins
   13. Use of Outer Joins
   14. Self Joins
   15. Joining a Table to Itself
   16. Cross Joins
   17. Creating Natural Joins
   18. Creating Joins with the USING Clause
   19. Retrieving Records with the USING Clause
   20. Creating Joins with the ON Clause
   21. Creating Three-Way Joins with the ON Clause
   22. INNER versus OUTER Joins
   23. LEFT OUTER JOIN
   24. RIGHT OUTER JOIN
   25. FULL OUTER JOIN

F. Aggregating Data Using Group Functions
   1.  What Are Group Functions
   2.  Types of Group Functions
   3.  Using the AVG and SUM Functions
   4.  Using the MIN and MAX Functions
   5.  Using the COUNT Function
   6.  Using the DISTINCT Keyword
   7.  Group Functions and Null Values
   8.  Using the NVL Function with Group Functions
   9.  Creating Groups of Data
   10. Using the GROUP BY Clause
   11. Grouping by More Than One Column
   12. Using the GROUP BY Clause on Multiple Columns
   13. Illegal Queries Using Group Functions
   14. Excluding Group Results
   15. The HAVING Clause
   16. Nesting Group Functions
   17. Enhancements to the GROUP BY Clause
   18. GROUP BY with ROLLUP and CUBE Operators
   19. ROLLUP Operator
   20. CUBE Operator
   21. GROUPING Function
   22. GROUPING SETS
   23. Composite Columns
   24. Concatenated Groupings

G. Subqueries
   1.  Using a Subquery
   2.  Guidelines for Using Subqueries
   3.  Types of Subqueries
   4.  Single-Row Subqueries
   5.  Using Group Functions in a Subquery
   6.  The HAVING Clause with Subqueries
   7.  What Is Wrong with This Statement?
   8.  Will This Statement Return Rows? 
   9.  Multiple-Row Subqueries
   10. Using the ANY Operator in Multiple-Row Subqueries
   11. Null Values in a Subquery
   12. Advanced Subqueries
   13. Multiple-Column Subqueries
   14. Column Comparisons
   15. Pairwise Comparison Subquery
   16. Nonpairwise Comparison Subquery
   17. Using a Subquery in the FROM Clause
   18. Scalar Subquery Expressions
   19. Correlated Subqueries
   20. Using Correlated Subqueries
   21. Using the EXISTS Operator
   22. Using the NOT EXISTS Operator
   23. Correlated UPDATE
   24. Correlated DELETE
   25. The WITH Clause

H. Hierarchical Retrieval
   1.  Sample Data from the EMPLOYEES Table
   2.  Natural Tree Structure
   3.  Hierarchical Queries
   4.  Walking the Tree: From the Bottom Up
   5.  Walking the Tree: From the Top Down
   6.  Ranking Rows with the LEVEL Pseudocolumn
   7.  Formatting Hierarchical Reports Using LEVEL and LPAD

I. Manipulating Data
   1.  Data Manipulation Language
   2.  Adding a New Row to a Table
   3.  Inserting Rows with Null Values
   4.  Inserting Special Values
   5.  Inserting Specific Date Values
   6.  Copying Rows from Another Table
   7.  Types of Multitable INSERT Statements
   8.  Multitable INSERT Statements
   9.  Unconditional INSERT ALL
   10. Conditional INSERT ALL
   11. Conditional FIRST INSERT
   12. Changing Data in a Table
   13. The UPDATE Statement
   14. Updating Rows in a Table 8-14
   15. Updating Two Columns with a Subquery
   16. Updating Rows Based on Another Table
   17. Updating Rows: Updating Rows: Integrity Constraint Error
   18. Removing a Row from a Table.
   19. Deleting Rows Based on Another Table
   20. Deleting Rows: Integrity Constraint Error
   21. Using a Subquery in an INSERT Statement
   22. Using the WITH CHECK OPTION Keyword on DML Statements
   23. Using Explicit Default Values
   24. The MERGE Statement
   25. Database Transactions
   26. Advantages of COMMIT and ROLLBACK Statements
   27. Controlling Transactions
   28. Rolling Back Changes to a Marker
   29. Implicit Transaction Processing
   30. State of the Data Before COMMIT or ROLLBACK
   31. State of the Data After COMMIT
   32. Committing Data
   33. State of the Data After ROLLBACK
   34. Statement-Level Rollback
   35. Read Consistency

J. Creating and Managing Tables
   1.  Database Objects
   2.  Naming Rules
   3.  The CREATE TABLE Statement
   4.  Referencing Another Users Tables
   5.  The DEFAULT Option
   6.  Creating Tables
   7.  Tables in the Oracle Database
   8.  Querying the Data Dictionary
   9.  Data Types
   10. Datetime Data Types
   11. TIMESTAMP WITH TIME ZONE Data Type
   12. TIMESTAMP WITH LOCAL TIME Data Type
   13. INTERVAL YEAR TO MONTH Data Type
   14. Creating a Table  by Using a Subquery
   15. The ALTER TABLE Statement
   16. Adding a Column
   17. Modifying a Column
   18. Dropping a Column
   19. The SET UNUSED Option
   20. Dropping a Table
   21. Changing the Name of an Object
   22. Truncating a Table
   23. Adding Comments to a Table
   24. Normal table structure
   25. Using no logging mechanism
   26. Create Table by Copying another table structure with all data
   27. Create Table by Copying another table structure without data.
   28. Using compressed data
   29. Using parallel data
   30. Using compressed nologing parallel
   31. Table column data type change and create structure as per as client required
   32. Create table with Virtual Columns
   33. Create Directory 
   34. External Table
   35. Comma Delimited
   36. Pipe Delimited
   37. Tab Delimited
   38. Size Delimited
   39. New line Delimited
   40. External Table by defining Log_File and Bad_File
   41. Global Temporary Table
   42. ON COMMIT DELETE ROWS
   43. ON COMMIT PRESERVE ROWS

K. Including Constraints
   1.  What Are Constraints?
   2.  Constraint Guidelines
   3.  Defining Constraints
   4.  The NOT NULL Constraint
   5.  The UNIQUE Constraint
   6.  The PRIMARY KEY Constraint
   7.  The FOREIGN KEY Constraint
   8.  The CHECK Constraint 10-16
   9.  Adding a Constraint
   10. Dropping a Constraint
   11. Disabling Constraints
   12. Enabling Constraints
   13. Cascading Constraints
   14. Viewing Constraints
   15. Viewing the Columns Associated with Constraints

L. Creating Views Objectives
   1.  What Is a View?
   2.  Why Use Views?
   3.  Simple Views
   4.  Complex Views
   5.  Creating a View
   6.  Retrieving Data from a View
   7.  Modifying a View
   8.  Creating a Complex View
   9.  Rules for Performing DML Operations on a View
   10. Using the WITH CHECK OPTION Clause
   11. Denying DML Operations
   12. Removing a View
   13. Inline Views
   14. Top-n Analysis
   15. Performing Top-n Analysis

M. Other Database Objects Objectives
   1.  What Is a Sequence?
   2.  Creating a Sequence
   3.  Confirming Sequences
   4.  NEXTVAL and CURRVAL Pseudocolumns
   5.  Using a Sequence
   6.  Modifying a Sequence
   7.  Guidelines for Modifying a Sequence
   8.  Removing a Sequence
   9.  What Is an Index?
   10. How Are Indexes Created?
   11. Creating an Index
   12. When to Create an Index
   13. When Not to Create an Index
   14. Confirming Indexes
   15. Function-Based Indexes
   16. Removing an Index
   17. Creating Synonyms
   18. Removing Synonyms
   19. View Synonyms

N. Controlling User Access
   1.  Controlling User Access
   2.  Privileges
   3.  System Privileges
   4.  Creating Users
   5.  User System Privileges
   6.  Granting System Privileges
   7.  What Is a Role?
   8.  Creating and Granting Privileges to a Role
   9.  Changing Your Password
   10. Object Privileges
   11. Granting Object Privileges
   12. Using the WITH GRANT OPTION and PUBLIC Keywords
   13. Confirming Privileges Granted
   14. How to Revoke Object Privileges
   15. Revoking Object Privileges
   16. Database Links

O. Oracle Analytical Functions
   --1.  over 
   --2.  partition by 
   --3.  order by
   4.  rank
   5.  dense_rank
   6.  lag
   7.  lead
   8.  row_number
   9.  wm_concat
   10. listagg
   11. first_value
   12. last_value

P. Oracle Regular Expression
   1.  regexp_count
   2.  regexp_like
   3.  regexp_substr
   4.  regexp_instr
   5.  regexp_replace

Q. Oracle Partitione Tables and Indexs
   1.  Benefits of Partitioning
   2.  Partitioning Concepts
   3.  Basics of Partitioning
   4.  Partitioning Key
   5.  When to Partition a Table
   6.  Partitioning for Performance
   7.  Partition Pruning
   8.  Oracle Consistent gets
   9.  Partition-Wise Joins
   10. Partitioning Strategies
   11. Single-Level Partitioning (DEFAULT/TABLESPACE/STORE IN)
       • Range Partitioning
           Using Table Compression with Partitioned Tables
           Using Multicolumn Partitioning Keys
           Using ENABLE ROW MOVEMENT
           Using Interval-Partitioned
           Using Virtual Column
           Using reference-partitioned tables
       • Hash Partitioning
           Using Table Compression with Partitioned Tables
           Using Multicolumn Partitioning Keys
           Using ENABLE ROW MOVEMENT
           Using Interval-Partitioned
           Using Virtual Column
           Using reference-partitioned tables
       • List Partitioning
           Using Table Compression with Partitioned Tables
           Using Multicolumn Partitioning Keys
           Using Default Partition
           Using NULL Partition
           Using ENABLE ROW MOVEMENT
   12. Composite Partitioning (DEFAULT/TABLESPACE/STORE IN)
       • Composite Range-Range Partitioning.
       • Composite Range-Hash Partitioning.
       • Composite Range-List Partitioning.
       • Composite Hash-Hash Partitioning.
       • Composite Hash-Range Partitioning.
       • Composite Hash-List Partitioning.
       • Composite List-List Partitioning.
       • Composite List-Range Partitioning.
       • Composite List-Hash Partitioning.
   13. Partition Indexes Organized tables (DEFAULT/TABLESPACE/STORE IN)
       • Local Index
           Prefixed Local Index
           Non_Prefixed Local Index
       • Global Index
           Prefixed Global Index
           Non_Prefixed Global Index
   14. Maintaining Partitions
       • Maintenance Operations on Partitions That Can Be Performed
           ALTER TABLE Maintenance Operations for Table Partitions
           ALTER TABLE Maintenance Operations for Table Subpartitions
           ALTER INDEX Maintenance Operations for Index Partitions
       • Adding Partitions
           Adding a Partition to a Range-Partitioned Table
           Adding a Partition to a Hash-Partitioned Table
           Adding a Partition to a List-Partitioned Table
           Adding a Partition to an Interval-Partitioned Table
           Adding Partitions to a Composite *-Hash Partitioned Table
           Adding a Partition to a *-Hash Partitioned Table
           Adding a Subpartition to a *-Hash Partitioned Table
           Adding Partitions to a Composite *-List Partitioned Table
           Adding a Partition to a *-List Partitioned Table
           Adding a Subpartition to a *-List Partitioned Table
           Adding Partitions to a Composite *-Range Partitioned Table
           Adding a Partition to a *-Range Partitioned Table
           Adding a Subpartition to a *-Range Partitioned Table
           Adding Index Partitions
       • Coalescing Partitions
           Coalescing a Partition in a Hash-Partitioned Table
           Coalescing a Subpartition in a *-Hash Partitioned Table
           Coalescing Hash-Partitioned Global Indexes
       • Dropping Partitions
           Exchanging Partitions
           Exchanging a Range, Hash, or List Partition
           Exchanging a Partition of an Interval Partitioned Table
           Exchanging a Partition of a Reference-Partitioned Table
           Exchanging a Hash-Partitioned Table with a *-Hash Partition
           Exchanging a Subpartition of a *-Hash Partitioned Table
           Exchanging a List-Partitioned Table with a *-List Partition
           Exchanging a Range-Partitioned Table with a *-Range Partition
       • Merging Partitions
           Merging Range Partitions
           Merging Interval Partitions
           Merging List Partitions
           Merging *-Hash Partitions
           Merging *-List Partitions
           Merging Partitions in a *-List Partitioned Table
           Merging Subpartitions in a *-List Partitioned Table
           Merging *-Range Partitions
       • Modifying Default Attributes
       • Modifying Real Attributes of Partitions
           Modifying Real Attributes for a Range or List Partition
           Modifying Real Attributes of a Subpartition
       • Modifying List Partitions: Adding Values
           Adding Values for a List Partition
           Adding Values for a List Subpartition
       • Modifying List Partitions: Dropping Values
           Dropping Values from a List Partition
           Dropping Values from a List Subpartition
       • Modifying a Subpartition Template
       • Moving Partitions
           Moving Table Partitions
           Moving Subpartitions
       • Rebuilding Index Partitions
       • Renaming Partitions
       • Truncating Partitions
       • Splitting Partitions
           Splitting a Partition of a Range-Partitioned Table
           Splitting a Partition of a List-Partitioned Table
           Splitting a Partition of an Interval-Partitioned Table
           Splitting a *-Hash Partition
           Splitting Partitions in a *-List Partitioned Table
           Splitting a *-List Partition
           Splitting a *-List Subpartition
           Splitting Partitions in a *-Range Partition
           Splitting a *-Range Partition
           Splitting a *-Range Subpartition
   15. Customized Oracle PL/SQL Units to Fulfill the naming conventions
   16. DML Operations with Oracle Partition Table
   17. Non-Partitioned table to a Partitioned table
   18. Partitioned table to a Non-Partitioned table
   19. Conversion of improper Partition to proper partition