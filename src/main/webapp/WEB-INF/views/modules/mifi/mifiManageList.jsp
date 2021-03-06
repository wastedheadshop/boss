<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>MIFI设备管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/WEB-INF/views/include/dialog.jsp"%>
	<script type="text/javascript">
	document.addEventListener('DOMContentLoaded', function() {
		document.getElementById('btnSubmit').addEventListener('click', function() {
			$.jBox.tip("正在查询...", 'loading', {persistent: true});
			$(this).attr("disabled",true);
	    	$("#searchForm").submit();
	    }, false);
	}, false);
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
	    	return false;
	    }
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/mifi/mifiManage/">MIFI设备管理列表</a></li>
	</ul>
	<form:form id="searchForm" action="${ctx}/mifi/mifiManage/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<input id="initTag" name="initTag" type="hidden" value="${initTag}"/>
		<div>
			<label>设备序列号：</label><input id="sn" name="sn" type="text" maxlength="50" class="input-small required" value="${sn}"/>
			<label>代理商：</label> <select id="sourceType" name="sourceType"
				class="input-small">
				<option value="">--请选择--</option>
				<c:forEach
					items="${fns:getListByTableAndWhere('om_channel','channel_name_en','channel_name',' and del_flag = 0')}"
					var="sourceTypeValue">
					<option value="${sourceTypeValue.channel_name_en}"
						<c:if test="${sourceTypeValue.channel_name_en==sourceType}">selected</c:if>>${sourceTypeValue.channel_name}</option>
				</c:forEach>
			</select>
			&nbsp;&nbsp; <input id="btnSubmit" class="btn btn-primary" type="button" value="查询" /> 
		</div>
	</form:form>
	<tags:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>设备序列号</th>
				<th>代理商</th>
				<th>是否订单中</th>
				<th>订单编号</th>
				<th>设备状态</th>
				<th>时间</th>
				<th>所在地区中文名</th>
				<th>所在地区英文名</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="mifiManage">
			<tr>
				<td>${mifiManage.sn}</td>
				<td>${mifiManage.source_type}|${fns:getLabelByTable('om_channel','channel_name_en','channel_name',mifiManage.source_type)}</td>
				<td><c:if test="${!empty mifiManage.cnt}" var="inOrder">是</c:if><c:if test="${!inOrder}">否</c:if></td>
				<td>${mifiManage.outOrderId}</td>
				<td><c:if test="${!empty mifiManage.cnt}" var="inOrder">${mifiManage.uestatus}|${fns:getDictLabel(mifiManage.uestatus, 'mifi_uestatus', '')}</c:if><c:if test="${!inOrder}">锁定</c:if></td>
				<td>${mifiManage.stamp_updated}</td>
				<td>${mifiManage.country_name_cn}</td>
				<td>${mifiManage.country_name_en}</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>