FSWebServiceAnalyze
===========

xml-->NSMutableArray (List<Entity>);
json-->NSMutableArray (List<Entity>).

Features
========

* Reflection
* Regular Expression

What you need
---

* FSWebServiceAnalyze.h
* FSWebServiceAnalyze.m
* [GDataXMLNode.h](http://code.google.com/p/gdata-objectivec-client/downloads/list)
* [GDataXMLNode.m](http://code.google.com/p/gdata-objectivec-client/downloads/list)

How to use
---  

```objective-c
NSMutableArray *retVal = [FSWebServiceAnalyze jsonToArray:xml class:Entity.class];
    
NSMutableArray *retVal = [FSWebServiceAnalyze xmlToArray:xml class:Entity.class rowRootName:@"rowRootName"];
    
```

## xml-->NSMutableArray (List<Class>)

```objective-c

/**
 * 将标准的xml(实体)转换成NSMutableArray
 * @param xml:(忽略实体属性大小写差异)
    <data xmlns="">
    <row><UserID>ff0f0704</UserID><UserName>fs</UserName></row>
    <row><UserID>ff0f0704</UserID><UserName>fs</UserName></row>
    ......
    </data>
 * @param class:
    User @property userName,userID;
 * @param rowRootName:
    row
 * @return NSMutableArray (List<User>)
 */
+(NSMutableArray*)xmlToArray:(NSString*)xml class:(Class)class rowRootName:rowRootName;
```


## json-->NSMutableArray (List<Class>)

```objective-c
/**
 * 将标准的Json(实体)转换成NSMutableArray
 * @param xml:(忽略实体属性大小写差异)
    [{"UserID":"ff0f0704","UserName":"fs"},
    {"UserID":"ff0f0704","UserName":"fs"},...]
 * @param class:
    User @property userName,userID;
 * @return NSMutableArray (List<User>)
 */
+(NSMutableArray*)jsonToArray:(NSString*)json class:(Class)class;    
```
