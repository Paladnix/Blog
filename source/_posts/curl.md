---
title: curl
date: 2017-07-11 17:37:47
tags: [linux, http]
---

linux下面自带的一个命令行工具，很常用，关键是很强大。

# supports
DICT, FILE, FTP, FTPS, Gopher, HTTP, HTTPS, IMAP, IMAPS, LDAP, LDAPS, POP3, POP3S, RTMP, RTSP, SCP, SFTP, SMB, SMBS, SMTP, SMTPS, Telnet and TFTP. 

supports SSL certificates, HTTP POST, HTTP PUT, FTP uploading, HTTP form based upload, proxies, HTTP/2, cookies, user+password authentication (Basic, Plain, Digest, CRAM-MD5, NTLM, Negotiate and Kerberos)

file transfer resume, proxy tunneling and more.

基本上无所不能了。。。
这里是cURL的[PDF](https://www.gitbook.com/download/pdf/book/bagder/everything-curl)版本说明文档，不是很难看懂，里面介绍了这个项目的起源发展、网络协议、如何使用等等。作者还有个很帅的名字：丹尼尔·斯坦伯格。

作者写了这样一段话：

`Running curl from the command line was natural and Daniel never considered anything else
than that it would output data on stdout, to the terminal, by default. The "everything is a pipe"
mantra of standard Unix philosophy was something Daniel believed in. curl is like 'cat' or one
of the other Unix tools; it sends data to stdout to make it easy to chain together with other
tools to do what you want. That's also why virtually all curl options that allow reading from a
file or writing to a file, also have the ability to select doing it to stdout or from stdin.`
这是我喜欢Linux的其中一个原因，称之为优雅。

鉴于看了几个小时的文档，就没有时间写了，待续...


