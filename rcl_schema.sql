set echo on
SPOOL rcl_schema_output.txt

--student id: 34715320
--student name: Senuthi Seneviratne

--student id: 32844700
--student name: Teh Jia Xuan

--student id: 33244413
--student name: Woon Chong

-- Generated by Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   at:        2024-09-17 21:18:25 SGT
--   site:      Oracle Database 12c
--   type:      Oracle Database 12c



DROP TABLE author CASCADE CONSTRAINTS;

DROP TABLE author_call CASCADE CONSTRAINTS;

DROP TABLE book_copy CASCADE CONSTRAINTS;

DROP TABLE borrower CASCADE CONSTRAINTS;

DROP TABLE borrower_class CASCADE CONSTRAINTS;

DROP TABLE branch CASCADE CONSTRAINTS;

DROP TABLE catalogue_entry CASCADE CONSTRAINTS;

DROP TABLE isbn CASCADE CONSTRAINTS;

DROP TABLE lga CASCADE CONSTRAINTS;

DROP TABLE loan CASCADE CONSTRAINTS;

DROP TABLE manager CASCADE CONSTRAINTS;

DROP TABLE publisher CASCADE CONSTRAINTS;

DROP TABLE reserve CASCADE CONSTRAINTS;

DROP TABLE subject CASCADE CONSTRAINTS;

DROP TABLE subject_call CASCADE CONSTRAINTS;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE author (
    author_id    NUMBER(4) NOT NULL,
    author_fname VARCHAR2(20) NOT NULL,
    author_lname VARCHAR2(20) NOT NULL
);

COMMENT ON COLUMN author.author_id IS
    'author id';

COMMENT ON COLUMN author.author_fname IS
    'Author''s first name';

COMMENT ON COLUMN author.author_lname IS
    'Author''s last name';

ALTER TABLE author ADD CONSTRAINT author_pk PRIMARY KEY ( author_id );

CREATE TABLE author_call (
    ac_no        NUMBER(4) NOT NULL,
    author_id    NUMBER(4) NOT NULL,
    cata_call_no VARCHAR2(30) NOT NULL
);

COMMENT ON COLUMN author_call.ac_no IS
    'author catalogue entry (surrogate pk)';

COMMENT ON COLUMN author_call.author_id IS
    'author id';

COMMENT ON COLUMN author_call.cata_call_no IS
    'Catalogue call ID';

ALTER TABLE author_call ADD CONSTRAINT author_call_pk PRIMARY KEY ( ac_no );

ALTER TABLE author_call ADD CONSTRAINT author_call_nk UNIQUE ( cata_call_no,
                                                               author_id );

CREATE TABLE book_copy (
    bookcopy_id    NUMBER(10) NOT NULL,
    branch_code    NUMBER(10) NOT NULL,
    bookcopy_flag  CHAR(1) NOT NULL,
    bookcopy_price NUMBER(4, 2) NOT NULL,
    isbn_no        NUMBER(13) NOT NULL
);

ALTER TABLE book_copy
    ADD CONSTRAINT chk_bookcopy_status CHECK ( bookcopy_flag IN ( 'A', 'D', 'G', 'L', 'R',
                                                                  'S' ) );

COMMENT ON COLUMN book_copy.bookcopy_id IS
    'book copy id';

COMMENT ON COLUMN book_copy.branch_code IS
    'branch code';

COMMENT ON COLUMN book_copy.bookcopy_flag IS
    'flag (Reserve, R, On Loan, L, Available, A, Stolen, S, Lost/Gone, G, Damage, D)';

COMMENT ON COLUMN book_copy.bookcopy_price IS
    'Price to purchase  bookcopy';

COMMENT ON COLUMN book_copy.isbn_no IS
    'ISBN code';

ALTER TABLE book_copy ADD CONSTRAINT book_copy_pk PRIMARY KEY ( bookcopy_id,
                                                                branch_code );

CREATE TABLE borrower (
    borrower_id       NUMBER(10) NOT NULL,
    branch_code       NUMBER(10) NOT NULL,
    borrower_fname    VARCHAR2(20) NOT NULL,
    borrower_lname    VARCHAR2(20) NOT NULL,
    borrower_status   CHAR(1) NOT NULL,
    borrower_street   VARCHAR2(15) NOT NULL,
    borrower_city     VARCHAR2(15) NOT NULL,
    borrower_postcode NUMBER(5) NOT NULL,
    borrower_state    VARCHAR2(15) NOT NULL,
    borrower_phone_no CHAR(12),
    borrow_class_type CHAR(1) NOT NULL
);

ALTER TABLE borrower
    ADD CONSTRAINT chk_borrower_status CHECK ( borrower_status IN ( 'B', 'P' ) );

COMMENT ON COLUMN borrower.borrower_id IS
    'borrower id';

COMMENT ON COLUMN borrower.branch_code IS
    'branch code';

COMMENT ON COLUMN borrower.borrower_fname IS
    'Borrower''s first name';

COMMENT ON COLUMN borrower.borrower_lname IS
    'Borrower''s last name';

COMMENT ON COLUMN borrower.borrower_status IS
    'Borrower Status (P - Permitted / B - Banned)';

COMMENT ON COLUMN borrower.borrower_street IS
    'Borrower Street';

COMMENT ON COLUMN borrower.borrower_city IS
    'Borrower''s city';

COMMENT ON COLUMN borrower.borrower_postcode IS
    'Borrower''s postcode';

COMMENT ON COLUMN borrower.borrower_state IS
    'Borrower''s state';

COMMENT ON COLUMN borrower.borrower_phone_no IS
    'borrower phone number ';

COMMENT ON COLUMN borrower.borrow_class_type IS
    'Borrower Class (Adult, A, Child, C, Organisation, O)';

ALTER TABLE borrower ADD CONSTRAINT borrower_pk PRIMARY KEY ( borrower_id );

CREATE TABLE borrower_class (
    borrow_class_type        CHAR(1) NOT NULL,
    borrow_class_bookamt     NUMBER(2) NOT NULL,
    borrow_class_loan_period NUMBER(2) NOT NULL
);

ALTER TABLE borrower_class
    ADD CONSTRAINT chk_borrower_classtype CHECK ( borrow_class_type IN ( 'A', 'C', 'O' ) );

COMMENT ON COLUMN borrower_class.borrow_class_type IS
    'Borrower Class (Adult, A, Child, C, Organisation, O)';

COMMENT ON COLUMN borrower_class.borrow_class_bookamt IS
    'book amount that allowed by that class';

COMMENT ON COLUMN borrower_class.borrow_class_loan_period IS
    'Loan period allowed for class';

ALTER TABLE borrower_class ADD CONSTRAINT borrower_class_pk PRIMARY KEY ( borrow_class_type );

CREATE TABLE branch (
    branch_code     NUMBER(10) NOT NULL,
    lga_code        NUMBER(10) NOT NULL,
    manager_id      NUMBER(10) NOT NULL,
    branch_name     VARCHAR2(20) NOT NULL,
    branch_address  VARCHAR2(50) NOT NULL,
    branch_phone_no CHAR(12) NOT NULL
);

COMMENT ON COLUMN branch.branch_code IS
    'branch code';

COMMENT ON COLUMN branch.lga_code IS
    'lga code';

COMMENT ON COLUMN branch.manager_id IS
    'manager id';

COMMENT ON COLUMN branch.branch_name IS
    'Name of Branch';

COMMENT ON COLUMN branch.branch_address IS
    'Branch address';

COMMENT ON COLUMN branch.branch_phone_no IS
    'Branch phone number';

ALTER TABLE branch ADD CONSTRAINT branch_pk PRIMARY KEY ( branch_code );

CREATE TABLE catalogue_entry (
    cata_call_no        VARCHAR2(30) NOT NULL,
    publisher_id        NUMBER(10) NOT NULL,
    cata_title          VARCHAR2(50) NOT NULL,
    cata_content        VARCHAR2(500) NOT NULL,
    cata_published_date NUMBER(4) NOT NULL,
    cata_classification CHAR(1) NOT NULL,
    cata_page_no        NUMBER(4) NOT NULL,
    cata_reading_level  NUMBER(2),
    cata_language       VARCHAR2(20) NOT NULL,
    cata_note           VARCHAR2(200),
    cata_edition        VARCHAR2(20)
);

ALTER TABLE catalogue_entry
    ADD CONSTRAINT chk_cataclass CHECK ( cata_classification IN ( 'F', 'R' ) );

COMMENT ON COLUMN catalogue_entry.cata_call_no IS
    'Catalogue call ID';

COMMENT ON COLUMN catalogue_entry.publisher_id IS
    'publisher id';

COMMENT ON COLUMN catalogue_entry.cata_title IS
    'Catalogue title';

COMMENT ON COLUMN catalogue_entry.cata_content IS
    'Catalogue description';

COMMENT ON COLUMN catalogue_entry.cata_published_date IS
    'Date of catalogue published';

COMMENT ON COLUMN catalogue_entry.cata_classification IS
    'Classification of catalogue genre (Reference, R, Fiction, F)';

COMMENT ON COLUMN catalogue_entry.cata_page_no IS
    'Number of pages';

COMMENT ON COLUMN catalogue_entry.cata_reading_level IS
    'Reading level of catalogue';

COMMENT ON COLUMN catalogue_entry.cata_language IS
    'Language used';

COMMENT ON COLUMN catalogue_entry.cata_note IS
    'catalogue notes';

COMMENT ON COLUMN catalogue_entry.cata_edition IS
    'Edition number';

ALTER TABLE catalogue_entry ADD CONSTRAINT catalogue_entry_pk PRIMARY KEY ( cata_call_no );

CREATE TABLE isbn (
    isbn_no        NUMBER(13) NOT NULL,
    cata_call_no   VARCHAR2(30) NOT NULL,
    isbn_covertype VARCHAR2(20) NOT NULL
);

COMMENT ON COLUMN isbn.isbn_no IS
    'ISBN code';

COMMENT ON COLUMN isbn.cata_call_no IS
    'Catalogue call ID';

COMMENT ON COLUMN isbn.isbn_covertype IS
    'Cover book type';

ALTER TABLE isbn ADD CONSTRAINT isbn_pk PRIMARY KEY ( isbn_no );

CREATE TABLE lga (
    lga_code     NUMBER(10) NOT NULL,
    lga_name     VARCHAR2(50) NOT NULL,
    lga_size     NUMBER(5, 2) NOT NULL,
    lga_contact  VARCHAR2(20) NOT NULL,
    lga_phone_no CHAR(12) NOT NULL
);

COMMENT ON COLUMN lga.lga_code IS
    'lga code';

COMMENT ON COLUMN lga.lga_name IS
    'LGA name';

COMMENT ON COLUMN lga.lga_size IS
    'LGA Size in hectares';

COMMENT ON COLUMN lga.lga_contact IS
    'LGA Service Contact Name';

COMMENT ON COLUMN lga.lga_phone_no IS
    'LGA phone number';

ALTER TABLE lga ADD CONSTRAINT lga_pk PRIMARY KEY ( lga_code );

CREATE TABLE loan (
    loan_id              NUMBER(4) NOT NULL,
    loan_datetime        DATE NOT NULL,
    bookcopy_id          NUMBER(10) NOT NULL,
    branch_code          NUMBER(10) NOT NULL,
    borrower_id          NUMBER(10) NOT NULL,
    loan_due_back        DATE NOT NULL,
    loan_return_datetime DATE,
    loan_fine_amnt       NUMBER(5, 2),
    loan_date_fine_paid  DATE
);

COMMENT ON COLUMN loan.loan_id IS
    'Loan ID (Surrogate Key)';

COMMENT ON COLUMN loan.loan_datetime IS
    'loan datetime';

COMMENT ON COLUMN loan.bookcopy_id IS
    'book copy id';

COMMENT ON COLUMN loan.branch_code IS
    'branch code';

COMMENT ON COLUMN loan.borrower_id IS
    'borrower id';

COMMENT ON COLUMN loan.loan_due_back IS
    'Due date to return bookcopy to branch';

COMMENT ON COLUMN loan.loan_return_datetime IS
    'Date and time for book returned to branch';

COMMENT ON COLUMN loan.loan_fine_amnt IS
    'Amount to pay back for overdue loan';

COMMENT ON COLUMN loan.loan_date_fine_paid IS
    'Date of loan fine paid';

ALTER TABLE loan ADD CONSTRAINT loan_pk PRIMARY KEY ( loan_id );

ALTER TABLE loan
    ADD CONSTRAINT loan_id_nk UNIQUE ( loan_datetime,
                                       bookcopy_id,
                                       branch_code );

CREATE TABLE manager (
    manager_id       NUMBER(10) NOT NULL,
    branch_code      NUMBER(10) NOT NULL,
    manager_fname    VARCHAR2(20) NOT NULL,
    manager_lname    VARCHAR2(20) NOT NULL,
    manager_phone_no CHAR(12) NOT NULL
);

COMMENT ON COLUMN manager.manager_id IS
    'manager id';

COMMENT ON COLUMN manager.branch_code IS
    'branch code';

COMMENT ON COLUMN manager.manager_fname IS
    'Manager''s first name';

COMMENT ON COLUMN manager.manager_lname IS
    'Manager''s last name';

COMMENT ON COLUMN manager.manager_phone_no IS
    'Manager''s phone number';

CREATE UNIQUE INDEX manager__idx ON
    manager (
        branch_code
    ASC );

ALTER TABLE manager ADD CONSTRAINT manager_pk PRIMARY KEY ( manager_id );

CREATE TABLE publisher (
    publisher_id   NUMBER(10) NOT NULL,
    publisher_name VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN publisher.publisher_id IS
    'publisher id';

COMMENT ON COLUMN publisher.publisher_name IS
    'Publisher''s name';

ALTER TABLE publisher ADD CONSTRAINT publisher_pk PRIMARY KEY ( publisher_id );

CREATE TABLE reserve (
    reserve_no       NUMBER(5) NOT NULL,
    reserve_datetime DATE NOT NULL,
    reserve_phone_no NUMBER(12) NOT NULL,
    borrower_id      NUMBER(10) NOT NULL,
    bookcopy_id      NUMBER(10) NOT NULL,
    branch_code      NUMBER(10) NOT NULL
);

COMMENT ON COLUMN reserve.reserve_no IS
    'surrogate key for reserve';

COMMENT ON COLUMN reserve.reserve_datetime IS
    'Datetime reserve was applied';

COMMENT ON COLUMN reserve.reserve_phone_no IS
    'phone no for book reserve';

COMMENT ON COLUMN reserve.borrower_id IS
    'borrower id';

COMMENT ON COLUMN reserve.bookcopy_id IS
    'book copy id';

COMMENT ON COLUMN reserve.branch_code IS
    'branch code';

ALTER TABLE reserve ADD CONSTRAINT reserve_pk PRIMARY KEY ( reserve_no );

ALTER TABLE reserve ADD CONSTRAINT reserve_nk UNIQUE ( reserve_datetime,
                                                       reserve_phone_no );

CREATE TABLE subject (
    subject_id   NUMBER(10) NOT NULL,
    subject_desc VARCHAR2(100) NOT NULL
);

COMMENT ON COLUMN subject.subject_id IS
    'Subject ID';

COMMENT ON COLUMN subject.subject_desc IS
    'Description of subject';

ALTER TABLE subject ADD CONSTRAINT subject_pk PRIMARY KEY ( subject_id );

CREATE TABLE subject_call (
    sc_no        NUMBER(4) NOT NULL,
    cata_call_no VARCHAR2(30) NOT NULL,
    subject_id   NUMBER(10) NOT NULL
);

COMMENT ON COLUMN subject_call.sc_no IS
    'surrogate key for subject call entity';

COMMENT ON COLUMN subject_call.cata_call_no IS
    'Catalogue call ID';

COMMENT ON COLUMN subject_call.subject_id IS
    'Subject ID';

ALTER TABLE subject_call ADD CONSTRAINT subject_call_pk PRIMARY KEY ( sc_no );

ALTER TABLE subject_call ADD CONSTRAINT subject_call_nk UNIQUE ( cata_call_no,
                                                                 subject_id );

ALTER TABLE author_call
    ADD CONSTRAINT author_athcall_fk FOREIGN KEY ( author_id )
        REFERENCES author ( author_id );

ALTER TABLE loan
    ADD CONSTRAINT bookcopy_loan_fk FOREIGN KEY ( bookcopy_id,
                                                  branch_code )
        REFERENCES book_copy ( bookcopy_id,
                               branch_code );

ALTER TABLE reserve
    ADD CONSTRAINT bookcopy_reserve FOREIGN KEY ( bookcopy_id,
                                                  branch_code )
        REFERENCES book_copy ( bookcopy_id,
                               branch_code );

ALTER TABLE borrower
    ADD CONSTRAINT borrower_class_borrower_fk FOREIGN KEY ( borrow_class_type )
        REFERENCES borrower_class ( borrow_class_type );

ALTER TABLE loan
    ADD CONSTRAINT borrower_loan_fk FOREIGN KEY ( borrower_id )
        REFERENCES borrower ( borrower_id );

ALTER TABLE reserve
    ADD CONSTRAINT borrower_reserve_fk FOREIGN KEY ( borrower_id )
        REFERENCES borrower ( borrower_id );

ALTER TABLE book_copy
    ADD CONSTRAINT branch_bookcopy_fk FOREIGN KEY ( branch_code )
        REFERENCES branch ( branch_code );

ALTER TABLE borrower
    ADD CONSTRAINT branch_borrower_fk FOREIGN KEY ( branch_code )
        REFERENCES branch ( branch_code );

ALTER TABLE manager
    ADD CONSTRAINT branch_manager_fk FOREIGN KEY ( branch_code )
        REFERENCES branch ( branch_code );

ALTER TABLE subject_call
    ADD CONSTRAINT cat_subcall_fk FOREIGN KEY ( cata_call_no )
        REFERENCES catalogue_entry ( cata_call_no );

ALTER TABLE author_call
    ADD CONSTRAINT cata_athcall_fk FOREIGN KEY ( cata_call_no )
        REFERENCES catalogue_entry ( cata_call_no );

ALTER TABLE isbn
    ADD CONSTRAINT cata_isbn_fk FOREIGN KEY ( cata_call_no )
        REFERENCES catalogue_entry ( cata_call_no );

ALTER TABLE book_copy
    ADD CONSTRAINT isbn_bookcopy_fk FOREIGN KEY ( isbn_no )
        REFERENCES isbn ( isbn_no );

ALTER TABLE branch
    ADD CONSTRAINT lga_branch_fk FOREIGN KEY ( lga_code )
        REFERENCES lga ( lga_code );

ALTER TABLE branch
    ADD CONSTRAINT manager_branch_fk FOREIGN KEY ( manager_id )
        REFERENCES manager ( manager_id );

ALTER TABLE catalogue_entry
    ADD CONSTRAINT publisher_cata_fk FOREIGN KEY ( publisher_id )
        REFERENCES publisher ( publisher_id );

ALTER TABLE subject_call
    ADD CONSTRAINT subj_subjcall_fk FOREIGN KEY ( subject_id )
        REFERENCES subject ( subject_id );



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            15
-- CREATE INDEX                             1
-- ALTER TABLE                             40
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- TSDP POLICY                              0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
SPOOL off
set echo off
