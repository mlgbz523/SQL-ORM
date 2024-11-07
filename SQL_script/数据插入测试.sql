
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE departments;
TRUNCATE TABLE employees;
TRUNCATE TABLE roles;
TRUNCATE TABLE users;


-- departments 初始化数据
INSERT INTO departments (dept_name, description) VALUES
('研发部', '负责软件研发工作'),
('市场部', '负责产品市场推广'),
('销售部', '负责产品销售工作'),
('人事部', '负责员工招聘和管理'),
('财务部', '负责公司财务管理');


-- employees 初始化数据
INSERT INTO employees (real_name, gender, dept_id, contact_info) VALUES
('张三', '0', 'DEPT-00001', '13812345678'),
('李四', '1', 'DEPT-00002', '13698765432'),
('王五', '0', 'DEPT-00003', '15012349876'),
('赵六', '1', 'DEPT-00004', '18876543210'),
('孙七', '0', 'DEPT-00005', '13900001111');


-- roles 初始化数据
INSERT INTO roles (role_name, description) VALUES
('管理员', '拥有所有权限'),
('员工', '拥有基本权限'),
('经理', '拥有管理权限');


-- users 初始化数据  emp_id 和 created_by, updated_by 暂时设置为 null ，后续可以根据需要更新
INSERT INTO users (username, password, role_id, dept_id, emp_id) VALUES
('admin', 'password123', 'ROL-00001', 'DEPT-00001', NULL),
('zhangsan', 'zhangsan123', 'ROL-00002', 'DEPT-00001', 'EMP-00001'),
('lisi', 'lisi123', 'ROL-00002', 'DEPT-00002', 'EMP-00002'),
('wangwu', 'wangwu123', 'ROL-00003', 'DEPT-00003', 'EMP-00003'),
('zhaoliu', 'zhaoliu123', 'ROL-00002', 'DEPT-00004', 'EMP-00004');  -- 设置一个用户为禁用状态


-- 更新 departments 表的 manager_id  (这步可以根据实际情况调整)
UPDATE departments SET manager_id = 'EMP-00001' WHERE dept_id = 'DEPT-00001';
UPDATE departments SET manager_id = 'EMP-00002' WHERE dept_id = 'DEPT-00002';
UPDATE departments SET manager_id = 'EMP-00003' WHERE dept_id = 'DEPT-00003';
UPDATE departments SET manager_id = 'EMP-00004' WHERE dept_id = 'DEPT-00004';
UPDATE departments SET manager_id = 'EMP-00005' WHERE dept_id = 'DEPT-00005';


SET FOREIGN_KEY_CHECKS = 1;