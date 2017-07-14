---
title: 比赛题解-2017苏大暑假集训个人赛(13)
date: 2017-07-14 12:53:21
tags: [ACM]
---

比赛现场[传送门](https://vjudge.net/contest/170743)。此次比赛共8道题目如下：
1. A. [HDU 5777](http://acm.hdu.edu.cn/showproblem.php?pid=5777) 签到题
2. B. [Poj 3581](http://poj.org/problem?id=3581) 后缀数组 + 细节处理
3. C. [Poj 2228](http://poj.org/problem?id=2228) DP+循环情况处理
4. D. [Poj 2155](http://poj.org/problem?id=2155) 二维树状数组/二维线段树(区域修改，单点查询)
5. E. [UVA 11853](https://uva.onlinejudge.org/index.php?option=com_onlinejudge&Itemid=8&page=show_problem&problem=2953) DFS乱搞
6. F. [HDU 4609](http://acm.hdu.edu.cn/showproblem.php?pid=4609) FFT基础题
7. G. [HDU 5676](http://acm.hdu.edu.cn/showproblem.php?pid=5676) DFS + 二分
8. H. [Poj 2728](http://poj.org/problem?id=2728) 最优比例生成树(0-1分数规划)/二分

题目整体偏难，除签到题外应该都是银牌及以上题目，基本上要掌握到这个程度才算可以。

# A. [HDU 5777](http://acm.hdu.edu.cn/showproblem.php?pid=5777) 签到题

某一场BestCoder的B题，很简单的思维小题目。
```c++
#include<iostream>
#include<cstdio>
#include<cstring>
#include<algorithm>
using namespace std;
typedef long long ll;
int n,k;
int a[100006];
ll sum=0;
bool cmp(int a,int b)
{
	return a>b;
}
int main()
{
	int T;
	scanf("%d", &T);
	while(T--)
	{
		scanf("%d%d", &n,&k);
		for(int i=0;i<n-1;i++)
			scanf("%d", &a[i]);
		sort(a,a+n-1,cmp);
		sum=n;
		for(int i=k-1;i<n-1;i++)
			sum+=a[i];
		printf("%lld\n",sum);
	}
	return 0;
}
```

# B. [Poj 3581](http://poj.org/problem?id=3581) 后缀数组 + 细节处理

#### 题意：
给一个序列，让你分成三段，段内反转一下，然后使得新拼接成的序列字典序最小，字典序的意思就是你懂得。题目保证第一个数字最大。

#### 分析：
思路很直白，分三段就是找两个切分点。开始到第一个切分点的部分就是第一段，要整体字典序最小，这个第一段一定要足够小。由于第一段是由原串第一段反转过来得到的，所以就可以将原来的串先直接整体反转一下，这样问题就转化成了我们要找个字典序最小的后缀，所以后缀数组搞一下。至于这么贪心是对的，下一段说明。
那么对于第二个切分点，就不能直接这么来了。因为第一段的贪心思路我们是可以证明的，至少你提不出反例，对于贪心算法的证明，提不出反例就默认是对的。为什么第一个贪心是对的，因为题目有一个条件保证了，就是第一个数是最大的。保证了什么情况呢？就是这个样例：`4 2 2 1 1 10`，最小的后缀是`1 1 10`, 而不是`1 10`。你匹配到的最小后缀一定是最长的那个。同样这个样例，对于第二个切分点来说就不是这样了，没有一个大头来保证后缀第一的是最长的串，直接搞就会得到2这一个元素，显然不是最优解。
这个时候我们还有一个可以作为思维出发点的东西，就是剩余的这两个串的位置关系。对于`abcd`来说(原串反转过后去掉第一段后的剩余部分)，如果我们将其分成两段，其在结果串中真正的顺序应该是`cdab`，这个点抓住了就很直观了，我们先将原串复制一遍，搞成：`abcdabcd`, 然后求一个字典序最小的后缀就是我们要的了，一样后缀数组搞一下。
注意后缀中长度小于原串长的都过滤掉，因为我要的是`cdab`这个串，起点要一定在前一段中，所以后缀长度要大于原串长度。还有就是要一定分三份，所以最长的后缀一定不能做为结果。

```c++
代码暂时不在手边，回头补。
```

# C. [Poj 2228](http://poj.org/problem?id=2228) DP+循环情况处理

#### 题意：
就是给N个数，选B个，问和最大是多少。
限制：N个数围成环，每个数的值被计算当其前面一个数被选择的时候，也就说一段连续的数中第一个是不算的。

#### 分析：
先来看线性问题，就是不成环的问题。很简单，定义`Dp[i][j]`为：前i个数选择了j个数且第i个数必选的最优解。
`Dp[i][j] = max( Dp[i-1][j-1]+a[i], max(Dp[k][j-1]) ), k<i-1`

对于环的情况Dp转移不变，但是要特殊处理一下。环的处理就那么两种，第一种是搞成直的，还有就是讨论一下。这里显然只要讨论一下就可以，因为无非就是跨天和不跨天的区别，也就是最后一个取的时候地一个取不取的问题。
所以搞两次就好了。

有两个优化，一个是循环清0,还有就是记录前面的Max。
```c++
#include<iostream>
#include<cstdio>
#include<cstring>
#include<algorithm>

using namespace std;
const int MAX_N = 4000;
int Dp[MAX_N][MAX_N], v[MAX_N];

int main()
{
    int N, B;
    while( scanf( "%d %d", &N, &B) != EOF ){

        for(int i = 1; i <= N; i ++ ) scanf("%d", &v[i]);
        
        for(int i = 0; i <= N; i ++) for(int j = 0; j <= B; j++ ) Dp[i][j] = 0;

        int Max = 0;
        for(int j = 2; j <= B ; j ++ ){
            Max = 0;
            for(int i = j; i <= N ; i ++){
                Dp[i][j] = max( Max, Dp[i-1][j-1] + v[i] );
                Max = max( Max, Dp[i-1][j-1] );
            }
        }

        int ans = 0;
        for( int i = B; i <= N; i ++ ) ans = max( ans, Dp[i][B] );

        for(int i = 0; i <= N; i ++) for(int j = 0; j <= B; j++ ) Dp[i][j] = 0;
        Dp[2][2] = v[2];
        for( int j = 3; j <= B ; j++ ){
            Max = 0 ;
            for( int i = j; i <= N ; i ++ ){
                Dp[i][j] = max( Max, Dp[i-1][j-1] + v[i] );
                Max = max( Max, Dp[i-1][j-1] );
            }
        }
        if( B > 2 ) ans = max( ans, Dp[N][B] + v[1] );

        printf("%d\n", ans);

    }
    return 0;
}
```

# D. [Poj 2155](http://poj.org/problem?id=2155) 二维树状数组/二维线段树(区域修改，单点查询)

会二维的都能秒出。不会的也是可以推出来的，只有一点点的难度，距离真正的二维操作差得还远，如果有时间建议学习一下二维树状数组的区间改值与区间加值区间求和等操作。
手边没有，暂时不送了。


# E. [UVA 11853](https://uva.onlinejudge.org/index.php?option=com_onlinejudge&Itemid=8&page=show_problem&problem=2953) DFS乱搞

题意很简单，一个1000×1000的方格上有一些圆，不能从圆范围经过，问是否有从左到右的一条路。这是大连2016的热身赛最后一题。
1. 先判断有没有，这个从上边界往下DFS能到下边界的就说明没有路。
2. 每次DFS的时候都记录与左边和右边的交点，在dfs过程中更新答案。
```c++
代码回头再补。
```

# F. [HDU 4609](http://acm.hdu.edu.cn/showproblem.php?pid=4609) FFT基础题

给n个线段，求取三个组成三角形的概率，就是组成三角形的个数。
离散化+fft。FFT入门题。

# G. [HDU 5676](http://acm.hdu.edu.cn/showproblem.php?pid=5676) DFS + 二分

这一题就是打个表，然后二分答案就可以了。打表就DFS。最大的那个数会爆，特判一下。

# H. [Poj 2728](http://poj.org/problem?id=2728) 最优比例生成树(0-1分数规划)/二分
这一题二分答案去判断是可以过的。正解是0-1分数规划，不过这个不是我出这一题的本意，本意就是想让你们二分做掉。

# 总结

题目很看功力，结果跟预料的差不多。
比赛不重要，但是希望你们能掌握上面的东西。
有的时候就是到了赛场上，发现题目很熟悉，但就是跟你的能力隔了一点点的小沟，如果当时学这个东西能学的深一点，这题就过了。这就是我出这场题目的意思。
