

-- 设置所有外键约束为 0
SET FOREIGN_KEY_CHECKS = 0;

-- 如果存在则删除表 departments
DROP TABLE IF EXISTS departments;

-- 创建表 departments
CREATE TABLE departments (
    dept_id VARCHAR(12) NOT NULL COMMENT '部门ID',
    row_id INT NOT NULL,
    dept_name VARCHAR(50) NOT NULL COMMENT '部门名称',
    description VARCHAR(255) NULL COMMENT '部门描述',
    manager_id VARCHAR(12) NULL COMMENT '部门经理 - 员工ID',
    PRIMARY KEY (dept_id, row_id)
) COMMENT '部门表';

-- 如果存在则删除表 employees
DROP TABLE IF EXISTS employees;

-- 创建表 employees
CREATE TABLE employees (
    emp_id VARCHAR(12) NOT NULL COMMENT '员工ID',
    row_id INT NOT NULL,
    real_name VARCHAR(100) NOT NULL COMMENT '真实姓名',
    gender ENUM ('0', '1') NULL COMMENT '性别ID 0:男 1:女',
    dept_id VARCHAR(12) NULL COMMENT '部门ID',
    contact_info VARCHAR(255) NULL COMMENT '联系方式',
    PRIMARY KEY (emp_id, row_id),
    CONSTRAINT fk_employees_dept_id FOREIGN KEY (dept_id) REFERENCES departments (dept_id)
) COMMENT '公司职员表';

-- 如果存在则删除表 roles
DROP TABLE IF EXISTS roles;

-- 创建表 roles
CREATE TABLE roles (
    role_id VARCHAR(12) NOT NULL COMMENT '角色ID',
    row_id INT NOT NULL,
    role_name VARCHAR(50) NOT NULL COMMENT '角色名称',
    description VARCHAR(255) NULL COMMENT '角色描述',
    PRIMARY KEY (role_id, row_id)
) COMMENT '角色表';

-- 如果存在则删除表 users
DROP TABLE IF EXISTS users;

-- 创建表 users
CREATE TABLE users (
    user_id VARCHAR(12) NOT NULL COMMENT '用户ID',
    row_id INT NOT NULL,
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码',
    role_id VARCHAR(12) NOT NULL COMMENT '系统角色ID',
    last_login_time DATETIME NULL COMMENT '上次登录时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP NULL COMMENT '创建时间',
    update_time DATETIME NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by VARCHAR(12) NULL COMMENT '创建人 - 员工ID',
    updated_by VARCHAR(12) NULL COMMENT '更新人 - 员工ID',
    dept_id VARCHAR(12) NULL COMMENT '部门ID',
    emp_id VARCHAR(12) NULL COMMENT '员工ID',
    status ENUM ('0', '1')  default '1' NULL COMMENT '状态 (1: 启用, 0: 禁用)',
    PRIMARY KEY (user_id, row_id),
    CONSTRAINT fk_users_created_by FOREIGN KEY (created_by) REFERENCES employees (emp_id),
    CONSTRAINT fk_users_updated_by FOREIGN KEY (updated_by) REFERENCES employees (emp_id),
    CONSTRAINT fk_users_dept_id FOREIGN KEY (dept_id) REFERENCES departments (dept_id),
    CONSTRAINT fk_users_emp_id FOREIGN KEY (emp_id) REFERENCES employees (emp_id),
    CONSTRAINT fk_users_role_id FOREIGN KEY (role_id) REFERENCES roles (role_id),
    UNIQUE KEY username (username)
) COMMENT '系统用户表';


DROP VIEW IF EXISTS employee_roles_view;

CREATE VIEW employee_roles_view AS
    SELECT e.emp_id, u.user_id, r.role_id, d.dept_id
    FROM employees e
    JOIN users u ON e.emp_id = u.emp_id
    JOIN roles r ON u.role_id = r.role_id
    JOIN departments d ON e.dept_id = d.dept_id;


-- 存储过程 generate_prefix_id
DELIMITER //
DROP PROCEDURE IF EXISTS generate_prefix_id;
CREATE PROCEDURE generate_prefix_id(IN table_name_v VARCHAR(50), IN id INT, IN prefix VARCHAR(10), OUT new_id VARCHAR(20))
BEGIN
    SET new_id = CONCAT(prefix, '-', LPAD(id, 5, '0'));
END //
DELIMITER ;

-- 触发器 for departments
DELIMITER //
DROP TRIGGER IF EXISTS before_departments_insert;
CREATE TRIGGER before_departments_insert
BEFORE INSERT ON departments
FOR EACH ROW
BEGIN
  DECLARE max_row_id INT;
  SELECT IFNULL(MAX(row_id), 0) INTO max_row_id FROM departments;
  SET NEW.row_id = max_row_id + 1;
  CALL generate_prefix_id('departments', NEW.row_id, 'DEPT', @new_dept_id);
  SET NEW.dept_id = @new_dept_id;
END //
DELIMITER ;

-- 触发器 for employees
DELIMITER //
DROP TRIGGER IF EXISTS before_employees_insert;
CREATE TRIGGER before_employees_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
  DECLARE max_row_id INT;
  SELECT IFNULL(MAX(row_id), 0) INTO max_row_id FROM employees;
  SET NEW.row_id = max_row_id + 1;
  CALL generate_prefix_id('employees', NEW.row_id, 'EMP', @new_emp_id);
  SET NEW.emp_id = @new_emp_id;
END //
DELIMITER ;

-- 触发器 for roles
DELIMITER //
DROP TRIGGER IF EXISTS before_roles_insert;
CREATE TRIGGER before_roles_insert
BEFORE INSERT ON roles
FOR EACH ROW
BEGIN
  DECLARE max_row_id INT;
  SELECT IFNULL(MAX(row_id), 0) INTO max_row_id FROM roles;
  SET NEW.row_id = max_row_id + 1;
  CALL generate_prefix_id('roles', NEW.row_id, 'ROL', @new_role_id);
  SET NEW.role_id = @new_role_id;
END //
DELIMITER ;

-- 触发器 for users
DELIMITER //
DROP TRIGGER IF EXISTS before_users_insert;
CREATE TRIGGER before_users_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
  DECLARE max_row_id INT;
  SELECT IFNULL(MAX(row_id), 0) INTO max_row_id FROM users;
  SET NEW.row_id = max_row_id + 1;
  CALL generate_prefix_id('users', NEW.row_id, 'USR', @new_user_id);
  SET NEW.user_id = @new_user_id;
END //
DELIMITER ;

-- 恢复外键约束
SET FOREIGN_KEY_CHECKS = 1;

