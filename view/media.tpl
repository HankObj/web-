{% extends "widget/layout.tpl" %}
{% block title %}子龙广告平台{% endblock %}
{% block body %}
	{% include "./widget/top_bar.tpl" %}
	{% include "./widget/main_nav.tpl" %}
	<br>
    <div class="Meida container">
        {# 推广导航条 #}
        {% include "./widget/media_nav.tpl" %}
        {% raw %}
    	<div class="block">
    		<div class="clearfix">
    			<div class="pull-left">
					<input @click="edit()" class="btn btn-primary" type="button" value="创建媒体">
    			</div>
    		</div>
    		<br>
            <table class="table table-bordered table-striped">
                <thead>
                    <tr class="table-active">
                        <th>媒体名称</th>
                        <th width="160">操作</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="litem in list">
                        <td><a :href="'/media/ad?media_id='+litem.id">{{litem.name}}</a></td>
                        <td>
                            <span class="icon" @click="stop(litem.id)" v-if="litem.status==1"><i class="fa fa-pause action" aria-hidden="true"></i>禁用</span>
                            <span class="icon" @click="start(litem.id)" v-if="litem.status==0"><i class="fa fa-play action" aria-hidden="true"></i>启用</span>
                            <span class="icon" @click="edit(litem.id, litem.name)"><i class="fa fa-edit action" aria-hidden="true"></i>编辑</span>
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
        <div id="DlgNew" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        <span class="sr-only">关闭</span>
                        </button>
                        <h4 class="modal-title">创建媒体</h4>
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
                            <label class="col-sm-2 form-control-label">媒体名称</label>
                            <div class="col-sm-10">
                                <input v-model="name" type="text" class="form-control" placeholder="媒体名称">
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
    </div>
    <script type="text/javascript">
        $(function(){
            Widget.Meida = new Vue({
                el: ".Meida",
                data: {
                    name: "",
                    id: "",
                    alertText: "",
                    pageData: {
                        total: 0,
                        pageCount: 0
                    },
                    list: []
                },
                methods: {
                    "loadData": function(pn){
                        Widget.loading = weui.loading('数据加载中');
                        var me = this;
                        $.ajax({
                            type: "GET",
                            url: "{{config.host}}/v1/media",
                            data: {
                                'access-token': "{{token}}",
                                page: pn || 1
                            },
                            dataType: "json",
                            success: function(data){
                                if(data.code == 200){
                                    me.$data.list = data.data.items;
                                    me.$data.pageData = data.data.pagination;
                                    Widget.loading.hide();
                                }else{
                                    alert(data.msg);
                                }
                            }
                        });
                    }, 
                    "submit": function(){
                        var me = this;
                        if(!this.$data.name){
                            this.$data.alertText = "媒体名称不能为空";
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
                                    "url": "{{config.host}}/v1/media/" + this.$data.id + "?access-token=" + encodeURIComponent('{{token}}'),
                                    "data": JSON.stringify({
                                        "name": this.$data.name
                                    })
                                },
                                dataType: "json",
                                success: function(data){
                                    if(data.code == 200){
                                        $("#DlgNew").modal("hide");
                                        me.loadData();
                                    }else{
                                        alert(data.msg);
                                    }
                                }
                            });                   
                        }else{
                            $.ajax({
                                type: "POST",
                                url: "{{config.host}}/v1/media?access-token=" + encodeURIComponent('{{token}}'),
                                data: {
                                    name: this.$data.name
                                },
                                dataType: "json",
                                success: function(data){
                                    if(data.code == 200){
                                        $("#DlgNew").modal("hide");
                                        me.loadData();
                                    }else{
                                        alert(data.msg);
                                    }
                                }
                            });
                        }
                    },            
                    "start": function(id){
                        var me = this;
                        $.ajax({
                            type: "GET",
                            url: "{{config.host}}/v1/media-start/" + id,
                            data: {
                                'access-token': "{{token}}"
                            },
                            dataType: "json",
                            success: function(data){
                                if(data.code == 200){
                                    me.loadData();
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
                            url: "{{config.host}}/v1/media-stop/" + id,
                            data: {
                                'access-token': "{{token}}"
                            },
                            dataType: "json",
                            success: function(data){
                                if(data.code == 200){
                                    console.log(data);
                                    me.loadData();
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
                        this.$data.id = id || "";
                        this.$data.name = name || "";
                        if(this.$data.id > 0){
                            $('.modal-title').text('编辑媒体');
                        }else{
                            $('.modal-title').text('创建媒体');
                        }

                        $("#DlgNew").modal("show");
                    }
                }
            });
            Widget.Meida.loadData();
        });
    </script>
{% endblock %}