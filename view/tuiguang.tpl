{% extends "widget/layout.tpl" %}
{% block title %}子龙广告平台{% endblock %}
{% block body %}
	{% include "./widget/top_bar.tpl" %}
	{% include "./widget/main_nav.tpl" %}
	<br>
    <div class="container">
    	{# 推广导航条 #}
    	{% include "./widget/tuiguang_nav.tpl" %}
    	<div class="block">
    		<div class="clearfix">
    			<div class="pull-left">
					<input class="btn btn-primary BtnNewAd" type="button" value="创建广告单元">
    			</div>
    			<div class="pull-right">
					<select class="form-control c-select">
						<option value="">选择时间范围</option>
						<option value="">按天</option>
						<option value="">按月</option>
					</select>
    			</div>
    		</div>
    		<br>
			{# 广告计划列表 #}
    		{% include "./widget/ad_jihua_list.tpl" %}
    	</div>
    </div>
	{# 创建广告 #}
    {% include "./widget/edit_ad_danyuan.tpl" %}
{% endblock %}