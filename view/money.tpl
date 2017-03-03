{% extends "widget/layout.tpl" %}
{% block title %}子龙广告平台{% endblock %}
{% block body %}
    {% include "./widget/top_bar.tpl" %}
    {% include "./widget/main_nav.tpl" %}
	<br>
    {% raw %}
    <div class="container money">
    	<div class="block infos">
    		<br>
    		<div class="row">
    			<div class="col-sm-3">
    				<span class="text-muted">账户余额：</span><strong>{{data.balance}}元</strong>
    			</div>
    			<div class="col-sm-5">
					<input data-toggle="modal" data-target="#DlgContact" class="btn btn-primary" type="button" value="开发票">
    			</div>
    		</div>    	
    		<br>	
    		<div class="row">
    			<div class="col-sm-12">
    				<span class="text-muted">广告消费：</span>
    				<strong>{{data.ad_consume}}元</strong>
    				<span class="text-danger">（提示：消费数据有2小时左右延迟！）</span>
    			</div>
    		</div>
    	</div>
    	<p class="text-muted">交易记录</p>
    	<div class="block blank">
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-active">
						<th width="350">订单创建时间</th>
						<th>交易号</th>
						<th>交易方式</th>
						<th>金额</th>
						<th>状态</th>
					</tr>
				</thead>
				<tbody>
					<tr v-for="item in data.orders">
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
                    <tr v-if="data.orders.length==0">
                        <td colspan="5">暂无数据</td>
                    </tr>
				</tbody>
			</table>
    	</div>
    </div>
    {% endraw %}
    <script type="text/javascript">
        $(function(){
            var Money = new Vue({
                el: ".money",
                data: {
                    loaded: false,
                    data: {
                        ad_consume: "0",
                        balance: "0",
                        orders: []
                    }
                },
                methods: {
                    "loadData": function(){
                        var me = this;
                        $.ajax({
                            type: "GET",
                            url: "{{config.host}}/v1/finance",
                            dataType: "json",
                            data: {
                                'access-token': "{{token}}"
                            },
                            success: function(data){
                                if(data.code == 200){
                                    me.$data.data = data.data;
                                    me.$data.loaded = true;
                                    //loading.hide();
                                }
                            }
                        });
                    }
                }
            });
            Money.loadData();
        });
    </script>
{% endblock %}