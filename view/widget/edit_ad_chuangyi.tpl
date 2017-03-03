{% raw %}
<div class="modal fade" id="DlgNew" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				<span class="sr-only">关闭</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">创建广告创意</h4>
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
					<label class="col-sm-2 form-control-label text-right">创意名称</label>
					<div class="col-sm-9">
						<input type="text" v-model="name" class="form-control" placeholder="创意名称">
					</div>
				</div>						
				<div class="form-group row">
					<label class="col-sm-2 form-control-label text-right">广告</label>
					<div class="col-sm-9">
						<select v-model="ad_id" class="form-control c-select">
							<option value="0">请选择广告</option>
							<template v-for="litem in adList">
								<option :value="litem.id">{{litem.name}}</option>
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
								<figcaption class="figure-caption"><input type="radio" v-model="style" name="style" value="1">&nbsp;横幅图片</figcaption>
							</figure>
						</label>							
						<label>
							<figure class="figure">
								<img src="http://static.wkanx.com/w001/M00/00/46/Cgp4R1brpjaARL2nAABUGOaPUOU247.jpg" alt="..." class="img-thumbnail">
								<figcaption class="figure-caption"><input type="radio" v-model="style" name="style" value="2">&nbsp;横幅图文</figcaption>
							</figure>							
						</label>							
						<label>
							<figure class="figure">
								<img src="http://static.wkanx.com/w001/M00/00/46/Cgp0RVbrpjKAAbZUAABl3v4twCo437.jpg" alt="..." class="img-thumbnail">
								<figcaption class="figure-caption"><input type="radio" v-model="style" name="style" value="3">&nbsp;三图图文</figcaption>
							</figure>
						</label>							
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 form-control-label text-right">上传素材</label>
					<div class="col-sm-4">
						<label class="file">
							<input class="upload" type="file" @change="upload" multiple="multiple">
							<span class="file-custom"></span>
						</label>
					</div>					
					<div class="col-sm-4">
						<div v-show="false" class="weui-loadmore" style="margin: 8px auto;text-align:left;">
						    <i class="weui-loading"></i>
						    <span class="weui-loadmore__tips">正在上传</span>
						</div>
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
				pageData: {
					total: 0
				},
				adList: [],
				name: "",
				ad_id: "0",
				id: "",
				style: "",
				image: [],
				uploading: true
			},
			methods: {
				"loadAdData": function(){
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
                        		me.$data.adList = data.data.items;
                        	}else{
                        		alert(data.msg);
                        	}
                        }
                    });
				},
				"upload": function(){
					var me = this;
					Widget.loading = weui.loading('素材上传中...');
					me.$data.uploading = true;
	                var me = this;
	                var formData = new FormData();
	                var files = $('.upload')[0].files;
	                for(var i=0;i<files.length;i++){
	                	formData.append('imgFiles[]', files[i]);
	                }
	                $.ajax({
	                    cache: true,
	                    type: "POST",
	                    url: '{{config.host}}/v1/image',
	                    data: formData,
	                    async: false,     
	                    processData: false,
	                    contentType: false,             
	                    success: function (data) {
	                    	console.log(data);
	                    	Widget.loading.hide();
	                    	me.$data.image = data.data;
							me.$data.uploading = false;
	                    },
	                    error: function (request) {
	                    	Widget.loading.hide();
	                        alert("Connection error");
							me.$data.uploading = false;
	                    }
	                });
				},
				"submit": function(){
					if(!this.$data.name){
						weui.topTips('创意名称不能为空');
						return false;
					}						
					if(!this.$data.ad_id){
						weui.topTips('广告不能为空');
						return false;
					}						
					if(!this.$data.style){
						weui.topTips('广告样式不能为空');
						return false;
					}						
					if(!this.$data.image){
						//weui.topTips('素材不能为空');
						//return false;
					}
					if(this.$data.id){
	                    $.ajax({
	                        type: "POST",
	                        url: "{{config.host}}/v1/idea/update?id=" + this.$data.id,
	                        data: {
	                        	name: this.$data.name,
	                        	ad_id: this.$data.ad_id,
	                        	style: this.$data.style,
	                        	image: this.$data.image
	                        	//"csrf-zlong": CSRF,
	                        },
	                        dataType: "json",
	                        success: function(data){
	                        	if(data.code == 200){
	                        		$("#DlgNew").modal("hide");
	                        		Widget.CyList.loadData();
	                        	}else{
                        			alert(data.msg);
	                        	}
	                        }
	                    });						
					}else{
	                    $.ajax({
	                        type: "POST",
	                        url: "{{config.host}}/v1/idea/create",
	                        data: {
	                        	name: this.$data.name,
	                        	ad_id: this.$data.ad_id,
	                        	style: this.$data.style,
	                        	image: this.$data.image
	                        	//"csrf-zlong": CSRF,
	                        },
	                        dataType: "json",
	                        success: function(data){
	                        	if(data.code == 200){
	                        		$("#DlgNew").modal("hide");
	                        		Widget.CyList.loadData()
	                        	}else{
                        			alert(data.msg);
	                        	}
	                        }
	                    });
	                }
				}
			}
		});
		//加载广告数据
		Widget.Edit.loadAdData();
	});
</script>