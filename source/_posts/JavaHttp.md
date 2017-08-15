---
title: Java HttpClient
date: 2017-08-15 20:07:20
tags: [Java, Http]
---

来记录一下Java 发起Http请求的方法。

这里使用的是`org.apache.http`包中的一些封装工具。

1. 首先实例化一个client：
```
    CloseableHttpClient httpclient = HttpClients.createDefault();
```

2. 然后来实例化一个URIBuild：
```
    URIBuilder builder = new URIBuilder(url);

```

3. 如果Http请求带有参数，就设置在uri中：
```

    builder.setParameter(key, value);
```

4. 实例化一个Httpget/Httppost:
```
    HttpGet httpget = new HttpGet(builder.build());
    HttpPost httppost = new HttpPost(builder.build());

```

5. 你可以设置请求的Header：
```
	httpget.setHeader("Accept", "application/json");

        // 接收json数据格式

```
6. 发送请求：
```
    CloseableHttpResponse response = httpclient.execute(httpget);
```

7. 查看请求结果：
```
    if (response.getStatusLine().getStatusCode() == 200) {
        String content = EntityUtils.toString(response.getEntity(), "utf-8");
    }
```

更多设置可以直接补全出来看。
