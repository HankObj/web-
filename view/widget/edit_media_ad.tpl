{% raw %}
<div class="modal fade" id="DlgNew" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				<span class="sr-only">关闭</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">编辑广告位</h4>
			</div>
			<div class="modal-body">
				<div class="alert alert-danger hide" role="alert">
					<button type="button" class="close" data-dismiss="alert" aria-label="Close">
						<span aria-hidden="true">&times;</span>
						<span class="sr-only">Close</span>
					</button>
					<strong>{{alertText}}</strong>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 form-control-label text-right">名称</label>
					<div class="col-sm-9">
						<input type="text" v-model="name" class="form-control" placeholder="广告位名称">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 form-control-label text-right">选择媒体</label>
					<div class="col-sm-9">
						<select v-model="media_id" class="form-control c-select">
							<option value="-1">选择媒体</option>
							<template v-for="item in mdList">
								<option :value="item.id">{{item.name}}</option>
							</template>
						</select>
					</div>
				</div>				
				<div class="form-group row">
					<label class="col-sm-2 form-control-label text-right">选择样式</label>
					<div class="col-sm-9">
						<label>
							<figure class="figure">
								<img src="http://static.wkanx.com/w001/M00/05/2D/Cgp4R1hvC9-AUp5uAAA1BY7jVh0727.jpg" alt="..." class="img-thumbnail">
								<figcaption class="figure-caption"><input type="radio" v-model="style" value="1">&nbsp;横幅图片</figcaption>
							</figure>
						</label>							
						<label>
							<figure class="figure">
								<img src="http://static.wkanx.com/w001/M00/00/46/Cgp4R1brpjaARL2nAABUGOaPUOU247.jpg" alt="..." class="img-thumbnail">
								<figcaption class="figure-caption"><input type="radio" v-model="style" value="2">&nbsp;横幅图文</figcaption>
							</figure>							
						</label>						
						<label>
							<figure class="figure">
								<img src="http://static.wkanx.com/w001/M00/00/46/Cgp0RVbrpjKAAbZUAABl3v4twCo437.jpg" alt="..." class="img-thumbnail">
								<figcaption class="figure-caption"><input type="radio" v-model="style" value="3">&nbsp;三图图文</figcaption>
							</figure>
						</label>							
					</div>
				</div>
			</div>
			<div class="modal-footer text-center">
				<button @click="submit" type="button" class="btn btn-primary btn-lg">保存</button>
			</div>
		</div>
	</div>
</div>
{% endraw %}
<script type="text/javascript">
	$(function(){
		Widget.Edit = new Vue({
			el: "#DlgNew",
			data: {
				alertText: "",
				id: "",
				media_id: "-1",
				name: "",
				style: "",
				type: "",
                mdList: []
			},
			methods: {
				"loadMdData": function(){
                    var loading = weui.loading('数据加载中',{
					    className: 'loading1'
					});
                    var me = this;
                    $.ajax({
                        type: "GET",
                        url: "{{config.host}}/v1/media-list",
						data: {
						    'access-token': "{{token}}",
							'status': "all"
						},
                        dataType: "json",
                        success: function(data){
                            if(data.code == 200){
                                me.$data.mdList = data.data;
                                //loading.hide();
                            }else{
                        		alert(data.msg);
                            }
                        }
                    });
                },
				"submit": function(){
					var me = this;
					if(!this.$data.name){
						weui.topTips('广告位名称不能为空');
						return false;
					}						
					if(!this.$data.style){
						weui.topTips('广告样式不能为空');
						return false;
					}						
					if(this.$data.id){
	                    $.ajax({
	                        url: "/put",
	                        type: "POST",
	                        data: {
	                        	"url": "{{config.host}}/v1/place/" + this.$data.id + "?access-token=" + encodeURIComponent('{{token}}'),
	                        	"data": JSON.stringify({
		                        	name: this.$data.name,
		                        	media_id: this.$data.media_id,
		                        	style: this.$data.style,
		                        	type: this.$data.type
	                        	})
	                        },
	                        dataType: "json",
	                        success: function(data){
                        		if(data.code == 200){
	                        		$("#DlgNew").modal("hide");
            						Widget.Media.loadData();
	                        	}else{
                        			alert(data.msg);
	                        	}
	                        }
	                    });					
					}else{
	                    $.ajax({
	                        type: "POST",
	                        url: "{{config.host}}/v1/place?access-token=" + encodeURIComponent('{{token}}'),
	                        data: {
	                        	name: this.$data.name,
	                        	media_id: this.$data.media_id,
	                        	style: this.$data.style,
	                        	type: this.$data.type
	                        },
	                        dataType: "json",
	                        success: function(data){
	                        	if(data.code == 200){
	                        		$("#DlgNew").modal("hide");
            						Widget.Media.loadData();
	                        	}else{
                        			alert(data.msg);
	                        	}
	                        }
	                    });
	                }
				}
			}
		});
		//加载媒体数据
		Widget.Edit.loadMdData();
	});
</script>