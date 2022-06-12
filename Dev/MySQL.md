# MySQL
## SQL语句
功能划分：

- DDL：数据定义语句，用来定义数据库对象，创建库、表、列等
- DML：数据操作语句，操作数据库表中的记录
- DQL：数据库查询语句
- DCL：数据控制语句，用来定义访问权限和安全级别

### 数据库操作
#### 创建数据库
```sql
create database 名称;
```
> 名称若是关键字或特殊符号，需要添加``符号。

- 无则创建，有则跳过：

```sql
create database if not exists 名称;
```

- 指定编码格式：

```sql
create database if not exists 名称 charset=utf8;
```

- 查看数据库全局默认编码：

```sql
show variables like 'character_set_%';
```

- 查看指定数据库编码格式：

```sql
show create database 库名;
```

#### 删除数据库
```sql
drop database 名称;
```

- 有则删除，无则跳过：

```sql
drop database if exists 名称;
```

#### 修改数据库
- 修改字符集：

```sql
alter database 名称 charset=utf8;
```

### 表操作
对数据库的表操作前需指定要操作的数据库：

```sql
use 库名;
```

#### 创建表
```sql
create table  if not exists 表名(
    field名称 数据类型,
    field名称 数据类型
);
```

- 查看所有表：

```sql
show tables;
```

- 查看表结构：

```sql
desc 表名;
```

#### 删除表

```sql
drop if exists 表名;
```

#### 修改表
- 修改表名：

```sql
rename table 原表名 to 新表名;
```

- 添加字段：

```sql
alter table 表名 add 字段名称 数据类型 [位置];
```

> 位置参数：可选，默认会新增到最后，可指定为 `first`、`after 已有字段名`。

 

- 删除字段：

```sql
alter table 表名 drop 字段名;
```

- 修改字段：

```sql
// 只修改字段类型
alter table 表名 modify 字段名 数据类型;
// 修改字段名及数据类型
alter table 表名 change 原字段名 新字段名 数据类型; 
```

### 存储引擎
不同存储引擎的安全级别、存储功能等不一样：

- MyISAM：安全性低，不支持事务和外键。适合频繁插入和查询而不修改的场景
- InnoDB（默认）：安全性高，支持事务和外键，适合对安全性、数据完整性要求较高的应用
- Memory：访问速度极快，但不会永久存储数据，适合对读写速度要求较高的应用

修改表的存储引擎：

```sql
alter table 表名 engine=Memory
```

### 数据操作
#### 插入数据
```sql
insert into 表名 (field1, field2) values (value1, value2);
```

#### 查询数据
- 查询表中所有数据：

```sql
select * from 表名;
```

- 条件查询：

```sql
select field1, field2 from 表名 [where 条件];
```

- `where`支持的运算符：
    - =
    - !=
    - <
    - <=
    - IN(set)：值包含
    - BETWEEN...AND：值的范围
    - IS NULL
    - IN NO NULL
    - AND
    - OR
    - NOT


#### 更新数据
```sql
update 表名 set 字段名=值 [where 条件];
```

> 不指定条件则修改表内所有数据的值。

#### 删除数据
```sql
delete from 表名 [where 条件];
```

## 数据类型
### 整数类型
|类型|解释|字节|取值范围|
|:-:|:-:|:-:|:-:|
|TINYINT|小整数值|1|(-128, 127)或无符号范围(0, 255)|
|SMALLINT|大整数值|2|(-32768, 32767)|
|MEDIUMINT|大整数值|3|(-8388608, 8388607)|
|INT或INTEGER|大整数值|4|(-2147483648, 2147483647)|
|BIGINT|任意大|8||

- 设置无符号整型：

```sql
id int unsigned;
```

- 整型可设置位宽，长度不足补零：

```sql
create table person (
    id int(2) zerofill
)
```

### 浮点类型
- FLOAT(m, d)：4字节，单精度
- DOUBLE(m, d)：8字节，双精度

区别：

- 占用存储空间大小不同
- 默认保留小数位数不同
- 保留的小数有效精度不同

### 定点类型
decimal(m, d)：也用于存储小数，本质是将数据分为两个部分存储，每个部分都是整数，非常消耗资源。

### 字符类型
- CHAR(size)：0-255字节，定长字符串
- varchar(size)：：0-65535字节，变长字符串

区别：

- 能够保存的数据容量不同
- char 不会回收多余的字符，设置长度多大就多大，varchar 会回收多余字符

> varchar 理论可以存储 65535 个字符，但实际会随着当前数据库的字符集改变，如utf-8为 65535/3=21845字符。gbk 32767个字符。


### 大文本类型
MySQL 中对每一行数据的大小有限制，每行最多 65534 字节。

- TINYTEXT：0-255字节，短文本字符串
- TEXT：0-65535字节，长文本数据
- MEDIUMTEXT：0-16777215字节，中等长度文本数据
- LONGTEXT：0-4294967295字节，极大文本数据

> 大文本类型在表中不会实际占用保存的字节数，而是利用10字节引用了实际保存数据的地址。

### 枚举类型
- ENUM(值1, 值2, ...)

> MySQL 中的枚举是通过整型实现的，并且从1开始。

### 集合类型
- SET(值1, 值2)：字段取值只能是几个固定值中的几个

> 集合类型通过 2^n 的整型实现的

### 布尔类型

> 布尔类型也通过整型实现，0为假，1为真，原因是 MySQL 底层是用 C/C++ 实现的，非零即真。

### 日期类型
|类型|解释|字节|格式|
|:-:|:-:|:-:|:-:|
|DATE|日期|3|YYYY-MM-DD|
|TIME|时间值或持续时间|3|HH:MM:SS|
|DATETIME|混合日期和时间值|8|YYYY-MM-DD HH:MM:SS|

> 存储时值要加引号。

## 数据完整性
数据完整性指保证保存到数据库中的数据都是正确的，通过创建表时给表添加约束实现，分为三类：

- 实体完整性
- 域完整性
- 参照完整性

### 实体完整性
表中的一行数据就是一个实体（entity），需保证每一行数据的唯一性。

约束类型：

#### 主键约束 primary key
唯一标识每一条数据。

```sql
// 方式一
create table user(
	id int primary key,
	user_name varchar(5)
)

// 方式二
create table user(
	id int,
	user_name varchar(5),
	primary key(id)
)
```

- 主键字段取值不可重复
- 主键字段不能为 NULL
- 一张表中只能有一个主键

联合主键：同时将多个字段作为一个主键。

```sql
create table user(
	id int primary key,
	user_name varchar(5),
	primary key(id, user_name)
)
```

#### 唯一约束 unique
和主键的异同：

- 都能保证字段的取值不重复
- 主键在一张表中只能有一个，唯一约束不限制
- 设置唯一约束的字段可以为 NULL

#### 自动增长列 auto_increment

```sql
create table person(
    id int auto_increment primary key,
    name varchar(20)
)
```

- 自动增长的字段可以为 NULL，存储后会自动增加。

#### 修改约束
**1. 修改主键**

```sql
alter table 表名 add primary key(字段);
```

**2. 修改唯一约束**

```sql
alter table 表名 add unique(字段);
```

**3. 修改自动增长列**

```sql
// 必须是主键才能修改
alter table 表名 modify 字段名 数据类型 auto_increment;
```

### 域完整性
- 一行数据中的每个单元格都是一个域，即每一个字段
- 域的完整性指保证单元格数据的正确性
    - 使用正确的数据类型
    - 非空约束（not null）
    - 默认约束（default）

### 参照完整性

参照完整性又称引用完整性，用于保证多表之间引用关系的正确性。

表与表的关系：

- 一对一：不需要拆分
- 一对多：需要拆分，一个表存外键
- 多对多：需要拆分，添加关系表

**外键**：如果一张表中有一个字段指向了另一张表的主键，该字段为外键，

```sql
create table grade(
    id int auto_increment primary key,
    uid int,
    foreign key(外键名字) references 主表名(主表主键名)
)
```

- 只有 InnoDB 的存储引擎才支持外键约束
- 外键的数据类型必须与指向的主键一致
- 一对多的关系中，外键一般定义在多的一方
- 定义外键的表称为**从表**，被外键引用的表称为**主表**

#### 外键其它操作

- 动态添加外键：


```sql
alter table 从表名称 add foreign key(外键字段名称) references 主表名称(主表主键名称);
```

- 查看外键：

```sql
show create table 从表名称;
```

- 删除外键：

```sql
alter table 从表名 drop foreign key 外键名;
```

外键操作有三个模式：

- 严格操作：
    - 主表不存在对应数据，从表不允许条件
    - 从表引用着数据，主表不允许删除和修改主键
- 指控操作
- 级联操作：自动更新

## 查询深入
#### 去重
```sql
select distinct 字段名 from 表名;
```

#### 排序
```sql
select * from 表名 order by 排序依据1 asc/desc, 排序依据2 asc/desc;
```
- asc 升序
- desc降序

#### 模糊查找
```sql
select * from 表名 where 字段 like 值;
```
- 值中使用`%`作为通配符，如`薛%`。

#### 跳过
```sql
select * from 表名 limit 0, 3; // 前三条数据
```

#### 函数
```sql
select max(表名.字段名) form 表名;
```

- min()
- sum()
- avg()：求平均值

#### 集合
- 查询在集合中的：

```sql
select * from 表名 where 字段名 in (值1, 值2, 值3);
```

> 不在集合内：`not in`

- 查询在范围内的：

```sql
select * from 表名 where 字段名 between 起始值 and 结束值; // 左右都包含
```

#### 联查
- 旧语法：

```sql
select * from 表1, 表2 where 表1.id = 表2._id;
```

- 新语法 join：

```sql
select * from 表1 join 表2 on 表1.id = 表2._id;
```

> 以上联查方式如果一方没有数据则整个数据都会被过滤掉（与 MongoDB 的 aggregate 关联类似），若不需要整个过滤，使用 **`left join`**（更常用） 和 `right join`。


#### 分组
```sql
select 分组依据字段, avg(字段2) from 表名 group by 分组依据字段 having 过滤条件;
```

> `group by` 必须结合函数使用。
> 
> `having` 只能与 `group by` 结合使用来过滤，指定计算结果的别名来操作过滤条件。

#### case when
当……则……

```sql
SELECT
	s.NAME,
	c.score,
CASE
		WHEN c.score > 90 THEN
		"牛逼" 
		WHEN c.score BETWEEN 60 
		AND 90 THEN
			"麻麻得" ELSE "笨逼" 
		END 
		FROM
		student s
	JOIN score c ON s.id = c.student_id;
```

## 事务
银行转账例子，如果后面有一步操作失败，整个数据应该回滚至全部操作之前。

```sql
start transaction
...数据库操作
commit;
```

事务隔离的四个级别：

- **read uncommitted**：读取未提交的内容（最低的事务隔离级别）
- **read committed**：读取提交的内容（不可重复读取，重复读取可能结果不同，别的事务可能 commit 了）
- **reaptable read**：默认机制，可重复读（读取的结果相同，MVVC多版本并发控制机制解决了插入导致的幻影行读取问题）
- **serializable**：序列化（不允许事务并发，严重限制性能）
