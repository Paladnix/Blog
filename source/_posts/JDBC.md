---
title: JDBC
date: 2017-07-09 15:25:31
tags: [Java, SQL]
---

JDBC(Java DataBase Connectivity) 这是JDK中集成的一个数据库API，可以访问任何类型表列数据，特别是存储在关系数据库中的数据。
本文以mysql为例。

所谓数据库交互，无非就是那么几个部分：建立连接，执行SQL，取回数据。JDBC的设计思路被Php借鉴过去后就产生了PDO，跟JDBC一曲同工，加之轻量级，然后就感觉很好的样子...
与数据库交互体现在程序上，也无非就是那么几个部分：引入包，实例化对象，调用函数。

那么学习JDBC学他的什么？学会了怎么用然后呢？可以学习其设计思路，有的时候，从设计思路来学习怎么用会比直接学怎么用要容易，Let me show you.

# 架构
现在把自己当成设计者，从设计的角度出发来看JDBC。
你要做的事情是将市面上诸多数据库整合到一起，给Java程序提供一个格式统一的工具。用更学术的语言来表达就是将底层差异屏蔽掉，抽象出一个数据库抽象层，使得数据库对于Java程序透明（学术其实也是将事物统一整理成一个较高的层次，忽略底层实现差异，用思想指导实践。例如当你碰到一个新的问题，整体十分复杂，你不可能直接就想到一个实践方法将其实现，这个时候就需要知识来抽象这个问题，当问题抽象到了某个知识领域内，这个问题就可以再从抽象顺着这个知识往下拆解，最后落实到具体实践跟抽象知识已经没什么关系了）。

要实现统一接口，我们借鉴操作系统与硬件之间的做法，就是每个数据库按照我给的一个标准来写你自己的驱动程序，这个标准就是初步将数据库之间的差异屏蔽，例如我规定所有的`select`语句由什么函数执行，返回什么格式的数据等。这就是底层的Driver。

再往上，我们需要一个统一的入口。在Java中，不同数据库实现的Driver肯定是不同的类，这样的话难道我们要用什么数据库就用什么类吗？当然能透明就透明，最好是我在参数中体现我要用什么数据库，灵活性更大。所以这个时候我们在几个类上面在做一个抽象，抽出来一个Manager，这个Manage负责数据库的选择，动态实例化，连接等等乱七八糟的事情，然后这个manage在整理封装成JDBC API提供给Java程序使用。

Over.

但是你知道了怎么设计，还是没有卵用，哈哈哈呵呵！上面已经说过了，当你具体实践的时候已经跟上层知识没有什么关系了，但是你会很快理解具体该怎么做。
# 实例
jdbc简单的使用差不多在下面的代码中都有体现，另外我对于这个资源关闭的问题还有点迷惑，因为在jdbc的代码中实现了一个Autocloseable的接口，对于当前版本的JDBC要不要显示关闭资源的问题，有可能是不需要的。有待深入了解这个AutoCloseAble接口。

```java
//STEP 1. Import required packages
import java.sql.*;

public class FirstExample {
   // JDBC driver name and database URL
   static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";  
   static final String DB_URL = "jdbc:mysql://localhost/emp";
   // URL 格式(mysql)： jdbc:mysql://host:port/databaseName

   //  Database credentials
   static final String USER = "root";
   static final String PASS = "123456";

   public static void main(String[] args) {
   Connection conn = null;
   PreparedStatement stmt = null;
   try{
      //STEP 2: Register JDBC driver
      // JDBC要求要显式注册你要用的驱动类
      // 这个代码就是让JVM加载对应的类，并执行其中的静态代码。
      Class.forName("com.mysql.jdbc.Driver");

      //STEP 3: Open a connection
      System.out.println("Connecting to database...");
      conn = DriverManager.getConnection(DB_URL,USER,PASS);

      //STEP 4: Execute a query
      System.out.println("Creating statement...");
      String sql;
      sql = "SELECT id, first, last, age FROM Employees";
      stmt = conn.prepareStatement(sql);
      ResultSet rs = stmt.executeQuery();

      //STEP 5: Extract data from result set
      while(rs.next()){
         //Retrieve by column name
         int id  = rs.getInt("id");
         int age = rs.getInt("age");
         String first = rs.getString("first");
         String last = rs.getString("last");

         //Display values
         System.out.print("ID: " + id);
         System.out.print(", Age: " + age);
         System.out.print(", First: " + first);
         System.out.println(", Last: " + last);
      }
      //STEP 6: Clean-up environment
      rs.close();
      stmt.close();
      conn.close();
   }catch(SQLException se){
      //Handle errors for JDBC
      se.printStackTrace();
   }catch(Exception e){
      //Handle errors for Class.forName
      e.printStackTrace();
   }finally{
      //finally block used to close resources
      try{
         if(stmt!=null)
            stmt.close();
      }catch(SQLException se2){
      }// nothing we can do
      try{
         if(conn!=null)
            conn.close();
      }catch(SQLException se){
         se.printStackTrace();
      }//end finally try
   }//end try
   System.out.println("There are so thing wrong!");
}//end main
}//end FirstExample
```

Java 的文档已经非常的详细了，除了是英文版，其他的都非常棒。你可以只了解上面的部分内容，当你需要使用其他的功能的时候都可以方便的在函数列表中找到你要的函数，估计你要实现的功能都有。
例如在获取字段的时候，你可以用下标来获取，而不是只能用字段名称获取。

如何学习Java的使用? 去看源代码。所谓看源代码并不是代码的细节去看，而是去看这个代码都做了写什么，这个类是个什么类? 其内部是Array还是Map还是List？这些东西清楚了，足以让你知道如何使用它了。当然很多情况下，其内部不是简单的一中数据结构，可能是多种并行。所以你只需要对基础的数据结构很了解，在用这些东西的时候只要看函数名称就能理解其用法。可能在如何学习计算机科学这篇文章中还会提及这方面的技巧。

# Statement
上面有个地方你可能会不太理解，就是为什么我建立连接后不能直接执行SQL而是要搞一个statement呢？这个就是设计模式与直观思路的差异问题。直观想法就是我建立了连接就可以去执行SQL了呀，但是JDBC要实现更多的功能，所以又进行了流程分拆，这个Statement就是用来执行SQL的那个部分，既然用一个类来执行，必然对这个SQL做了一些什么骚操作。事实上JDBC对于这个Statement有三种设计。

### 三种Statement类：

- `Statement`：由createStatement创建，用于发送简单的SQL语句（不带参数）。
- `PreparedStatement` ：继承自Statement接口，由preparedStatement创建，用于发送含有一个或多个参数的SQL语句。PreparedStatement对象比Statement对象的效率更高，并且可以防止SQL注入，所以我们一般都使用PreparedStatement。
- `CallableStatement`：继承自PreparedStatement接口，由方法prepareCall创建，用于调用存储过程。

### 常用Statement方法：

- `execute(String sql)`:运行语句，返回是否有结果集
- `executeQuery(String sql)`：运行select语句，返回ResultSet结果集。
- `executeUpdate(String sql)`：运行insert/update/delete操作，返回更新的行数。
- `addBatch(String sql)` ：把多条sql语句放到一个批处理中。
- `executeBatch()`：向数据库发送一批sql语句执行。

# 其他

以上只是简单的基础使用和一些基本概念的理解，以后会补充JDBC事务的概念，以及JDBC与SQL之间的数据类型转换等。

会了这个你就基本懂php 中PDO的使用了。

# 常用代码实例
有一些常用的代码，就直接写在这里，用的到的时候直接Copy上就好了。

## 获取insert后自增字段值
用于在资源创建后获取资源ID， 要求具有原子性。
```java
    private String insertSQL(String sql) {
        //Connection 参考上面的代码
        ...
        // 
        ResultSet rs;
        Connection conn = null;
        PreparedStatement ps = null;
        long ret = 0;
        try {
            conn = ds.getConnection();
            // important & 
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            int rows = ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            if( rs.next() ) {
                ret = rs.getLong(1);
            }
            conn.close();
            ps.close();
            rs.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Long.toString(ret);

    }
```
