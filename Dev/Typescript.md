# TypeScript
## 简介
[TypeScript]()是 JavaScript 的一个超集，主要提供了**类型系统**和**对 ES6 的支持**，可以编译为纯 JavaScript。由 Microsoft 开发并[开源](https://github.com/Microsoft/TypeScript)。

> 目前，Vue 3.0、Angular、React 都使用 TypeScript 作为开发语言。

## 安装
```s
npm install -g typescript
```
全局安装 TypeScript 后可在命令行使用`tsc`命令编译一个 TypeScript 文件。

使用 TypeScript 编写的文件以`.ts`为后缀，使用 TypeScript 编写 React 时以`.tsx`为后缀。

> TypeScript 大大增强了编辑器和 IDE 的功能，包括代码补全、接口提示、跳转到定义、重构等。尤其 Visual Studio Code，它内置了 TypeScript 支持，并且它本身也是[使用 TypeScript 编写](https://github.com/Microsoft/vscode/)的。

## Hello TypeScript
1. 新建 hello.ts
	
	```ts
	function helloWorld(name: String) {
	  return `Hello ${name}`;
	}
	
	const zander = 'Zander';
	
	console.log(helloWorld(zander));
	```
2. 编译文件

	```s
	tsc hello.ts
	```
3. 生成编译好的 JavaScript 文件

	```js
	function helloWorld(name) {
	    return "Hello " + name;
	}
	var zander = 'Zander';
	console.log(helloWorld(zander));
	```

TypeScript 中，`:`可以指定变量的类型，编译的时候会进行检查，有错误编译时会报错，但还是会生成 js 文件的编译结果。
```
hello.ts:7:24 - error TS2345: Argument of type '4444' is not assignable to parameter of type 'String'.

7 console.log(helloWorld(zander));
                         ~~~~~~


Found 1 error.
```
## 类型系统
### 原始数据类型
JavaScript 中数据类型分为两种：

- 原始数据类型：Boolean、Number、String、null、undefined、Symbol（ES6）
- 对象类型：Object、Array

先来看看五种原始数据类型在 TypeScript 中是如何使用的：

**1. Boolean**

定义布尔值类型：

```ts
let isDone: boolean = false;
```

> 不能在 TypeScript 中使用构造函数**实例化**布尔值对象：`let newBoolean: boolean = new Boolean(1)`，这种方式返回的是一个 Boolean 对象，应直接调用：`let newBoolean: boolean = Boolean(1)`

**2. Number**

```ts
let num: number = 6;
let binary: number = 0b1010; // ES6中的二进制表示法
let notNum = NaN;
```
```js
var num = 6;
var binary = 10; // ES6中的二进制表示法
var notNum = NaN;
```

**3. String**

```ts
let myName: string = 'Zander';
let myAge: number = 23;

let about: string = `my name is ${myName}, and I am ${myAge}.`
```
```js
var myName = 'Zander';
var myAge = 23;
var about = "my name is " + myName + ", and I am " + myAge + ".";
```

**4. 空值**

JS 中没有空值（void）的概念，但在 TS 中，可以用`void`表示没有任何返回值的函数：

```ts
function voidFunc(): void {
  console.log('this is a void function!')
}
```
声明一个`void`类型的变量没有什么意义，只能将这个变量赋值为`null`和`undefined`：

```ts
let voidName: void = null;
```

```js
function voidFunc() {
    console.log('this is a void function!');
}
var voidName = null;
```

**5. Null 和 Undefined**

```ts
let u: undefined = undefined;
let n: null = null;
let num1: number = undefined;
let str1: string = n;
```
```js
var u = undefined;
var n = null;
var num1 = undefined;
var str1 = n;
```
`null`和`undefined`是所有类型的子类型，可以赋值给其它类型，而`void`不可以。

### 任意值
任意值（Any）用来表示允许将变量赋值为任意类型。

> 个人认为 TS 的类型系统相当于将 JS 的“弱类型”、“动态类型”限制为“强类型”、“静态类型”，但 TS 是 JS 的超集，不能摒弃 JS 的这一特性，所以有了 Any。

1. `any`类型的变量允许被赋值为任意类型

	```ts
	let any: any = 'six';
	any = 6;
	```
	
2. 允许调用任何方法（方法无实际功能）

	```ts
	let anyFunc: any = 'Zander';
	anyFunc.hello();
	anyFunc.world('heihei');
	```
	
	> 可以编译不代表可以运行，这段代码可以编译为 js 文件，但运行还是会报错`anyFunc.hello is not a function`。

3. 未声明类型的变量会被识别为任意值类型

	```ts
	let name;
	name = 'zander';
	name = 666;
	```

### 类型推论
如果没有在代码中明确指定类型，TS 会依照类型推论的规则推断出一个类型，如果非法，编译时依然会报错。

```ts
// 编译时报错
let name = 'zander';
name = 666;
```

### 联合类型
联合类型表示取值可以为多种类型中的一种，使用`|`分隔每一种类型。

```ts
let strOrNum: number | string;
strOrNum = 'zander';
strOrNum = 6;
```

当变量是联合类型时，只可以访问这些类型的共有方法（`toString()`、`length()`等）。

### 对象的类型——接口
在 TypeScript 中，使用接口（Interfaces）来定义对象的类型。

```ts
interface Person {
  name: string;
  age: number;
  alive: boolean;
}

let zander: Person = {
  name: 'Zander',
  age: 18,
  alive: true
}
```
```js
var zander = {
    name: 'Zander',
    age: 18,
    alive: true
};
```
**定义的变量属性不能比接口的属性少或多，必须相同。**

但可设置**可选属性**：

```ts
interface Person {
  name: string;
  age?: number;
  alive?: boolean;
}

let zander: Person = {
  name: 'Zander'
}
```

**任意属性**：

```ts
interface Person {
  name: string;
  age?: number;
  [propName: string]: any
}

let zander: Person = {
  name: 'Zander',
  hello: 'world',
  world: 'lalala'
}
```
`[propName: string]: any`可以添加任意个属性，但是**定义了任意属性后确定属性和可选属性都必须是相同的类型，**即对象里的所有属性必须为同一类型。

**只读属性**：

```ts
interface Person {
  readOnly name: string;
}

let zander: Person = {
  name: 'Zander'
}

zander.name = 'notZander'; // 报错
```
`readOnly`可以使属性只能在创建的时候被赋值。

### 数组类型
数组的定义方法：

**1. 类型 + 方括号**

```ts
let arr: number[] = [1, 2, 3, 4, 5];
```
> 上述代码中数组中不能出现除了 number 类型以外的其他类型，指定为`any`即可添加任意类型的元素。

**2. 数组泛型**

```ts
let arr: Array<number> = [1, 2, 3, 4, 5];
```

**3. 接口**

```ts
interface NumberArray {
  	[index: number]: number;
}
let arr: NumberArray = [1, 2, 3, 4, 5];
```

**4. 类数组**

像函数的参数这种不是数组的类数组不能使用数组的定义方法，要用接口：

```ts
function zander() {
  let args: {
    [index: number]: number;
    length: number;
    callee: Function;
  } = arguments;
}
```
ts 已经定义好了常用的类数组接口，如函数的参数：

```ts
function zander() {
  let args: IArguments = arguments;
}
```
```js
function zander() {
  var args = arguments;
}
```
### 函数类型

> 函数是 JavaScript 中的一等公民。

**1. 函数声明**

```js
// js
function sum(x, y) {
  return x + y;
}
```

```ts
// ts
function sum(x: number, y: number): number {
	return x + y;
}
```
ts 考虑到了函数的输入和输出类型，不可输入多余或少于设定的实参。

**2. 函数表达式**

```js
// js
const sum = function (x, y) {
  return x + y;
}
```

```ts
const sum: (x: number, y: number) => number = function (x: number, y: number): number {
  return x + y;
}
```
此处的`=>`表示 ts 中的**函数定义**，左边为输入类型，右边为输出类型，而非 ES6 中的~~箭头函数~~。

#### 可选参数

	```ts
	function zander(firstName: string, lastName?: string): string {
	  if (lastName) {
	    return `${firstName} ${lastName}`;
	  } else {
	    return firstName;
	  }
	}
	zander('Zander', 'Xue');
	zander('Zander');
	```
⚠️：可选参数必须在必选参数后，即可选参数后面不允许再出现必需参数。
#### 参数默认值

	ts 中，当函数设置了默认参数，会将这个参数识别为可选参数，此时不受可选参数必须在必选参数后的限制。
	
	```ts
	function zander(firstName: string, lastName: string = "Xue"): string {
	  return `${firstName} ${lastName}`;
	}
	zander('Zander');
	```

#### 重载
重载允许一个函数接受不同数量或类型的参数时，作出不同的处理。
> 如需要实现一个函数 reverse，输入数字 123 的时候，输出反转的数字 321，输入字符串 'hello' 的时候，输出反转的字符串 'olleh'。且需要精确为输入为数字的时候，输出也应该为数字，输入为字符串的时候，输出也应该为字符串。

	```ts
	function reverse(x: number): number;
	function reverse(x: string): string;
	function reverse(x: number | string): number | string {
	    if (typeof x === 'number') {
	        return Number(x.toString().split('').reverse().join(''));
	    } else if (typeof x === 'string') {
	        return x.split('').reverse().join('');
	    }
	}
	```

编译结果：

	```js
	function reverse(x) {
	    if (typeof x === 'number') {
	        return Number(x.toString().split('').reverse().join(''));
	    }
	    else if (typeof x === 'string') {
	        return x.split('').reverse().join('');
	    }
	}
	```
### 类型断言
类型断言（Type Assertion）可以用来手动指定一个值的类型。

语法：

`<类型>值` 或 `值 as 类型`

> 当 TypeScript 不确定一个联合类型的变量到底是哪个类型的时候，只能访问此联合类型的所有类型里共有的属性或方法:

```ts
function getLength(something: string | number): number {
    return something.length;
}
// 编译报错，因为number类型没有.length方法
```
但有些时候需要在还不确定类型的时候就访问其中一个类型的属性或方法，如：

```ts
function getLength(something: string | number): number {
    if (something.length) {
        return something.length;
    } else {
        return something.toString().length;
    }
}
// 编译仍报错
```
此时可使用类型断言，将参数断言为 string 类型：

```ts
function getLength(something: string | number): number {
    if ((<string>something).length) {
        return (<string>something).length;
    } else {
        return something.toString().length;
    }
}
```
⚠️：类型断言不是类型转换，断言成一个联合类型中不存在的类型是不允许的。

### 声明文件
此处概念不结合实例难以理解，应在具体项目中加以实践，先放[链接](https://ts.xcatliu.com/basics/declaration-files)，回头敲综合 demo 时结合概念食用。

### 内置对象
JavaScript 中的[内置对象](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects)可以直接在 ts 中当作定义好的类型。
#### ECMAScript 中的内置对象
`Boolean`、`Error`、`Date`、`RegExp`[等](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects)。

```ts
let b: Boolean = new Boolean(true);
let e: Error = new Error('error');
let d: Date = new Date();
let r: RegExp = /[a-z]/;
```
#### DOM 和 BOM 中的内置对象

`Document`、`HTMLElement`、`Event`、`NodeList`等。

```ts
let body: HTMLElement = document.body;
let allDiv: NodeList = document.querySelectorAll('div');
document.addEventListener('click', function(e: MouseEvent) {
  console.log('zander');
});
```
编译结果：

```js
var body = document.body;
var allDiv = document.querySelectorAll('div');
document.addEventListener('click', function (e) {
    console.log('zander');
});
```


> [TypeScript 核心库的定义文件](https://github.com/Microsoft/TypeScript/tree/master/src/lib)中内置了所有浏览器环境需要用到的类型，所以才有不符合类型时的报错，ts 内部做了类型校验。**但核心库的定义中不包含 Node.js 部分**，要使用 ts 写 node 需要引入：
> 
> ```js
> npm install @types/node --save-dev
> ```

---

### 类型别名
使用 `type` 可创建类型别名，常用于联合类型。

```ts
type numberAlias = number;
let a: numberAlias = 999;
```
编译结果：

```js
var a = 999;
```

### 字符串字面量类型
字符串字面量类型用来约束取值只能是某几个字符串中的一个，也是使用`type`进行定义。

```ts
type eventType = 'click' | 'mouseover' | 'scroll';
function handleEvenet(ele: Element, event: eventType) {
  console.log('zander');
}

handleEvenet(document.getElementById('div'), 'click'); // 正确
handleEvenet(document.getElementById('div'), 'mousemove'); // 报错
```

### 元组类型
ts 中的数组的元素都为同一类型，而要存储不同类型的数据需要使用**元组**。

```ts
let zander: [string, number] = ['Zander', 23];
```

可以给元组的元素单独赋值，但直接给元素赋值时需要提供所有的元组类型：

```ts
let zander: [string, number];

zander[0] = "Zander";
zander[1] = "Xue"; // 报错

zander = ["Zander", 23];
zander = ["Zander"]; // 报错
```

### 枚举类型
枚举（Enum）类型用于取值被限定在一定范围内的场景，比如一周只能有七天，颜色限定为红绿蓝等，使用`enum`定义。ts 支持基于数字和字符串的枚举。

#### 数字枚举
枚举成员会默认被赋值为从 0 开始递增的数字，也可以初始化成员的数值：

```ts
enum Week { Sun, Mon, Tue, Wed, Thu, Fri, Sat } // 默认

console.log(Week["Sun"] === 0); // true
console.log(Week[0] === "Sun"); // true

enum Week2 { Sun = 1, Mon, Tue, Wed, Thu, Fri, Sat } // 初始化
```

编译结果：

```js
// 原理：反向映射表
var Week;
(function (Week) {
    Week[Week["Sun"] = 0] = "Sun";
    Week[Week["Mon"] = 1] = "Mon";
    Week[Week["Tue"] = 2] = "Tue";
    Week[Week["Wed"] = 3] = "Wed";
    Week[Week["Thu"] = 4] = "Thu";
    Week[Week["Fri"] = 5] = "Fri";
    Week[Week["Sat"] = 6] = "Sat";
})(Week || (Week = {}));
console.log(Week["Sun"] === 0); // true
console.log(Week[0] === "Sun"); // true
```

#### 字符串枚举
在一个字符串枚举里，**每个成员都必须用字符串进行初始化**。
```ts
enum Gender { Male = "MALE", Female = "Female", Unknow = "UNKNOW" }
```

编译结果：

```js
var Gender;
(function (Gender) {
    Gender["Male"] = "MALE";
    Gender["Female"] = "Female";
    Gender["Unknow"] = "UNKNOW";
})(Gender || (Gender = {}));
```

#### 常量枚举（`const`枚举）
常量枚举是使用 `const enum` 定义的枚举类型，它会在编译阶段被删除，并且不能包含计算成员。

```ts
const enum Week { Sun, Mon, Tue, Wed, Thu, Fri, Sat }
```
编译结果：

```js
var week = [0 /* Sun */, 1 /* Mon */, 2 /* Tue */, 3 /* Wed */, 5 /* Fri */, 6 /* Sat */];
```

## 类
回顾类的相关概念：

- 类(Class)：定义了一件事物的抽象特点，包含它的属性和方法
- 对象（Object）：类的实例，通过 new 生成
- 面向对象（OOP）的三大特性：封装、继承、多态
- 封装（Encapsulation）：将对数据的操作细节隐藏起来，只暴露对外的接口。外界调用端不需要（也不可能）知道细节，就能通过对外提供的接口来访问该对象，同时也保证了外界无法任意更改对象内部的数据
- 继承（Inheritance）：子类继承父类，子类除了拥有父类的所有特性外，还有一些更具体的特性
- 多态（Polymorphism）：由继承而产生了相关的不同的类，对同一个方法可以有不同的响应。比如 Cat 和 Dog 都继承自 Animal，但是分别实现了自己的 eat 方法。此时针对某一个实例，我们无需了解它是 Cat 还是 Dog，就可以直接调用 eat 方法，程序会自动判断出来应该如何执行 eat
- 存取器（getter & setter）：用以改变属性的读取和赋值行为
- 修饰符（Modifiers）：修饰符是一些关键字，用于限定成员或类型的性质。比如 public 表示公有属性或方法
- 抽象类（Abstract Class）：抽象类是供其他类继承的基类，抽象类不允许被实例化。抽象类中的抽象方法必须在子类中被实现
- 接口（Interfaces）：不同类之间公有的属性或方法，可以抽象成一个接口。接口可以被类实现（implements）。一个类只能继承自另一个类，但是可以实现多个接口

传统的 JavaScript 使用函数和基于原型的继承来创建可重用的组件（类），从 ES6 开始新增了 `class`。TypeScript 除了实现了所有 ES6 中的类的功能以外，还添加了一些新的用法。

```ts
class Greeter {
  greeting: string;
  constructor(message: string) {
    this.greeting = message;
  }
  greet() {
    return 'Hello, ' + this.greeting;
  }
}

let greeter = new Greeter('world');
```

编译结果：

```js
var Greeter = /** @class */ (function () {
    function Greeter(message) {
        this.greeting = message;
    }
    Greeter.prototype.greet = function () {
        return 'Hello, ' + this.greeting;
    };
    return Greeter;
}());
var greeter = new Greeter('world');
```

#### 继承
```ts
class Animal {
  constructor(name: string) { this.name = name; }
  alive(age: number = 0) {
      console.log(`This animal is ${age} years old.`);
  }
}

class Dog extends Animal {
  constructor(name: string) { super(name); }
  alive(age = 10) {
    console.log(`I am ${age} years old!`);
  }
  bark() {
      console.log('Woof! Woof!');
  }
}

const dog = new Dog();
dog.bark();
dog.alive(10);
dog.bark();
```

此处的 Dog 是一个**派生类**，它派生自 Animal 基类，通过 extends 关键字。 派生类通常被称作**子类**，基类通常被称作**超类**。

但是在 ts 中有一条重要的规则，如上述代码所示，派生类包含了一个构造函数`name`，它必须调用`super()`方法，它会执行基类的构造函数。**在构造函数里访问 this 的属性之前，必须要调用 super()。**

而且，Dog 中重写了 Animal 中定义的`alive`方法，使其具有不同的功能。

#### 公共，私有与受保护的修饰符
**1. public**

在TypeScript里，成员都默认为`public`。

**2. private**

当成员被标记成 `private`时，它就不能在声明它的类的外部访问。

```ts
class Animal {
    private name: string;
    constructor(theName: string) { this.name = theName; }
}

new Animal("Cat").name; // 错误: 'name' 是私有的.
```

**3. protected**

`protected`修饰符与 `private`修饰符的行为很相似，但有一点不同， `protected`成员在派生类中仍然可以访问。

```ts
class Person {
  protected name: string;
  constructor(name: string) { this.name = name; }
}

class Employee extends Person {
  private department: string;

  constructor(name: string, department: string) {
      super(name)
      this.department = department;
  }

  public getName() {
      return `Hello, my name is ${this.name} and I work in ${this.department}.`;
  }
}

let zander = new Employee("Zander", "西安开发中心");
console.log(zander.getName());
console.log(zander.name); // 错误
```
⚠️：不能在 Person 类外直接使用 name，但是可以通过 Employee类的实例方法访问。

**4. readonly**

`readonly`关键字可将属性设置为只读的，只读属性必须在声明时或构造函数里被初始化。

```ts
class Person {
  readonly name: string;
  readonly age: number = 8;
  constructor (theName: string) {
      this.name = theName;
  }
}
let zander = new Person("Zander");
zander.name = "Tom"; // 错误! name 是只读的
```

使用**参数属性**在构造函数前创建并初始化参数，可简化构造函数的赋值：

```ts
class Person {
  readonly age: number = 8;
  constructor(readonly name: string) {
  }
}
```

#### 静态属性
类的静态成员存在于类本身上面而不是类的实例上。

```ts
class Grid {
    static origin = {x: 0, y: 0};
    calculateDistanceFromOrigin(point: {x: number; y: number;}) {
        let xDist = (point.x - Grid.origin.x);
        let yDist = (point.y - Grid.origin.y);
        return Math.sqrt(xDist * xDist + yDist * yDist) / this.scale;
    }
    constructor (public scale: number) { }
}

let grid1 = new Grid(1.0);  // 1x scale
let grid2 = new Grid(5.0);  // 5x scale

console.log(grid1.calculateDistanceFromOrigin({x: 10, y: 10}));
console.log(grid2.calculateDistanceFromOrigin({x: 10, y: 10}));
```
在这个例子里，使用 `static`定义 `origin`，因为它是所有网格都会用到的属性。每个实例想要访问这个属性的时候，都要在 `origin`前面加上类名。如同在实例属性上使用 `this.`前缀来访问属性一样，这里使用 `Grid.`来访问静态属性。

#### 抽象类
`abstract`用于定义抽象类和其中的抽象方法。

1. 抽象类不允许被实例化

	```ts
	abstract class Animal {
	    public name;
	    public constructor(name) {
	        this.name = name;
	    }
	    public abstract sayHi();
	}
	
	let a = new Animal('Jack'); // 报错
	```
2. 抽象类中的抽象方法必须被子类实现

	```ts
	abstract class Animal {
	    public name;
	    public constructor(name) {
	        this.name = name;
	    }
	    public abstract sayHi();
	}
	
	class Cat extends Animal {
	    public eat() {
	        console.log(`${this.name} is eating.`);
	    }
	}
	
	let cat = new Cat('Tom'); // 报错，Cat 中必须实现 salHi 方法
	```

## 泛型
泛型（Generics）是指在定义函数、接口或类的时候，不预先指定具体的类型，而在使用的时候再指定类型的一种特性。有利于组件的可复用性。

```ts
function zander<T>(arg: T): T {
  return arg;
}
```
类型变量 T 可捕获用户传入的类型（比如：number），之后就可以使用这个类型。比如再次使用了 T 当做返回值类型。

> 与使用`any`定义参数和返回值不同，`any`不能保证传入的类型与返回的类型相同。

定义了泛型函数后，有两种使用方法：

1. 传入所有的参数，包含类型参数

	```ts
	function zander<T>(arg: T): T {
	  return arg;
	}
	
	const hello = zander<String>('hello');
	```
2. 类型推论

	即编译器会根据传入的参数自动地确定 T 的类型，**更常用**。

	```ts
	const hello = zander('hello');
	```

### 泛型变量

如果想要获取传入参数的`length`属性时，直接使用会报错，因为不确定传入的参数是否有`length`属性（如 number 类型）：

```ts
function zander<T>(arg: T): T {
    console.log(arg.length);  // 报错
    return arg;
}
```
可以使用泛型变量指定参数的类型来使用该类型参数具有的属性：

```ts
function zander<T>(arg: T[]): T[] {
    console.log(arg.length);  // 正确
    return arg;
}

zander([22, 33]);
```

### 泛型类型

泛型函数的类型与非泛型函数的类型没什么不同，只是有一个类型参数在最前面，像函数声明一样：

```ts
function zander<T>(arg: T): T {
  return arg;
}

let zander1: <T>(arg: T) => T = zander;
```

### 泛型接口

```ts
interface zander {
  <T>(arg: T): T;
}

function zanderFunc<T>(arg: T): T {
  return arg;
}

let zander1: zander = zanderFunc;
```

### 泛型类

泛型类看上去与泛型接口差不多。 泛型类使用`<>`括起泛型类型，跟在类名后面。

> 无法创建泛型枚举和泛型命名空间。

```ts
class Add<T> {
  zeroValue: T;
  add: (x: T, y: T) => T;
}

let add = new Add<number>();
add.zeroValue = 0;
add.add = function(x, y) { return x + y; };

let add = new GenericNumber<string>(); // 可指定任意类型
add.zeroValue = "";
add.add = function(x, y) { return x + y; };
console.log(add.add(add.zeroValue, "test"));

```

⚠️：类有两部分：静态部分和实例部分。 泛型类指的是实例部分的类型，所以类的静态属性不能使用这个泛型类型。

### 泛型约束
像上面使用`length`	属性的例子，也可限制函数去处理任意带有`.length`属性的所有类型。只要传入的类型有这个属性，就允许。这就是泛型约束。

```ts
interface Lengthwise {
  length: number;
}

function zander<T extends Lengthwise>(arg: T): T {
  console.log(arg.length); // T 一定具有lenth属性
  return arg;
}

zander(6); // 报错

zander({length: 10, value: 6});
```

编译结果：

```js
function zander(arg) {
    console.log(arg.length); // T 一定具有lenth属性
    return arg;
}
// zander(6); // 报错
zander({ length: 10, value: 6 });
```

## 声明合并
“声明合并”是指编译器将针对同一个名字的两个独立声明合并为单一声明。 合并后的声明同时拥有原先两个声明的特性。 任何数量的声明都可被合并；不局限于两个声明。

简单来说：**如果定义了两个相同名字的函数、接口或类，那么它们会合并成一个类型。**

### 函数的合并

```ts
function reverse(x: number): number;
function reverse(x: string): string;
function reverse(x: number | string): number | string {
    if (typeof x === 'number') {
        return Number(x.toString().split('').reverse().join(''));
    } else if (typeof x === 'string') {
        return x.split('').reverse().join('');
    }
}
```
### 接口的合并
最简单也最常见的声明合并类型，合并的机制是把双方的成员放到一个同名的接口里。

```ts
interface Box {
    height: number;
    width: number;
}

interface Box {
    scale: number;
}

let box: Box = {height: 5, width: 6, scale: 10};
```

- 接口的非函数的成员应该是唯一的。如果它们不是唯一的，那么它们必须是相同的类型。如果两个接口中同时声明了同名的非函数成员且它们的类型不同，则编译器会报错。

- 对于函数成员，每个同名函数声明都会被当成这个函数的一个重载。同时需要注意，当接口A与后来的接口A合并时，后面的接口具有更高的优先级。如：

	```ts
	interface Cloner {
	    clone(animal: Animal): Animal;
	}
	
	interface Cloner {
	    clone(animal: Sheep): Sheep;
	}
	
	interface Cloner {
	    clone(animal: Dog): Dog;
	    clone(animal: Cat): Cat;
	}
	```
	合并为一个声明：
	
	```ts
	interface Cloner {
	    clone(animal: Dog): Dog;
	    clone(animal: Cat): Cat;
	    clone(animal: Sheep): Sheep;
	    clone(animal: Animal): Animal;
	}
	```
## 声明文件
在JavaScript中一个库有很多使用方式，这就需要书写声明文件去匹配它们。

### 书写声明文件步骤
**1. 识别库的类型**

1. 全局库

	全局库是指能在全局命名空间下访问的（不需要使用任何形式的import）。许多全局库都是简单的暴露出一个或多个全局变量。如 jq 中的`$`变量可以被简单的引用：
	
	```js
	$(() => { console.log('hello!') })
	```
	全局库的常用引用方式即在 HTML 文件的`<script>`标签中：
	
	```js
	<script src="<script src="https://cdn.staticfile.org/jquery/1.10.2/jquery.min.js">"></script>
	```
	
	全局库源码的特性：
	
	- 顶级的`var`语句或`function`声明
	- 一个或多个赋值语句到`window.someName`
	- 存在 DOM 对象`document`或`window`
	- 不存在`require`或`define`调用
	
	[全局库导入模板](https://www.tslang.cn/docs/handbook/declaration-files/templates/global-d-ts.html)

2. 模块化库

	一些库只能工作在模块加载器的环境下。比如，express 只能在 Node.js 里工作所以必须使用 CommonJS 的`require`函数加载。
	
	ES6 后，CommonJS 和 RequireJS 具有相同的导入模块作用。例如，对于JavaScript CommonJS（Node.js）：
	
	```js
	var fs = require("fs");
	```
	
	ES6 `import`导入：
	
	```js
	import fs = require("fs");
	```
	模块化库源码的特性：
	
	- 调用`require`或`define`
	- 存在`import`、`export`声明
	- 赋值给`exports`或`module.exports`
	- 极少包含`window`或`global`的赋值

3. UMD

	UMD 模块是指那些既可以作为模块使用（通过导入）又可以作为全局（在没有模块加载器的环境里）使用的模块。
	
	如 [Moment.js](http://momentjs.com/)、Lodash 等，在Node.js或RequireJS里:
	
	```js
	import moment = require("moment");
	console.log(moment.format());
	```
	也可以通过全局变量使用：
	
	```js
	console.log(moment.format());
	```
	
	UMD 库源码的特性：
	
	- 模块加载器环境
		
		```js
		(function (root, factory) {
		    if (typeof define === "function" && define.amd) {
		        define(["libName"], factory);
		    } else if (typeof module === "object" && module.exports) {
		        module.exports = factory(require("libName"));
		    } else {
		        root.returnExports = factory(root.libName);
		    }
		}(this, function (b) {
		```
	- 文件的顶端存在`typeof define`，`typeof window`，或`typeof module`这样的测试

> 常用的第三方库都已经存在了声明文件，但也需要知道一些基本知识，如使用`declare`来定义类型。

## ts 优缺点

||作者|使用者|
|:-:|:-:|:-:|
|**优点**|清晰的函数参数/接口属性；静态检查；生成api文档|清晰的函数参数/接口属性；配合现代编辑器，各种提示|
|**缺点**|标记类型；声明(interface/type)|与某些库配合度不是很完美（vue 2.x）|

#### 学习链接
- [官方文档](https://www.tslang.cn/docs/handbook/compiler-options.html)
- [TypeScript 入门教程](https://ts.xcatliu.com/)
- [一篇朴实的文章带你30分钟捋完TypeScript,方法是正反对比](https://juejin.im/post/5d53a8895188257fad671cbc)