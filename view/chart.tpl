{% extends "widget/layout.tpl" %}
{% block title %}子龙广告平台{% endblock %}
{% block body %}
	{% include "./widget/top_bar.tpl" %}
	{% include "./widget/main_nav.tpl" %}
	<br>
	<div class="container chart">
    	<div class="block">
			<div class="row">
				<div class="col-sm-2">
					<select class="form-control c-select">
						<option value="">所有广告</option>
						<option value="">单元1</option>
						<option value="">单元2</option>
					</select>					
				</div>					
				<div class="col-sm-2">
					<select class="form-control c-select">
						<option value="">所属创意</option>
						<option value="">单元1</option>
						<option value="">单元2</option>
					</select>					
				</div>					
				<div class="col-sm-2">
					<select class="form-control c-select">
						<option value="">所属计划</option>
						<option value="">单元1</option>
						<option value="">单元2</option>
					</select>
				</div>    				
				<div class="col-sm-2">
					<select class="form-control c-select">
						<option value="">统计粒度</option>
						<option value="">日期</option>
						<option value="">小时</option>
					</select>
				</div>
			</div>
			<hr>
			<div class="row">
				<!-- 时间 -->
				<div class="col-sm-4">
					<div class="btn-group" role="group" aria-label="Basic example">
						<button type="button" class="btn btn-secondary">今天</button>
						<button type="button" class="btn btn-secondary">昨天</button>
						<button type="button" class="btn btn-secondary">最近7天</button>
						<button type="button" class="btn btn-secondary">最近30天</button>
					</div>
				</div>
				<!-- 折线图按钮 -->
				<div class="col-sm-5" id="col">
					<label class="radio-inline">
						<input type="radio" name="inlineRadioOptions" id="inlineRadio" value="option"> 展现
					</label>					
					<label class="radio-inline">
						<input type="radio" name="inlineRadioOptions" id="inlineRadio1" value="option"> 点击
					</label>					
					<label class="radio-inline">
						<input type="radio" name="inlineRadioOptions" id="inlineRadio2" value="option"> 点击率
					</label>					
					<label class="radio-inline">
						<input type="radio" name="inlineRadioOptions" id="inlineRadio3" value="option"> CPM
					</label>					
					<label class="radio-inline">
						<input type="radio" name="inlineRadioOptions" id="inlineRadio4" value="option"> 消费
					</label>
				</div>
			</div>
			<hr>
			<!-- 折线图画板 -->
			<div class="chart-wrap" id="chart1">
				<div id="main" style="width: 1100px;height:400px;"></div>
				<div id="main1" style="width: 1100px;height:400px;" class="cur"></div>
				<div id="main2" style="width: 1100px;height:400px; " class="cur"></div>
				<div id="main3" style="width: 1100px;height:400px;" class="cur"></div>
				<div id="main4" style="width: 1100px;height:400px; " class="cur"></div>
			</div>
    	</div>
    	<!-- 报表 -->
    	<div class="block">
    		<div class="clearfix">
    			<div class="pull-left">
    				<h5>详情列表</h5>
    			</div>
    			<div class="pull-right">
					<input class="btn btn-primary" type="button" value="下载报表">
    			</div>
    		</div>
    		<br>
			<table class="table table-bordered table-striped">
				<thead>
					<tr class="table-active">
						<th width="300">日期</th>
						<th>汇报对象</th>
						<th>展现</th>
						<th>点击</th>
						<th>点击率</th>
						<th>CPM</th>
						<th>消费</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>2017--2-16</td>
						<td>CEO</td>
						<td>0</td>
						<td>0</td>
						<td>0%</td>
						<td>5元</td>
						<td>20元</td>
					</tr>					<tr>
						<td>2017--2-16</td>
						<td>CEO</td>
						<td>0</td>
						<td>0</td>
						<td>0%</td>
						<td>5元</td>
						<td>20元</td>
					</tr>					<tr>
						<td>2017--2-16</td>
						<td>CEO</td>
						<td>0</td>
						<td>0</td>
						<td>0%</td>
						<td>5元</td>
						<td>20元</td>
					</tr>
				</tbody>
			</table>
			<br>
			<!-- 分页 -->
			<div class="clearfix">
				<div class="pull-left">
					<p class="text-center"><span class="label label-default">共100条</span></p>
				</div>
				<div class="pull-right">
					<nav class="text-center">
						<ul class="pagination pagination-sm" style="margin:0;">
							<li><a href="#">首页</a></li>
							<li class="disabled">
								<a href="#" aria-label="Previous">
								<span aria-hidden="true">&laquo;</span>
								<span class="sr-only">Previous</span>
								</a>
							</li>
							<li class="active">
								<a href="#">1 <span class="sr-only">(current)</span></a>
							</li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li>
								<a href="#" aria-label="Next">
								<span aria-hidden="true">&raquo;</span>
								<span class="sr-only">Next</span>
								</a>
							</li>
							<li><a href="#">尾页</a></li>
						</ul>
					</nav>
				</div>
			</div>
    	</div>
    </div>
	<script type="text/javascript">
	/*双向数据绑定*/
        $(function(){
            var Money = new Vue({
                el: ".chart",
                data: {
                    loaded: false,
                    data: {
                        ad_consume: "0",
                        balance: "0",
                        orders: []
                    }
                },
                methods: {
                    "loadData": function(){
                        var me = this;
                        $.ajax({
                            type: "GET",
                            url: "{{config.host}}/v1/report",
                            dataType: "json",
                            data: {
                                'access-token': "{{token}}"
                            },
                            success: function(data){
                                if(data.code == 200){
                                    me.$data.data = data.data;
                                    me.$data.loaded = true;
                                    //loading.hide();
                                }
                            }
                        });
                    }
                }
            });
            Money.loadData();
        });
    </script>
	<script type="text/javascript">
	    // 基于准备好的dom，初始化echarts实例
	    var myChart = echarts.init(document.getElementById('main'));
	    var myChart1 = echarts.init(document.getElementById('main1'));
	    var myChart2 = echarts.init(document.getElementById('main2'));
	    var myChart3 = echarts.init(document.getElementById('main3'));
	    var myChart4 = echarts.init(document.getElementById('main4'));
	    // 指定图表的配置和数据
	    var option = {
		    title: {
		        text: '折线图堆叠'
		    },
		    tooltip: {
		        trigger: 'axis'
		    },
		    legend: {
		        data:['展现']
		    },
		    grid: {
		        left: '3%',
		        right: '4%',
		        bottom: '3%',
		        containLabel: true
		    },
		    toolbox: {
		        feature: {
		            saveAsImage: {}
		        }
		    },
		    xAxis: {
		        type: 'category',
		        boundaryGap: false,
		        data: ['周一','周二','周三','周四','周五','周六','周日']
		    },
		    yAxis: {
		        type: 'value'
		    },
		    series: [
		        {
		            name:'展现',
		            type:'line',
		            stack: '总量',
		            data:[120, 132, 101, 134, 90, 230, 210],
		            itemStyle : { normal: {label : {show: true}}}
		        }
		        
		    ]
		};
		var option1= {
		    title: {
		        text: '折线图堆叠'
		    },
		    tooltip: {
		        trigger: 'axis'
		    },
		    legend: {
		        data:['点击']
		    },
		    grid: {
		        left: '3%',
		        right: '4%',
		        bottom: '3%',
		        containLabel: true
		    },
		    toolbox: {
		        feature: {
		            saveAsImage: {}
		        }
		    },
		    xAxis: {
		        type: 'category',
		        boundaryGap: false,
		        data: ['周一','周二','周三','周四','周五','周六','周日']
		    },
		    yAxis: {
		        type: 'value'
		    },
		    series: [
		        {
		            name:'点击',
		            type:'line',
		            stack: '总量',
		            data:[220, 182, 191, 234, 290, 330, 310],
		            itemStyle : { normal: {label : {show: true}}}
		        }
		        
		    ]
		};
		var option2 = {
		    title: {
		        text: '折线图堆叠'
		    },
		    tooltip: {
		        trigger: 'axis'
		    },
		    legend: {
		        data:['点击率']
		    },
		    grid: {
		        left: '3%',
		        right: '4%',
		        bottom: '3%',
		        containLabel: true
		    },
		    toolbox: {
		        feature: {
		            saveAsImage: {}
		        }
		    },
		    xAxis: {
		        type: 'category',
		        boundaryGap: false,
		        data: ['周一','周二','周三','周四','周五','周六','周日']
		    },
		    yAxis: {
		        type: 'value'
		    },
		    series: [
		       
		        {
		            name:'点击率',
		            type:'line',
		            stack: '总量',
		            data:[150, 232, 201, 154, 190, 330, 410],
		            itemStyle : { normal: {label : {show: true}}}
		        },
		        
		    ]
		};
		var option3 = {
		    title: {
		        text: '折线图堆叠'
		    },
		    tooltip: {
		        trigger: 'axis'
		    },
		    legend: {
		        data:['CPM']
		    },
		    grid: {
		        left: '3%',
		        right: '4%',
		        bottom: '3%',
		        containLabel: true
		    },
		    toolbox: {
		        feature: {
		            saveAsImage: {}
		        }
		    },
		    xAxis: {
		        type: 'category',
		        boundaryGap: false,
		        data: ['周一','周二','周三','周四','周五','周六','周日']
		    },
		    yAxis: {
		        type: 'value'
		    },
		    series: [
		        
		        {
		            name:'CPM',
		            type:'line',
		            stack: '总量',
		            data:[190, 72, 101, 124, 130, 555, 390],
		            itemStyle : { normal: {label : {show: true}}}
		        },
		        
		    ]
		};
		var option4 = {
		    title: {
		        text: '折线图堆叠'
		    },
		    tooltip: {
		        trigger: 'axis'
		    },
		    legend: {
		        data:['消费']
		    },
		    grid: {
		        left: '3%',
		        right: '4%',
		        bottom: '3%',
		        containLabel: true
		    },
		    toolbox: {
		        feature: {
		            saveAsImage: {}
		        }
		    },
		    xAxis: {
		        type: 'category',
		        boundaryGap: false,
		        data: ['周一','周二','周三','周四','周五','周六','周日']
		    },
		    yAxis: {
		        type: 'value'
		    },
		    series: [
		        
		        {
		            name:'消费',
		            type:'line',
		            stack: '总量',
		            data:[111, 222, 156, 875, 140, 310, 240],
		            itemStyle : { normal: {label : {show: true}}}
		        }
		        
		    ]
		};
	    // 使用刚指定的配置项和数据显示图表。
	    myChart.setOption(option);
	    myChart1.setOption(option1);
	    myChart2.setOption(option2);
	    myChart3.setOption(option3);
	    myChart4.setOption(option4);
	</script>
	<!-- 点击轮换折线图效果 -->
	<script>
		var $li = $('#col>label');
		var $lis = $('#chart1>div');		
		$li.click(function(){
			var $this = $(this);
			var $t = $this.index();
			$li.removeClass();
			$lis.css('display','none');
			$lis.eq($t).css('display','block');
		})
	</script>
{% endblock %}