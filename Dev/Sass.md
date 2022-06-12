# Sass
Sass 是世界上最成熟、稳定，功能最强大的专业级 CSS 扩展语言。 ——王婆卖瓜环节

## 安装
### MacOS 安装
Sass 是使用 Ruby 语言编写的，要使用 Sass 必须先[安装 Ruby](http://www.ruby-lang.org/zh_cn/downloads/)。

1. MacOS 上默认已经安装了 Ruby，使用 `$ ruby -v` 可查看安装情况。

2. 如果没有安装 Ruby，可使用 Homebrew 安装 Ruby：`$ brew install ruby`

3. 使用 Ruby 安装 Sass：`$ sudu gem install sass`

> 国内的 Gem 极慢，可改为使用[国内镜像](https://gems.ruby-china.com/)。或者直接使用 Homebrew 安装：`$ brew install sass/sass/sass`

### Npm 安装
```s
$ npm install -g sass
```
## 使用
### 命令行使用
Sass 文件一般指以 `.scss` 结尾的文件，意为 Sassy CSS，还有一种更旧的语法以 `.sass` 结尾，需要[区分开来](https://stackoverflow.com/questions/5654447/whats-the-difference-between-scss-and-sass)。

先编写一段 Sass 代码：

```sass
$yy: black;

ul {
  width: 100px;
  li {
    color: $yy;
  }
}
```

输入命令将其编译转化为 CSS 代码：

```s
$ sass test.scss
```

也可以将编译的结果保存为文件：

```s
$ sass test.sass test.css
```

#### 输出样式
是否觉得输出的代码格式有些怪异（缩进等）：

```css
ul {
  width: 100px; }
  ul li {
    color: black; }

/*# sourceMappingURL=01.css.map */
```

这是因为采用了默认的代码风格来编译，使用 `--style` 可指定编译后的 CSS 代码风格，支持一下四种输出样式：

1. nested：默认格式，嵌套缩进。
2. expanded：平时手动格式化后的样式，无缩进、无嵌套。
3. compact：一个样式规则处于同一行。
4. compressed：压缩。

> 生产环境一般采用压缩的格式。

#### 监听
也可以让SASS监听某个文件或目录，一旦源文件有变动，就自动生成编译后的版本。

```s
# 监听单个文件
$ sass --style expanded --watch test.scss:test.css

# 监听文件夹
$ sass --watch app/sass:public/stylesheets
```

## Sass 规则
### 变量 Variables
变量以 `$` 开头，可以是任何 CSS 的单个/多个值：

```sass
$primary-color: yellow;
$primary-border: 1px solid $primary-color;

body {
  background-color: $primary-color;
  div {
    border: $primary-border;
  }
}
```

> 使用变量的时候名字中的 `-` 和 `_` 可替换，但尽量保持统一。

### 嵌套 Nesting
#### 基本嵌套
Sass 中的选择器可以嵌套使用，避免重复书写父级选择器/

```sass
.nav {
  background-color: yellow;
  ul {
    margin: 0;
    width: 100px;
    height: 50px;
    li {
      color: red;
      padding: 0;
    }
  }
}
```

#### 嵌套时调用父选择器
嵌套时调用父选择器使用 `&`，在使用伪类选择器等时较常用：

```sass
a {
    font-style: 16px;
    &:hover {
        color: blue;
         }
     }
```

#### 嵌套属性
属性也可以嵌套，使用时内部只需要写属性的后半部分：

```sass
body div {
  font: {
    family: Arial, Helvetica;
    size: 16px;
    weight: 700;
  }
  border: {
    radius: 12px;
    color: black;
    width: 12px;
  }
}
```

> 注： 属性的前半部分后面必须加冒号 `:`。

### 混合 Mixins
Mixins 是一段可以重用的代码块。

先使用 `@mixin` 定义一个代码块：

```sass
@mixin warning {
  color: red;
  background-color: #fff;
  a {
    color: yellow;
  }
}
```

然后可以使用 `@include` 调用定义的 mixin 代码：

```sass
.warning-box {
  @include warning;
  width: 100px;
}
```
#### 使用参数
```sass
@mixin warning($text-color, $bgc-color: red) {
  color: $text-color;
  background-color:  $bgc-color;
  a {
    color: yellow;
  }
}

.warning-box {
  @include warning(yellow, white);
  width: 100px;
}
```

> 支持像 ES6 函数的默认参数一样传属性的默认值 。

### 继承/扩展 Inheritance
`@extend` 可继承样式：

```sass
.father {
  color: yellow;
  font-size: 16px;
}

.father a {
  font-weight: bold;
}

.son {
  @extend .father;
  font-family: Arial, Helvetica, sans-serif;
}
```

编译后的 CSS：

```css
.father, .son {
  color: yellow;
  font-size: 16px;
}

.father a, .son a {
  font-weight: bold;
}

.son {
  font-family: Arial, Helvetica, sans-serif;
}
```
### 导入
Sass 优化了 CSS 的 @import，提高了效率。

新建一个 Partails 文件 `_base.scss`，写入样式：

```sass
body {
  margin: 0;
  padding: 0;
}
```

再其它 .scss 文件中直接导入即可使用：

```sass
@import "./base";
```

> 注：Partails 文件尽量使用下划线开头，引入时不需要加。

### 注释
Sass 中有三种注释：

**1. 单行注释**

```sass
// 单行注释
```

单行注释不会出现在编译后的 CSS 文件中。

**2. 多行注释**

```sass
/* 
 * 多行注释
 * 天王盖地虎 
 */
```

编译后多行注释只会在没有压缩的 CSS 文件中。

**3. 强制注释**

```sass
/*! 强制输出注释 */ 
```

强制注释在压缩后的 CSS 文件中也出存在。

### 数据类型
Sass 中也有自己的数据类型系统，可在命令行输入 `$ sass -i` 进入交互模式，然后使用 `type-of()` 函数判断数据类型。

#### number
数字可以进行数学运算。

数字函数：

- abs()：得到绝对值
- round()：四舍五入
- ceil()：向上取整
- floor()： 向下取整
- min()：返回最小值，`min(1, 2, 3)` 返回 1
- max()：返回最大值

#### string
字符串可以使用 `+` 拼接。

字符串函数：

- to-upper-case()：转为大写字母
- to-lower-case()：转为小写
- str-length()：获取字符串长度
- str-index()：获取字符串位置，如 `str-index("hello zander", "hello")`返回1，**Sass 中索引值从1开始**
#### color
颜色包括类如 `red`、`rgb(255, 0, 0)`、`#fff`、`hsl(0, 100%, 23%)`。

颜色函数：

- rgb()：生成RGB颜色。
- hsla()：HSL颜色加透明度
- adjust-hue()：调整色相度数，如 `adjust-hue(hsl(1, 100, 50%), 137deg)`
- lighten()：调整颜色明度至更亮，如 `lighten(yellow, 30%)`
- darken()：调整颜色明度至更暗
- saturate()：调整颜色纯度（饱和度）至更高，如 `saturate(#f7dd23, 30%)`
- desaturate()：调整颜色纯度至更高
- transparentize()：调整颜色至更透明,，如 `transparentize(#f7dd23, .4)`
- opacify()：调整颜色至更不透明
#### list
list 指列表类型的值，元素之间使用逗号或空格分隔开，如 border 的值 `1px solid #000`。列表之间通过逗号或括号分隔开，如 padding 的值 `(23px 6px) (3px 8px)`。

列表函数：

- nth()：获取列表中对应下标的值，需注意**下标从1开始**，如 `nth(5px 10px, 1)` 得到 5px。
- index()：获取列表中元素的下标，如 `index(1px solid pink, solid)` 返回2，不存在的元素返回 null。
- append()：给列表追加元素，第三个参数为可选参数，表示返回列表的分隔符，`comma` 为逗号，`space` 为空格。
- join()：合并列表，如 `join(1px 5px, 10px 6px)`。

#### map
map 类型为健值对的数据，如：

```sass
$map: (key1: value1, key2: value2);
```

map的函数：

- length()：返回map健值对的个数
- map-get()：根据key获取value，如：

    ```sass
    $color: (dark: #000, light: #fff);

    body {
        background-color: map-get($color, dark);
    }
    ```

- map-keys()：返回一个map所有的key列表。
- map-values()：返回一个map所有的value列表。
- map-has-key()：判断一个map中是否包含这个key，返回true或false，如 `map-has-key($color, dark)`。
- map-merge()：合并两个map
- map-remove()：删除map中的元素，如 `map-remove($color, dark, light)`

#### Boolean
- Sass 中的且：`and`
- 或：`or`
- 非：`not()`

#### Interpolation
Interpolation 用于在注释或属性中使用表达式，使用方式为 `#{}`。如：

```sass
$version: 0.0.1;
$name: "line";
$attr: "border";

/* 本系统版本为 #{$version} */

.hello-#{$name} {
  #{$attr}-color: yellow;
}
```

结果为：

```css
@charset "UTF-8";
/* 本系统版本为 0 0.1 */
.hello-line {
  border-color: yellow;
}

/*# sourceMappingURL=01.css.map */
```

### 控制指令
#### @if
```sass
$isOld: true;

div {
  @if $isOld {
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
  }
  border-radius: 5px;
}
```

> 还有常见的例子是更换网站日间/夜间模式，使用 `@if{}@else if{}@else{}`。

#### @for
`@for $var from start to end` 表示循环从 start 到 end 立即结束，不包含 end：

```sass
$columns: 4;

@for $i from 1 to $columns {
  .col-#{$i} {
    width: 100% / $columns * $i;
  }
}
```

编译结果：

```css
.col-1 {
  width: 25%;
}

.col-2 {
  width: 50%;
}

.col-3 {
  width: 75%;
}
```

`@for $var from start through end` 表示循环从 start 到 end 结束，包含 end：

```sass
$columns: 4;

@for $i from 1 through $columns {
  .col-#{$i} {
    width: 100% / $columns * $i;
  }
}
```

编译结果：

```css
.col-1 {
  width: 25%;
}

.col-2 {
  width: 50%;
}

.col-3 {
  width: 75%;
}

.col-4 {
  width: 100%;
}
```

#### @each
用法：

```
@each $var in $list {
	...
}
```


例子：

```sass
$list: success error warning;

@each $icon in $list {
  .icon-#{$icon} {
    background-color: url(./icons/#{$icon}.png);
  }
}
```

编译结果：

```css
.icon-success {
  background-color: url(./icons/success.png);
}

.icon-error {
  background-color: url(./icons/error.png);
}

.icon-warning {
  background-color: url(./icons/warning.png);
}
```

#### @while
用法：

```
@while 条件 {
	...
}
```

例：

```sass
$i: 6;

@while $i > 0 {
  .item-#{$i} {
    width: 5px * $i;
  }
  $i: $i - 2;
}
```

编译结果；

```css
.item-6 {
  width: 30px;
}

.item-4 {
  width: 20px;
}

.item-2 {
  width: 10px;
}
```

#### 自定义函数
用法：

```
@function 名称(参数1, 参数2) {
	...
}
```

例：

```sass
$color: (light: #fff, dark: #000);

@function color($key){
  @return map-get($color, $key);
}

.div {
  background-color: color(dark);
}
```

编译结果：

```css
.div {
  background-color: #000;
}
```
### 警告与错误
- 警告：`@warn`
- 错误：`@error`

例：

```
$color: (light: #fff, dark: #000);

@function color($key){
  @if not map-has-key($color, $key) {
    @warn "在 $color 中没有找到 #{$key}";
  }
  @return map-get($color, $key);
}

.div {
  background-color: color(hello);
}
```

> 警告的信息会显示在sass命令行中
> 
> 错误的信息会直接以注释的形式显示在编译后的结果中