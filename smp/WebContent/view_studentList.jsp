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
<title>학생목록</title>
</head>
<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	StringBuffer queryBuffer = new StringBuffer();
	queryBuffer.append("SELECT TOTAL.STUDENT_SEQ");
	queryBuffer.append("	 , TOTAL.STUDENT_NAME");
	queryBuffer.append("	 , TOTAL.GENDER");
	queryBuffer.append("	 , TOTAL.PHONE_NO");
	queryBuffer.append("	 , TOTAL.STUDENT_ADDR");
	queryBuffer.append("	 , TOTAL.STUDENT_NO");
	queryBuffer.append("	 , SUBSTRING(TOTAL.STUDENT_NO, 1, 1) AS SCHOOL_YEAR_NO");
	queryBuffer.append("	 , SUBSTRING(TOTAL.STUDENT_NO, 2, 2) AS CLASS_NO");
	queryBuffer.append("	 , SUBSTRING(TOTAL.STUDENT_NO, 4, 2) AS PERSONAL_NO");
	queryBuffer.append("  FROM (  ");
	queryBuffer.append("	SELECT M.STUDENT_SEQ");
	queryBuffer.append("		 , M.STUDENT_NAME");
	queryBuffer.append("		 , M.GENDER");
	queryBuffer.append("		 , M.PHONE_NO");
	queryBuffer.append("		 , M.STUDENT_ADDR");
	queryBuffer.append("		 , MAX(H.STUDENT_NO) AS STUDENT_NO");
	queryBuffer.append("	  FROM TB_STUDENT_M M");
	queryBuffer.append("		, TB_STUDENT_H H");
	queryBuffer.append("	 WHERE M.STUDENT_SEQ = H.STUDENT_SEQ");
	queryBuffer.append("	  AND M.USE_YN = 1");
	queryBuffer.append("	  AND H.USE_YN = 1");
	queryBuffer.append("	 GROUP BY M.STUDENT_SEQ");
	queryBuffer.append(") TOTAL");
	
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
	} finally {
		rs.close();
		pstmt.close();
		conn.close();
	}

%>
<body>
	<jsp:include page="header.jsp"></jsp:include>
	<jsp:include page="menu.jsp"></jsp:include>

	<table border = "">
		<tr>
			<td>학번</td>
			<td>이름</td>
			<td>학년</td>
			<td>반</td>
			<td>번호</td>
			<td>성별</td>
			<td>전화번호</td>
			<td>주소</td>
		</tr>
		<%
			for (int i = 0; i < list.size(); i++) {
		%>
		<tr>
			<td><%=list.get(i).get("studentNo") %></td>
			<td><%=list.get(i).get("studentName") %></td>
			<td><%=list.get(i).get("schoolYearNo") %></td>
			<td><%=list.get(i).get("classNo") %></td>
			<td><%=list.get(i).get("personalNo") %></td>
			<td><%=list.get(i).get("gender") %></td>
			<td><%=list.get(i).get("phoneNo") %></td>
			<td><%=list.get(i).get("studentAddr") %></td>

		</tr>
		<%	
			}
		%>	
	
	</table>
	
	

	
</body>
</html>