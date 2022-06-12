# MongoDB
## 主键
- 用于保证每一条数据的唯一性
- 自动添加，无需自行指定，主键名为 `_id`
- `_id` 是一个 ObjectId 类型的数据，即一个12个字节的字符串（4e5ade53-8cd45e-9de3-d943ae）
    - 4子节是存储这条数据的时间戳
    - 3字节是存储这条数据的电脑的标识符
    - 2字节是存储这条数据的 MongoDB 进程 id
    - 3字节是计数器

    > 可保证数据库横向扩展后数据的唯一性。

## 增
### 写入单个文档
**1. `db.<collection>.insertOne()`**

**2. `db.<collection>.save()`**

> 两个方法的区别在于插入时如果主键重复，`insertOne()` 报错，插入失败，而 `save()` 会覆盖已存在的数据。

### 写入多个文档
**1.` db.<collection>.insertMany()`**

接收两个参数：

- 文档数组
- 可选的配置项对象，对象内可传入 `ordered` ，表示是否按顺序写入。默认为 true，前面的文档出错时后面的所有文档都不会被写入。设为 false 时，不按顺序写入，但写入效率较高，前面的文档出错，后面所有文档会被继续写入。

## 查
### 过滤数据
**1. `db.<collection>.find(<query>, <projection>)`**

- query：查询的条件
- projection：投影文档，规定查询的结果中显示哪些字段，默认都为1，不显示字段的设为 0

> 投影的条件不能同时包含 0 和 1（`_id` 不受限制），如不能为 `db.getCollection('person').find({}, {age: 0, name: 1});`

### 比较操作符
- `$eq`：等于
- `$ne`：不等于（不存在需要判断的字段也算作不等于）
- `$gt`：大于
- `$gte`：大于等于
- `$lt`：小于
- `$lte`：小于等于

```js
db.<collection>.find({name: {$ne: "Zander"}});
```


- `$in`：匹配和任意指定值相等的文档，值为数组
- `$nin`：匹配和任意指定值都不相等的文档，值为数组（不存在需要判断的字段也满足条件）

```js
db.<collection>.find({name: {$in: ["Zander", "Paul", "Leon"]}});
```

### 逻辑操作符
逻辑操作符后需为一个正则表达式或对象。

- `$not`：非（不存在需要判断的字段也满足条件）
- `$and`：且
- `$or`：或
- `$nor`：都不（不存在需要判断的字段也满足条件）

```js
// 查询所有名字不为 Zander 的
db.person.find({name: {$not: {$eq: "Zander"}}});

// 且
db.person.find({$and: [{name: "Zander", age: 18}]});

// 或
db.person.find({$or: [{name: "Zander"}, {name: "Hello"}]})

// not or 都不
db.person.find({$nor: [{name: "Zander"}, {name: "Hello"}]})
```

### 字段操作符
- `$exists`：查询包含某个字段的文档

> 可配合 $ne、$nin、$nor、$not 清理数据

```js
db.person.find({name: {$ne: 'Zander', $exists: true}})
```

- `$type`：查询指定字段包含指定类型的文档

```js
db.person.find({age :{$type: 'number'}})
```

### 数组操作符
- `$all`：匹配数组字段包含指定数组内所有元素的文档

```js
db.getCollection('person').find({book: {$all: ["a", "b"]}})
```

- `$is`：匹配数组字段中至少有一个元素符合多个查询条件的文档

```js
db.getCollection('person').find({students: {$elemMatch: {name: "Zander", age: 18}}})
```

### 运算操作符
- `$regex`：查询满足正则的文档

```js
// 匹配 name 以 z/Z 开头的文档，i 表示忽略大小写
db.getCollection('person').find({name: {$regex: /^z/, $options: 'i'}})
// or
db.getCollection('person').find({name: {$regex: /^z/i}})
```

### 文档游标
`find()` 方法的返回值是一个文档游标，相当于 C 语言的指针，文档游标的方法有：

- hasNext()：判断是否还有下一个文档
- next()：取出下一个文档
- forEach()：依次取出所有文档

### 分页函数
- cursor.limit()：取出文档的数量
- cursor.skip()：跳过文档的数量

### 排序函数
- `cursor.sort({field: ordering})`：按照指定规则排序
    - ordering 为1表示升序，为-1表示降序

> sort 和 limit/skip 同时使用时，无论 sort 写在前面还是后面都会先执行 sort。

### 统计函数
- count()：统计查询结果的数目

可接收一个 `applySkipLimit` 参数，表示统计数目时是否忽略 skip 和 limit，默认为 false，表示忽略 skip 和 limit 查询总数。

```js
db.getCollection('person').find({}).limit(5).sort({age: 1}).count({applySkipLimit: true})
```

## 改
### 更新文档的方法
**1. `db.<collection>.save()`**

当没有指定 `_id` 字段时为新增，如果指定了已经存在的 `_id` 则覆盖原文档。

**2. `db.<collection>.update(<filter>, <update>, <options>)`**

- `<filter>`：筛选条件
- `<update>`：新的内容
- `<options>`：配置项

> 默认会覆盖原文档，若要只更新，则需使用更新操作符。
> 
> 默认只更新满足筛选条件的第一个文档，若要更新所有满足条件的文档需指定第三个参数 `{ multi: true}`，同时在第二个参数中必须使用更新操作符
> 
> 第二个参数中如果指定了 `_id`，则必须与原文档取值一致，否则报错无法更新（一般不指定 `_id`）


**3. `db.<collection>.findAndModify()`**

### 更新操作符
默认情况下 update 会直接覆盖旧文档，使用更新操作符可更新文档内特定的字段。

**1. $set**

更新或新增字段，字段存在则更新，不存在则新增。

```js
db.getCollection('person').update({name: "Tony"}, {$set: {age: 99, book: "her"}})
```

**2. $unset**

删除字段，字段的值无关紧要。

```js
db.getCollection('person').update({name: "Tony"}, {$unset: {'age': ""}})
```

> 如果删除的是数组字段中的元素，不会改变数组的长度，而是使用 null 替换删除的内容

**3. $rename**

重命名字段。

```js
db.getCollection('person').update({name: "Tony"}, {$rename: {'name': "first_name"}})
```

> 如果文档里已经存在新的名称，则会删除已经存在的字段
> 
> 不能通过 $rename 来操作数组内对象的属性名

- 使用技巧：

可将内层文档中的字段转移到外层，或将外层转移到内层：

```js
db.getCollection('person').update({name: "Tony"}, {$rename: {'age': "obj.age"}})
```

**4. $inc**

更新字段值（增加或减少字段的值），只能操作 Number 类型的字段。

```js
db.getCollection('person').update({name: "Tony"}, {$inc: {'age': 2}})

db.getCollection('person').update({name: "Tony"}, {$inc: {'age': -5}})
```

> 若不存在要操作的字段，则新增这个字段，初始值为0再执行增加/减少操作。

**5. $mul**

更新字段值（乘以或除以字段的值），只能操作 Number 类型的字段。

**6. $min**

更新值时保存较小的值。

```js
db.getCollection('person').update({name: "Zander"}, {$min: {'age': 1}})
```

> 如果要操作的字段不存在，则自动增加这个字段并将值赋给它。

**6. $max**

更新值时保存较大的值。

**7. $addToSet**

向数组字段中添加元素。

```js
db.getCollection('person').update({name: "Zander"}, {$addToSet: {"book": "金瓶梅"}})
```

> 如果要操作的字段不存在，则自动增加这个数组字段并向数组中添加元素。
> 
> 添加的元素会自动去重。

**8. $push**

向数组字段中添加元素（不去重）。

**9. $pop**

从数组中删除元素，传1表示删除最后一个元素，传-1表示删除第一个元素。

```js
db.getCollection('person').update({name: "Zander"}, {$pop: {"book_name": -1}})
```

**10. $pull**

从数组中删除指定的元素，可以指定具体的值或正则表达式。

```js
db.getCollection('person').update({name: "Zander"}, {$pull: {"book_name": "123"}}) // 指定元素的值

db.getCollection('person').update({name: "Zander"}, {$pull: {"book_name": /^1/}}) // 指定正则表达式
```

> 如果要删除的数组内的元素是 Object 类型，只要匹配到一个属性就可删除整个对象。

**11. $pullAll**

从数组中批量删除特定元素。

```js
db.getCollection('person').update({name: "Dom"}, {$pullAll: {book: ["三国", "西游"]}})
```

> 如果要删除的数组内的元素是 Array 类型或者 Object 类型，元素的顺序和值必须一摸一样才可删除。

**12. $和$[]**

- $：更新数组中满足条件的特定元素

```js
db.getCollection('person').update({name: "Dom", "book.name": "西游"}, {$set: {"book.$.name": "水浒"}}) // 更新数组中对象的属性值
```


- $[]：更新数组中所有元素

```js
db.getCollection('person').update({name: "Zander"}, {$set: {"book_name.$[]": "水浒"}})
```

## 删
**1. 删除所有满足条件的数据**

```js
db.getCollection('person').remove({name: "Zander"})
```

**2. 删除满足条件的第一条数据**

```js
db.getCollection('person').remove({name: "Zander"}, {justOne: true})
```

## 聚合操作
聚合操作就是通过一个方法完成一系列的方法，聚合中的每一个操作成为一个阶段，上一阶段会将处理的结果传给下一个阶段继续处理。

### $project
- 作用：对输入的文档进行再次投影，按照需要的格式生成结果
- 格式：`{$project: { field: value }}`

> 如果在 $project 操作中使用了原文档中不存在的字段则自动添加，使用 null 填充。

```js
db.getCollection('person').aggregate([
    {
        $project: {
            _id: 0,
            my_name: "$name"
         }
     }
])
```

### $macth
- 作用：用于筛选符合条件的文档
- 格式：`{$match:{ field: value }}`

### $limit 和 $skip
**1. $limit**

- 作用：用于指定获取的文档数目
- 格式：`{$limit: <number>}`

**2. $skip**

- 作用：用于指定跳过的文档数目
- 格式：`{$skip: <number>}`

### $unwind
- 作用：展开数组字段
- 格式：`$unwind: {path: <$field>}`
- 参数：
    - `includeArrayIndex: 'index'`：在结果中添加数组的索引
    - `preserveNullAndEmptyArrays: true`：空数组和 null 也拆分

### $sort
- 作用：排序
- 格式：`$sort: {<field: 1>}`

### $lookup
- 作用：关联查询
- 格式：

    关联形式：
    
    ```js
    {$lookup: {
            form: <关联集合名>
            localField: <当前集合中的字段名>
            foreignField: <关联集合中的字段名>
            as: <输出的字段名>
        }
    }
    ```
    
    不关联形式：
    
    ```
    {$lookup: {
            form: <关联集合名>
            let: { 定义给关联集合的聚合操作使用的当前集合的常量 }
            pipeline: [关联集合中的聚合操作]
            as: <输出的字段名>
        }
    }
    ```

### $group
- 作用：对文档进行分组
- 格式：

```js
{$group: {
    _id: <分组的依据字段>,
    <field>: { <操作> },
    ...: ...
  }
}
```

### $out
- 作用：将前面阶段处理完的文档写入一个新的集合
- 格式：`{$out: <集合名>}`

> 若不存在这个集合，则自动创建；若已存在这个集合，则直接覆盖。

### 聚合操作额外配置
```js
db.<collection>.aggregate(<pipeline>, <options>)
```

**1. `allowDiskUse: <boolean>`**

管道阶段占用内存超过100M时允许写入数据到临时文件中。

### 聚合操作表达式
**1. 字段路径表达式**

`$<field>`：使用 `$` 表示字段路径

```js
{$project: {
    _id: 0,
    name: '$name'
  }
}
```

**2. 系统变量表达式**

`$$CURRENT`：表示当前操作的文档

```js
$$CURRENT.name === $name
```

**3. 常量表达式**（相当于转义）

`$literal: <value>`

```js
{$project: {
    _id: 0,
    name: {$literal: '$name'}
  }
}
```

### 数据类型转换操作符
- 作用：将不同的数据类型转换为相同的类型，便于后续处理，不是一个单独的管道阶段
- 格式：

```js
{$convert: {
    input: <需要转换的字段>,
    to: <转换之后的数据类型>,
    onError: <如果不支持，转换的类型>,
    onNull: <如果没有，转换的类型>
  }
}
```

## 索引
用于提升数据的查询速度，相当于字段的目录。

- 主键会默认创建索引

- 获取索引：`getIndexes()`
- 创建索引：`createIndex({ <field>: 1 | -1 })`，1表示正序，-1倒序

### explain() 查询分析工具
```
db.getCollection('person').find({name: "Zander"}).explain()
```

- 依据 `winningPlan` 中的 `stage` 的取值来判断查询的方式：
    - `IXSCAN`：根据索引查询
    - `COLLSCAN`：遍历整个集合查询

### 复合索引
```js
db.getCollection('person').createIndex({name: -1, age: -1})
```

- 查询的时候只支持**前缀查询**（查询条件包含前缀），如上面的查询只支持使用 `name` 的索引查询，使用 `age` 查询时不会使用索引。

### 多键索引
为数组字段创建索引时会为其每一个元素都创建索引。

### 索引对排序的影响
- 排序的字段若不是索引字段，会在执行查询的时候排序再输出；反之，直接获取索引对应的文档来输出。
- 如果是符合索引，则排序条件包含索引字段的**前缀字段**才会使用索引来排序

### 唯一索引
- 主键默认为唯一索引
- 创建唯一索引：指定参数 `{unique: true}`
- 若添加的字段没有唯一索引的字段，第一个这样的文档会自动填充null，第二个会报错

### 稀疏索引
- 稀疏索引可优化索引占用的存储空间，添加参数 `{sparse: true}`。
- 稀疏性索引忽略不含有索引字段的文档，即如果索引具备唯一性且具备稀疏性，可添加缺失索引字段的文档

### 索引生存时间
若文档包含日期字段或包含日期的数组字段，可在创建索引的时候指定索引的生存时间，超过生存时间会自动删除对应的文档。

> ⚠️不能保证即时性。

```
db.getCollection('person').createIndex({addTime: 1}, {expireAfterSeconds: 5})
```

- 若给数组字段指定了超时时间，则以数组中时间最小的值为基准计算超时时间。

### 删除索引
```js
db.<collection>.dropIndex(<索引名称>)
```

## 数据模型
### 文档间关系
- 内嵌式结构
    - 一次查询就能得到所有数据
    - 若数据比较复杂，不方便管理和更新
    - 适用于数据不复杂/查询频率较高的场景
- 规范式结构：通过 id 关联
    - 方便管理复杂的数据
    - 查询数据相对麻烦
    - 适用于数据复杂/更新频率较高的场景

关系的方式：

- 一对一
- 一对多
- 多对多


## Mongoose
1. 安装并导入
2. 链接 MongoDB
3. 监听链接状态

```js
// 自调用函数返回 Promise

(async () => {
    const result = await User.find({});
})();
```

## 复制集
如果所有数据都存储在一台 MongoDB 服务器上：

1. 不具备高可用性，一旦服务器宕机，用户无法继续使用
2. 不具备数据安全性，服务器损坏数据丢失
3. 不能对数据进行分流（访问数据时远慢近快）

将**多台**保存了**相同内容**的 MongoDB 服务器组成一个集群，称为复制集。

- 在复制集中每一台 MongoDB 服务器都是一个节点。
- 在一个复制集中最多有50个节点。
- 在复制集中必须有一个主节点，只有主节点可以同时**读写数据**，其它副节点只能读数据。
- 复制集中节点之间每隔2秒相互发送心跳请求，检查是否有节点出现问题，若某个节点10s没有相应请求，视为出现问题。
- 主节点若出现问题，副节点自动发起投票，重新选举主节点。

触发选举的条件：

- 初始化复制集时
- 有新节点加入时
- 已有主节点挂了时

### 复制集同步规则
1. 初始化同步

当有一个新节点加入到复制集之后，会将所有主节点的数据拷贝到新节点中

2. 同步写库记录

在每一个 MongoDB 服务器上都有一个 local 数据库，其中 oplog 集合保存当前服务器的所有操作记录。执行完初始化同步后，副节点会定期同步和执行写库记录

## 分片
分片就是将数据库集合中的数据拆分成多份，分布式地保存到多台主机上，可解决服务器的容量问题。

- 并不是所有集合都需要做分片，不使用分片的集合统一保存在**主分片**中。

### 分片结构
- 分片服务器：同于存储不同数据的多个服务器
- 配置服务器：用于配置分片服务器存储范围
- **路由服务器**：负责分发客户端请求

路由服务器分发请求的流程：

1. 客户端发送请求到路由服务器
2. 路由服务器配置服务器查询数据段（数据范围）
3. 根据查询的结果到对应的分片服务器上做处理
4. 拿到处理结果，将处理的结果返回给用户

### 分片片键
分片片键用于将数据存储到不用的分片服务器上。

- 可以将文档里的一个或多个字段设置为分片片键
- 设置完后，mongodb 会自动按照字段的取值进行划分，划分为一个个数据段
- 然后 mongodb 会自动决定哪个分片服务器保存哪些数据段

注意点：

1. 片键可以一个或者多个字段
2. 只有索引字段才能被设置为片键
3. 分片服务器保存哪些数据段的值是随机的，并不是连续的
4. 数据段的划分可以使用片键的取值，也可以使用片键取值的哈希值

### 如何选择片键
1. 片键字段取值范围应更广，以划分更多的数据段
2. 字段取值的分配应更平衡，而不是都集中在某个数据段内
3. 不应该选择单向增加或者减少的字段作为片键

技巧：

- 取值不够广或不够平衡，可使用复合片键
- 如果取值是单向增加/减少，可使用其哈希值划分

**片键一旦选择就不能更改，前期选择片键要谨慎。**

### 分片查询
1. 查询的条件是分片片键

路由服务器可以准确找到保存对应数据的分片服务器。


2. 查询的的条件不是分片片键

将请求发送到所有分片服务器上，再将返回的结果整合，整合后返回给客户端。