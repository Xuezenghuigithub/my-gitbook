# rem 自适应布局
为什么要使用 rem 布局：

1. 页面布局文字能否随着屏幕大小变化而变化？
2. 六十布局和 flex 布局主要针对于宽度布局，那高度如何设置？
3. 怎么样让屏幕发生变化的时候元素高度和宽度等比例缩放？

## rem 基础
### 概念
rem （root em）是一个**相对单位**，类似于 em，em 相对于父元素的字体大小。

不同的是 rem 的基准是相对于 html 元素的字体大小。

### em 与 rem
**em:**

```html
<!DOCTYPE html>
<html lang="zh-CN">

<head>
  <meta charset="UTF-8">
  <title>Zander</title>
  <style>
    div {
      font-size: 12px;
    }

    p {
      /* 宽和高都是 12px *10 = 120px */
      width: 10em;
      height: 10em;
      background-color: pink;
    }
  </style>
</head>

<body>
  <div>
    <p></p>
  </div>
</body>

</html>
```

**rem:**

```css
html {
  font-size: 14px;
}

p {
  /* 宽和高都是 14px *10 = 140px */
  width: 10rem;
  height: 10rem;
  background-color: pink;
}
```
### rem 的优点
rem 相对于根元素 html 的文字大小来控制， 便于控制页面中所有使用 rem 单位的元素。——**整体控制**

## 媒体查询
### 概念
媒体查询 Midea Query 是 CSS3 新语法，有以下特性：

- 使用 @media 查询，可以针对不同的媒体类型定义不同的样式
- @media 可以针对不同的屏幕尺寸设置不用的样式
- 当重置浏览器大小的过程中，页面也会根据浏览器的宽度和高度重新渲染页面
- 目前针对很多苹果手机、安卓手机、平板等设备都用得到媒体查询

### 语法规范
```css
@media mediatype and|not|only (media feature) {
	css-code;
}
```

- 用 `@media` 开头
- mediatype 指媒体类型，如手机屏幕
- 关键字 and、not、only
- media feature 媒体特性，必须有小括号

**1. mediatype 媒体类型**

将不同的终端设备划分成不同的类型，称为媒体类型。

|值|说明|
|:-:|:-:|
|all|用于所有设备|
|print|用于打印机和打印预览|
|scree|用于电脑设备、平板电脑、智能手机等|

**2. 关键字**

关键字将媒体类型或多个媒体特性连接到一起作为**媒体查询的条件**。

- and：将多个媒体特性连接到一起，相当于“且”
- not：排除某个媒体类型，相当于“非”
- only：指定某个特性的媒体类型

**3. 媒体特性**

每种媒体类型都具有各自不同的特性，根据不同媒体类型的媒体特性设置不同的展示风格。

|值|说明|
|:-:|:-:|
|width|定义输出设备中页面可见区域的宽度|
|min-width|定义输出设备中最小可见区域宽度|
|max-width|定义输出设备中最大可见区域宽度|

```css
/* 在屏幕上并且最大的宽度是800px时（小于等于800px时）设置的样式 */
@media screen and (max-width: 800px) {
  body {
    background-color: pink;
  }

@media screen and (max-width: 500px) {
  body {
    background-color: yellow;
  }
}
```

### 案例——根据屏幕宽度修改背景颜色
```css
    /* 1. 媒体查询一般按照从大到小或者从小到大的顺序来设置 */
    /* 2. 小于 540 px 时背景颜色为蓝色 */
    @media screen and (max-width: 539px) {
      body {
        background-color: blue;
      }
    }

    /* 3. 540px～970px时背景颜色为绿色 */
    @media screen and (min-width: 540px) and (max-width: 969px) {
      body {
        background-color: green;
      }
    }
    /* 4. 大于等于970px背景颜色为红色 */
    @media screen and (min-width: 970px){
      body {
        background-color: red;
      }
    }
```

因为 CSS 的层叠性原则，3可省略为：

```css
    @media screen and (min-width: 540px)  {
      body {
        background-color: green;
      }
    }
```

> 媒体查询从小到大写，代码更简洁。


### 案例——媒体查询 + rem 实现元素动态大小变化
```html
<!DOCTYPE html>
<html lang="zh-CN">

<head>
  <meta charset="UTF-8">
  <title>Zander</title>
  <style>
    * {
      margin: 0;
      padding: 0;
    }
    @media screen and (min-width: 320px){
      html {
        font-size: 50px;
      }
    }
    @media screen and (min-width: 640px){
      html {
        font-size: 100px;
      }
    }
    .top {
      height: 1rem;
      font-size: .5rem;
      background-color: yellow;
      color: white;
      text-align: center;
      line-height: 1rem;
    }
  </style>
</head>

<body>
  <div class="top">购物车</div>
</body>

</html>
```

### 引入资源
当样式比较繁多的时候，可针对不同的媒体使用不同的 stylesheets。

原理就是直接在 link 中判断设备的尺寸，然后引用不同的css 文件。

**语法规范**

```html
<link rel="stylesheets" media="mediatyoe and|not|only (meda feature)" href="mystylesgeets.css">
```

## Less 基础
### CSS 的弊端
CSS 是一门非程序式语言，没有变量、函数、Scope 等概念。

- css 需要书写大量看似没有逻辑的代码，冗余度较高
- 不方便维护及扩展，不利于复用
- 没有良好的计算能力

### Less 介绍
Leaner Style Sheets 是一门 CSS 扩展语言，也是 CSS 的预处理器。它没有减少 CSS 的功能，而是在现有的 CSS 语法上，为 CSS 加入程序式语言的特性。

如引入了变量、Minxin、运算以及函数等功能，大大简化了 CSS 的编写，并且降低了 CSS 的维护成本，Less 可以让我们用更少的代码做更多的事情。

Less 中文网址：[http://lesscss.cn/](http://lesscss.cn/)

### 安装 Less
```s
$ npm install -g less
```

### Less 变量
变量是指没有固定的值，可以改变的。用于 CSS 中一些常用的颜色和数值定义。

```
@变量名: 指;
```

#### 变量命名规范
- 必须有@为前缀
- 不能包含特殊符号
- 不能以数字开头
- 大小写敏感

#### less 编译
less 文件需要编译生成为 css 文件，这样 html 页面才能使用。

Vscode Less 插件——Easy Less 插件用来把 less 文件编译为 css 文件。安装完后编写完 less 文件保存文件就会自动转换为 css 文件。

#### less 嵌套
与 Sass 一致

```
.nav {
	.logo {
		...
	}
}
```

- 内层选择器前没有 & 符号，则它被解析为父选择器后代
- 如果有 & 符号，被解析为父元素自身或父元素的伪类

```
a {
	&:hover {
		color: yellow;
	}
}
```

#### less 运算
less 中任何的数字、颜色或者变量都可以参与算术运算。

```
@border: 5px + 5;

div {
  border: @border solid red;
}
```

- 运算符中间左右有空格隔开
- 对于两个不同单位的值之间的运算，运算结果的值取第一个值的单位
- 如果两个值之间只有一个值有单位，则运算结果取该单位

### rem 适配方案
1. 适配的目标是什么？
2. 怎么去达成这个目标？
3. 在实际开发中如何使用？

**1. 方案一**

- less
- 媒体查询
- rem

**2. 方案二**

- flexible.js
- rem

### 适配方案一
设计稿常见尺寸宽度：

|设备|常见宽度|
|:-:|:-:|
|iphone 5|640px|
|iphone 678|750px|
|Android|常见320px、375px、384px、400px、414px、500px、720px|

> 基本以750px 为准。

```
@media screen and (min-width: 320px) {
  html {
    font-size: 21.33px;
  }
}

@media screen and (min-width: 750px) {
  html {
    font-size: 50px;
  }
}
```

动态设置html 标签 font-size  大小：

1. 假设设计稿为750px
2. 把整个屏幕分为 15等份（划分标准不一，也可为10份/20份）
3. 每一份作为html字体大小，这里为50px
4. 那么在320px设备时，字体大小为320px/15=21.33px

元素大小取值方法：

1. 页面元素的 rem 值 = 页面元素值（px）/ （屏幕宽度 / 划分的份数）
2. 屏幕宽度/划分的份数就是 html fon-size 的大小
3. 页面元素rem值 = 页面元素值（px）/ html font-size 字体大小


### 适配方案二
flexible.js：

手机淘宝团队发布的简洁高效移动端适配库。不需要写繁琐的媒体查询，js 里做了相应处理，原理是把当前设备分为10等份，但不同设备下，比例相同。

只需要确定当前设备的 html 文字大小即可，比如当前设计稿为 750px，那么只需要把 html 文字大小设置为 75px（710px /10），页面中元素的 rem 值：页面元素的 px 值 / 75。

下载地址：[https://github.com/amfe/lib-flexible](https://github.com/amfe/lib-flexible)




