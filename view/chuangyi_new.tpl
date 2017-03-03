{% extends "widget/layout.tpl" %}
{% block title %}创建广告计划-子龙广告平台{% endblock %}
{% block body %}
	{% include "./widget/top_bar.tpl" %}
	{% include "./widget/main_nav.tpl" %}
	{% raw %}
	<br>
    <div class="Chuangyi container">
	    <div class="block">
			<div class="modal-header">
				<h4 class="modal-title">编辑广告创意</h4>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-md-11">
						<div class="form-group row">
							<label class="col-sm-2 form-control-label text-right">创意名称</label>
							<div class="col-sm-10">
								<input type="text" v-model="name" class="form-control" placeholder="创意名称">
							</div>
						</div>		
						<div class="form-group row">
							<label class="col-sm-2 form-control-label text-right">广告</label>
							<div class="col-sm-10">
								<select v-model="ad_id" class="form-control c-select">
									<option value="-1">请选择广告</option>
									<template v-for="litem in adList">
										<option :value="litem.id">{{litem.name}}</option>
									</template>
								</select>
							</div>
						</div>					
						<div class="form-group row">
							<label class="col-sm-2 form-control-label text-right">选择样式</label>
							<div class="col-sm-10">
								<label style="margin-right: 20px;">
									<figure class="figure">
										<img src="http://static.wkanx.com/w001/M00/05/2D/Cgp4R1hvC9-AUp5uAAA1BY7jVh0727.jpg" alt="..." class="img-thumbnail">
										<figcaption class="figure-caption"><input @click="reStyle" type="radio" v-model="style" name="style" value="1">&nbsp;横幅图片</figcaption>
									</figure>
								</label>							
								<label style="margin-right: 20px;">
									<figure class="figure">
										<img src="http://static.wkanx.com/w001/M00/00/46/Cgp4R1brpjaARL2nAABUGOaPUOU247.jpg" alt="..." class="img-thumbnail">
										<figcaption class="figure-caption"><input @click="reStyle" type="radio" v-model="style" name="style" value="2">&nbsp;横幅图文</figcaption>
									</figure>							
								</label>							
								<label>
									<figure class="figure">
										<img src="http://static.wkanx.com/w001/M00/00/46/Cgp0RVbrpjKAAbZUAABl3v4twCo437.jpg" alt="..." class="img-thumbnail">
										<figcaption class="figure-caption"><input @click="reStyle" type="radio" v-model="style" name="style" value="3">&nbsp;三图图文</figcaption>
									</figure>
								</label>							
							</div>
						</div>
						<div class="form-group row">
							<label class="col-sm-2 form-control-label text-right">创意描述</label>
							<div class="col-sm-10">
								<input type="text" v-model="txt" class="form-control" placeholder="创意描述">
							</div>
						</div>
						<div class="form-group row" v-for="(item,index) in uploads">
							<label class="col-sm-2 form-control-label text-right">上传素材</label>
							<div class="col-sm-4">
								<label class="file">
									<input class="upload" type="file" @change="upload(index)">
									<span class="file-custom"></span>
								</label>
							</div>					
							<div class="col-sm-4">
								<img style="position:relative;left:50px;" height="36" class="view" :src="'http://'+item">
							</div>
						</div>
					</div>
					<div class="col-md-3" v-show="false">
						<div class="iphone">
							<template v-for="item in image">
								<img class="img-rounded" :class="'style'+style" :src="'http://'+item">
							</template>
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
			Widget.Chuangyi = new Vue({
				el: ".Chuangyi",
				data: {
					alertText: "",
					pageData: {
						total: 0
					},
					adList: [],
					name: "",
					ad_id: "-1",
					id: "{{id}}",
					style: "",
					txt: "",
					image: [],
					uploading: true,
					uploads: [""]
				},
				methods: {
					"loadAdData": function(){
						var me = this;
	                    $.ajax({
	                        type: "GET",
	                        url: "{{config.host}}/v1/ad",
	                        data: {
	                        	"access-token": "{{token}}"
	                        },
	                        dataType: "json",
	                        success: function(data){
	                        	if(data.code == 200){
	                        		me.$data.adList = data.data.items;
	                        		me.loadCyData();
	                        	}else{
                        			alert(data.msg);
	                        	}
	                        }
	                    });
					},
					"loadCyData": function(){
						var me = this;
						if(this.$data.id){
		                    $.ajax({
		                        type: "GET",
		                        url: "{{config.host}}/v1/idea/" + me.$data.id,
		                        data: {
                            		'access-token': "{{token}}",
		                        },
		                        dataType: "json",
		                        success: function(data){
		                        	if(data.code == 200){
		                        		me.$data.id = data.data.id;
		                        		me.$data.name = data.data.name;
		                        		me.$data.style = data.data.style;
		                        		if(data.data.image){
		                        			me.$data.image = JSON.parse(data.data.image);
		                        			me.$data.uploads = me.$data.image;
		                        		}
		                        		me.$data.txt = data.data.txt;
		                        		me.$data.ad_id = data.data.ad_id;
		                        	}else{
                        				alert(data.msg);
		                        	}
		                        }
		                    });
	                	}
					},
					"reStyle": function(){
						var len = this.$data.style == 3?3:1;
						if(len == 3 && this.$data.image.length < 3){
							this.$data.image.length = 3;
						}else{
							this.$data.image.length = 1;
						}
						this.$data.uploads = this.$data.image.slice(0,len);
					},
					"upload": function(index){
						var me = this;
						Widget.loading = weui.loading('素材上传中...');
						me.$data.uploading = true;
		                var me = this;
		                var formData = new FormData();
		                var file = $('.upload')[index].files[0];
		                formData.append('imgFiles', file);
		                $.ajax({
		                    cache: true,
		                    type: "POST",
		                    url: '{{config.host}}/v1/image?access-token=' + encodeURIComponent('{{token}}'),
		                    data: formData,
		                    async: true,     
		                    processData: false,
		                    contentType: false,             
		                    success: function (data) {
		                    	console.log(data);
		                    	Widget.loading.hide();
		                    	me.$data.image[index] = data.data[0];
		                    	me.reStyle();
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
						if(!this.$data.txt){
							weui.topTips('创意描述不能为空');
							return false;
						}						
						if(!this.$data.style){
							weui.topTips('广告样式不能为空');
							return false;
						}						
						if(!this.$data.uploads || (this.$data.style == 3 && (!this.$data.uploads[1] || !this.$data.uploads[2]))){
							weui.topTips('素材不能为空');
							return false;
						}
						if(this.$data.id){
		                    $.ajax({
		                        url: "/put",
		                        type: "POST",
		                        data: {
		                        	"url": "{{config.host}}/v1/idea/" + this.$data.id + "?access-token=" + encodeURIComponent('{{token}}'),
		                        	"data": JSON.stringify({
			                        	"name": this.$data.name,
		                        		"ad_id": this.$data.ad_id,
			                        	"txt": this.$data.txt,
			                        	"style": this.$data.style,
			                        	"image": JSON.stringify(this.$data.uploads)
		                        	})
		                        },
		                        dataType: "json",
		                        success: function(data){
		                        	if(data.code == 200){
		                        		$("#DlgNew").modal("hide");
		                        		window.location.href = "/tuiguang/chuangyi";
		                        	}else{
                        				alert(data.msg);
		                        	}
		                        }
		                    });						
						}else{
		                    $.ajax({
		                        type: "POST",
		                        url: "{{config.host}}/v1/idea?access-token=" + encodeURIComponent('{{token}}'),
		                        data: {
		                        	name: this.$data.name,
		                        	ad_id: this.$data.ad_id,
		                        	style: this.$data.style,
		                        	txt: this.$data.txt,
		                        	image: this.$data.uploads
		                        	//"csrf-zlong": CSRF,
		                        },
		                        dataType: "json",
		                        success: function(data){
		                        	if(data.code == 200){
		                        		$("#DlgNew").modal("hide");
		                        		window.location.href = "/tuiguang/chuangyi";
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
			Widget.Chuangyi.loadAdData();
		});
	</script>
{% endblock %}