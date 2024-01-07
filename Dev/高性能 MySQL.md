# 高性能 MySQL
## MySQL 架构
### 架构的逻辑视图
- 连接/线程处理
- 解析器
- 优化器
- 存储引擎

### 并发控制
**两种锁：**

- 读锁（共享锁）：多个客户端可以同时读取同一个资源而互不干扰
- 写锁（排他锁）：一个写锁既会阻塞读锁也会阻塞其他的写锁

**锁策略：**

- 表锁
- 行级锁：最大程度地支持并发处理，开销最大，在存储引擎中实现

### 事务
事务需要具备四种特性 ACID：

- 原子性（atomicity）
- 一致性（consistency）
- 隔离性（isolation）
- 持久性（durability）

MySQL 的事务是由下层的**存储引擎**实现的，所以不能在事务表（如 InnoDB）和非事务表（如 MyISAM）混合使用事务。

### 隔离级别
较低的隔离级别通常允许更高的并发性，并且开销也更低。

|隔离级别|脏读|不可重复读|幻读|加锁读|备注|
|:-:|:-:|:-:|:-:|:-:|:-:|
|READ UNCOMMITTED（未提交读）|Y|Y|Y|N||
|READ COMMITTED（提交读）|N|Y|Y|N||
|REPEATABLE READ（重复读）|N|N|Y|N|MySQL 默认事务隔离级别，InnoDB 使用**间隙锁**防止幻读 |
|SERIALIZABLE（可串行化）|N|N|N|Y|严格确保数据安全但并发性能下降|

### 死锁
两个或多个事务相互持有和请求相同资源上的锁，产生了循环依赖。InnoDB 处理方案：将持有最少行级排他锁的事务回滚。

### 多版本并发控制 MVCC
避免很多情况下的加锁操作，开销更低。原理是——使用数据在某个时间点的快照。

1. 事务启动时会分配一个**事务 ID**
2. 事务修改记录时写入 Undo 日志，并将回滚指针指向 Undo 日志
3. 其它事务读取时 MySQL 会比较事务 ID 的启动时间早晚，返回给事务 B 正确的数据版本

## 可靠性工程世界中的监控
- 服务水平指标（SLI）：一个定义 ，如何衡量客户是否满意
- 服务水平目标（SLO）：一个程度，比如 99.999%
- 服务水平协议（SLA）：一个协议，达不到会怎么样

### 监控解决方案
- 监控可用性：客户端或远程访问数据库
- 监控查询延迟：从客户端
- 监控报错：关键指标的报错频率
- 主动监控：
	- 磁盘空间使用率
	- 连接数：`threads_connected` 和 `threads_running`
	- 复制延迟：读写分离的场景
	- I/O 使用率
	- 自增键空间
	- 创建备份/恢复时间
- 使用监控工具检查性能时，不要过分关注平均值，要关注峰值

## Performance Schema
Performance Schema 提供了有关 MySQL 服务器内部运行的操作上的底层指标。

- 程序插桩（instrument）：通过在 MySQL 代码中插入探测代码获得想要了解的信息
- 消费者表（consumer）：存储关于程序插桩代码信息的表

### 插桩
查看插桩：

```sql
select * form performence_schema.setup_instruments;
```

插桩的格式：statement（插桩类型）/sql（子系统）/select（具体的插桩）

启用/禁用插桩的三种方式：

1. Update 语句(数据库重启后会失效)

```sql
UPDATE performance_schema.setup_instruments SET ENABLED = 'YES', TIMED = 'YES' WHERE NAME = 'statement/sql/select';
```

2. sys 存储过程(数据库重启后会失效)

```sql
CALL sys.ps_setup_enable_instrument('statement/sql/select');
```

3. 启动选项

```sql
mysqld --performance-schema-instrument='statement/sql/select=ON'
```

**优化 SQL 语句时 `event_statement_history` 表中重要的几个指标：**

- `CREATE_TMP_DISK_TABLES`：查询创建的磁盘临时表数量，太高时要优化查询或增加内存临时表的最大大小
- `CREATE_TMP_TABLES`：查询创建的内存临时表数量，超过空间限制时可能会转换为磁盘临时表
- `SELECT_FULL_JOIN`：没有合适索引，JOIN 执行了全表扫描。除非表特别小，否则要看看索引
- `SELECT_RANGE_CHECK`：JOIN 操作没索引，检查了每一行之后的键。这个值大于 0 就要看下索引是否合理
- `SORT_SCAN`：排序是否通过扫描表完成的。是的话比较糟糕，表示没用索引排序
- `NO_INDEX_USED`：查询没有使用索引，除非表很小否则需要关注
- `NO_GOOD_INDEX_USED`：查询所用的索引不是最合适的。大于 0 则要看下索引
