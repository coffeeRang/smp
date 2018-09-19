<%@page import="java.util.LinkedHashSet"%>
<%@page import="java.util.Set"%>
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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>학생성적</title>
</head>
<%
	String year = request.getParameter("year");
	String schoolYearTypeCd = request.getParameter("schoolYearTypeCd");
	String classTypeCd = request.getParameter("classTypeCd");
	String termTypeCd = request.getParameter("termTypeCd");
	String examTypeCd = request.getParameter("examTypeCd");
	System.out.println(">> year : " + year + ", schoolYearTypeCd : " + schoolYearTypeCd + ", classTypeCd : " + classTypeCd + ", termTypeCd : " + termTypeCd + ", examTypeCd : " + examTypeCd);

	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	StringBuffer queryBuffer = new StringBuffer();
	
	
	if (schoolYearTypeCd != null) {
		System.out.println("################ schoolYearTypeCd는 null이 아니다  ################");
		if (schoolYearTypeCd.equals("null")) {
			System.out.println(">> schoolYearTypeCd는 String 형태 null 이다");
		} else {
			System.out.println(">> schoolYearTypeCd는 String 형태 null이 아니다.");
		}
	} else {
		System.out.println("################ schoolYearTypeCd는 null이다  ################");
	}
	
	if (year != null && schoolYearTypeCd != null && classTypeCd != null && termTypeCd != null && examTypeCd != null) {
		
		queryBuffer.append("SELECT TOTAL.STUDENT_SEQ");
		queryBuffer.append("	 , TOTAL.STUDENT_NO");
		queryBuffer.append("	 , TOTAL.OCCUR_YEAR");
		queryBuffer.append("	 , TOTAL.SCHOOL_YEAR");
		queryBuffer.append("	 , TOTAL.CLASS_NO");
		queryBuffer.append("	 , TOTAL.PERSONAL_NO");
		queryBuffer.append("	 , TOTAL.STUDENT_NAME");
		queryBuffer.append("	 , TOTAL.SUBJECT_CD");
		queryBuffer.append("	 , TOTAL.SUBJECT_NAME");
		queryBuffer.append("	 , TOTAL.SCHOOL_YEAR_CD");
		queryBuffer.append("	 , TOTAL.SUBJECT_TERM_TYPE_CD");
		queryBuffer.append("	 , CASE WHEN TOTAL.SUBJECT_TERM_TYPE_CD = '01' THEN '1학기' ELSE '2학기' END SUBJECT_TERM_TYPE_NAME");
		queryBuffer.append("	 , TOTAL.EXAM_TYPE_CD");
		queryBuffer.append("	 , CASE WHEN TOTAL.EXAM_TYPE_CD = '01' THEN '중간고사'");
		queryBuffer.append("	 		WHEN TOTAL.EXAM_TYPE_CD = '02' THEN '기말고사' ELSE '수행평가' END EXAM_TYPE_NAME");
		queryBuffer.append("	 , TOTAL.SCORE_SEQ");
		queryBuffer.append("	 , TOTAL.SCORE");
		queryBuffer.append("  FROM (");
		queryBuffer.append("	SELECT TSM.STUDENT_SEQ");
		queryBuffer.append("		 , TSH.STUDENT_NO");
		queryBuffer.append("		 , TSH.OCCUR_YEAR");
		queryBuffer.append("		 , SUBSTRING(TSH.STUDENT_NO, 1, 1) AS SCHOOL_YEAR");
		queryBuffer.append("		 , SUBSTRING(TSH.STUDENT_NO, 2, 2) AS CLASS_NO");
		queryBuffer.append("		 , SUBSTRING(TSH.STUDENT_NO, 4, 2) AS PERSONAL_NO");
		queryBuffer.append("		 , TSM.STUDENT_NAME");
		queryBuffer.append("		 , TSUBM.SUBJECT_CD");
		queryBuffer.append("		 , TSUBM.SUBJECT_NAME");
		queryBuffer.append("		 , TSUBM.SCHOOL_YEAR_CD");
		queryBuffer.append("		 , TSL.SUBJECT_TERM_TYPE_CD	/*1학기, 2학기*/");
		queryBuffer.append("		 , TSL.EXAM_TYPE_CD			/*중간, 기말, 수행평가*/");
		queryBuffer.append("		 , TSL.SCORE_SEQ");
		queryBuffer.append("		 , TSL.SCORE");
		queryBuffer.append("	  FROM TB_STUDENT_M TSM");
		queryBuffer.append("		 , TB_STUDENT_H TSH");
		queryBuffer.append("		 , TB_SUBJECT_M TSUBM");
		queryBuffer.append("		 , TB_SCORE_L TSL");
		queryBuffer.append("	 WHERE 1 = 1");
		queryBuffer.append("	  AND TSM.STUDENT_SEQ = TSH.STUDENT_SEQ");
		queryBuffer.append("	  AND TSH.OCCUR_YEAR = ?				/*연도 구분*/");
	
		if (schoolYearTypeCd != null && !schoolYearTypeCd.equals("null")) {
			queryBuffer.append("	  AND TSH.STUDENT_NO LIKE ?				/*학년구분 : ex) 3% */");
			queryBuffer.append("	  AND TSUBM.SCHOOL_YEAR_CD = ?			/*학년구분 : ex) 03*/");
		}
	
		queryBuffer.append("	  AND TSM.STUDENT_SEQ = TSL.STUDENT_SEQ");
		queryBuffer.append("	  AND TSUBM.SUBJECT_SEQ = TSL.SUBJECT_SEQ");
		queryBuffer.append("	GROUP BY TSM.STUDENT_SEQ, TSH.STUDENT_NO, TSH.OCCUR_YEAR, TSM.STUDENT_NAME, TSUBM.SUBJECT_CD, TSUBM.SUBJECT_NAME, TSUBM.SCHOOL_YEAR_CD, TSL.SUBJECT_TERM_TYPE_CD, TSL.EXAM_TYPE_CD, TSL.SCORE_SEQ, TSL.SCORE");
		queryBuffer.append("  ) TOTAL");
		queryBuffer.append(" WHERE 1 = 1");
	
		if (classTypeCd != null && !classTypeCd.equals("null")) {
			queryBuffer.append("  AND TOTAL.CLASS_NO = ?				/*반 구분 : ex) 01*/");
		}
	
		if (termTypeCd != "00" && !termTypeCd.equals("null")) {
			queryBuffer.append("  AND TOTAL.SUBJECT_TERM_TYPE_CD = ?	/*학기 구분 : ex) 01*/");
		}
	
		if (examTypeCd != "00" && !examTypeCd.equals("null")) {
			queryBuffer.append("  AND TOTAL.EXAM_TYPE_CD = ?			/*시험구분 : ex) 01*/");
		}
		
		String query = queryBuffer.toString();
		
		ArrayList<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		
		try {
			
			DbConnection dbCon = new DbConnection();
			conn = dbCon.getConnection();
			if (conn != null) {
				System.out.println("connection success");
				pstmt = conn.prepareStatement(query);
	
				pstmt.setString(1, year);	// 연도
				if (!schoolYearTypeCd.equals("null")) {
					pstmt.setString(2, schoolYearTypeCd + "%");	// 학번 like 로 비교하기 위한 like 비교하기 위해 % 포함된 parameter
					pstmt.setString(3, "0" + schoolYearTypeCd);	// 학년코드
				}
				if (!classTypeCd.equals("null")) {
					pstmt.setString(4, classTypeCd);			// 반
				}
				if (!termTypeCd.equals("null")) {
					pstmt.setString(5, termTypeCd);				// 학기
				}
				if (!examTypeCd.equals("null")) {
					pstmt.setString(6, examTypeCd);				// 시험구분
				}
				
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("studentSeq", rs.getString("STUDENT_SEQ"));
					map.put("studentNo", rs.getString("STUDENT_NO"));
					map.put("occurYear", rs.getString("OCCUR_YEAR"));
					map.put("schoolYear", rs.getString("SCHOOL_YEAR"));
					map.put("classNo", rs.getString("CLASS_NO"));
					map.put("personalNo", rs.getString("PERSONAL_NO"));
					map.put("studentName", rs.getString("STUDENT_NAME"));
					map.put("subjectCd", rs.getString("SUBJECT_CD"));
					map.put("subjectName", rs.getString("SUBJECT_NAME"));
					map.put("schoolYearCd", rs.getString("SCHOOL_YEAR_CD"));
					map.put("subjectTermTypeCd", rs.getString("SUBJECT_TERM_TYPE_CD"));
					map.put("subjectTermTypeName", rs.getString("SUBJECT_TERM_TYPE_NAME"));
					map.put("examTypeCd", rs.getString("EXAM_TYPE_CD"));
					map.put("examTypeName", rs.getString("EXAM_TYPE_NAME"));
					map.put("scoreSeq", rs.getString("SCORE_SEQ"));
					map.put("score", rs.getString("SCORE"));
					list.add(map);
				}
				
				for (int i = 0; i < list.size(); i++) {
					System.out.println(i + " : " + list.get(i));
				}
				// tkfk
				
				ArrayList<Map<String, Object>> newList = new ArrayList<Map<String, Object>>();
				Set<String> studentSet = new LinkedHashSet<String>();			// 학생 seq
				Set<String> subjectTermTypeCdSet = new LinkedHashSet<String>();	// 학기
				Set<String> examTypeCdSet = new LinkedHashSet<String>();		// 시험구분
				Set<String> subjectCdSet = new LinkedHashSet<String>();			// 과목구분
				
				for (int i = 0; i < list.size(); i++) {
					studentSet.add( (String)list.get(i).get("studentSeq") );
					subjectTermTypeCdSet.add( (String)list.get(i).get("subjectTermTypeCd") );
					examTypeCdSet.add( (String)list.get(i).get("examTypeCd") );
					subjectCdSet.add( (String)list.get(i).get("subjectCd") );
				}
				
				for (int i = 0; i < list.size(); i++) {
					HashMap<String, Object> tempMap = new HashMap<String, Object>();

					String studentSeq = (String)list.get(i).get("studentSeq");
					String subjectTermTypeCd = (String)list.get(i).get("subjectTermTypeCd");
					String examTypeCdValue = (String)list.get(i).get("examTypeCd");
					String subjectCd = (String)list.get(i).get("subjectCd");

					// tempMap.put("", list.get(i).get(""));
					for (String studentKey: studentSet) {
						if (studentKey.equals(studentSeq)) {
							tempMap.put("studentSeq", studentSeq);
							tempMap.put("studentName", list.get(i).get("studentName"));
							tempMap.put("schoolYear", list.get(i).get("schoolYear");
							tempMap.put("classNo", list.get(i).get("classNo"));
							tempMap.put("personalNo", list.get(i).get("personalNo"));
							tempMap.put("studentNo", list.get(i).get("studentNo"));
						}
						for (String subjectTermTypeKey: subjectTermTypeCdSet) {
							if (subjectTermTypeKey.equals(subjectTermTypeCd)) {
								
							}
							
						}
						
					}
					
				}
				
				
				
				
	
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	
	}

%>

<body>
	<jsp:include page="header.jsp"></jsp:include>
	<jsp:include page="menu.jsp"></jsp:include>
	학생성적(view_studentScoreList.jsp) 입니다.
	<form>
	
	<table>
		<tr>
			<td>연도</td>
			<td>학년</td>
			<td>반</td>
			<td>학기</td>
			<td>시험구분</td>
		</tr>
		<tr>
			<td>
				<select name="year">
					<option value = "2018">2018</option>
					<option value = "2017">2017</option>
					<option value = "2016">2016</option>
				</select>				
			</td>
			<td>
				<select name="schoolYearTypeCd">
					<option value = null>전체</option>
					<option value = "1">1학년</option>
					<option value = "2">2학년</option>
					<option value = "3">3학년</option>
				</select>				
			</td>
			<td>
				<select name="classTypeCd">
					<option value = null>전체</option>
					<option value = "01">1반</option>
					<option value = "02">2반</option>
					<option value = "03">3반</option>
					<option value = "04">4반</option>
					<option value = "05">5반</option>
				</select>				
			</td>
			<td>
				<select name="termTypeCd">
					<option value = null>전체</option>
					<option value = "01">1학기</option>
					<option value = "02">2학기</option>
				</select>				
			</td>
			<td>
				<select name="examTypeCd">
					<option value = null>전체</option>
					<option value = "01">중간고사</option>
					<option value = "02">기말고사</option>
					<option value = "03">수행평가</option>
				</select>
				
			</td>
		</tr>
	</table>
	<input type="submit" value="조회" />
	</form>

	
	
</body>
</html>