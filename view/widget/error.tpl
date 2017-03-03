<script type="text/javascript">
(function($){  
    var _ajax = $.ajax;  
    $.ajax = function(opt){  
        var fn = {  
            error:function(XMLHttpRequest, textStatus, errorThrown){},  
            success:function(data, textStatus){}  
        }  
        if(opt.error){  
            fn.error=opt.error;  
        }  
        if(opt.success){  
            fn.success=opt.success;
        }  
        var _opt = $.extend(opt,{  
            error:function(XMLHttpRequest, textStatus, errorThrown){  
                //错误方法增强处理  
                fn.error(XMLHttpRequest, textStatus, errorThrown);  
                switch(XMLHttpRequest.status){
                	case(500):
                		alert("系统错误");
                		break;                	
                	case(401):
                        weui.toast('未登录', {
                            duration: 1500
                        });
                		window.location.href = "/login";
                		break;
                }
            } 
        });  
        return _ajax(_opt);
    };  
})(jQuery);
</script>