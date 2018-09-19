<%@page import="jdbc.DbConnection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
  table {
    width: 100%;
    border: 1px solid #444444;
    border-collapse: collapse;
  }
  th, td {
    border: 1px solid #444444;
    padding: 10px;
  }
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>성적입력</title>
</head>
<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	StringBuffer queryBuffer = new StringBuffer();
	
	String query = queryBuffer.toString();
	
	ArrayList<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
	
	try {
		
		DbConnection dbCon = new DbConnection();
		conn = dbCon.getConnection();
		if (conn != null) {
			System.out.println("connection success");
			pstmt = conn.prepareStatement(query);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("studentSeq", rs.getString("STUDENT_SEQ"));
				map.put("studentName", rs.getString("STUDENT_NAME"));
				map.put("gender", rs.getString("GENDER"));
				map.put("phoneNo", rs.getString("PHONE_NO"));
				map.put("studentAddr", rs.getString("STUDENT_ADDR"));
				map.put("studentNo", rs.getString("STUDENT_NO"));
				map.put("schoolYearNo", rs.getString("SCHOOL_YEAR_NO"));
				map.put("classNo", rs.getString("CLASS_NO"));
				map.put("personalNo", rs.getString("PERSONAL_NO"));
				list.add(map);
				
			}

		}
		
	} catch (SQLException e) {
		e.printStackTrace();
	}

%>
<body>

	<jsp:include page="header.jsp"></jsp:include>
	<jsp:include page="menu.jsp"></jsp:include>
	성적입력(view_scoreInsertForm.jsp) 입니다.
	<h3 align="center">성적입력</h3>
	<div>학생을 검색하세요</div>
	
	
	
	
	<table>
		<tr>
			<td>학변</td>
			<td><input type="text" value=""></td>
		</tr>
		
		<tr>
			<td>학년</td>
			<td><input type="text" value=""></td>
		</tr>
		<tr>
			<td>학기</td>
			<td><input type="text" value=""></td>
		</tr>
		<tr>
			<td>시험구분</td>
			<td><input type="text" value=""></td>
		</tr>
		
		<tr>
			<td>국어점수</td>
			<td><input type="text" value=""></td>
		</tr>
		<tr>
			<td>국어점수</td>
			<td><input type="text" value=""></td>
		</tr>
		<tr>
			<td>국어점수</td>
			<td><input type="text" value=""></td>
		</tr>
		
		<tr>
			<td>국어점수</td>
			<td><input type="text" value=""></td>
		</tr>
		<tr>
			<td>수학점수</td>
			<td><input type="text" value=""></td>
		</tr>
		<tr>
			<td>영어점수</td>
			<td><input type="text" value=""></td>
		</tr>
		<tr>
			<td>역사점수</td>
			<td><input type="text" value=""></td>
		</tr>
		<tr>
			<td colspan="2"></td>
		</tr>
	</table>
	
	
</body>
</html>