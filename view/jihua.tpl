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
    	<div class="JhList block">
    		<div class="clearfix">
    			<div class="pull-left">
					<a class="btn btn-primary" href="/tuiguang/jihua/new">创建广告计划</a>
    			</div>
    			<div class="pull-right row">
    				<div class="col-sm-4">
						<select @change="loadData()" v-model="ad_id" class="form-control c-select">
							<option value="-1">所属广告单元</option>
							<template v-for="item in adlist">
								<option :value="item.id">{{item.name}}</option>
							</template>
						</select>
					</div>     				
					<div class="col-sm-4">
						<select @change="loadData()" v-model="idea_id" class="form-control c-select">
							<option value="-1">所属广告创意</option>
							<template v-for="item in idealist">
								<option :value="item.id">{{item.name}}</option>
							</template>
						</select>
					</div>    				
					<div class="col-sm-4">
						<select @change="loadData()" v-model="time" class="form-control c-select">
							<option value="-1">选择时间范围</option>
							<option value="today">今天</option>
							<option value="yesterday">昨天</option>
							<option value="lately_3">最近一天</option>
							<option value="lately_7">最近一周</option>
							<option value="lately_14">最近两周</option>
							<option value="lately_30">最近30天</option>
						</select>
					</div>
    			</div>
    		</div>
    		<br>
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-active">
						<th width="350">广告</th>
						<th>运行状态</th>
						<th>展现</th>
						<th>点击</th>
						<th>点击率</th>
						<th width="160">操作</th>
					</tr>
				</thead>
				<tbody>
					<tr v-for="litem in list">
						<td>{{litem.name}}</td>
						<td><span class="text-warning">未运行</span></td>
						<td>{{litem.display}}</td>
						<td>{{litem.click}}</td>
						<td>{{(litem.click>0?parseInt(litem.click/litem.display)*100 + "%" : "0")}}</td>
						<td>
							<span class="icon" @click="stop(litem.id)" v-if="litem.status==1"><i class="fa fa-pause action" aria-hidden="true"></i>暂停</span>
							<span class="icon" @click="start(litem.id)" v-if="litem.status==0"><i class="fa fa-play action" aria-hidden="true"></i>启动</span>
							<a class="icon" :href="'/tuiguang/jihua/new?id='+litem.id"><i class="fa fa-edit action" aria-hidden="true"></i>编辑</a>
						</td>
					</tr>					
					<tr>
						<td colspan="7">
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
    </div>
	{% endraw %}
	<script type="text/javascript">
		$(function(){
			Widget.AdList = new Vue({
				el: ".JhList",
				data: {
					pageData: {
						total: 0,
						pageCount: 0
					},
					adlist: [],
					idealist: [],
					ad_id: "-1",
					idea_id: "{{idea_id}}",
					time: "today",
					list: []
				},
				methods: {
					"loadData": function(pn){
						Widget.loading = weui.loading('数据加载中');
						var me = this;
	                    $.ajax({
	                        type: "GET",
	                        url: "{{config.host}}/v1/plan",
	                        data: {
    							'access-token': "{{token}}",
	                        	ad_id: me.$data.ad_id != "-1"?me.$data.ad_id:"",
	                        	idea_id: me.$data.idea_id != "-1"?me.$data.idea_id:"",
								time: me.$data.time != "-1"?me.$data.time:"",
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
					"loadAdData": function(){
						var me = this;
						var me = this;
	                    $.ajax({
	                        type: "GET",
	                        url: "{{config.host}}/v1/ad",
	                        data: {
    							'access-token': "{{token}}",
	                        },
	                        dataType: "json",
	                        success: function(data){
	                        	if(data.code == 200){
	                        		me.$data.adlist = data.data.items;
	                        		me.loadIdeaData();
	                        	}
	                        }
	                    });
					},						
					//加载广告创意			
					"loadIdeaData": function(){
						var me = this;
						var me = this;
	                    $.ajax({
	                        type: "GET",
	                        url: "{{config.host}}/v1/idea",
	                        data: {
    							'access-token': "{{token}}",
	                        	ad_id: me.$data.ad_id != "-1"?me.$data.ad_id:"",
	                        },
	                        dataType: "json",
	                        success: function(data){
	                        	if(data.code == 200){
	                        		me.$data.idealist = data.data.items;
	                        	}
	                        }
	                    });
					},		
					"start": function(id){
						var me = this;
	                    $.ajax({
	                        type: "GET",
	                        url: "{{config.host}}/v1/plan-start/" + id,
	                        data: {
    							'access-token': "{{token}}"
	                        },
	                        dataType: "json",
	                        success: function(data){
	                        	if(data.code == 200){
	                        		console.log(data);
									Widget.AdList.loadData();
	                        	}else{
                        			alert(data.msg);
	                        	}
	                        }
	                    });
					},				
					"stop": function(id){
						var me = this;
	                    $.ajax({
	                        type: "GET",
	                        url: "{{config.host}}/v1/plan-stop/" + id,
	                        data: {
    							'access-token': "{{token}}"
	                        },
	                        dataType: "json",
	                        success: function(data){
	                        	if(data.code == 200){
	                        		console.log(data);
									Widget.AdList.loadData();
	                        	}else{
                        			alert(data.msg);
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
					"edit": function(id, name){
						Widget.New.$data.id = id;
						Widget.New.$data.name = name;
	                    $("#DlgNew").modal("show");
					}
				}
			});
			Widget.AdList.loadData();
		});
	</script>
{% endblock %}