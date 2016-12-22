# ALDEBugTool
ALDEBugTool功能:

1. ALAssert使用方法与NSAssert相同，学习成本为零
2. ALAssert与NSAssert兼容，同时使用不会影响线程已有断言
3. ALAssert自定义断言处理,通过弹框提醒警告以及分发给责任方。RD及QA测试阶段使用弹框比直接Crash要友好。

## Quick Start

目前都使用cocoapods安装，在Podfile中加入

```
pod "ALDEBugTool" 
```

## Example

``` 
demo请参考ALAppDelegate

```

## 维护者

alex520biao <alex520biao@163.com>

## License

ALDEBugTool is available under the MIT license. See the LICENSE file for more info.
