{% extends "widget/layout.tpl" %}
{% block title %}登录{% endblock %}
{% block body %}
	{% include "./widget/top_bar.tpl" %}
	{% raw %}
	<div style="background: #c2dbdf url(/static/images/banner.jpg) center bottom no-repeat;">
		<br>
		<br>
		<br>
		<div class="Login container" style="width:1000px;">
			<div class="row">
				<div class="pull-left">
					<br>
					<h1>懂消费，更懂消费者</h1>
					<br>
					<h4>在这里获取更适合的营销方案</h4>
					<h4>让对的产品，在对的地方，出现在对的用户面前</h4>
				</div>
				<div class="pull-right">
					<div class="card" style="width:318px;">
						<div class="card-block" style="background:#fff;">
							<h4 style="margin-bottom:15px;" class="card-title text-center">VIP登录</h4>
							<div class="cart-text">
								<fieldset class="form-group">
									<input v-model="username" type="text" class="form-control" placeholder="用户名">
								</fieldset>
								<fieldset class="form-group">
									<input v-model="password" type="password" class="form-control" placeholder="密码">
								</fieldset>
								<fieldset class="form-group" v-if="false">
									<div class="input-group">
										<input v-model="captcha" type="text" class="form-control" placeholder="验证码" aria-describedby="basic-addon2">
										<span class="input-group-addon mcode" @click="reMcode"><img height="36" :src="mcodeImg"></span>
									</div>
								</fieldset>
								<button @click="login()" type="button" class="btn btn-primary btn-lg btn-block">极速登录</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<br>
		<br>
		<br>
		<br>
	</div>
	{% endraw %}
	<script type="text/javascript">
		$(function(){
			var Login = new Vue({
				el: ".Login",
				data: {
					username: "",
					password: "",
					captcha: "",
					mcodeImg: "{{config.host}}/captcha/captcha?t={{t}}"
				},
				methods: {
					"reMcode": function(){
						var me = this;
			            $.ajax({
			                type: "GET",
			                url: "{{config.host}}/captcha/captcha?refresh=1",
			                dataType: "json",
			                success: function(data){
								me.$data.mcodeImg = "{{config.host}}/" + data.url;
			                }
			            });
					},
					"login": function(){
						var username = this.$data.username,
							password = this.$data.password,
							captcha = this.$data.captcha
						if(!username){
							weui.alert("用户名不能为空");
							return false;
						}						
						if(!password){
							weui.alert("密码不能为空");
							return false;
						}	
						/*					
						if(!captcha){
							weui.alert("验证码不能为空");
							return false;
						}
						*/
                        $.ajax({
                            type: "POST",
                            url: "http://api.zlongad.com/v1/login",
                            data: {
                            	username: username,
                            	password: password,
                            	captcha: captcha,
                            	rememberMe: 1
                            },
                            dataType: "json",
                            success: function(data){
                                if(data.code == "200"){
                                	$.cookie("token",data.data.token);
                                	$.cookie("username",data.data.username);
                                	$.cookie("uid",data.data.uid);
									window.location.href = "/";
                                }else{
									weui.alert(data.msg);
                                }
                            }
                        });
					}
				}
			});
		});
	</script>
{% endblock %}