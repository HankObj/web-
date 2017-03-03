var express = require('express'),
    app = express(),
    bodyParser = require('body-parser'),
    cookieParser = require('cookie-parser'),
    swig = require('swig');
var request = require('request');

app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());
app.use(cookieParser());

app.engine('tpl', swig.renderFile);
app.set('view engine', 'tpl');
app.set('views', __dirname + '/view');

//跨域输出设置
app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    req.config = {
        host: "http://api.zlongad.com"
    };    
    req.token = decodeURIComponent(req.cookies.token) || "";
    req.userinfo = {
        username: req.cookies.username || "",
        uid: req.cookies.uid || ""
    }
    next();
});

app.get('/login', function (req, res) {
    var ps = req.query;
    res.render('login.tpl',{
        config: req.config,
        userinfo: req.userinfo,
        t: (new Date()).getTime()
    });
});
app.get('/', function (req, res) {
    var ps = req.query;
    res.render('index.tpl', {
        config: req.config,
        userinfo: req.userinfo,
        token: req.token,
    	nav: ["active","","","",""],
        url: ps.url,
        page: "index"
    });
});
app.get('/tuiguang', function (req, res) {
    var ps = req.query;
    res.render('tuiguang.tpl', {
        config: req.config,
        userinfo: req.userinfo,
        token: req.token,
    	nav: ["","active","","",""],
    	navItem: ["active","",""],
        url: ps.url,
        pageData: require("./data/index.json")
    });
});
app.get('/tuiguang/chuangyi', function (req, res) {
    var ps = req.query;
    res.render('chuangyi.tpl', {
        config: req.config,
        userinfo: req.userinfo,
        token: req.token,
        nav: ["","active","","",""],
        navItem: ["","active",""],
        url: ps.url,
        ad_id: ps.ad_id || "-1"
    });
});
app.get('/tuiguang/chuangyi/new', function (req, res) {
    var ps = req.query;
    res.render('chuangyi_new.tpl', {
        config: req.config,
        userinfo: req.userinfo,
        token: req.token,
    	nav: ["","active","","",""],
    	navItem: ["","active",""],
        url: ps.url,
        id: ps.id || null
    });
});
app.get('/tuiguang/jihua', function (req, res) {
    var ps = req.query;
    res.render('jihua.tpl', {
        config: req.config,
        userinfo: req.userinfo,
        token: req.token,
        nav: ["","active","","",""],
        navItem: ["","","active"],
        url: ps.url,
        idea_id: ps.idea_id || "-1"
    });
});
app.get('/tuiguang/jihua/new', function (req, res) {
    var ps = req.query;
    //处理城市
    var areas = require("./data/config.json").data.areas,
        _temp = {},
        __temp = {}
    //第0层
    for(var i=0;i<areas.length;i++){
        areas[i].data = {}
        __temp[areas[i].id] = areas[i];
    }     
    for(var item in __temp){
        if(__temp.hasOwnProperty(__temp[item].parent_id)){
            __temp[__temp[item].parent_id].data[item] = __temp[item];
        }
    }     
    //第一层
    for(var i=0;i<areas.length;i++){
        if(areas[i].parent_id == 0){
            areas[i].data = {};
            _temp[areas[i].id] = areas[i];
        }
    }   
    //第二层
    for(var i=0;i<areas.length;i++){
        if(_temp.hasOwnProperty(areas[i].parent_id) && areas[i].type != 2){
            areas[i].data = {};
            _temp[areas[i].parent_id].data[areas[i].id] = areas[i];
        }
    }    
    //第三层
    for(var i=0;i<areas.length;i++){
        if(areas[i].type == 2 && areas[i].parent_id && areas[i].group_id){
            //areas[i].data = __temp[areas[i].id];
            _temp[areas[i].parent_id].data[areas[i].group_id].data[areas[i].id] = areas[i];
        }
    }    
    res.render('jihua_new.tpl', {
        config: req.config,
        userinfo: req.userinfo,
        token: req.token,
        areas: _temp,
    	nav: ["","active","","",""],
    	navItem: ["","","active"],
        url: ps.url,
        id: ps.id || null
    });
});
app.get('/chart', function (req, res){
    var ps = req.query;
    res.render('chart.tpl', {
        config: req.config,
        userinfo: req.userinfo,
        token: req.token,
    	nav: ["","","active","",""],
        url: ps.url
    });
});
app.get('/money', function (req, res) {
    var ps = req.query;
    res.render('money.tpl', {
        config: req.config,
        userinfo: req.userinfo,
        token: req.token,
        nav: ["","","","active",""],
        url: ps.url
    });
});
app.get('/media', function (req, res) {
    var ps = req.query;
    res.render('media.tpl', {
        config: req.config,
        userinfo: req.userinfo,
        token: req.token,
        nav: ["","","","","active"],
        navItem: ["active",""],
        url: ps.url
    });
});
app.get('/media/ad', function (req, res) {
    var ps = req.query;
    res.render('media_ad.tpl', {
        config: req.config,
        userinfo: req.userinfo,
        token: req.token,
        nav: ["","","","","active"],
        navItem: ["","active"],
        url: ps.url,
        media_id: ps.media_id || null
    });
});
app.post('/put', function (req, res) {
    var ps = req.body;
    console.log(ps.url);
    request.put({
        url:ps.url, 
        form: JSON.parse(ps.data)
        /*
        form: {
            "name": ps.name,
            "ad_id": ps.ad_id,
            "txt": ps.txt,
            "style": ps.style,
            "image": ps.image
        }
        */
        }, function(err,httpResponse,body){
            res.send(body);
     });
});

app.use('/static', express.static( __dirname + '/static'));

app.listen(9999);