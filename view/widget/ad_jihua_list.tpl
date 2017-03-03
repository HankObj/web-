{% raw %}
<table class="AdList table table-bordered table-striped hide" :class="{show:list.length>0}">
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
		<template v-for="(litem,index) in list">
			<tr>
				<td v-if="page!='index'"><a :href="'/tuiguang/chuangyi?ad_id=' + litem.id">{{litem.name}}<i class="fa fa-bars" aria-hidden="true"></i></a></td>
				<td v-if="page=='index'">
					<div v-if="!(litem.ideaList.length>0)">
						<span class="action" @click="loadCyData(index, litem.id)"><i class="fa fa-plus" aria-hidden="true"></i>&nbsp;{{litem.name}}</span>
					</div>
					<div v-if="(litem.ideaList.length>0)">
						<span class="action" @click="close(index,false)"><i class="fa fa-minus" aria-hidden="true"></i>&nbsp;{{litem.name}}</span>
					</div>
				</td>
					<td v-if="litem.status"><span class="text-success">运行中</span></td>
					<td v-if="!litem.status"><span class="text-warning">未运行</span></td>
					<td>{{litem.display}}</td>
					<td>{{litem.click}}</td>
					<td>{{(0)}}</td>
				<td>
					<span class="icon" @click="edit(litem.id, litem.name)"><i class="fa fa-edit action" aria-hidden="true"></i>编辑</span>
				</td>
			</tr>
			<template v-for="(iitem,iindex) in litem.ideaList">
				<tr>
					<td>
						<div class="idea-list">
							<div v-if="!(iitem.planList.length>0)">
								<span class="action" @click="loadJhData(index,iindex,iitem.id)"><i class="fa fa-plus" aria-hidden="true"></i>&nbsp;{{iitem.name}}</span>
							</div>
							<div v-if="(iitem.planList.length>0)">
								<span class="action" @click="closeIdea(index,iindex)"><i class="fa fa-minus" aria-hidden="true"></i>&nbsp;{{iitem.name}}</span>
							</div>
						</div>
					</td>
					<td v-if="iitem.status"><span class="text-success">运行中</span></td>
					<td v-if="!iitem.status"><span class="text-warning">未运行</span></td>
					<td>{{iitem.display}}</td>
					<td>{{iitem.click}}</td>
					<td>{{(iitem.click>0?parseInt(iitem.click/iitem.display)*100 + "%" : "0")}}</td>
					<td>
						<a class="icon" :href="'/tuiguang/chuangyi/new?id='+iitem.id"><i class="fa fa-edit action" aria-hidden="true"></i>编辑</a>
					</td>
				</tr>				
				<tr v-for="(pitem,pindex) in iitem.planList">
					<td>
						<div class="plan-list">
							<div>{{pitem.name}}</div>
						</div>
					</td>
					<td v-if="pitem.status"><span class="text-success">运行中</span></td>
					<td v-if="!pitem.status"><span class="text-warning">未运行</span></td>
					<td>{{pitem.display}}</td>
					<td>{{pitem.click}}</td>
					<td>{{pitem.click_lv}}</td>
					<td>
						<a class="icon" :href="'/tuiguang/jihua/new?id='+pitem.id"><i class="fa fa-edit action" aria-hidden="true"></i>编辑</a>
						<span class="icon" @click="stop(pitem.id,index,iindex,iitem.id)" v-if="pitem.status==1"><i class="fa fa-pause action" aria-hidden="true"></i>暂停</span>
						<span class="icon" @click="start(pitem.id,index,iindex,iitem.id)" v-if="pitem.status==0"><i class="fa fa-play action" aria-hidden="true"></i>启动</span>
					</td>
				</tr>
			</template>
		</template>	
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
{% endraw %}
<script type="text/javascript">
	$(function(){
		Widget.AdList = new Vue({
			el: ".AdList",
			data: {
				page: "{{page}}",
				pageData: {
					total: 0,
					pageCount: 0
				},
				list: []
			},
			methods: {
				"loadData": function(pn){
					var loading = weui.loading('数据加载中');
					var me = this;
                    $.ajax({
                        type: "GET",
                        url: "{{config.host}}/v1/ad",
                        data: {
                            'access-token': "{{token}}",
                        	page: pn || 1
                        },
                        dataType: "json",
                        success: function(data){
                        	if(data.code == 200){
                        		for(var i=0;i<data.data.items.length;i++){
                        			data.data.items[i].ideaList = [];
                        		}
                        		me.$data.list = data.data.items;
                        		me.$data.pageData = data.data.pagination;
								loading.hide();
                        	}else{
                        		alert(data.msg);
                        	}
                        }
                    });
				},	
				//加载创意数据
				"loadCyData": function(index,id){
					var me = this;
					var loading = weui.loading('数据加载中');
					var me = this;
                    $.ajax({
                        type: "GET",
                        url: "{{config.host}}/v1/idea",
                        data: {
                        	ad_id: id,
                            'access-token': "{{token}}",
                        },
                        dataType: "json",
                        success: function(data){
                        	if(data.code == 200){
                           		for(var i=0;i<data.data.items.length;i++){
                        			data.data.items[i].planList = [];
                        		}
                        		me.$data.list[index].ideaList = data.data.items;
								loading.hide();
								if(data.data.items.length==0){
									weui.toast('没有数据', {
									    duration: 1500,
									    className: 'custom-classname',
									});
								}
                        	}else{
                        		alert(data.msg);
                        	}
                        }
                    });
				},					
				//加载计划数据
				"loadJhData": function(pindex,index,id){
					var me = this;
					var loading = weui.loading('数据加载中');
					var me = this;
                    $.ajax({
                        type: "GET",
                        url: "{{config.host}}/v1/plan",
                        data: {
                        	idea_id: id,
                            'access-token': "{{token}}",
                        },
                        dataType: "json",
                        success: function(data){
                        	if(data.code == 200){
                        		me.$data.list[pindex].ideaList[index].planList = data.data.items;
								loading.hide();
								if(data.data.items.length == 0){
									weui.toast('没有数据', {
									    duration: 1500,
									    className: 'custom-classname',
									});
								}
                        	}else{
                        		alert(data.msg);
                        	}
                        }
                    });
				},	
				"close": function(pindex){
					this.$data.list[pindex].ideaList = [];
				},				
				"closeIdea": function(pindex,index){
					this.$data.list[pindex].ideaList[index].planList = [];
				},
				"start": function(id,pindex,index,id){
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
								me.loadJhData(pindex,index,id);
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
								me.loadJhData(pindex,index,id);
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