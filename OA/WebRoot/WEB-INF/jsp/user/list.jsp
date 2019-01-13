<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib uri="/prev-tag" prefix="slp"%>
<!doctype html>
<html>
<head>
<%@include file="/WEB-INF/jsp/public/header.jspf"%>
</head>
<body>

	<%@include file="/WEB-INF/jsp/index/header.jsp"%>


	<div class="am-cf admin-main">
		<!-- sidebar start -->
		<%@include file="/WEB-INF/jsp/index/menu.jsp"%>
		<!-- sidebar end -->

		<!-- content start -->
		<div class="admin-content">

			<div class="am-cf am-padding">
				<div class="am-fl am-cf">
      				<small>位置</small>：<small>用户中心</small>/<small>系统用户管理</small>
      			</div>
			</div>

			<div class="am-g">
				<div class="am-u-md-6 am-cf">
					<div class="am-fl am-cf">
						<div class="am-btn-toolbar am-fl">
							<div class="am-btn-group am-btn-group-xs">
							<slp:privilege module="userManager" oprator="add">
								<a class="am-btn am-btn-default"
									href="${pageContext.request.contextPath}/system/user/user_add_init"><span
									class="am-icon-plus"></span> 新增</a>
									</slp:privilege>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="am-g">
				<div class="am-u-sm-12">
					<form class="am-form">
						<table class="am-table am-table-striped am-table-hover table-main">
							<thead>
								<tr>
									<th>编号</th>
									<th>用户账号</th>
									<th>用户昵称</th>
									<th>用户部门</th>
									<th>用户类型</th>
									<th>用户状态</th>
									<th>上次登录时间</th>
									<th class="table-set">操作</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${list }" var="p">
									<tr>
										<td>${p.id}</td>
										<td>${p.userName}</td>
										<td>${p.nickName}</td>
										<td>${p.department.dpName}</td>
										<td>
										<c:choose>
											<c:when test="${p.userType == 1 }">
												部门管理员
											</c:when><c:otherwise>
												普通用户
											</c:otherwise>
										</c:choose>
										</td>
										<td class="status">
										<c:choose>
											<c:when test="${p.userStatus == 0 }">
												启用
											</c:when><c:otherwise>
												停用
											</c:otherwise>
										</c:choose>
										</td>
										<td>
										<fmt:formatDate value="${p.loginTime }" pattern="yyyy-MM-dd HH:mm:ss"/>
										</td>
										<td>
											<div class="am-btn-toolbar">
												<div class="am-btn-group am-btn-group-xs">
													<slp:privilege module="userManager" oprator="roleAssigned">
														<a href="${pageContext.request.contextPath}/system/user/userPrevInit?id=${p.id}"
															class="am-btn am-btn-default am-btn-xs am-text-secondary">
															 授权
														</a>
													</slp:privilege>
													<slp:privilege module="userManager" oprator="update">
														<a href="${pageContext.request.contextPath}/system/user/user_edit_init?id=${p.id}" class="am-btn am-btn-default am-btn-xs">
															 修改
														</a>
													</slp:privilege>
													<slp:privilege module="userManager" oprator="delete">
														<a href="javascript:if(confirm('您确定要删除?')){window.location='${pageContext.request.contextPath}/system/user/user_del?id=${p.id}&currentPage=${requestScope.page.currentPage}'}"
															class="am-btn am-btn-default am-btn-xs am-text-danger">
															 删除
														</a>
													</slp:privilege>
													<slp:privilege module="userManager" oprator="startOrStop">
														<a href="javascript:void(0);" name="${p.id }"
															class="am-btn am-btn-default am-btn-xs am-text-danger startOrStop">
															<c:choose>
																<c:when test="${p.userStatus == 0 }">
																	停用
																</c:when><c:otherwise>
																	启用
																</c:otherwise>
															</c:choose>
														</a>
													</slp:privilege>
													<slp:privilege module="userManager" oprator="initPwd">
														<a href="javascript:void(0);" name="${p.id }"
															class="am-btn am-btn-default am-btn-xs am-text-danger resetpwd">
															重置密码
														</a>
													</slp:privilege>
												</div>
											</div></td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
						<div class="am-cf">
							共 ${requestScope.page.totalSize } 条记录&nbsp;&nbsp;<span class="tooltip"></span>
							<div class="am-fr">
								<ul class="am-pagination ">
									${requestScope.pageString }
								</ul>
							</div>
						</div>
					</form>
				</div>

			</div>
			<br><br><br><br><br>
		</div>
		<!-- content end -->

	</div>
	<%@include file="/WEB-INF/jsp/index/foot.jsp"%>
	<input type="hidden" value="${requestScope.page.totalPage }" id="totalPage"/>
	<script type="text/javascript">
		$(document).ready(function(){
			$('.page_s').on('click',function(){
				var count = $(this).attr('lang');
				if (count <= parseInt($('#totalPage').val()) && count >= 1){
				window.location.href="${pageContext.request.contextPath}/system/user/user_list?currentPage="+count;
			}
			});
			/**
			 * 用户启用或者暂停
			 */
			$(".startOrStop").click(function() {
				var params = $(this).attr("name");
				var obj = $(this);
				$.ajax({
					type : "post",
					dataType : "json",
					data : {
						id : params
					},
					url : "${pageContext.request.contextPath}/system/user/startOrStop",
					success : function(data) {
						if (data.errorFlags) {
							$(obj).html(obj.parent().parent().parent().parent().children('.status').html());
							obj.parent().parent().parent().parent().children('.status').html(data.message);
							$('.tooltip').html('操作成功');
							$('.tooltip').fadeIn("fast",function(){
						  			$(this).fadeOut(3000);
						  		});
						} else {
							$('.tooltip').html(data.message);
							$('.tooltip').fadeIn("fast",function(){
						  			$(this).fadeOut(3000);
						  		});
						}
					},
					error : function() {
						$('.tooltip').html('用户启用或者停用出错了，请稍后再试');
							$('.tooltip').fadeIn("fast",function(){
						  			$(this).fadeOut(3000);
						  		});
					}
				});
		});
		$(".resetpwd").click(function() {
				var params = $(this).attr("name");
				$.ajax({
					type : "post",
					dataType : "json",
					data : {
						id : params
					},
					url : "${pageContext.request.contextPath}/system/user/pwdInt",
					success : function(data) {
							$('.tooltip').html(data.message);
							$('.tooltip').fadeIn("fast",function(){
						  			$(this).fadeOut(3000);
						  		});
					},
					error : function() {
						$('.tooltip').html('用户密码重置出错了，请稍后再试');
							$('.tooltip').fadeIn("fast",function(){
						  			$(this).fadeOut(3000);
						  		});
					}
				});
	});
		});
	</script>
</body>
</html>