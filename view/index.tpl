{% extends "widget/layout.tpl" %}
{% block title %}子龙广告平台{% endblock %}
{% block body %}
	{% include "./widget/top_bar.tpl" %}
	{% include "./widget/main_nav.tpl" %}
	<br>
    <div class="container home">
        {% raw %}
    	<div class="block infos hide" :class="{show:loaded}">
    		<br>
    		<div class="row">
    			<div class="col-sm-3">
    				<span class="text-muted">账户余额：</span><strong>{{data.balance}}元</strong>
    			</div>
    			<div class="col-sm-5">
    			</div>
    		</div>    	
    		<div class="row">
    			<div class="col-sm-3">
    				<span class="text-muted">今日消费：</span><strong>{{data.myAd.today_consume}}元</strong>
    			</div>
    		</div>
    		<br>
    		<p><span class="text-muted">我的广告</p>
    		<div class="row">
    			<div class="col-sm-3">
	    			<div class="card card-block">
						<p class="card-text text-muted">运行中投放：</p>
						<h4 class="card-title">{{data.myAd.run_ad}}个</h4>
					</div>
				</div>    			
				<div class="col-sm-3">
	    			<div class="card card-block">
						<p class="card-text text-muted">昨日展现：</p>
						<h4 class="card-title">{{data.myAd.yesterday_display}}次</h4>
					</div>
				</div>    			
				<div class="col-sm-3">
	    			<div class="card card-block">
						<p class="card-text text-muted">昨日点击：</p>
						<h4 class="card-title">{{data.myAd.yesterday_click}}次</h4>
					</div>
				</div>    			
				<div class="col-sm-3">
	    			<div class="card card-block">
						<p class="card-text text-muted">昨日消费：</p>
						<h4 class="card-title">{{data.myAd.yesterday_consume}}元</h4>
					</div>
				</div>
    		</div>
    	</div>
        {% endraw %}
        <script type="text/javascript">
            $(function(){
                var Infos = new Vue({
                    el: ".infos",
                    data: {
                        loaded: false,
                        data: {
                            "balance": 0,
                            "myAd": {
                                "user_id": 0,
                                "today_consume": "0",
                                "yesterday_consume": "0",
                                "yesterday_click": "0",
                                "yesterday_display": "0",
                                "run_ad": "0"
                            }
                        }
                    },
                    methods: {
                        "loadData": function(){
                            var me = this;
                            //var loading = weui.loading('数据加载中');
                            $.ajax({
                                type: "GET",
                                url: "{{config.host}}/v1/index",
                                dataType: "json",
                                data: {
                                    'access-token': "{{token}}"
                                },
                                success: function(data){
                                    if(data.code == 200){
                                        if(data.data.myAd){
                                            me.$data.data = data.data;
                                        }
                                        me.$data.loaded = true;
                                        //loading.hide();
                                    }
                                }
                            });
                        }
                    }
                });
                Infos.loadData();
            });
        </script>
    	<div class="block blank">
    		{# 广告计划列表 #}
    		{% include "./widget/ad_jihua_list.tpl" %}
    	</div>
    </div>
    {# 创建广告 #}
    {% include "./widget/edit_ad_danyuan.tpl" %}
{% endblock %}