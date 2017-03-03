{% extends "widget/layout.tpl" %}
{% block title %}广告位-子龙广告平台{% endblock %}
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
					<input data-toggle="modal" data-target="#DlgNew" class="btn btn-primary" type="button" value="创建广告位">
    			</div>
    		</div>
    		<br>
            <table class="table table-bordered table-striped">
                <thead>
                    <tr class="table-active">
                        <th>媒体名称</th>
                        <th width="120">操作</th>
                        <th width="120">获取代码</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="litem in list">
                        <td>{{litem.name}}</td>
                        <td>
                            <span class="icon" @click="edit(litem)"><i class="fa fa-edit action" aria-hidden="true"></i>编辑</span>
                        </td>                        
                        <td>
                            <a href="javascript:;" @click="getCode(litem.id)">获取代码</a>
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
        <div id="DlgCode" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        <span class="sr-only">关闭</span>
                        </button>
                        <h4 class="modal-title">获取代码</h4>
                    </div>
                    <div class="modal-body">
                        <textarea class="form-control" rows="3" v-model="codeText"></textarea>
                    </div>
                </div>
            </div>
        </div>
        {% endraw %}
    </div>
    <script type="text/javascript">
        $(function(){
            Widget.Media = new Vue({
                el: ".Meida",
                data: {
                    name: "",
                    media_id: "{{media_id}}",
                    id: "",
                    alertText: "",
                    pageData: {
                        total: 0,
                        pageCount: 0
                    },
                    list: [],
                    codeText: ""
                },
                methods: {
                    "loadData": function(pn){
                        var loading = weui.loading('数据加载中');
                        var me = this;
                        $.ajax({
                            type: "GET",
                            url: "{{config.host}}/v1/place",
                            data: {
                                'access-token': "{{token}}",
                                media_id: me.$data.media_id,
                                page: pn || 1
                            },
                            dataType: "json",
                            success: function(data){
                                if(data.code == 200){
                                    me.$data.list = data.data.items;
                                    me.$data.pageData = data.data.pagination;
                                    loading.hide();
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
                                type: "POST",
                                url: "{{config.host}}/media/media/update?id=" + this.$data.id,
                                data: {
                                    name: this.$data.name,
                                    id: this.$data.id
                                    //"csrf-zlong": CSRF,
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
                                url: "{{config.host}}/v1/place?access-token=" + encodeURIComponent('{{token}}'),
                                data: {
                                    name: this.$data.name,
                                    //"csrf-zlong": CSRF,
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
                            url: "{{config.host}}/media/media/start",
                            data: {
                                id: id
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
                            url: "{{config.host}}/media/media/stop",
                            data: {
                                id: id
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
                    "edit": function(vo){
                        Widget.Edit.$data.id = vo.id;
                        Widget.Edit.$data.name = vo.name;
                        Widget.Edit.$data.style = vo.style;
                        Widget.Edit.$data.type = vo.type;
                        Widget.Edit.$data.media_id = vo.media_id;
                        $("#DlgNew").modal("show");
                    },
                    "getCode": function(){
                        $("#DlgCode").modal("show");
                        this.$data.codeText = ("\<script\>console.log(0);\<\/script\>");
                    }
                }
            });
            Widget.Media.loadData();
        });
    </script>
    {# 创建广告位 #}
    {% include "./widget/edit_media_ad.tpl" %}
{% endblock %}