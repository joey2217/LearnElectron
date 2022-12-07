# NSIS_SetupSkin

NSIS打包工具，基于XML可自定义UI，通过项目[NSIS-UI](https://github.com/hilanmiao/NSIS-UI)找到[nsNiuniuSkin](http://www.ggniu.cn/download.htm)修改而来

> 该安装包界面控件是一个可集成于NSIS的插件，采用Duilib开发，在使用时，安装包制作者只需要做如下两件事情：
>> 1. 通过配置Duilib的资源，设计好界面显示的元素

>> 2. 在NSIS的脚本中，通过NSIS脚本调用nsNiuniuSkin.dll的相关接口，集成UI及安装包的业务功能 

> 在控件的资源中，采用的是通过TAB控件来实现不同阶段的安装界面，比如：选择路径、许可协议、安装进度、完成、卸载等，在实际使用中，通过NSIS脚本来设置当前需要显示的TAB页，即可完美的呈现出需要的界面UI了。



* [使用方法](/使用方法.md)
* [api](/api.md)


**[更多打包工具](https://www.bajins.com/Other/Windows%E8%BD%AF%E4%BB%B6.html#%E7%A8%8B%E5%BA%8F%E6%89%93%E5%8C%85)**


**关于nsNiuniuSkin License**

* [http://www.ggniu.cn/articles/nsniuniuskin.html](http://www.ggniu.cn/articles/nsniuniuskin.html)
* [http://www.leeqia.com/nsniuniuskin/download](http://www.leeqia.com/nsniuniuskin/download)

> nsNiuniuSkin是目前国内最专业的安装包UI控件，与NSIS完美融合。同时它也是一个完全免费的安装包UI控件，无任何的使用限制。我们的目标是让稍微有一点NSIS基础的人在一天内完成一个安装包制作。



**下载软件目录包：**

* [https://gd.bajins.com/PacketTool/software-pkg/](https://gd.bajins.com/PacketTool/software-pkg/)
* [https://od.bajins.com](https://od.bajins.com)



## NSIS

* [https://sourceforge.net/projects/nsis](https://sourceforge.net/projects/nsis)
* [https://nsis.sourceforge.io/Category:Plugins](https://nsis.sourceforge.io/Category:Plugins)
* [https://sourceforge.net/projects/hmne](https://sourceforge.net/projects/hmne)
* [http://hmne.sourceforge.net](http://hmne.sourceforge.net)




## 修改如下

- 1、修改目录结构，使项目更加规范：
  - 对图片文件统一归纳
  - 对编译bat文件针对每个程序目录放在该目录下

- 2、修改函数调用，使项目更加规范，例如：

> ui.nsh 73-76行

- 3、修改函数中代码块语句错误的bug：

> ui.nsh 第70行

- 4、UI中白色背景时白色按钮不显示修改为黑色按钮可显示：

> install.xml 24-32行

- 5、bat中删除文件时先判断是否存在

- 6、bat中遍历源程序文件夹时先判断是否为空：

> makensiscode.bat 第45行

- 7、产品信息使用变量，避免输入多次可能输错：

> songliwu.nsi 6-10行

- 8、[修改卸载时的提示语中产品名称自动使用变量值](https://github.com/woytu/NSIS_SetupSkin/commit/eeb250b12f9af7851d79d69d8f68608d2e858d6a)

- 9、[所需空间大小使用函数计算FilesToInstall文件夹大小，不再需要手动输入配置](https://github.com/woytu/NSIS_SetupSkin/commit/607abd9502800aac91ba15bb22b0f591a88c5ca0)


## 目录结构

```
.
│  7z.dll                                   7z压缩dll
│  7z.exe                                   7z压缩主程序
│  makeapp.bat                              压缩FilesToInstall文件夹脚本
│  makensiscode.bat                         不压缩时遍历FilesToInstall文件夹生成编译需要的app.nsh文件
│  makeskinzip.bat                          压缩SetupScripts/*/skin文件夹
│  
├─FilesToInstall                            源程序文件夹
├─NSIS                                      NSIS主程序文件夹
├─OriginPlugin                              插件
└─SetupScripts                               项目UI配置目录
    │  commonfunc.nsh                        公共函数
    ├─nim                                    无复选框UI示例
    │  │  build-nim-nozip.bat                 不带压缩构建脚本
    │  │  build-nim.bat                       带压缩构建脚本
    │  │  licence.rtf                         产品许可文件
    │  │  license.txt
    │  │  logo.ico                            产品logo图标
    │  │  nim.nsi                             安装包产品信息定义,引用了ui.nsh
    │  │  ui.nsh                              UI函数
    │  │  uninst.ico                          卸载图标
    │  │  
    │  └─skin                                 UI配置
    │      │  configpage.xml                    配置页XML
    │      │  default.xml                       全局XML
    │      │  finishpage.xml                    安装完成页XML
    │      │  install.xml                       安装首页XML
    │      │  installingpage.xml                安装进行页XML
    │      │  licensepage.xml                   产品许可页XML
    │      │  msgBox.xml                        提示消息页XML
    │      │  uninstallfinishpage.xml           卸载完成页XML
    │      │  uninstallingpage.xml              卸载进行页XML
    │      │  uninstallpage.xml                 卸载首页XML
    │      │  
    │      ├─form                             公共文件，比如公用图片
    │      └─public                           独立部件文件
    │          ├─bk
    │          ├─button
    │          ├─caption
    │          ├─checkbox
    │          ├─edit
    │          └─vsrcollbar
    │                  
    └─songliwu                                   有复选框UI示例
        │  build-songliwu-nozip.bat              不带压缩构建脚本
        │  build-songliwu.bat                    带压缩构建脚本
        │  license.txt                           产品许可文件
        │  logo.ico                              产品logo图标
        │  songliwu.nsi                          安装包产品信息定义,引用了ui.nsh
        │  ui.nsh                                UI函数
        │  uninst.ico                            卸载图标
        │  
        └─skin                                 UI配置
            │  configpage.xml                    配置页XML
            │  default.xml                       全局XML
            │  finishpage.xml                    安装完成页XML
            │  install.xml                       安装首页XML
            │  installingpage.xml                安装进行页XML
            │  licensepage.xml                   产品许可页XML
            │  msgBox.xml                        提示消息页XML
            │  msgBox2.xml
            │  uninstallfinishpage.xml           卸载完成页XML
            │  uninstallingpage.xml              卸载进行页XML
            │  uninstallpage.xml                 卸载首页XML
            │  
            └─form                             公共文件，比如公用图片
```

## 图片示例

![](/images/打包好的程序信息.png)
![](/images/网易云音乐示例.png)
![](/images/网易云音乐许可协议页面.png)
![](/images/有复选框UI.png)
![](/images/有复选框UI许可协议页面.png)
