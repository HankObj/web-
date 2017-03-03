#前端开发文档

##一、web架构

### 1、后端架构

> 基于nodejs的web后端架构，以express为框架，swig为模板引擎。

**依赖库安装**

```
npm install express
npm install swig
npm install body-parser
npm install cookie-parser
npm install request
npm install pm2
```
**附文档**

- swig模板：http://www.cnblogs.com/elementstorm/p/3142644.html


**启动命令**

```
pm2 start index --name="zlongad" --watch
```

### 2、前端架构

**第3方依赖库**

- jquery2.0：基础js库
- bootstrap4.0：前端界面UI库
	- 参考文档：http://wiki.jikexueyuan.com/project/bootstrap4/
- vue2.0：前端MVVM数据框架
	- 参考文档：https://vuefe.cn/v2/guide/
- weui：微信前端UI框架，弹层，loading等
	- 参考文档：https://github.com/weui/weui.js/blob/master/docs/README.md
- font-awesome-4.7.0：图标字体库
- echarts：百度图表库

**数据交互思路**

> 异步向服务器请求数据，通过vue前端model进行动态渲染


### 3、目录结构
```
|____data
| |____config.json //地区配置文件
| |____index.json //测试数据
|____index.js //启动入口文件
|____readme.md //帮助文档
|____static //静态文件目录
| |____css //css目录
| |____html //静态页面目录
| | |____xieyi.html //协议页面
| |____images //图像目录
| |____lib //第3方前端库
|____view //模板目录
| |____chart.tpl //图表
| |____chuangyi.tpl //创意列表
| |____chuangyi_new.tpl //创建创意
| |____index.tpl //首页
| |____jihua.tpl //广告计划
| |____jihua_new.tpl //创建/更新广告计划
| |____login.tpl //登录
| |____media.tpl //媒体列表
| |____media_ad.tpl //创建/更新媒体广告
| |____money.tpl //财务
| |____tuiguang.tpl //推广页面
| |____widget //页面版块
| | |____ad_jihua_list.tpl //广告单元列表
| | |____edit_ad_chuangyi.tpl //编辑广告创意
| | |____edit_ad_danyuan.tpl //编辑广告单元
| | |____edit_ad_jihua.tpl //编辑广告计划(已换成页面)
| | |____edit_media_ad.tpl //编辑媒体广告位
| | |____error.tpl //前端错误提示
| | |____layout.tpl //模板基构
| | |____main_nav.tpl //主导航
| | |____media_nav.tpl //媒体子导航
| | |____top_bar.tpl //顶部bar
| | |____tuiguang_nav.tpl //推广导航
```