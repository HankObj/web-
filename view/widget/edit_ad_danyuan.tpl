{% raw %}
<div id="DlgNew" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				<span class="sr-only">关闭</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">创建广告</h4>
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
					<label class="col-sm-2 form-control-label">广告名称</label>
					<div class="col-sm-10">
						<input v-model="name" type="text" class="form-control" placeholder="广告名称">
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
		$(".BtnNewAd").click(function(){
			Widget.New.$data.name = "";
			Widget.New.$data.id = "";
			$("#DlgNew").modal("show");
		});
		Widget.New = new Vue({
			el: "#DlgNew",
			data: {
				name: "",
				id: "",
				alertText: ""
			},
			methods: {
				"submit": function(){
					if(!this.$data.name){
						this.$data.alertText = "广告名称不能为空";
						$("#DlgNew .alert").show();
						setTimeout(function(){
							$("#DlgNew .alert").hide();
						},1000);
						//weui.alert("广告名称不能为空");
						return false;
					}
					if(this.$data.id){
	                    $.ajax({
	                        url: "/put",
	                        type: "POST",
	                        data: {
	                        	"url": "{{config.host}}/v1/ad/" + this.$data.id + "?access-token=" + encodeURIComponent('{{token}}'),
	                        	"data": JSON.stringify({
		                        	"name": this.$data.name
	                        	})
	                        },
	                        dataType: "json",
	                        success: function(data){
	                        	if(data.code == 200){
	                        		$("#DlgNew").modal("hide");
	                        		Widget.AdList.loadData();
	                        	}else{
                        			alert(data.msg);
	                        	}
	                        }
	                    });					
					}else{
	                    $.ajax({
	                        type: "POST",
	                        url: "{{config.host}}/v1/ad?access-token=" + encodeURIComponent('{{token}}'),
	                        data: {
	                        	name: this.$data.name
	                        },
	                        dataType: "json",
	                        success: function(data){
	                        	if(data.code == 200){
	                        		$("#DlgNew").modal("hide");
	                        		Widget.AdList.loadData();
	                        	}else{
                        			alert(data.msg);
	                        	}
	                        }
	                    });
	                }
				}
			}
		});
	});
</script>