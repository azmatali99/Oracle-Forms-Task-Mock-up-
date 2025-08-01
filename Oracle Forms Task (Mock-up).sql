Write a PL/SQL block to update salaries for employees in a department based on a percentage input.
 

declare
pcnt number := 50;
cursor cur is select * from employees;
begin
for rec in cur loop
update employees a
set salary = rec.salary *pcnt /100
where id = rec.id;
end loop;
end;



Oracle Forms Task (Mock-up)
Create a simple Oracle Form to insert/update employee data. The form must include validations (e.g., salary not null, email format) and a button to fetch department name from the database using PL/SQL.
Evaluation Criteria:
Correct use of triggers
Code readability
Validation logic
 
shereen@pso.amktechnology.com
 

1. SALARY Validation
Trigger: PRE-INSERT / PRE-UPDATE

IF :BLK_EMP.SALARY IS NULL THEN
   MESSAGE('Salary must not be null.');
   RAISE FORM_TRIGGER_FAILURE;
END IF;

2. WHEN-VALIDATE-ITEM (to check EMAIL format)
IF NOT REGEXP_LIKE(:EMAIL, '^[A-Za-z0-9._+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
   MESSAGE('Invalid email format.');
   RAISE FORM_TRIGGER_FAILURE;
END IF;

Or can use below code before 12c

DECLARE
   v_at_pos      NUMBER;
   v_dot_pos     NUMBER;
   v_email       VARCHAR2(320);
BEGIN
   v_email := :blk.EMAIL;

   v_at_pos := INSTR(v_email, '@');
   v_dot_pos := INSTR(v_email, '.', -1);  -- last dot position

   IF v_at_pos < 2 OR                         -- must be at least one character before @
      v_dot_pos < v_at_pos + 2 OR            -- at least one character between @ and .
      v_dot_pos >= LENGTH(v_email) THEN      -- dot cannot be last character
      MESSAGE('Invalid email format.');
      RAISE FORM_TRIGGER_FAILURE;
   END IF;
END;

Button: Fetch Department Name
Block: BLK_DEPT
Trigger: WHEN-BUTTON-PRESSED
DECLARE
   v_dept_name VARCHAR2(100);
BEGIN
   SELECT dept_name
   INTO v_dept_name
   FROM departments
   WHERE department_id = :BLK_DEPT.DEPT_ID;

   :BLK_DEPT.DEPARTMENT_NAME := v_dept_name;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      MESSAGE('No department found for the given Deparment ID.');
      :BLK_DEPT.DEPARTMENT_NAME := NULL;
   WHEN OTHERS THEN
      MESSAGE('Error fetching department name.');
      :BLK_DEPT.DEPARTMENT_NAME := NULL;
END;