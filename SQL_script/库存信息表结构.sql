SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS
    phone_inventory,
    phone_models,
    phone_ram_capacities,
    phone_specs_combinations,
    phone_statuses,
    phone_storage_capacities,
    phone_camera_resolutions,
    phone_brands;
SET FOREIGN_KEY_CHECKS = 1;

DROP TABLE IF EXISTS _prefixes;
CREATE TABLE _prefixes
(
    prefix_id   INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT '前缀ID，主键，自增',
    prefix      VARCHAR(10) UNIQUE NOT NULL COMMENT '前缀',
    description VARCHAR(50)        NOT NULL COMMENT '前Q缀描述',
    table_name  VARCHAR(255)       NOT NULL COMMENT '表名' -- 添加 table_name 字段
) COMMENT '手机信息前缀表';
-- 初始化前缀表
INSERT INTO _prefixes (prefix, description, table_name)
VALUES ('BRN-', '品牌', 'phone_brands'),
       ('MOD-', '型号', 'phone_models'),
       ('RAM-', '运行内存', 'phone_ram_capacities'),
       ('STO-', '存储容量', 'phone_storage_capacities'),
       ('CAM-', '摄像头分辨率', 'phone_camera_resolutions'),
       ('SPE-', '规格组合', 'phone_specs_combinations'),
       ('INV-', '库存商品', 'phone_inventory'),
       ('BAT-', '电池容量', 'phone_battery_capacities'),
       ('STA-', '商品状态', 'phone_statuses');


DROP TABLE IF EXISTS files;
CREATE TABLE files
(
    id          INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    file_name   VARCHAR(255) NOT NULL,
    file_path   VARCHAR(255) NOT NULL,
    file_size   INT UNSIGNED NOT NULL,
    file_type   VARCHAR(50),
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) COMMENT ='文件存储路径';

-- 手机品牌表 (phone_brands)
DROP TABLE IF EXISTS phone_brands;
CREATE TABLE phone_brands
(
    row_id     INT UNSIGNED UNIQUE AUTO_INCREMENT COMMENT '自增行号 ',
    brand_id   VARCHAR(12) UNIQUE COMMENT '品牌ID',
    brand_name VARCHAR(50) NOT NULL COMMENT '品牌名称',
    brand_logo VARCHAR(255) COMMENT '图片 file_path',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (row_id, brand_id)
) COMMENT '手机品牌表';


-- 运行内存枚举表 (phone_ram_capacities)
DROP TABLE IF EXISTS phone_ram_capacities;
CREATE TABLE phone_ram_capacities
(
    row_id    INT UNSIGNED UNIQUE AUTO_INCREMENT COMMENT '自增行号 ',
    ram_id    VARCHAR(12) UNIQUE COMMENT '运行内存ID，主键，自增',
    ram_value VARCHAR(20) NOT NULL COMMENT '运行内存值（例如：8GB）',
    PRIMARY KEY (row_id, ram_id)
) COMMENT '手机运行内存枚举表';


-- 存储容量枚举表 (phone_storage_capacities)
DROP TABLE IF EXISTS phone_storage_capacities;
CREATE TABLE phone_storage_capacities
(
    row_id        INT UNSIGNED UNIQUE AUTO_INCREMENT COMMENT '自增行号 ',
    storage_id    VARCHAR(12) UNIQUE COMMENT '存储容量ID，主键，自增',
    storage_value VARCHAR(20) NOT NULL COMMENT '存储容量值（例如：128GB）',
    PRIMARY KEY (row_id, storage_id)
) COMMENT = '手机存储容量枚举表';


-- 摄像头分辨率枚举表 (phone_camera_resolutions)
DROP TABLE IF EXISTS phone_camera_resolutions;
CREATE TABLE phone_camera_resolutions
(
    row_id     INT UNSIGNED UNIQUE AUTO_INCREMENT COMMENT '自增行号 ',
    camera_id  VARCHAR(12) UNIQUE COMMENT '摄像头ID，主键，自增',
    resolution VARCHAR(20) NOT NULL COMMENT '摄像头分辨率（例如：12MP）',
    PRIMARY KEY (row_id, camera_id)
) COMMENT = '手机摄像头分辨率枚举表';




-- 手机状态枚举表 (phone_statuses)
DROP TABLE IF EXISTS phone_statuses;
CREATE TABLE phone_statuses
(
    row_id      INT UNSIGNED UNIQUE AUTO_INCREMENT COMMENT '自增行号 ',
    status_id   VARCHAR(12) UNIQUE COMMENT '状态ID，主键，自增',
    status_name VARCHAR(20) NOT NULL COMMENT '状态名称',
    PRIMARY KEY (row_id, status_id)
) COMMENT = '手机状态枚举表';

-- 手机电池容量枚举表 (phone_battery_capacities)
DROP TABLE IF EXISTS phone_battery_capacities;
CREATE TABLE phone_battery_capacities (
    row_id INT UNSIGNED UNIQUE AUTO_INCREMENT COMMENT '自增行号 ',
    battery_id VARCHAR(12) UNIQUE NOT NULL COMMENT '电池容量ID',
    battery_value VARCHAR(20) NOT NULL COMMENT '电池容量值（例如：3000mAh）',
    PRIMARY KEY (row_id, battery_id)
) COMMENT '手机电池容量枚举表';



-- 手机规格组合表 (phone_specs_combinations)
DROP TABLE IF EXISTS phone_specs_combinations;
CREATE TABLE phone_specs_combinations
(
    row_id            INT UNSIGNED AUTO_INCREMENT COMMENT '自增行号 ',
    combination_id    VARCHAR(12) UNIQUE NOT NULL COMMENT '规格组合ID',
    ram_id            VARCHAR(12) COMMENT '运行内存ID，外键关联phone_ram_capacities表',
    storage_id        VARCHAR(12) COMMENT '存储容量ID，外键关联phone_storage_capacities表',
    front_camera_id   VARCHAR(12) COMMENT '前置摄像头ID，外键关联phone_camera_resolutions表',
    rear_camera_id    VARCHAR(12) COMMENT '后置摄像头ID，外键关联phone_camera_resolutions表',
    battery_id VARCHAR(12) COMMENT '电池容量ID，外键关联phone_battery_capacities表' ,
    specs_description TEXT COMMENT '配置说明',
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (row_id, combination_id),
    FOREIGN KEY (ram_id) REFERENCES phone_ram_capacities (ram_id),
    FOREIGN KEY (storage_id) REFERENCES phone_storage_capacities (storage_id),
    FOREIGN KEY (front_camera_id) REFERENCES phone_camera_resolutions (camera_id),
    FOREIGN KEY (rear_camera_id) REFERENCES phone_camera_resolutions (camera_id),
    FOREIGN KEY (battery_id) REFERENCES phone_battery_capacities (battery_id)
) COMMENT '手机规格组合表';


-- 手机型号表 (phone_models)
DROP TABLE IF EXISTS phone_models;
CREATE TABLE phone_models
(
    row_id            INT UNSIGNED UNIQUE AUTO_INCREMENT COMMENT '自增行号 ',
    model_id          VARCHAR(12) UNIQUE COMMENT '型号ID，主键，自增',
    brand_id          VARCHAR(12) COMMENT '品牌ID，外键关联phone_brands表',
    model_name        VARCHAR(50)    NOT NULL COMMENT '型号名称',
    color             VARCHAR(50) COMMENT '手机颜色',
    current_stock     INT UNSIGNED   NOT NULL COMMENT '当前库存数量',
    combination_id    VARCHAR(12) COMMENT '规格组合ID，外键关联phone_specs_combinations表',
    price             DECIMAL(10, 2) NOT NULL COMMENT '单价（定价）',
    status_id         VARCHAR(12)    NOT NULL COMMENT '状态ID，外键关联phone_statuses表',
    model_description TEXT COMMENT '型号描述',
    model_image       VARCHAR(255) COMMENT '图片 file_path',
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (row_id, model_id),
    FOREIGN KEY (brand_id) REFERENCES phone_brands (brand_id),
    FOREIGN KEY (combination_id) REFERENCES phone_specs_combinations (combination_id),
    FOREIGN KEY (status_id) REFERENCES phone_statuses (status_id),
    UNIQUE KEY unique_model_color (model_id, color) # 每个机型的每种颜色占用一个 ID
) COMMENT '手机型号表';


-- 手机商品库存详情表 (phone_inventory)
DROP TABLE IF EXISTS phone_inventory;
CREATE TABLE phone_inventory
(
    row_id           INT UNSIGNED UNIQUE AUTO_INCREMENT COMMENT '自增行号 ',
    inventory_id     VARCHAR(12) COMMENT '库存商品ID，主键，自增',
    model_id         VARCHAR(12) COMMENT '商品型号，根据modelID渲染手机详细信息',
    unique_id        VARCHAR(255) UNIQUE NOT NULL COMMENT '手机唯一识别码 IMEI',
    purchase_date    DATE COMMENT '进货日期',
    output_date      DATE COMMENT '出库日期',
    warranty_period  INT COMMENT '保修期（月）',
    inventory_status ENUM ('in_stock', 'out_of_stock', 'sold', 'returned') DEFAULT 'in_stock' COMMENT '库存状态in_stock：在库 out_of_stock：无货 sold：已售 returned：退货',
    created_at       TIMESTAMP                                             DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at       TIMESTAMP                                             DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    location         VARCHAR(50) COMMENT '库存位置',
    PRIMARY KEY (row_id, inventory_id),
    FOREIGN KEY (model_id) REFERENCES phone_models (model_id)
) COMMENT = '手机商品详情表';


