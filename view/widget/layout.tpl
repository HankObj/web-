<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>{% block title %}{% endblock %}</title>
	<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no" />
    <link rel="stylesheet" type="text/css" href="/static/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="/static/bootstrap/css/bootstrap-datetimepicker.min.css">
    <link rel="stylesheet" type="text/css" href="/static/lib/weui.min.css">
	<link rel="stylesheet" type="text/css" href="/static/css/zilong.css">
    <link href="/static/lib/font-awesome-4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <script type="text/javascript" src="/static/lib/jquery-3.1.1.min.js"></script>
    <script type="text/javascript" src="/static/bootstrap/js/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript" src="/static/bootstrap/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="/static/lib/vue.min.js"></script>
	<script type="text/javascript" src="/static/lib/weui.min.js"></script>
    <script type="text/javascript" src="/static/bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="/static/lib/echarts.simple.min.js"></script>
    <link rel="icon" type="image/x-icon" href="/static/favicon.ico">   
    <script type="text/javascript">
(function (factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD (Register as an anonymous module)
        define(['jquery'], factory);
    } else if (typeof exports === 'object') {
        // Node/CommonJS
        module.exports = factory(require('jquery'));
    } else {
        // Browser globals
        factory(jQuery);
    }
}(function ($) {

    var pluses = /\+/g;

    function encode(s) {
        return config.raw ? s : encodeURIComponent(s);
    }

    function decode(s) {
        return config.raw ? s : decodeURIComponent(s);
    }

    function stringifyCookieValue(value) {
        return encode(config.json ? JSON.stringify(value) : String(value));
    }

    function parseCookieValue(s) {
        if (s.indexOf('"') === 0) {
            // This is a quoted cookie as according to RFC2068, unescape...
            s = s.slice(1, -1).replace(/\\"/g, '"').replace(/\\\\/g, '\\');
        }

        try {
            // Replace server-side written pluses with spaces.
            // If we can't decode the cookie, ignore it, it's unusable.
            // If we can't parse the cookie, ignore it, it's unusable.
            s = decodeURIComponent(s.replace(pluses, ' '));
            return config.json ? JSON.parse(s) : s;
        } catch(e) {}
    }

    function read(s, converter) {
        var value = config.raw ? s : parseCookieValue(s);
        return $.isFunction(converter) ? converter(value) : value;
    }

    var config = $.cookie = function (key, value, options) {

        // Write

        if (arguments.length > 1 && !$.isFunction(value)) {
            options = $.extend({}, config.defaults, options);

            if (typeof options.expires === 'number') {
                var days = options.expires, t = options.expires = new Date();
                t.setMilliseconds(t.getMilliseconds() + days * 864e+5);
            }

            return (document.cookie = [
                encode(key), '=', stringifyCookieValue(value),
                options.expires ? '; expires=' + options.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
                options.path    ? '; path=' + options.path : '',
                options.domain  ? '; domain=' + options.domain : '',
                options.secure  ? '; secure' : ''
            ].join(''));
        }

        // Read

        var result = key ? undefined : {},
            // To prevent the for loop in the first place assign an empty array
            // in case there are no cookies at all. Also prevents odd result when
            // calling $.cookie().
            cookies = document.cookie ? document.cookie.split('; ') : [],
            i = 0,
            l = cookies.length;

        for (; i < l; i++) {
            var parts = cookies[i].split('='),
                name = decode(parts.shift()),
                cookie = parts.join('=');

            if (key === name) {
                // If second argument (value) is a function it's a converter...
                result = read(cookie, value);
                break;
            }

            // Prevent storing a cookie that we couldn't decode.
            if (!key && (cookie = read(cookie)) !== undefined) {
                result[name] = cookie;
            }
        }

        return result;
    };

    config.defaults = {};

    $.removeCookie = function (key, options) {
        // Must not alter options, thus extending a fresh object...
        $.cookie(key, '', $.extend({}, options, { expires: -1 }));
        return !$.cookie(key);
    };

}));
        window.Widget = {};
    </script>
    {% include "./error.tpl" %}
</head>
<body class="{{mobile}}">
    {% block body %}{% endblock %}
    <div class="footer text-center">
        <p>
            <a href="javascript:;" data-toggle="modal" data-target="#DlgXieyi">服务协议</a>
            <a href="javascript:;" data-toggle="modal" data-target="#DlgContact">联系我们</a>
        </p>
        <p>Copyright © 1000-2017 zlongad.com All Rights Reserved</p>
        <p>京ICP备12345678号</p>
    </div>
    <div class="modal fade" id="DlgXieyi" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                    <span class="sr-only">关闭</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">服务协议</h4>
                </div>
                <div class="modal-body">
                    <iframe width="100%" height="5380" frameborder="no" src="/static/html/xieyi.html"></iframe>
                </div>
            </div>
        </div>
    </div>    
    <div class="modal fade" id="DlgContact" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                    <span class="sr-only">关闭</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">联系我们</h4>
                </div>
                <div class="modal-body">
                    <div style="width:80%;margin:auto;">
                        <p>地址：北京红军营南路15号</p>
                        <p>邮箱：ad@zlongad.com</p>
                        <p>QQ：123456678</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>