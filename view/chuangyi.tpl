{% extends "widget/layout.tpl" %}
{% block title %}子龙广告平台{% endblock %}
{% block body %}
	{% include "./widget/top_bar.tpl" %}
	{% include "./widget/main_nav.tpl" %}
	<br>
    <div class="container">
    	{# 推广导航条 #}
    	{% include "./widget/tuiguang_nav.tpl" %}
    	{% raw %}
    	<div class="ChuangYi block">
    		<div class="clearfix">
    			<div class="pull-left">
					<a class="btn btn-primary" href="/tuiguang/chuangyi/new">创建广告创意</a>
    			</div>
    			<div class="pull-right row">
    				<div class="col-sm-6">
						<select @change="loadData()" v-model="ad_id" class="form-control c-select">
							<option value="-1">所属广告单元</option>
							<template v-for="item in adlist">
								<option :value="item.id">{{item.name}}</option>
							</template>
						</select>
					</div>    				
					<div class="col-sm-6">
						<select class="form-control c-select">
							<option value="">选择时间范围</option>
							<option value="">按周</option>
							<option value="">按月</option>
						</select>
					</div>
    			</div>
    		</div>
    		<hr>
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-active">
						<th width="200">创意名称</th>
						<th>所属广告</th>
						<th>运行状态</th>
						<th>展现</th>
						<th>点击</th>
						<th>点击率</th>
						<th width="80">操作</th>
					</tr>
				</thead>
				<tbody>
					<tr v-for="litem in list">
						<td><a :href="'/tuiguang/jihua?idea_id=' + litem.id">{{litem.name}}<i class="fa fa-bars" aria-hidden="true"></i></a></td>
						<td>{{litem.ad_name}}</td>
						<td><span class="text-warning">未运行</span></td>
						<td>{{litem.display}}</td>
						<td>{{litem.click}}</td>
						<td>{{(litem.click>0?parseInt(litem.click/litem.display)*100 + "%" : "0")}}</td>
						<td>
							<a class="icon" :href="'/tuiguang/chuangyi/new?id='+litem.id"><i class="fa fa-edit action" aria-hidden="true"></i>编辑</a>
						</td>
					</tr>	
					<tr>
						<td colspan="9">
							<div class="clearfix">
								<div class="pull-left">
									<p class="text-center"><span class="label label-default">共{{pageData.total}}条</span></p>
								</div>
								<div class="pull-right">
									<nav class="text-center">
										<ul class="pagination pagination-sm" style="margin:0;">
											<li><a href="javascript:;" @click="first()">首页</a></li>
											<li @click="pre()">
												<a href="javascript:;" aria-label="Previous">
												<span aria-hidden="true">&laquo;</span>
												<span class="sr-only">上一页</span>
												</a>
											</li>
											<template v-for="pn in pageData.pageCount">
												<li :class="{active:(pn-1)==pageData.page}" @click="loadData(pn)"><a href="javascript:;">{{pn}}</a></li>
											</template>
											<li @click="next()">
												<a href="javascript:;" aria-label="Next">
												<span aria-hidden="true">&raquo;</span>
												<span class="sr-only">下一页</span>
												</a>
											</li>
											<li><a href="javascript:;" @click="end()">尾页</a></li>
										</ul>
									</nav>
								</div>
							</div>
						</td>
					</tr>			
				</tbody>
			</table>
    	</div>
    	{% endraw %}
    </div>
    <script type="text/javascript">
		$(function(){
			Widget.CyList = new Vue({
				el: ".ChuangYi",
				data: {
					pageData: {
						total: 0,
						pageCount: 0
					},
					list: [],
					adlist: [],
					ad_id: "{{ad_id}}"
				},
				methods: {
					"loadData": function(pn){
						var me = this;
						Widget.loading = weui.loading('数据加载中');
						var me = this;
	                    $.ajax({
	                        type: "GET",
	                        url: "{{config.host}}/v1/idea",
	                        data: {
	                        	ad_id: me.$data.ad_id != "-1"?me.$data.ad_id:"",
                            	'access-token': ("{{token}}"),
	                        	page: pn || 1
	                        },
	                        dataType: "json",
	                        success: function(data){
	                        	if(data.code == 200){
	                        		me.$data.list = data.data.items;
	                        		me.$data.pageData = data.data.pagination;
									Widget.loading.hide();
									me.loadAdData();
	                        	}else{
                        			alert(data.msg);
	                        	}
	                        }
	                    });
					},
					//加载广告单元				
					"loadAdData": function(pn){
						var me = this;
						var me = this;
	                    $.ajax({
	                        type: "GET",
	                        url: "{{config.host}}/v1/ad",
	                        dataType: "json",
	                        data: {
                            	'access-token': "{{token}}",
	                        },
	                        success: function(data){
	                        	if(data.code == 200){
	                        		me.$data.adlist = data.data.items;
	                        	}
	                        }
	                    });
					},
					"first": function(){
						this.loadData(1);
					},					
					"end": function(){
						this.loadData(this.$data.pageData.pageCount);
					},				
					"pre": function(){
						this.loadData(this.$data.pageData.page-1);
					},				
					"next": function(){
						this.loadData(this.$data.pageData.page+2);
					},
					"edit": function(vo){
						Widget.Edit.$data.id = vo.id;
						Widget.Edit.$data.name = vo.name;
						Widget.Edit.$data.ad_id = vo.ad_id;
						Widget.Edit.$data.style = vo.style;
						//Widget.Edit.$data.image = vo.image;
	                    $("#DlgNew").modal("show");
					}
				}
			});
			Widget.CyList.loadData();
		});
    </script>
{% endblock %}