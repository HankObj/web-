{% extends "widget/layout.tpl" %}
{% block title %}编辑广告计划-子龙广告{% endblock %}
{% block body %}
	{% include "./widget/top_bar.tpl" %}
	{% include "./widget/main_nav.tpl" %}
	{% raw %}
	<br>
    <div class="NewJihua container">
	    <div class="block">
			<div class="modal-header">
				<h4 class="modal-title">编辑广告计划</h4>
			</div>
			<div class="modal-body">
				<div class="form-group row">
					<label class="col-sm-2 form-control-label text-right">计划名称</label>
					<div class="col-sm-9">
						<input type="text" v-model="form.name" class="form-control" placeholder="计划名称">
					</div>
				</div>					
				<div class="form-group row">
					<label class="col-sm-2 form-control-label text-right">广告单元</label>
					<div class="col-sm-9">
						<select @change="reAd()" v-model="form.ad_id" class="form-control c-select" placeholder="请选择广告单元">
							<option value="-1">请选择广告单元</option>
							<template v-for="item in adList">
								<option :value="item.id">{{item.name}}</option>
							</template>
						</select>
					</div>
				</div>					
				<div class="form-group row">
					<label class="col-sm-2 form-control-label text-right">选择创意</label>
					<div class="col-sm-9">
						<select v-model="form.idea_id" class="form-control c-select" placeholder="请选择广告创意">
							<option value="-1">请选择广告创意</option>
							<template v-for="litem in ideaList">
								<option :value="litem.id">{{litem.name}}</option>
							</template>
						</select>
					</div>
				</div>				
				<div class="form-group row">
					<label class="col-sm-2 form-control-label text-right">选择媒体</label>
					<div class="col-sm-9">
						<select v-model="form.media_id" @change="reMedia()" class="form-control c-select">
							<option value="-1">选择媒体</option>
							<template v-for="litem in mediaList">
								<option :value="litem.id">{{litem.name}}</option>
							</template>
						</select>
					</div>
				</div>					
				<div class="form-group row" v-if="mdList.length>0">
					<label class="col-sm-2 form-control-label text-right">选择广告位</label>
					<div class="col-sm-9">
						<select v-model="form.place_id" class="form-control c-select">
							<option value="-1">选择广告位</option>
							<template v-for="litem in mdList">
								<option :value="litem.id">{{litem.name}}</option>
							</template>
						</select>
					</div>
				</div>	
				<div class="form-group row">
					<label class="col-sm-2 form-control-label text-right">推广网址</label>
					<div class="col-sm-9">
						<input v-model="form.url" type="text" name="" class="form-control" placeholder="推广网址">
					</div>
				</div>								
				<div class="form-group row">
					<label class="col-sm-2 form-control-label text-right">计费类型</label>
					<div class="col-sm-9">
						<label class="radio-inline">
							<input v-model="form.charge_type" type="radio" value="1">&nbsp;CPC
						</label>							
						<label class="radio-inline">
							<input v-model="form.charge_type" type="radio" value="2">&nbsp;CPM
						</label>
					</div>
				</div>	
				<div class="form-group row">
					<label class="col-sm-2 form-control-label text-right">出价</label>
					<div class="col-sm-2">
						<div class="input-group">
							<input v-model="form.price" type="text" name="" class="form-control" placeholder="出价">
							<span class="input-group-addon">元</span>
						</div>
					</div>
				</div>											
				<div class="field-group">
					<div class="form-group row">
						<label class="col-sm-2 form-control-label text-right">投放地域</label>
						<div class="col-sm-9">
							<label class="radio-inline radio-diy-hide">
								<input v-model="form.region" type="radio" value="all">&nbsp;全部地域
							</label>							
							<label class="radio-inline radio-diy">
								<span>
									<input v-model="form.region" type="radio" value="diy">&nbsp;自定义
								</span>
							</label>
						</div>
					</div>	
					<div class="form-group row">
						<div class="col-sm-2"></div>
						<div class="col-sm-9">
							<div class="collapse">
								<table class="table table-bordered table-sm">
									<template v-for="item in areas">
										<tr class="table-active">
											<th>
												<label class="radio-inline">
													<span>
														<input type="checkbox">&nbsp;{{item.name}}
													</span>
												</label>
											</th>
										</tr>
										<template v-for="iitem in item.data">
											<tr v-if="item.name=='中国'">
												<td>
													<div class="row">
														<div class="col-sm-2">
															<label class="radio-inline">
																<input type="checkbox">&nbsp;{{iitem.name}}
															</label>
														</div>
														<div class="col-sm-10">
															<label v-for="iiitem in iitem.data" class="radio-inline radio-diy">
																<span>
																	<input type="checkbox">&nbsp;{{iiitem.name}}
																</span>
															</label>
														</div>
													</div>
												</td>
											</tr>
										</template>
									</template>
								</table>
							</div>
						</div>					
					</div>					
				</div>
				<div class="field-group">
					<div class="form-group row">
						<label class="col-sm-2 form-control-label text-right">手机品牌</label>
						<div class="col-sm-9">
							<label class="radio-inline radio-diy-hide">
								<input v-model="form.mobile_brand" type="radio" value="all">&nbsp;全部品牌
							</label>							
							<label class="radio-inline radio-diy">
								<span>
									<input v-model="form.mobile_brand" type="radio" value="diy">&nbsp;自定义
								</span>
							</label>
						</div>
					</div>	
					<div class="form-group row">
						<div class="col-sm-2"></div>
						<div class="col-sm-9">
							<div class="collapse" :class="form.mobile_brand=='diy'?'in':''">
								<div class="card card-block">
									<label class="checkbox-inline" v-for="(item,key,index) in config.mobileBrands">
										<input v-model="subform.mobile_brand" type="checkbox" :value="key">&nbsp;{{item}}
									</label>							
								</div>
							</div>					
						</div>					
					</div>					
				</div>					
				<div class="field-group">
					<div class="form-group row">
						<label class="col-sm-2 form-control-label text-right">手机档次</label>
						<div class="col-sm-9">
							<label class="radio-inline radio-diy-hide">
								<input v-model="form.mobile_level" type="radio" value="all">&nbsp;全部档次
							</label>							
							<label class="radio-inline radio-diy">
								<span>
									<input v-model="form.mobile_level" type="radio" value="diy">&nbsp;自定义
								</span>
							</label>
						</div>
					</div>	
					<div class="form-group row">
						<div class="col-sm-2"></div>
						<div class="col-sm-9">
							<div class="collapse" :class="form.mobile_level=='diy'?'in':''">
								<div class="card card-block">
									<label class="checkbox-inline" v-for="(item,key,index) in config.mobileLevel">
										<input v-model="subform.mobile_level" type="checkbox" :value="key">&nbsp;{{item}}
									</label>							
								</div>
							</div>					
						</div>					
					</div>						
				</div>						
				<div class="field-group">
					<div class="form-group row">
						<label class="col-sm-2 form-control-label text-right">操作系统</label>
						<div class="col-sm-9">
							<label class="radio-inline radio-diy-hide">
								<input v-model="form.mobile_system" type="radio" value="all">&nbsp;所有版本
							</label>							
							<label class="radio-inline radio-diy">
								<span>
									<input v-model="form.mobile_system" type="radio" value="diy">&nbsp;自定义
								</span>
							</label>
						</div>
					</div>	
					<div class="form-group row">
						<div class="col-sm-2"></div>
						<div class="col-sm-9">
							<div class="collapse" :class="form.mobile_system=='diy'?'in':''">
								<div class="card card-block">
									<label class="checkbox-inline" v-for="(item,key,index) in config.mobileSystem">
										<input v-model="subform.mobile_system" type="checkbox" :value="key">&nbsp;{{item}}
									</label>							
								</div>
							</div>					
						</div>					
					</div>					
				</div>					
				<div class="field-group">
					<div class="form-group row">
						<label class="col-sm-2 form-control-label text-right">年龄</label>
						<div class="col-sm-9">
							<label class="radio-inline radio-diy-hide">
								<input v-model="form.age" type="radio" value="all">&nbsp;不限年龄
							</label>							
							<label class="radio-inline radio-diy">
								<span>
									<input v-model="form.age" type="radio" value="diy">&nbsp;自定义
								</span>
							</label>
						</div>
					</div>
					<div class="form-group row">
						<div class="col-sm-2"></div>
						<div class="col-sm-9">
							<div class="collapse" :class="form.age=='diy'?'in':''">
								<div class="card card-block">
									<label class="checkbox-inline" v-for="(item,key,index) in config.age">
										<input v-model="subform.age" type="checkbox" :value="key">&nbsp;{{item}}
									</label>					
								</div>
							</div>					
						</div>					
					</div>				
				</div>				
				<div class="form-group row">
					<label class="col-sm-2 form-control-label text-right">投放时段</label>
					<div class="col-sm-9">
						<div>
							<label class="checkbox-inline">
								<input v-model="form.time_slof.week" type="checkbox" value="1">&nbsp;周一
							</label>							
							<label class="checkbox-inline">
								<input v-model="form.time_slof.week" type="checkbox" value="2">&nbsp;周二
							</label>							
							<label class="checkbox-inline">
								<input v-model="form.time_slof.week" type="checkbox" value="3">&nbsp;周三
							</label>							
							<label class="checkbox-inline">
								<input v-model="form.time_slof.week" type="checkbox" value="4">&nbsp;周四
							</label>							
							<label class="checkbox-inline">
								<input v-model="form.time_slof.week" type="checkbox" value="5">&nbsp;周五
							</label>							
							<label class="checkbox-inline">
								<input v-model="form.time_slof.week" type="checkbox" value="6">&nbsp;周六
							</label>							
							<label class="checkbox-inline">
								<input v-model="form.time_slof.week" type="checkbox" value="0">&nbsp;周日
							</label>	
						</div>
						<hr>
						<template v-for="tt in form.time_slof.time">
							<div class="row">
								<div class="col-md-2">
									<select v-model="tt.start" class="form-control c-select">
										<option value="0">起始时段</option>
										<template v-for="(titem,index) in 24">
											<option :value="((titem<11)?('0'+ (titem-1)):titem-1)+':00'">{{(titem<11?("0"+ (titem-1)):titem-1)}}:00</option>
										</template>
									</select>
								</div>
								<div class="col-md-1" style="width:20px;margin:0;padding:0;position:relative;top:5px;left:2px;">
									<i class="fa fa-minus" aria-hidden="true"></i>
								</div>
								<div class="col-md-2">
									<select v-model="tt.end" class="form-control c-select">
										<option value="0">结束时段</option>
										<template v-for="titem in 24">
											<option :value="((titem<11)?('0'+ (titem-1)):titem-1)+':59'">{{(titem<11?("0"+ (titem-1)):titem-1)}}:59</option>
										</template>
									</select>
								</div>
							</div>
							<br>
						</template>
						<button @click="addTime()" type="button" class="btn btn-primary btn-sm">增加</button>
					</div>
				</div>	
				<div class="field-group">
					<div class="form-group row">
						<label class="col-sm-2 form-control-label text-right">推广周期</label>
						<div class="col-sm-9">
							<label class="radio-inline radio-diy-hide">
								<input v-model="form.cycle" type="radio" value="0">&nbsp;长期投放
							</label>							
							<label class="radio-inline radio-diy">
								<input v-model="form.cycle" type="radio" value="diy">&nbsp;自定义
							</label>
						</div>
					</div>	
					<div class="form-group row">
						<div class="col-sm-2"></div>
						<div class="col-sm-9">
							<div class="collapse" :class="form.cycle=='diy'?'in':''">
								<hr>
								<template v-for="tt in subform.cycle">
									<div class="row">
										<div class="col-sm-3">
											<input class="form-control" v-model="tt.start_date" type="date">
										</div>
										<div class="col-sm-1" style="width:20px;margin:0;padding:0;position:relative;top:5px;left:2px;">
											<i class="fa fa-minus" aria-hidden="true"></i>
										</div>
										<div class="col-sm-3">
											<input class="form-control" v-model="tt.end_date" type="date">
										</div>
									</div>
									<br>
								</template>
								<button @click="addDate()" type="button" class="btn btn-primary btn-sm">增加</button>	
							</div>					
						</div>					
					</div>				
				</div>					
				<div class="field-group">
					<div class="form-group row">
						<label class="col-sm-2 form-control-label text-right">每日预算</label>
						<div class="col-sm-9">
							<label class="radio-inline radio-diy-hide">
								<input v-model="form.daily_budget" type="radio" value="0.00">&nbsp;不设置预算
							</label>							
							<label class="radio-inline radio-diy">
								<input v-model="form.daily_budget" type="radio" value="diy">&nbsp;设置预算
							</label>
						</div>
					</div>	
					<div class="form-group row">
						<div class="col-sm-2"></div>
						<div class="col-sm-9">
							<div class="collapse" :class="form.daily_budget=='diy'?'in':''">
								<div class="card card-block">
									<div class="form-group">
										<div class="input-group">
											<input v-model="subform.daily_budget" type="text" name="" class="form-control" placeholder="出价">
											<span class="input-group-addon">元</span>
										</div>
										<hr>
										<p class="text-muted">提示：当日消费达到每日预算设定的金额之后会停止展现广告，由于系统延迟，当您设定的预算较小时不能精确控制，会有少量的超预算展现</p>
									</div>	
								</div>	
							</div>					
						</div>					
					</div>					
				</div>					
			</div>
			<div class="modal-footer text-center">
				<button @click="submit()" type="button" class="btn btn-primary btn-lg">保存</button>
			</div>
		</div>
	</div>
	{% endraw %}
	<script type="text/javascript">
		$(function(){
			$(document).delegate(".field-group .radio-diy","click",function(){
				console.log(0);
				var collapse = $(this).parents(".field-group").find(".collapse");
				collapse.collapse('show');
			});			
			$(document).delegate(".field-group .radio-diy-hide","click",function(){
				console.log(0);
				var collapse = $(this).parents(".field-group").find(".collapse");
				collapse.collapse('hide');
			});			
			$(document).delegate(".SelDate","click",function(){
				var date = $(this).parents("[type='date']");
				date.trigger("click");
			});
			var today = (function(d){ 
                        var _y = d.getFullYear(),
                            _m = d.getMonth()+1,
                            _mm = _m<=10?"0" + "" + _m:_m,
                            _d = d.getDate();
                        return _y + "-" + _mm + "-" + _d;
                    })(new Date());
			Widget.NewJihua = new Vue({
				el: ".NewJihua",
				data: {
					id: "{{id}}",
					form: {
						//广告
						'ad_id': '-1',
						//广告创意ID
			            'idea_id': '-1',
			            //媒体id
			            'media_id': '-1',
			            'place_id': '-1',
			            //计划名称
			            'name': '',
			            //出价
			            'price': '',
			            //投放地址
			            'url': '',		            
			            //计费类型
			            'charge_type': '1',
			            //投放地域
			            'region': 'all',
			            //手机品牌
			            'mobile_brand': 'all',
			            //手机级别
			            'mobile_level': 'all',
			            //手机操作系统
			            'mobile_system': 'all',
			            //网络环境
			            'network_setting': '',
			            //运营商
			            'operator': '',
			            //性别0:不限；1：男；2：女
			            'gender': '0',
			            //年龄段
			            'age': 'all',
			            //投放时段
			            'time_slof': {
			            	"week":[0,1,2,3,4,5,6],
			            	"time":[
			            		{
			            			"start": "00:00",
			            			"end": "23:59"
			            		}
			            	]
			            },
			            //推广周期0：长期投放；1：自定义
			            'cycle': '0',
			            //每日预算0:不设置预算
			            'daily_budget': '0.00',
		        	},
		        	subform: {
			            //投放地域
			            'region': [],
			            //手机品牌
			            'mobile_brand': [],
			            //手机级别
			            'mobile_level': [],
			            //手机操作系统
			            'mobile_system': [],
			            //网络环境
			            'network_setting': [],
			            //年龄段
			            'age': [],
			            'daily_budget': "",
			            'cycle': [
			            	{
			            		'start_date': "2017-02-21",
			            		'end_date': "2017-02-22"
			            	}
			            ]
		        	},
		        	areas: {{areas|raw|json_encode}},
		            adList: [],
		            ideaList: [],
		            mediaList: [],
		            mdList: [],
		            areaList: [
		            	{
		            		title: "中国",
		            		type: 1,
		            		list: []
		            	},		            	
		            	{
		            		title: "国外",
		            		type: 0,
		            		list: []
		            	},
		            ],
		            config: {
		            	age: null,
		            	areas: null,
		            	mobileBrands: null,
		            	mobileLevel: null,
		            	mobileSystem: null,
		            	operator: null
		            },
					today: (function(d){ 
                        var _y = d.getFullYear(),
                            _m = d.getMonth()+1,
                            _mm = _m<=10?"0" + "" + _m:_m,
                            _d = d.getDate();
                        return _y + "-" + _mm + "-" + _d;
                    })(new Date())
				},
				methods: {
					"loadConfig": function(){
						var me = this;
						Widget.loading = weui.loading('数据加载中');
	                    $.ajax({
	                        type: "GET",
	                        url: "{{config.host}}/v1/config",
	                        data: {
    							'access-token': "{{token}}"
	                        },
	                        dataType: "json",
	                        success: function(data){
	                        	if(data.code == 200){
	                        		me.$data.config = data.data;
									Widget.NewJihua.loadAdData();	
	                        	}else{
                        			alert(data.msg);
	                        	}
	                        }
	                    });
					},		
					//加载广告列表	
					"loadAdData": function(){
						var me = this;
	                    $.ajax({
	                        type: "GET",
	                        url: "{{config.host}}/v1/ad",
	                        data: {
    							'access-token': "{{token}}"
	                        },
	                        dataType: "json",
	                        success: function(data){
	                        	if(data.code == 200){
	                        		me.$data.adList = data.data.items;
									Widget.NewJihua.loadMediaData();
	                        	}else{
                        			alert(data.msg);
	                        	}
	                        }
	                    });
					},		
					//加载媒体列表			
					"loadMediaData": function(){
						var me = this;
	                    $.ajax({
	                        type: "GET",
	                        url: "{{config.host}}/v1/media-list",
	                        data: {
    							'access-token': "{{token}}"
	                        },
	                        dataType: "json",
	                        success: function(data){
	                        	if(data.code == 200){
	                        		me.$data.mediaList = data.data;
									Widget.NewJihua.loadJhData();
	                        	}else{
                        			alert(data.msg);
	                        	}
	                        }
	                    });
					},				
					//加载创意列表			
					"reAd": function(idea_id){
						var me = this;
	                    $.ajax({
	                        type: "GET",
	                        url: "{{config.host}}/v1/idea",
	                        data: {
    							'access-token': "{{token}}",
	                        	ad_id: me.$data.form.ad_id
	                        },
	                        dataType: "json",
	                        success: function(data){
	                        	if(data.code == 200){
	                        		me.$data.ideaList = data.data.items;
	                        		me.$data.form.idea_id = idea_id || -1;
	                        	}else{
                        			alert(data.msg);
	                        	}
	                        }
	                    });
					},											
					"loadJhData": function(plan_id){
						var me = this;
						if(this.$data.id){
		                    $.ajax({
		                        type: "GET",
		                        url: "{{config.host}}/v1/plan/" + this.$data.id,
		                        data: {
    								'access-token': "{{token}}"
		                        },
		                        dataType: "json",
		                        success: function(data){
		                        	if(data.code == 200){
		                        		var _data = data.data;
		                        		for(var field in _data){
		                        			if(me.$data.subform.hasOwnProperty(field) && (_data[field] != "all") && (_data[field] != "0.00")){
		                        				//特殊情况
		                        				if(field == "daily_budget" || field == "cycle"){
		                        					me.$data.subform[field] = _data[field];
		                        				}else{
		                        					me.$data.subform[field] = _data[field].split(",");
		                        				}
		                        				_data[field] = "diy";
		                        			}
	           		                        if(field == "time_slof"){
	                        					_data[field] = _data[field];
	                        				}	           		                        
		                        		}
		                        		me.$data.form = _data;
		                        		me.reMedia();
		                        		me.reAd(_data.idea_id);
		                        		Widget.loading.hide();
		                        	}else{
                        				alert(data.msg);
		                        	}
		                        }
		                    });
	                	}else{
		                    Widget.loading.hide();
	                	}
					},
					reMedia: function(){
						var me = this;
						var media_id = this.$data.form.media_id;
                        $.ajax({
                            type: "GET",
                            url: "{{config.host}}/v1/place",
                            data: {
    							'access-token': "{{token}}",
                            	media_id: media_id
                            },
                            dataType: "json",
                            success: function(data){
                                if(data.code == 200){
                                    me.$data.mdList = data.data.items;
                                }else{
                        			alert(data.msg);
                                }
                            }
                        });
					},
					"submit": function(){
						var postData = {};
						for(var field in this.$data.form){
							if(this.$data.form[field] == "diy"){
								console.log(field);
								if(this.$data.subform[field].constructor === Array && field!= "cycle"){
									postData[field] = this.$data.subform[field].join(",");
								}else{
									postData[field] = this.$data.subform[field];
								}
							}else{
								postData[field] = this.$data.form[field];
							}
						}
						//postData.time_slof.week = [1,3,5];
						if(!this.$data.form.name){
							weui.topTips('名称不能为空');
							return false;
						}							
						if(this.$data.form.ad_id == -1){
							weui.topTips('广告单元不能为空');
							return false;
						}							
						if(this.$data.form.idea_id == -1){
							weui.topTips('广告创意不能为空');
							return false;
						}						
						if(this.$data.form.media_id == -1){
							weui.topTips('媒体不能为空');
							return false;
						}						
						if(this.$data.form.place_id == -1){
							weui.topTips('广告位不能为空');
							return false;
						}							
						if(!this.$data.form.url){
							weui.topTips('推广网址不能为空');
							return false;
						}	
						if(!this.$data.form.price){
							weui.topTips('价格不能为空');
							return false;
						}					
						if(!this.$data.form.ad_id){
							weui.topTips('广告不能为空');
							return false;
						}
						if(!(postData.time_slof.week.constructor === Array)){
							postData.time_slof.week = [0];
						}		
						if(this.$data.id){
		                    $.ajax({
		                        url: "/put",
		                        type: "POST",
		                        data: {
		                        	"url": "{{config.host}}/v1/plan/" + this.$data.id + "?access-token=" + encodeURIComponent('{{token}}'),
		                        	"data": JSON.stringify(postData)
		                        },
		                        dataType: "json",
		                        success: function(data){
		                        	if(data.code == 200){
		                        		weui.toast('更新成功', {
										    duration: 1500,
										    className: 'custom-classname',
										    callback: function(){
		                        				window.location.href = "/tuiguang/jihua";
										    }
										});
		                        	}else{
                        				alert(data.msg);
		                        	}
		                        }
		                    });					
						}else{
		                    $.ajax({
		                        type: "POST",
		                        url: "{{config.host}}/v1/plan?access-token=" + encodeURIComponent('{{token}}'),
		                        data: postData,
		                        dataType: "json",
		                        success: function(data){
		                        	if(data.code == 200){
		                        		weui.toast('保存成功', {
										    duration: 1500,
										    className: 'custom-classname',
										    callback: function(){
		                        				window.location.href = "/tuiguang/jihua";
										    }
										});
		                        	}else{
                        				alert(data.msg);
		                        	}
		                        }
		                    });
		                }
					},
					addTime: function(){
						this.$data.form.time_slof.time.push({
							"start": "00:00",
							"end": "23:59"
						});
					},
					addDate: function(){
						this.$data.subform.cycle.push({
							"start_date": this.$data.today,
							"end_date": this.$data.today
						});
					}
				}
			});
			//加载配置文件
			Widget.NewJihua.loadConfig();
		});
	</script>
{% endblock %}