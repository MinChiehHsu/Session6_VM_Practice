<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Language" content="zh-tw">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>販賣機</title>
<style type="text/css">
.page {
	display: inline-block;
	padding-left: 10px;
}
</style>
<script type="text/javascript">

	</script>
</head>

<body align="center">
	<table width="1000" height="400" align="center">
		<tr>
			<td colspan="2" align="right">
				<form action="FrontendAction.do" method="get">
					<input type="hidden" name="action" value="searchGoods" /> <input
						type="hidden" name="pageNo" value="1" /> <input type="text"
						name="searchKeyword" /> <input type="submit" value="商品查詢" />
				</form>
			</td>
		</tr>
		<tr>
			<form action="FrontendAction.do" method="post">
				<input type="hidden" name="customerID" value="${member.idNo}" />
				<td width="400" height="200" align="center"><img border="0"
					src="DrinksImage/coffee.jpg" width="200" height="200">
					<h1>歡迎光臨， ${sessionScope.member.cusName}</h1> <a
					href="BackendAction.do?action=queryGoods&page=1" align="left">後臺頁面</a>&nbsp;
					&nbsp; <a href="LoginAction.do?action=logout" align="left">登出</a> <br />
					<br /> <font face="微軟正黑體" size="4"> <b>投入:</b> <input
						type="number" name="inputMoney" max="100000" min="0" size="5"
						value="0"> <b>元</b> <b><input type="submit" value="送出">
							<br /> <br /></font> 
					<div></div>
					<c:if test="${not empty sessionScope.insertedAmount}">
						<div 
							style="border-width: 3px; border-style: dashed; border-color: #FFAC55; padding: 5px; width: 300px;">
							<p style="color: blue;">~~~~~~~ 消費明細 ~~~~~~~</p>
							<p style="margin: 10px;">投入金額：${insertedAmount}</p>
							<p align="left">所選購商品：</p>
							<p align="center">------------------------------------------------</p>
							<c:forEach items="${selectedItems}" var="selectedItem">
							    <p>${selectedItem.key.goodsName} * ${selectedItem.value}</p>
							</c:forEach>
							<p align="center">------------------------------------------------</p>
							<p style="margin: 10px;">購買金額：${orderSum}</p>
							<p style="margin: 10px;">${resultMsg}</p>
						</div>
						</c:if></td>
						<% session.removeAttribute("insertedAmount"); %>
						<% session.removeAttribute("selectedItems"); %>
						<% session.removeAttribute("orderSum"); %>
						<% session.removeAttribute("resultMsg"); %>
						
				<td width="600" height="400"><input type="hidden" name="action"
					value="buyGoods" /> 
					
					<c:set var="pageSize" value="6" /> <!-- 每頁顯示的記錄數 -->
					<c:set var="currentPage" value="${pageNo != null ? pageNo : 1}" />
					<!-- 當前頁碼 --> <c:set var="startPosition"
						value="${currentPage * pageSize - pageSize}" /> <c:set
						var="endPosition" value="${currentPage * pageSize -1}" />
					<table border="1" style="border-collapse: collapse">
						<c:forEach items="${goodsList}" var="good"
							begin="${startPosition}" end="${endPosition}"
							varStatus="itemIndexs">
							<c:if test="${itemIndexs.index % 3 == 0}">
								<tr>
							</c:if>
							<td width="300"><font face="微軟正黑體" size="4"> <!-- 例如: 可口可樂 30元/罐 -->
									${good.goodsName}
							</font> <br /> <font face="微軟正黑體" size="4" style="color: gray;">
									<!-- 例如: 可口可樂 30元/罐 --> ${good.goodsPrice} 元/件
							</font> <br /> <!-- 各商品圖片 --> <img border="0"
								src="DrinksImage/${good.goodsImageName}" width="150"
								height="150"> <br /> <font face="微軟正黑體" size="3">
									<input type="hidden" name="goodsIDs" value="${good.goodsID}">
									<!-- 設定最多不能買大於庫存數量 --> 購買<input type="number"
									name="buyQuantitys" min="0" max="30" size="5" value="0">件
									<!-- 顯示庫存數量 --> <br>
									<p style="color: red;">(庫存 ${good.goodsQuantity} 件)</p>
							</font>
						</c:forEach>
						</td>
						</tr>
					</table></td>
			</form>
		</tr>

	</table>
			<c:set var="totalRecords" value="${goodsList.size()}" /> <!-- 總記錄數 -->
			<c:set var="totalPages" value="${totalRecords % pageSize ==0 ? totalRecords/pageSize: (totalRecords/pageSize) }" /> <!-- 總頁數 -->
			<!-- 去掉頁碼小數點(因為fmt捨去小數點後會將整數進或退到最接近的偶數) -->
			<c:choose>
				<c:when test="${totalPages % 2 > 1}">
				    <fmt:formatNumber value="${totalPages}" pattern="###" var="roundedTotalPages" />
				    <c:set var="totalPagesInt" value="${roundedTotalPages}" />
				</c:when>
				<c:otherwise>
				    <fmt:formatNumber value="${totalPages}" pattern="###" var="roundedTotalPages" />
				    <c:set var="totalPagesInt" value="${roundedTotalPages + 1}" />
				</c:otherwise>
			</c:choose>
			<c:set var="startPage" value="${currentPage - 2 > 0 ? currentPage - 1 : 1}" /> <!-- 分頁連結開始的頁碼 -->
			<c:set var="endPage" value="${startPage + 2 > totalPagesInt ? totalPagesInt : startPage + 2}" /> <!-- 分頁連結結束的頁碼 -->

		<c:if test="${endPage >= startPage}">
			<div class="pagination">
			    <c:if test="${currentPage > 1}">
			        <a href="FrontendAction.do?action=searchGoods&pageNo=${currentPage - 1}" style="font-size: 24px;">&lt; 上一頁</a>
			    </c:if>
			    
			    <c:forEach begin="${startPage}" end="${endPage}" var="page">
			        <c:choose>
			            <c:when test="${page == currentPage}">
			                <span style="font-size: 24px;"><strong>&nbsp;${page}&nbsp;</strong></span>
			            </c:when>
			            <c:otherwise>
			                <a href="FrontendAction.do?action=searchGoods&pageNo=${page}" style="font-size: 24px;">&nbsp;${page}&nbsp;</a>
			            </c:otherwise>
			        </c:choose>
			    </c:forEach>
			    
			    <c:if test="${currentPage < totalPagesInt}">
			        <a href="FrontendAction.do?action=searchGoods&pageNo=${currentPage + 1}" style="font-size: 24px;">下一頁 &gt;</a>
			    </c:if>
			</div>
		</c:if>
</body>

</html>