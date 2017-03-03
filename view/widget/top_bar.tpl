<div class="top-bar">
    <div class="container">
        <div class="row">
            <div class="col-md-6">业务咨询邮箱：ad@zlongad.com&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;客服QQ：12345678</div>
            <!-- <div class="col-md-6 text-right"  v-if="userinfo.uid" > -->
            <div class="col-md-6 text-right"  >
            	<span id="span">{{userinfo.username}}</span>
            	<a class="logout" href="javascript:;" >退出</a>
            </div>
        </div>
    </div>
</div>
 <script type="text/javascript">
	$(function(){
        // 判断
        if ($('#span').html()==''){
            $(".logout").remove()
        }
		$(".logout").click(function(){
            $.ajax({
                type: "GET",
                url: "http://api.zlongad.com/v1/logout",
                data: {
                    'access-token': "{{token}}"
                },
                dataType: "json",
                success: function(data){
                    if(data.code == "200"){
                        $.cookie("token", '');
                        $.cookie("username", '');
                        $.cookie("uid", 0);
						window.location.href = "/login";
                    }else{
						weui.alert(data.msg);
                    }
                }
            });
		});
	});
</script>