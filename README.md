# HWJson
通过类OC语法获取Json值

通过字典Key-Value的形式获取json数据，包装了一个类替代直接用Dictionary获取Value。

## 特色

* 使用K-V形式获取值，效率快
* 类OC语法，容易上手

## Usage

初始化

```
json = [[HWJson alloc] initWithString:resString];

```

查看json结构，然后写query语句

原始Json
```
{
    "air": {
        "101010100": {
            "2001006": {
                "006": "4",
                "007": "74",
                "003": "67",
                "004": "2",
                "000": "201612201100",
                "001": "402",
                "005": "?",
                "002": "402"
            }
        }
    },
    ...
```

例如： 获取 005 的值。

直接获取：
```
NSString * query = @"air.101010100.2001006.005";
HWJson * resultJson = [json objectForQuery:query];

NSLog(@"%@", [resultJson toString]);
```

分开获取：

```
HWJson * airJson = [json objectForQuery:@"air"];
HWJson * sedJson = [airJson objectForQuery:@"101010100.2001006"];

// 005
NSlog(@"%@", [sedJson objectForQuery:@"005"]);

// 000
NSLog(@"%@", [sedJson objectforQuery:@"000"];

```

### 欢迎大家补充

由于本人自己的习惯是使用字典来对json存储，身边大部分朋友还是喜欢使用Model的方式。所以使用时自己分场景使用。   
功能简陋，欢迎大家补充或者发邮件到  ` huang1988519@126.com` 进行沟通。
