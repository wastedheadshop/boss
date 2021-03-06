<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>广告统计图</title>
<meta name="decorator" content="default" />
<%@include file="/WEB-INF/views/include/dialog.jsp"%>
<script src="${ctxStatic }/echarts-2.2.7/dist/echarts.js"></script>
<script type="text/javascript">
	$(function() {
		$('#btnExport').click(
				function() {
					top.$.jBox.confirm("确认导出？", "操作提示", function(v, h, f) {
						if (v == "ok") {
							$("#searchForm").attr('action',
									"${ctx}/mifi/deviceBoot/export");
							$("#searchForm").submit();
							$("#searchForm").attr('action',
									"${ctx}/mifi/deviceBoot/");
						}
					}, {
						buttonsFocus : 1
					});
					top.$('.jbox-body .jbox-icon').css('top', '55px');
					top.$('.jbox').css('top', '180px');
				});
		var countryName;
		var total;
		var total1;
		var total2;
		var total3;
		//条件查询
		$('#btnSubmit').click(function() {
			$.ajax({
				type : 'post',
				url : '${ctx}/mifi/deviceBoot/ByDeviceBoot',
				data : $('#searchForm').serialize(),
				dataType : 'json',
				success : function(data) {
					if (data.countryName.length === 0) {
						initNull();
					} else {
						init(data)
					}
				}
			});
		});
	});
</script>
</head>
<body>
	<!-- tab S -->
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/mifi/deviceBoot/byType">按类型统计</a></li>
		<li><a href="${ctx}/mifi/deviceBoot/year">按年统计</a></li>
		<li><a href="${ctx}/mifi/deviceBoot/month">按月统计</a></li>
		<li><a href="${ctx}/mifi/deviceBoot/day">按日统计</a></li>
	</ul>
	<!-- tab E -->

	<!-- 查询 S -->
	<form:form id="searchForm" class="breadcrumb form-search">
		<label>代理商：</label>
		<select id="eqSourceType" name="eqSourceType" class="input-small">
			<option value="">--请选择--</option>
			<c:forEach
				items="${fns:getListByTableAndWhere('om_channel','channel_name_en','channel_name',' and del_flag = 0 ')}"
				var="sourceTypeValue">
				<option value="${sourceTypeValue.channel_name_en}"
					<c:if test="${sourceTypeValue.channel_name_en==deviceBootCondition.eqSourceType}">selected</c:if>>${sourceTypeValue.channel_name}
				</option>
			</c:forEach>
		</select>
		<label>广告：</label>
		<select id="eqAdvertisingId" name="eqAdvertisingId"
			class="input-small">
			<option value="">--请选择--</option>
			<c:forEach items="${advList}" var="adv">
				<option value="${adv.id}"
					<c:if test="${adv.id==deviceBootCondition.eqAdvertisingId}">selected</c:if>>${adv.name}</option>
			</c:forEach>
		</select>
		<label>开机时间：</label>
		<input id="beginDate" name="beginDate" type="text" readonly="readonly"
			maxlength="20" class="input-small Wdate required" value="${begin}"
			onclick="WdatePicker({skin:'twoer',dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'endDate\')||\'%y-%M-%d\'}'});" />&nbsp;到
		<input id="endDate" name="endDate" type="text" readonly="readonly"
			maxlength="20" class="input-small Wdate required" value="${end}"
			onclick="WdatePicker({skin:'twoer',dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'beginDate\')}',maxDate:'%y-%M-%d'});" />		
		&nbsp;<input id="btnSubmit" class="btn btn-primary" type="button"
			value="统计" />
		&nbsp;<input id="btnExport" class="btn btn-primary" type="button"
			value="导出" />

	</form:form>
	<tags:message content="${message}" />

	<!-- 查询 E -->
	<div id="main"
		style="height: 600px; border: 1px solid #ccc; padding: 10px;"></div>
	<!-- 查询 S -->

	<script type="text/javascript">
		$('#btnSubmit').click(function() {
			$.ajax({
				type : 'post',
				url : '${ctx}/mifi/deviceBoot/ByDeviceBoot',
				data : $('#searchForm').serialize(),
				dataType : 'json',
				success : function(data) {
					if (data.countryName.length === 0) {
						initNull();
					} else {
						init(data)
					}
				}
			});
		});
		function init(data) {
			countryName = data.countryName;
			total = data.y;
			total1 = data.y1;
			total2 = data.y2;
			total3 = data.y3;
			// Step:3 conifg ECharts's path, link to echarts.js from current page.
			// Step:3 为模块加载器配置echarts的路径，从当前页面链接到echarts.js，定义所需图表路径
			require.config({
				paths : {
					echarts : '${ctxStatic}/echarts-2.2.7/dist',
				}
			});

			// Step:4 require echarts and use it in the callback.
			// Step:4 动态加载echarts然后在回调函数中开始使用，注意保持按需加载结构定义图表路径
			require([ 'echarts', 'echarts/chart/bar', 'echarts/chart/line' ],
					function(ec) {
						var myChart = ec.init(document.getElementById('main'));
						var option = {
							title : {
								show : true,
								text : '广告统计'
							},
							tooltip : {
								trigger : 'axis',
								axisPointer : { // 坐标轴指示器，坐标轴触发有效
									type : 'shadow' // 默认为直线，可选为：'line' | 'shadow'
								}
							},
							legend : {
								data : [ '开机', '首页显示' , '连接网络','页面跳转' ]
							},
							color : [ '#1e90ff', '#22bb22', '#4b0082',
									'#4b0042' ],
							tooltip : {
								trigger : 'axis',
								axisPointer : { // 坐标轴指示器，坐标轴触发有效
									type : 'shadow' // 默认为直线，可选为：'line' | 'shadow'
								}
							},

							calculable : true,
							xAxis : [ {
								show : false,
								type : 'category',
								splitLine : false,
								data : [ '' ],
								axisLabel : {
									interval : 0,
									rotate : 45,
									margin : 2,
									textStyle : {
										color : "#000000"
									}
								},
							} ],
							yAxis : [ {
								type : 'value'
							} ],
							series : [ {
								name : '开机',
								type : 'bar',
								data : total,
							}, 
							{
								name : '首页显示',
								type : 'bar',
								data : total3,

							},
							
							{
								name : '连接网络',
								type : 'bar',
								data : total1,

							},
							{
								name : '页面跳转',
								type : 'bar',
								data : total2,
							},
							]
						};

						myChart.setOption(option);
					});
		}
		//初始化没数据图表
		function initNull() {
			require.config({
				paths : {
					echarts : '${ctxStatic}/echarts-2.2.7/dist',
				}
			});
			require([ 'echarts', 'echarts/chart/bar', 'echarts/chart/line' ],
					function(ec) {
						var myChart = ec.init(document.getElementById('main'));
						var ecConfig = require('echarts/config');
						var option = {
							xAxis : [ {
								type : 'category',
								data : [],
							} ],
							yAxis : [ {
								type : 'value',
							} ],
							series : [ {} ]
						};
						myChart.setOption(option);
					});
		}
	</script>
</body>
</html>