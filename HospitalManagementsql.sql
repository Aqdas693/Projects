--  HOSPITAL MANAGEMENT SYSTEM
--  Database: MySQL 8.x
-- ============================================================


-- ============================================================
-- TABLE CREATION
-- ============================================================

CREATE TABLE Department (
    dept_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dept_name    VARCHAR2(100) NOT NULL,
    location     VARCHAR2(100),
    head_doctor  VARCHAR2(100)
);

CREATE TABLE Doctor (
    doctor_id    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name   VARCHAR2(50)  NOT NULL,
    last_name    VARCHAR2(50)  NOT NULL,
    specialization VARCHAR2(100),
    phone        VARCHAR2(20),
    email        VARCHAR2(100) UNIQUE,
    dept_id      NUMBER,
    hire_date    DATE,
    CONSTRAINT fk_dept
        FOREIGN KEY (dept_id)
        REFERENCES Department(dept_id)
        ON DELETE SET NULL
);

CREATE TABLE Patient (
    patient_id   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name   VARCHAR2(50) NOT NULL,
    last_name    VARCHAR2(50) NOT NULL,
    dob          DATE,
    gender       VARCHAR2(10) CHECK (gender IN ('Male','Female','Other')),
    phone        VARCHAR2(20),
    email        VARCHAR2(100),
    address      CLOB,
    blood_group  VARCHAR2(5),
    reg_date     DATE DEFAULT SYSDATE
);

CREATE TABLE Room (
    room_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    room_number  VARCHAR2(10) NOT NULL UNIQUE,
    room_type    VARCHAR2(20) CHECK (room_type IN ('General','Semi-Private','Private','ICU')),
    floor        NUMBER,
    is_available NUMBER(1) DEFAULT 1,
    daily_rate   NUMBER(8,2)
);

CREATE TABLE Appointment (
    appt_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id   NUMBER NOT NULL,
    doctor_id    NUMBER NOT NULL,
    appt_date    DATE NOT NULL,
    appt_time    VARCHAR2(10) NOT NULL,
    reason       VARCHAR2(255),
    status       VARCHAR2(20) DEFAULT 'Scheduled'
        CHECK (status IN ('Scheduled','Completed','Cancelled')),

    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id)  REFERENCES Doctor(doctor_id)  ON DELETE CASCADE
);

CREATE TABLE Admission (
    admission_id   NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id     NUMBER NOT NULL,
    doctor_id      NUMBER NOT NULL,
    room_id        NUMBER NOT NULL,
    admit_date     DATE NOT NULL,
    discharge_date DATE,
    diagnosis      CLOB,

    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (doctor_id)  REFERENCES Doctor(doctor_id),
    FOREIGN KEY (room_id)    REFERENCES Room(room_id)
);

CREATE TABLE Medicine (
    med_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    med_name     VARCHAR2(100) NOT NULL,
    category     VARCHAR2(50),
    unit_price   NUMBER(8,2),
    stock_qty    NUMBER DEFAULT 0
);

CREATE TABLE Prescription (
    pres_id       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    appt_id       NUMBER NOT NULL,
    med_id        NUMBER NOT NULL,
    dosage        VARCHAR2(50),
    duration_days NUMBER,

    FOREIGN KEY (appt_id) REFERENCES Appointment(appt_id) ON DELETE CASCADE,
    FOREIGN KEY (med_id)  REFERENCES Medicine(med_id)
);

CREATE TABLE Bill (
    bill_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id   NUMBER NOT NULL,
    admission_id NUMBER,
    bill_date    DATE DEFAULT SYSDATE,

    room_charges    NUMBER(10,2) DEFAULT 0,
    medicine_charges NUMBER(10,2) DEFAULT 0,
    doctor_charges   NUMBER(10,2) DEFAULT 0,
    other_charges    NUMBER(10,2) DEFAULT 0,
    total_amount     NUMBER(10,2),

    payment_status VARCHAR2(20) DEFAULT 'Pending'
        CHECK (payment_status IN ('Pending','Paid','Partial')),

    FOREIGN KEY (patient_id)   REFERENCES Patient(patient_id),
    FOREIGN KEY (admission_id) REFERENCES Admission(admission_id)
);

CREATE TABLE Staff (
    staff_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name   VARCHAR2(50) NOT NULL,
    last_name    VARCHAR2(50) NOT NULL,
    role         VARCHAR2(50),
    dept_id      NUMBER,
    phone        VARCHAR2(20),
    salary       NUMBER(10,2),

    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

-- ============================================================
-- INSERT DATA
-- ============================================================

INSERT INTO Department (dept_name, location, head_doctor) VALUES('Cardiology', 'Block A, Floor 1', 'Dr. Ahmed Khan');
INSERT INTO Department (dept_name, location, head_doctor) VALUES('Orthopedics', 'Block B, Floor 2', 'Dr. Sara Ali');
INSERT INTO Department (dept_name, location, head_doctor) VALUES('Neurology', 'Block A, Floor 3', 'Dr. Usman Raza');
INSERT INTO Department (dept_name, location, head_doctor) VALUES('Pediatrics', 'Block C, Floor 1', 'Dr. Ayesha Malik');
INSERT INTO Department (dept_name, location, head_doctor) VALUES('General Surgery', 'Block B, Floor 1', 'Dr. Bilal Hassan');
SELECT * FROM Department;
INSERT INTO Doctor (first_name, last_name, specialization, phone, email, dept_id, hire_date) VALUES('Ahmed','Khan','Cardiologist','0300-1111111','ahmed.khan@hospital.com',7, DATE '2015-03-10');
INSERT INTO Doctor (first_name, last_name, specialization, phone, email, dept_id, hire_date) VALUES('Sara','Ali','Orthopedic','0300-2222222','sara.ali@hospital.com',8, DATE '2017-06-15');
INSERT INTO Doctor (first_name, last_name, specialization, phone, email, dept_id, hire_date) VALUES('Usman','Raza','Neurologist','0300-3333333','usman.raza@hospital.com',9, DATE '2018-01-20');
INSERT INTO Doctor (first_name, last_name, specialization, phone, email, dept_id, hire_date) VALUES('Ayesha','Malik','Pediatrician','0300-4444444','ayesha.malik@hospital.com',10, DATE '2016-09-05');
INSERT INTO Doctor (first_name, last_name, specialization, phone, email, dept_id, hire_date) VALUES('Bilal','Hassan','General Surgeon','0300-5555555','bilal.hassan@hospital.com',11, DATE '2019-04-12');
INSERT INTO Doctor (first_name, last_name, specialization, phone, email, dept_id, hire_date) VALUES('Hina','Baig','Cardiologist','0300-6666666','hina.baig@hospital.com',7, DATE '2020-07-18');
INSERT INTO Doctor (first_name, last_name, specialization, phone, email, dept_id, hire_date) VALUES('Kamran','Siddiqui','Neurologist','0300-7777777','kamran.s@hospital.com',8, DATE '2021-02-28');
SELECT * FROM Doctor;

INSERT INTO Patient (first_name, last_name, dob, gender, phone, email, address, blood_group, reg_date) VALUES
('Ali','Raza',DATE '1990-05-14','Male','0311-1111111','ali.raza@gmail.com','12 Gulberg, Lahore','A+',DATE '2024-01-05');
INSERT INTO Patient (first_name, last_name, dob, gender, phone, email, address, blood_group, reg_date) VALUES('Fatima','Khan',DATE '1985-08-22','Female','0311-2222222','fatima.k@gmail.com','45 F-8, Islamabad','B+',DATE '2024-01-12');
INSERT INTO Patient (first_name, last_name, dob, gender, phone, email, address, blood_group, reg_date) VALUES('Hassan','Mirza',DATE '2000-11-30','Male','0311-3333333','hassan.m@gmail.com','7 DHA Phase 5, Karachi','O+',DATE '2024-02-03');
INSERT INTO Patient (first_name, last_name, dob, gender, phone, email, address, blood_group, reg_date) VALUES('Zainab','Sheikh',DATE '1975-03-18','Female','0311-4444444','zainab.s@gmail.com','22 Johar Town, Lahore','AB-',DATE '2024-02-15');
INSERT INTO Patient (first_name, last_name, dob, gender, phone, email, address, blood_group, reg_date) VALUES('Omar','Farooq',DATE '1995-07-09','Male','0311-5555555','omar.f@gmail.com','88 G-10, Islamabad','O-',DATE '2024-03-01');
INSERT INTO Patient (first_name, last_name, dob, gender, phone, email, address, blood_group, reg_date) VALUES('Sana','Javed',DATE '2010-12-25','Female','0311-6666666','sana.j@gmail.com','3 Clifton, Karachi','A-',DATE '2024-03-20');
INSERT INTO Patient (first_name, last_name, dob, gender, phone, email, address, blood_group, reg_date) VALUES('Tariq','Mehmood',DATE '1960-02-14','Male','0311-7777777','tariq.m@gmail.com','56 Model Town, Lahore','B-',DATE '2024-04-05');
INSERT INTO Patient (first_name, last_name, dob, gender, phone, email, address, blood_group, reg_date) VALUES('Nadia','Hussain',DATE '1988-09-11','Female','0311-8888888','nadia.h@gmail.com','19 I-8, Islamabad','AB+',DATE '2024-04-22');
SELECT * FROM Patient;

INSERT INTO Room (room_number, room_type, floor, is_available, daily_rate) VALUES('101','General',1,1,1500.00);
INSERT INTO Room (room_number, room_type, floor, is_available, daily_rate) VALUES('102','General',1,1,1500.00);
INSERT INTO Room (room_number, room_type, floor, is_available, daily_rate) VALUES('201','Semi-Private',2,1,2500.00);
INSERT INTO Room (room_number, room_type, floor, is_available, daily_rate) VALUES('202','Semi-Private',2,0,2500.00);
INSERT INTO Room (room_number, room_type, floor, is_available, daily_rate) VALUES('301','Private',3,1,5000.00);
INSERT INTO Room (room_number, room_type, floor, is_available, daily_rate) VALUES('302','Private',3,0,5000.00);
INSERT INTO Room (room_number, room_type, floor, is_available, daily_rate) VALUES('ICU1','ICU',4,1,15000.00);
INSERT INTO Room (room_number, room_type, floor, is_available, daily_rate) VALUES('ICU2','ICU',4,0,15000.00);
SELECT * FROM Room;

INSERT INTO Appointment (patient_id, doctor_id, appt_date, appt_time, reason, status) VALUES(1,8,DATE '2024-05-01','09:00:00','Chest pain','Completed');
INSERT INTO Appointment (patient_id, doctor_id, appt_date, appt_time, reason, status) VALUES(2,9,DATE '2024-05-02','10:30:00','Knee pain','Completed');
INSERT INTO Appointment (patient_id, doctor_id, appt_date, appt_time, reason, status) VALUES(3,10,DATE '2024-05-03','11:00:00','Headache && dizziness','Completed');
INSERT INTO Appointment (patient_id, doctor_id, appt_date, appt_time, reason, status) VALUES(4,11,DATE '2024-05-04','14:00:00','Fever and rash','Completed');
INSERT INTO Appointment (patient_id, doctor_id, appt_date, appt_time, reason, status) VALUES(5,12,DATE '2024-05-05','09:30:00','Abdominal pain','Completed');
INSERT INTO Appointment (patient_id, doctor_id, appt_date, appt_time, reason, status) VALUES(6,13,DATE '2024-05-06','15:00:00','Child vaccination','Scheduled');
INSERT INTO Appointment (patient_id, doctor_id, appt_date, appt_time, reason, status) VALUES(7,14,DATE '2024-05-07','08:00:00','Hypertension follow-up','Scheduled');
INSERT INTO Appointment (patient_id, doctor_id, appt_date, appt_time, reason, status) VALUES(8,12,DATE '2024-05-08','11:30:00','Heart palpitations','Scheduled');
INSERT INTO Appointment (patient_id, doctor_id, appt_date, appt_time, reason, status) VALUES(1,11,DATE '2024-05-09','10:00:00','Migraine','Cancelled');
INSERT INTO Appointment (patient_id, doctor_id, appt_date, appt_time, reason, status) VALUES(4,8,DATE '2024-05-10','13:00:00','Post-op review','Scheduled');
SELECT * FROM Appointment;

INSERT INTO Admission (patient_id, doctor_id, room_id, admit_date, discharge_date, diagnosis) VALUES(1,12,6,DATE '2024-04-10',DATE '2024-04-15','Acute Myocardial Infarction');
INSERT INTO Admission (patient_id, doctor_id, room_id, admit_date, discharge_date, diagnosis) VALUES(2,8,4,DATE '2024-04-12',DATE '2024-04-18','Fractured Tibia');
INSERT INTO Admission (patient_id, doctor_id, room_id, admit_date, discharge_date, diagnosis) VALUES(3,9,8,DATE '2024-04-20',NULL,'Cerebral Hemorrhage');
INSERT INTO Admission (patient_id, doctor_id, room_id, admit_date, discharge_date, diagnosis) VALUES(7,10,2,DATE '2024-05-01',DATE '2024-05-04','Hypertensive Crisis');
INSERT INTO Admission (patient_id, doctor_id, room_id, admit_date, discharge_date, diagnosis) VALUES(5,11,3,DATE '2024-05-05',NULL,'Appendicitis – Post Surgery');
SELECT * FROM Admission;

INSERT INTO Medicine (med_name, category, unit_price, stock_qty) VALUES('Aspirin 100mg','Antiplatelet',15.00,500);
INSERT INTO Medicine (med_name, category, unit_price, stock_qty) VALUES('Amoxicillin 500mg','Antibiotic',25.00,300);
INSERT INTO Medicine (med_name, category, unit_price, stock_qty) VALUES('Paracetamol 500mg','Analgesic',10.00,800);
INSERT INTO Medicine (med_name, category, unit_price, stock_qty) VALUES('Metformin 500mg','Antidiabetic',20.00,400);
INSERT INTO Medicine (med_name, category, unit_price, stock_qty) VALUES('Atorvastatin 40mg','Statin',45.00,250);
INSERT INTO Medicine (med_name, category, unit_price, stock_qty) VALUES('Ibuprofen 400mg','NSAID',18.00,350);
INSERT INTO Medicine (med_name, category, unit_price, stock_qty) VALUES('Omeprazole 20mg','PPI',30.00,200);
INSERT INTO Medicine (med_name, category, unit_price, stock_qty) VALUES('Lisinopril 10mg','ACE Inhibitor',35.00,150);
SELECT * FROM Medicine;

INSERT INTO Prescription (appt_id, med_id, dosage, duration_days) VALUES(61,1,'100mg once daily',30);
INSERT INTO Prescription (appt_id, med_id, dosage, duration_days) VALUES(62,5,'40mg once at night',60);
INSERT INTO Prescription (appt_id, med_id, dosage, duration_days) VALUES(71,6,'400mg three times',7);
INSERT INTO Prescription (appt_id, med_id, dosage, duration_days) VALUES(72,3,'500mg as needed',5);
INSERT INTO Prescription (appt_id, med_id, dosage, duration_days) VALUES(80,2,'500mg twice daily',7);
INSERT INTO Prescription (appt_id, med_id, dosage, duration_days) VALUES(81,7,'20mg before meals',14);
INSERT INTO Prescription (appt_id, med_id, dosage, duration_days) VALUES(82,3,'500mg twice daily',5);
INSERT INTO Prescription (appt_id, med_id, dosage, duration_days) VALUES(83,8,'10mg once daily',90);
SELECT * FROM Prescription;

INSERT INTO Bill (patient_id, admission_id, bill_date, room_charges, medicine_charges, doctor_charges, other_charges, total_amount, payment_status) VALUES(1,6,DATE '2024-04-15',30000,2500,10000,1500,44000,'Paid');
INSERT INTO Bill (patient_id, admission_id, bill_date, room_charges, medicine_charges, doctor_charges, other_charges, total_amount, payment_status) VALUES(2,7,DATE '2024-04-18',15000,1800,8000,1000,25800,'Paid');
INSERT INTO Bill (patient_id, admission_id, bill_date, room_charges, medicine_charges, doctor_charges, other_charges, total_amount, payment_status) VALUES(3,8,DATE '2024-05-10',75000,5000,20000,3000,103000,'Pending');
INSERT INTO Bill (patient_id, admission_id, bill_date, room_charges, medicine_charges, doctor_charges, other_charges, total_amount, payment_status) VALUES(7,9,DATE '2024-05-04',4500,900,5000,500,10900,'Paid');
INSERT INTO Bill (patient_id, admission_id, bill_date, room_charges, medicine_charges, doctor_charges, other_charges, total_amount, payment_status) VALUES(5,10,DATE '2024-05-10',10000,1200,7000,800,19000,'Partial');
SELECT * FROM Bill;

INSERT INTO Staff (first_name, last_name, role, dept_id, phone, salary) VALUES('Imran','Ali','Head Nurse',7,'0321-1111111',45000);
INSERT INTO Staff (first_name, last_name, role, dept_id, phone, salary) VALUES('Mariam','Siddiqui','Lab Technician',8,'0321-2222222',38000);
INSERT INTO Staff (first_name, last_name, role, dept_id, phone, salary) VALUES('Asad','Rehman','Pharmacist',9,'0321-3333333',42000);
INSERT INTO Staff (first_name, last_name, role, dept_id, phone, salary) VALUES('Noor','Fatima','Nurse',10,'0321-4444444',35000);
INSERT INTO Staff (first_name, last_name, role, dept_id, phone, salary) VALUES('Saad','Malik','Receptionist',11,'0321-5555555',30000);
SELECT * FROM Staff;

-- ============================================================
-- UPDATE QUERIES
-- ============================================================

-- Mark room available after patient discharged
UPDATE Room SET is_available = 0 WHERE room_id = 6;
UPDATE Room SET is_available = 0 WHERE room_id = 4;

-- Update appointment status
UPDATE Appointment SET status = 'Completed' WHERE appt_id = 82;

-- Update medicine stock after dispensing
UPDATE Medicine SET stock_qty = stock_qty - 50 WHERE med_id = 1;

-- Update patient contact info
UPDATE Patient SET phone = '0311-9999999' WHERE patient_id = 3;


-- ============================================================
-- DELETE QUERIES
-- ============================================================

-- Delete a cancelled appointment
DELETE FROM Appointment WHERE appt_id = 88 AND status = 'Cancelled';


-- ============================================================
-- SELECT QUERIES
-- ============================================================

-- 1. All patients registered in 2024
SELECT patient_id,
       first_name || ' ' || last_name AS Patient_Name,
       gender, blood_group, reg_date
FROM Patient
WHERE EXTRACT(YEAR FROM reg_date) = 2024
ORDER BY reg_date;

-- 2. Doctors and their departments
SELECT d.doctor_id,
       d.first_name || ' ' || d.last_name AS Doctor_Name,
       d.specialization, dep.dept_name
FROM Doctor d
JOIN Department dep ON d.dept_id = dep.dept_id
ORDER BY dep.dept_name;

-- 3. Currently admitted patients (no discharge date)
SELECT a.admission_id,
       p.first_name || ' ' || p.last_name AS Patient,
       doc.first_name || ' ' || doc.last_name AS Doctor,
       r.room_number,
       r.room_type,
       a.admit_date,
       a.diagnosis
FROM Admission a
JOIN Patient p   ON a.patient_id = p.patient_id
JOIN Doctor doc  ON a.doctor_id  = doc.doctor_id
JOIN Room r      ON a.room_id     = r.room_id
WHERE a.discharge_date IS NULL;

-- 4. Pending bills
SELECT b.bill_id,
       p.first_name || ' ' || p.last_name AS Patient,
       b.total_amount,
       b.payment_status
FROM Bill b
JOIN Patient p ON b.patient_id = p.patient_id
WHERE b.payment_status IN ('Pending','Partial');

-- 5. Appointments for a specific doctor (doctor_id = 1)
SELECT a.appt_id,
       p.first_name || ' ' || p.last_name AS Patient,
       a.appt_date,
       a.appt_time,
       a.reason,
       a.status
FROM Appointment a
JOIN Patient p ON a.patient_id = p.patient_id
WHERE a.doctor_id = 8
ORDER BY a.appt_date;

-- ============================================================
-- VIEWS
-- ============================================================

-- View: Patient full info
CREATE OR REPLACE VIEW vw_PatientInfo AS
SELECT p.patient_id,
       p.first_name || ' ' || p.last_name AS Full_Name,
       p.dob,
       p.gender,
       p.blood_group,
       p.phone,
       p.email,
       p.address,
       p.reg_date
FROM Patient p;
SELECT * From vw_PatientInfo;

-- View: Doctor schedule (upcoming appointments)
CREATE OR REPLACE VIEW vw_DoctorSchedule AS
SELECT d.first_name||' '|| d.last_name AS Doctor,
       d.specialization,
       dep.dept_name,
       a.appt_date, a.appt_time,
       p.first_name ||' '|| p.last_name AS Patient,
       a.reason, a.status
FROM Appointment a
JOIN Doctor     d   ON a.doctor_id  = d.doctor_id
JOIN Department dep ON d.dept_id    = dep.dept_id
JOIN Patient    p   ON a.patient_id = p.patient_id
WHERE a.status = 'Scheduled'
ORDER BY a.appt_date, a.appt_time;
SELECT * From vw_DoctorSchedule;

-- View: Revenue summary
CREATE OR REPLACE VIEW vw_RevenueSummary AS
SELECT b.bill_id,
       p.first_name ||' '|| p.last_name AS Patient,
       b.bill_date,
       b.room_charges, b.medicine_charges,
       b.doctor_charges, b.other_charges,
       b.total_amount, b.payment_status
FROM Bill b
JOIN Patient p ON b.patient_id = p.patient_id;
SELECT * From vw_RevenueSummary;

-- View: Available rooms
CREATE OR REPLACE VIEW vw_AvailableRooms AS
SELECT room_id,
       room_number,
       room_type,
       floor,
       daily_rate
FROM Room
WHERE is_available = 1;
SELECT * From vw_AvailableRooms;

-- ============================================================
-- TRIGGERS
-- ============================================================

-- Trigger 1: Set room unavailable on admission
CREATE OR REPLACE TRIGGER trg_AfterAdmission
AFTER INSERT ON Admission
FOR EACH ROW
BEGIN
    UPDATE Room
    SET is_available = 0
    WHERE room_id = :NEW.room_id;
END;
/

-- Trigger 2: Free room when patient discharged
CREATE OR REPLACE TRIGGER trg_AfterDischarge
AFTER UPDATE ON Admission
FOR EACH ROW
BEGIN
    IF :NEW.discharge_date IS NOT NULL
       AND :OLD.discharge_date IS NULL THEN

        UPDATE Room
        SET is_available = 1
        WHERE room_id = :NEW.room_id;

    END IF;
END;
/

-- Trigger 3: Auto-calculate bill total before insert
CREATE TRIGGER trg_CalcBillTotal
BEFORE INSERT ON Bill
FOR EACH ROW
BEGIN
     :NEW.total_amount := :NEW.room_charges + :NEW.medicine_charges
                         + :NEW.doctor_charges + :NEW.other_charges;
END;
/
---Testing
INSERT INTO Bill
(patient_id, room_charges, medicine_charges,
 doctor_charges, other_charges, payment_status)
VALUES
(1, 10000, 2000, 5000, 1000, 'Pending');
SELECT bill_id, total_amount
FROM Bill;
SELECT * FROM Patient;

-- Trigger 4: Reduce medicine stock when prescribed
CREATE TRIGGER trg_ReduceMedStock
AFTER INSERT ON Prescription
FOR EACH ROW
BEGIN
    UPDATE Medicine  SET stock_qty = stock_qty - 1 WHERE med_id = :NEW.med_id;
END;
/

DELIMITER ;

-- ============================================================
-- STORED PROCEDURES
-- ============================================================

-- SP 1: Admit a patient
CREATE OR REPLACE PROCEDURE sp_AdmitPatient (
    p_patient_id IN NUMBER,
    p_doctor_id  IN NUMBER,
    p_room_id    IN NUMBER,
    p_diagnosis  IN VARCHAR2
)
AS
    room_free NUMBER;
BEGIN
    -- Check room availability
    SELECT is_available
    INTO room_free
    FROM Room
    WHERE room_id = p_room_id;

    IF room_free = 1 THEN
        INSERT INTO Admission
        (patient_id, doctor_id, room_id, admit_date, diagnosis)
        VALUES
        (p_patient_id, p_doctor_id, p_room_id, SYSDATE, p_diagnosis);
        DBMS_OUTPUT.PUT_LINE('Patient admitted successfully.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Room is not available.');
    END IF;
END;
/
---Testing
SET SERVEROUTPUT ON;
BEGIN
    sp_AdmitPatient(3, 8, 1, 'Heart Problem');
END;
/
SELECT * FROM Room;


-- SP 2: Discharge a patient
CREATE OR REPLACE PROCEDURE sp_DischargePatient (
    p_admission_id IN NUMBER
)
AS
BEGIN
    UPDATE Admission
    SET discharge_date = SYSDATE
    WHERE admission_id = p_admission_id
      AND discharge_date IS NULL;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' row(s) updated');
END;
/
--Testing
SET SERVEROUTPUT ON;
BEGIN
    sp_DischargePatient(8);
END;
/


-- SP 3: Generate patient bill report
CREATE OR REPLACE PROCEDURE sp_PatientBillReport (
    p_patient_id IN NUMBER
)
AS
BEGIN
    FOR rec IN (
        SELECT b.bill_id,
               p.first_name || ' ' || p.last_name AS Patient,
               b.bill_date, b.room_charges, b.medicine_charges, b.doctor_charges, b.other_charges, b.total_amount, b.payment_status
        FROM Bill b
        JOIN Patient p ON b.patient_id = p.patient_id
        WHERE b.patient_id = p_patient_id
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            rec.bill_id || ' | ' ||
            rec.Patient || ' | ' ||
            rec.bill_date || ' | ' ||
            rec.total_amount || ' | ' ||
            rec.payment_status
        );
    END LOOP;
END;
/
---Testing
SET SERVEROUTPUT ON;
BEGIN
    sp_PatientBillReport(2);
END;
/

-- ============================================================
-- REPORTS / OUTPUT QUERIES
-- ============================================================

-- Report 1: Monthly appointment summary
SELECT EXTRACT(MONTH FROM appt_date) AS Month,
       COUNT(*) AS Total_Appointments,

       SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS Completed,
       SUM(CASE WHEN status = 'Scheduled' THEN 1 ELSE 0 END) AS Scheduled,
       SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) AS Cancelled

FROM Appointment
GROUP BY EXTRACT(MONTH FROM appt_date)
ORDER BY Month;

-- Report 2: Revenue by payment status
SELECT payment_status,
       COUNT(*) AS Total_Bills,
       SUM(total_amount) AS Total_Revenue
FROM Bill
GROUP BY payment_status;