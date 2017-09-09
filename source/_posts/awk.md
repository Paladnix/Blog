---
title: awk - Linux文本处理大杀器
date: 2017-09-07 17:44:07
tags: [Linux]
---

awk 已经不是一种命令了，而是一种语言。用于在linux/unix下对文本和数据进行处理。数据可以来自标准输入(stdin)、一个或多个文件，或其它命令的输出。

在最开始，我的文本处理方式就是写一个c语言去读文件然后在处理完输出来。刚开始学程序的时候觉得自己很厉害的样子。这样做过几次以后就发现并没有这么好用，因为每次都要写一个很麻烦。

在后来就是学习用脚本来处理。

关于Linux命令，推荐一个小[站点](http://man.linuxde.net/)，写的东西都还非常细致。

## 命令形式

```
awk [options] 'script' var=value file(s)
awk [options] -f scriptfile var=value file(s)
```
**命令选项**

- `-F fs`   fs指定输入分隔符，fs可以是字符串或正则表达式，如-F:
- `-v var=value`   赋值一个用户定义变量，将外部变量传递给awk脚本
- `-f scripfile`  从脚本文件中读取awk命令

## 脚本模式和操作

awk的脚本主要由模式和操作组成：

### 模式

- /正则表达式/：使用通配符的扩展集。
- 关系表达式：使用运算符进行操作，可以是字符串或数字的比较测试。
- 模式匹配表达式：用运算符~（匹配）和~!（不匹配）。
- BEGIN语句块、pattern语句块、END语句块

### 操作

操作由一个或多个命令、函数、表达式组成，之间由换行符或分号隔开，并位于大括号内，主要部分是：

- 变量或数组赋值
- 输出命令
- 内置函数
- 控制流语句

## awk脚本的基本结构

```
awk 'BEGIN{ print "start" } pattern{ commands } END{ print "end" }' file
```
一个awk脚本通常由：BEGIN语句块、能够使用模式匹配的通用语句块、END语句块3部分组成，这三个部分是可选的。任意一个部分都可以不出现在脚本中，脚本通常是被单引号或双引号中，例如：

```
awk 'BEGIN{ i=0 } { i++ } END{ print i }' filename
awk "BEGIN{ i=0 } { i++ } END{ print i }" filename
```

## 工作原理

- 第一步：执行BEGIN{ commands }语句块中的语句；
- 第二步：从文件或标准输入(stdin)读取一行，然后执行pattern{ commands }语句块，它逐行扫描文件，从第一行到最后一行重复这个过程，直到文件全部被读取完毕
- 第三步：当读至输入流末尾时，执行END{ commands }语句块。

**BEGIN语句块** 在awk开始从输入流中读取行之前被执行，这是一个可选的语句块，比如变量初始化、打印输出表格的表头等语句通常可以写在BEGIN语句块中。
**END语句块** 在awk从输入流中读取完所有的行之后即被执行，比如打印所有行的分析结果这类信息汇总都是在END语句块中完成，它也是一个可选语句块。
**pattern语句块** 中的通用命令是最重要的部分，它也是可选的。如果没有提供pattern语句块，则默认执行{ print }，即打印每一个读取到的行，awk读取的每一行都会执行该语句块。

## print

当使用不带参数的print时，它就打印当前行，当print的参数是以逗号进行分隔时，打印时则以空格作为定界符。在awk的print语句块中双引号是被当作拼接符使用，例如：

```
echo | awk '{ var1="v1"; var2="v2"; var3="v3"; print var1,var2,var3; }' 

# out:
v1 v2 v3
```
双引号：
```
echo | awk '{ var1="v1"; var2="v2"; var3="v3"; print var1"="var2"="var3; }'

# out:
v1=v2=v3
```

## awk 内置变量

**说明：** `[A][N][P][G]`表示第一个支持变量的工具，[A]=awk、[N]=nawk、[P]=POSIXawk、[G]=gawk

```
    $n          当前记录的第n个字段，比如n为1表示第一个字段，n为2表示第二个字段。 
    $0          这个变量包含执行过程中当前行的文本内容。
[N] ARGC        命令行参数的数目。
[G] ARGIND      命令行中当前文件的位置（从0开始算）。
[N] ARGV        包含命令行参数的数组。
[G] CONVFMT     数字转换格式（默认值为%.6g）。
[P] ENVIRON     环境变量关联数组。
[N] ERRNO       最后一个系统错误的描述。
[G] FIELDWIDTHS 字段宽度列表（用空格键分隔）。
[A] FILENAME    当前输入文件的名。
[P] FNR         同NR，但相对于当前文件。
[A] FS          字段分隔符（默认是任何空格）。
[G] IGNORECASE  如果为真，则进行忽略大小写的匹配。
[A] NF          表示字段数，在执行过程中对应于当前的字段数。
[A] NR          表示记录数，在执行过程中对应于当前的行号。
[A] OFMT        数字的输出格式（默认值是%.6g）。
[A] OFS         输出字段分隔符（默认值是一个空格）。
[A] ORS         输出记录分隔符（默认值是一个换行符）。
[A] RS          记录分隔符（默认是一个换行符）。
[N] RSTART      由match函数所匹配的字符串的第一个位置。
[N] RLENGTH     由match函数所匹配的字符串的长度。
[N] SUBSEP      数组下标分隔符（默认值是34）。
```
**示例**
```
echo -e "line1 f2 f3\nline2 f4 f5\nline3 f6 f7" | awk '{print "Line No:"NR", No of fields:"NF, "$0="$0, "$1="$1, "$2="$2, "$3="$3}' 

# out:
Line No:1, No of fields:3 $0=line1 f2 f3 $1=line1 $2=f2 $3=f3
Line No:2, No of fields:3 $0=line2 f4 f5 $1=line2 $2=f4 $3=f5
Line No:3, No of fields:3 $0=line3 f6 f7 $1=line3 $2=f6 $3=f7
```
使用print $NF可以打印出一行中的最后一个字段，使用$(NF-1)则是打印倒数第二个字段，其他以此类推：

统计文件中的行数：
```
awk 'END{ print NR }' filename
```
以上命令只使用了END语句块，在读入每一行的时，awk会将NR更新为对应的行号，当到达最后一行NR的值就是最后一行的行号，所以END语句块中的NR就是文件的行数。

一个每一行中第一个字段值累加的例子：
```
seq 5 | awk 'BEGIN{ sum=0; print "总和：" } { print $1"+"; sum+=$1 } END{ print "等于"; print sum }'

```

## 将外部变量值传递给awk
 
借助-v选项，可以将外部值（并非来自stdin）传递给awk：(在bash脚本中这样写)
```
VAR=10000
echo | awk -v VARIABLE=$VAR '{ print VARIABLE }'
```

another
```
var1="aaa"
var2="bbb"
echo | awk '{ print v1,v2 }' v1=$var1 v2=$var2
```
or
```
awk '{ print v1,v2 }' v1=$var1 v2=$var2 filename
```
以上方法中，变量之间用空格分隔作为awk的命令行参数跟随在BEGIN、{}和END语句块之后。

## 运算

作为一种程序设计语言所应具有的特点之一，awk支持多种运算，这些运算与C语言提供的基本相同。awk还提供了一系列内置的运算函数（如log、sqr、cos、sin等）和一些用于对字符串进行操作（运算）的函数（如length、substr等等）。这些函数的引用大大的提高了awk的运算功能。作为对条件转移指令的一部分，关系判断是每种程序设计语言都具备的功能，awk也不例外，awk中允许进行多种测试，作为样式匹配，还提供了模式匹配表达式~（匹配）和~!（不匹配）。作为对测试的一种扩充，awk也支持用逻辑运算符。

![pic](/img/awk-1.png)

    ```
    awk 'BEGIN{a="b";print a++,++a;}' 
    0 2
    ```

![pic](/img/awk-2.png)
    ```
    a+=5; 等价于：a=a+5; 其它同类
    ```

![pic](/img/awk-3.png)
    ```
    awk 'BEGIN{a=1;b=2;print (a>5 && b<=2),(a>5 || b<=2);}'
    0 1
    ```
![pic](/img/awk-4.png)
    ```
    awk 'BEGIN{a="100testa";if(a ~ /^100*/){print "ok";}}'
    ok
    ```
![pic](/img/awk-5.png)
    ```
    awk 'BEGIN{a=11;if(a >= 9){print "ok";}}'
    ok
    ```
![pic](/img/awk-6.png)
    ```
awk 'BEGIN{a="b";print a=="b"?"ok":"err";}'
ok

awk 'BEGIN{a="b";arr[0]="b";arr[1]="c";print (a in arr);}'
0

awk 'BEGIN{a="b";arr[0]="b";arr["b"]="c";print (a in arr);}'
1
    ```
![pic](/img/awk-7.png)

## 高级输入输出

awk中next语句使用：在循环逐行匹配，如果遇到next，就会跳过当前行，直接忽略下面语句。而进行下一行匹配。net语句一般用于多行合并：
```
cat text.txt
a
b
c
d
e

awk 'NR%2==1{next}{print NR,$0;}' text.txt
2 b
4 d

```
分析发现需要将包含有“web”行进行跳过，然后需要将内容与下面行合并为一行：
```
cat text.txt
web01[192.168.2.100]
httpd            ok
tomcat               ok
sendmail               ok
web02[192.168.2.101]
httpd            ok
postfix               ok
web03[192.168.2.102]
mysqld            ok
httpd               ok
0
awk '/^web/{T=$0;next;}{print T":t"$0;}' test.txt
web01[192.168.2.100]:   httpd            ok
web01[192.168.2.100]:   tomcat               ok
web01[192.168.2.100]:   sendmail               ok
web02[192.168.2.101]:   httpd            ok
web02[192.168.2.101]:   postfix               ok
web03[192.168.2.102]:   mysqld            ok
web03[192.168.2.102]:   httpd               ok
```

## getline

执行linux的date命令，并通过管道输出给getline，然后再把输出赋值给自定义变量out，并打印它：
```
awk 'BEGIN{ "date" | getline out; print out }' 

```
执行shell的date命令，并通过管道输出给getline，然后getline从管道中读取并将输入赋值给out，split函数把变量out转化成数组mon，然后打印数组mon的第二个元素：
```
awk 'BEGIN{ "date" | getline out; split(out,mon); print mon[2] }'
```
命令ls的输出传递给geline作为输入，循环使getline从ls的输出中读取一行，并把它打印到屏幕。
```
awk 'BEGIN{ while( "ls" | getline) print }'

```

## file

**输出到一个文件**：
```
echo | awk '{printf("hello word!n") > "datafile"}'
或
echo | awk '{printf("hello word!n") >> "datafile"}'

```
**关闭文件**：
```
close("filename")
```

## 设置字段定界符
默认的字段定界符是空格，可以使用-F "定界符" 明确指定一个定界符：
```
awk -F: '{ print $NF }' /etc/passwd
或
awk 'BEGIN{ FS=":" } { print $NF }' /etc/passwd
```

## 控制语句

在linux awk的while、do-while和for语句中允许使用break,continue语句来控制流程走向，也允许使用exit这样的语句来退出。break中断当前正在执行的循环并跳到循环外执行下一条语句。if 是流程选择用法。awk中，流程控制语句，语法结构，与c语言类型。有了这些语句，其实很多shell程序都可以交给awk，而且性能是非常快的。下面是各个语句用法。

### 条件判断语句
```
awk 'BEGIN{ 
    test=100; 
    if(test>90){ 
        print "very good"; 
    } else if(test>60){ 
        print "good"; 
    } else{ 
        print "no pass"; 
    } 
}' 

very good 
```

### for循环
Type 1.
```

awk 'BEGIN{
for(k in ENVIRON){
  print k"="ENVIRON[k];
}

}'

TERM=linux
G_BROKEN_FILENAMES=1
SHLVL=1
pwd=/root/text
...
logname=root
HOME=/root
SSH_CLIENT=192.168.1.21 53087 22
```

Type 2.
```
awk 'BEGIN{
total=0;
for(i=0;i<=100;i++){
  total+=i;
}
print total;
}'
5050
```

### While

```
awk 'BEGIN{
test=100;
total=0;
while(i<=test){
  total+=i;
  i++;
}
print total;
}'
5050
```
### do while
```
awk 'BEGIN{ 
total=0;
i=0;
do {total+=i;i++;} while(i<=100)
  print total;
}'
5050
```

### 其他

- **break** 当 break 语句用于 while 或 for 语句时，导致退出程序循环。
- **continue** 当 continue 语句用于 while 或 for 语句时，使程序循环移动到下一个迭代。
- **next** 能能够导致读入下一个输入行，并返回到脚本的顶部。这可以避免对当前输入行执行其他的操作过程。
- **exit** 语句使主输入循环退出并将控制转移到END,如果END存在的话。如果没有定义END规则，或在END中应用exit语句，则终止脚本的执行。

## 数组

数组是awk的灵魂，处理文本中最不能少的就是它的数组处理。因为数组索引（下标）可以是数字和字符串在awk中数组叫做关联数组(associative arrays)。awk 中的数组不必提前声明，也不必声明大小。数组元素用0或空字符串来初始化，这根据上下文而定。

### 定义
两种方式，数字索引和字符串索引

```
Array[1]="sun"
Array[2]="kai"


Array["first"]="www"
Array["last"]="name"
Array["birth"]="1987"
```
使用中print Array[1]会打印出sun；使用print Array[2]会打印出kai；使用print["birth"]会得到1987。

### 遍历数组

```bash
{ for(item in array) {print array[item]}; }       #输出的顺序是随机的
{ for(i=1;i<=len;i++) {print array[i]}; }         #Len是数组的长度
```

### 相关操作

#### length
length返回字符串以及数组长度，split进行分割字符串为数组，也会返回分割得到数组长度。


```
awk 'BEGIN{info="it is a test";lens=split(info,tA," ");print length(tA),lens;}'
4 4
```

#### asort
asort对数组进行排序，返回数组长度。
```
awk 'BEGIN{info="it is a test";split(info,tA," ");for(k in tA){print k,tA[k];}}'
4 test
1 it
2 is
3 a
```
for…in输出，因为数组是关联数组，默认是无序的。所以通过for…in得到是无序的数组。如果需要得到有序数组，需要通过下标获得。

```
awk 'BEGIN{info="it is a test";tlen=split(info,tA," ");for(k=1;k<=tlen;k++){print k,tA[k];}}'
1 it
2 is
3 a
4 test
```

#### 判断键值存在以及删除键值：
```bash
awk 'BEGIN{tB["a"]="a1";tB["b"]="b1";if( "c" in tB){print "ok";};for(k in tB){print k,tB[k];}}'  
a a1
b b1

#删除键值：
[chengmo@localhost ~]$ awk 'BEGIN{tB["a"]="a1";tB["b"]="b1";delete tB["a"];for(k in tB){print k,tB[k];}}'                     
b b1
```

#### 二维、多维数组使用
awk的多维数组在本质上是一维数组，更确切一点，awk在存储上并不支持多维数组。awk提供了逻辑上模拟二维数组的访问方式。例如，array[2,4]=1这样的访问是允许的。awk使用一个特殊的字符串SUBSEP(34)作为分割字段，在上面的例子中，关联数组array存储的键值实际上是2344。

类似一维数组的成员测试，多维数组可以使用if ( (i,j) in array)这样的语法，但是下标必须放置在圆括号中。类似一维数组的循环访问，多维数组使用for ( item in array )这样的语法遍历数组。与一维数组不同的是，多维数组必须使用split()函数来访问单独的下标分量。
```
awk 'BEGIN{
for(i=1;i<=9;i++){
  for(j=1;j<=9;j++){
    tarr[i,j]=i*j; print i,"*",j,"=",tarr[i,j];
  }
}
}'
1 * 1 = 1
1 * 2 = 2
1 * 3 = 3
1 * 4 = 4
1 * 5 = 5
1 * 6 = 6 
...
9 * 6 = 54
9 * 7 = 63
9 * 8 = 72
9 * 9 = 81
```

Another

```
awk 'BEGIN{
for(i=1;i<=9;i++){
  for(j=1;j<=9;j++){
    tarr[i,j]=i*j;
  }
}
for(m in tarr){
  split(m,tarr2,SUBSEP); print tarr2[1],"*",tarr2[2],"=",tarr[m];
}
}'
```
## 内置函数

awk内置函数，主要分以下3种类似：算数函数、字符串函数、其它一般函数、时间函数。

![pic](/img/awk-8.png)
```
awk 'BEGIN{OFMT="%.3f";fs=sin(1);fe=exp(10);fl=log(10);fi=int(3.1415);print fs,fe,fl,fi;}' 

0.841 22026.466 2.303 3
```
OFMT 设置输出数据格式是保留3位小数。

**Random**

```
awk 'BEGIN{srand();fr=int(100*rand());print fr;}'
78
awk 'BEGIN{srand();fr=int(100*rand());print fr;}'
31
awk 'BEGIN{srand();fr=int(100*rand());print fr;}'
41
```

![pic](/img/awk-9.png)

### gsub,sub使用
   
```
awk 'BEGIN{info="this is a test2010test!";gsub(/[0-9]+/,"!",info);print info}'

this is a test!test!
```
在 info中查找满足正则表达式，/[0-9]+/ 用””替换，并且替换后的值，赋值给info 未给info值，默认是$0

### 查找字符串（index使用）
```
awk 'BEGIN{info="this is a test2010test!";print index(info,"test")?"ok":"no found";}'
ok
```
未找到，返回0

### 正则表达式匹配查找(match使用）

```
awk 'BEGIN{info="this is a test2010test!";print match(info,/[0-9]+/)?"ok":"no found";}'
ok
```

### 截取字符串(substr使用）
               
```
awk 'BEGIN{info="this is a test2010test!";print substr(info,4,10);}'
s is a tes
```

### 格式化字符串输出（sprintf使用）
其中格式化字符串包括两部分内容：一部分是正常字符，这些字符将按原样输出; 另一部分是格式化规定字符，以"%"开始，后跟一个或几个规定字符,用来确定输出内容格式。

![pic](/img/awk-10.png)
```
awk 'BEGIN{n1=124.113;n2=-1.224;n3=1.2345; printf("%.2f,%.2u,%.2g,%X,%on",n1,n2,n3,n1,n1);}' 124.11,18446744073709551615,1.2,7C,174
```

![pic](/img/awk-11.png)

### 调用外部命令的方式
```
awk 'BEGIN{b=system("ls -al");print b;}' total 42092 drwxr-xr-x 14 chengmo chengmo 4096 09-30 17:47 . drwxr-xr-x 95 root root 4096 10-08 14:01 ..

```


![pic](/img/awk-12.png)

### 指定时间(mktime使用）

             ```
awk 'BEGIN{tstamp=mktime("2001 01 01 12 12 12");print strftime("%c",tstamp);}'
2001年01月01日 星期一 12时12分12秒
             ```
             ```
awk 'BEGIN{tstamp1=mktime("2001 01 01 12 12 12");tstamp2=mktime("2001 02 01 0 0 0");print tstamp2-tstamp1;}'
2634468

awk 'BEGIN{tstamp1=mktime("2001 01 01 12 12 12");tstamp2=systime();print tstamp2-tstamp1;}' 
308201392
             ```
![pic](/img/awk-13.png)
