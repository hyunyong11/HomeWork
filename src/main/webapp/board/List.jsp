<%@page import="utils.BoardPage"%>
<%@page import="model1.board.BoardDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="model1.board.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="./commons/header.jsp" %>
<%
//DAO 객체 생성 및 DB연결
BoardDAO dao = new BoardDAO(application);

//검색어가 있는 경우 파라미터를 저장하기 위한 Map컬렉션 생성
Map<String, Object> param = new HashMap<String, Object>();
//검색 파라미터를 request내장객체를 통해 얻어온다. 
String searchField = request.getParameter("searchField");
String searchWord = request.getParameter("searchWord");
//검색어가 있는 경우에만..
if(searchWord != null) {
	//Map컬렉션에 파라미터 값을 추가한다.
	param.put("searchField", searchField);//검색필드면(title, content등)
	param.put("searchWord", searchWord);//검색어
}
//board테이블에 저장된 게시물의 갯수 카운트
int totalCount = dao.selectCount(param);

//페이지 처리를 위한 코드 추가 부분....
/* 페이지 처리 start */
int pageSize = Integer.parseInt(application.getInitParameter("POSTS_PER_PAGE"));
int blockPage = Integer.parseInt(application.getInitParameter("PAGES_PER_BLOCK"));
int totalPage = (int)Math.ceil((double)totalCount / pageSize);

int pageNum = 1;
String pageTemp = request.getParameter("pageNum");
if (pageTemp != null && !pageTemp.equals(""))
	pageNum = Integer.parseInt(pageTemp);

int start = (pageNum -1) * pageSize + 1;
int end = pageNum * pageSize;
param.put("start", start);
param.put("end", end);
/* 페이지 처리 end */

//출력할 레코드 추출
List<BoardDTO> boardLists = dao.selectListPage(param);
//자원해제
dao.close();
%>
<body>
<div class="container">
    <!-- Top영역 -->
    <%@ include file="./commons/top.jsp" %>
    <!-- Body영역 -->
    <div class="row">
        <!-- Left메뉴영역 -->
    <%@ include file="./commons/left.jsp" %>
        <!-- Contents영역 -->
        <div class="col-9 pt-3">
            <h3>게시판 목록 - <small>자유게시판 현재 페이지 : <%= pageNum %> (전체 : <%= totalPage %>)</small></h3>
            <!-- 검색 -->
            <div class="row">
                <form action="" method="get">
                    <div class="input-group ms-auto" style="width: 400px;">
                        <select name="searchField" class="form-control">
                            <option value="title">제목</option>
                            <option value="content">내용</option>
                        </select>
                        <input type="text" class="form-control" name="searchWord" placeholder="Search" style="width: 200px;">
                        <button class="btn btn-success" type="submit">
                            <i class="bi-search" style="font-size: 1rem; color: white;"></i>
                        </button>
                    </div>
                </form>
            </div>
            <!-- 게시판 리스트 -->
            <div class="row mt-3 mx-1">
                <table class="table table-bordered table-hover table-striped">
                <thead>
                    <tr class="text-center">
                        <th>번호</th>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>조회수</th>
                        <th>작성일</th>
                    </tr>
                </thead>
                <tbody>
                    <%
					if(boardLists.isEmpty()){
					%>
							<tr>
								<td colspan="5" align="center">
									등록된 게시물이 없습니다.
								</td>
							</tr>
					<%
					}
					else{
						//게시물이 있을때
						int virtualNum = 0;//게시물의 출력번호
						int countNum = 0;
						//확장 for문을 통해 List컬렉션에 저장된 레코드의 갯수만큼 반복한다.
						for (BoardDTO dto : boardLists)
						{
							//전체 레코드 수를 1씩 차감하면서 번호를 출력
							//virtualNum = totalCount--;
							 virtualNum = totalCount - (((pageNum -1) * pageSize) + countNum++);
					%>
							<tr align="center">
								<td><%= virtualNum %></td>
								<td align="left">
									<a href="View.jsp?num=<%= dto.getNum() %>"><%= dto.getTitle() %></a>
								</td>
								<td align="center"><%= dto.getId() %></td>
								<td align="center"><%= dto.getVisitcount()%></td> 
								<td align="center"><%= dto.getPostdate() %></td>
							</tr>
					<% 
						}
						
					}
					%>           
                    
                </tbody>
                </table>
                <table  width="90%">
			        <tr align="center">
			        	<!-- 페이징 처리 -->
			             <div class="col d-flex justify-content-end">
		                    <button type="button" class="btn btn-primary" onclick="location.href='Write.jsp';">글쓰기</button>
		                </div>
			        	<td>
			        		<%= BoardPage.pagingStr(totalCount, pageSize, 
			        				blockPage, pageNum, request.getRequestURI()) %>
			        				<!-- 
			        				request.getRequestURI() : request내장객체를 통해 현재 페이지에서
			        				HOST부분을 제외한 전체 경로명을 얻을 수 있다. 여기서
			        				얻은 경로명을 통해 "경로명?pageNum=번호"와 같은 링크를 만들수 있다.
			        				 -->
			        	</td>
			        </tr>
    			</table>
            </div>
            <!-- 각종버튼 -->
            <!-- <div class="row">
                <div class="col d-flex justify-content-end">
                    <button type="button" class="btn btn-primary" onclick="location.href='Write.jsp';">글쓰기</button>
                </div>
            </div> -->
            <!-- 페이지 번호 -->
            <!-- <div class="row mt-3">
                <div class="col">
                    <ul class="pagination justify-content-center">
                        <li class="page-item"><a class="page-link" href="#">
                            <i class='bi bi-skip-backward-fill'></i>
                        </a></li>
                        <li class="page-item"><a class="page-link" href="#">
                            <i class='bi bi-skip-start-fill'></i>
                        </a></li>
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                        <li class="page-item"><a class="page-link" href="#">
                            <i class='bi bi-skip-end-fill'></i>
                        </a></li>
                        <li class="page-item"><a class="page-link" href="#">
                            <i class='bi bi-skip-forward-fill'></i>
                        </a></li>
                    </ul>
                </div>
            </div> -->
        </div>
    </div>
    <!-- Copyright영역 -->
    <%@ include file="./commons/copyright.jsp" %>
</div>
</body>
</html>