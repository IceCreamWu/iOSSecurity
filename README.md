# iOSSecurity
生成公钥私钥文件可以在Mac终端使用openssl，命令如下：

openssl req -x509 -out public_key.der -outform der -new -newkey rsa:1024 -keyout private_key.pem

输入这个命令后会要求输入密码，这个密码会在加载私钥文件时用到。
然后按照提示输入其他一些信息，比如国家省份单位等。

完成以上操作后会在当前目录下生成公钥文件public_key.der和私钥文件private_key.pem。
