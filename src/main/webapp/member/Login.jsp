<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        .user_input{border:1px solid rgb(75, 75, 75);width:320px;height:27px;padding:10px;font-size:18px;}
        input[type=image]{margin-top: 2px;}
    </style>
</head>
<body>
<span style="color: red; font-size: 1.2em;">
	<%= request.getAttribute("LoginErrMsg")==null ?
			"" : request.getAttribute("LoginErrMsg")%>
	</span>
	<%
	if(session.getAttribute("UserId") == null){ //로그인 상태 확인
		//만약 session영역에 저장된 속성이 없다면 로그인 이전의 상태이므로
		//로그인 폼을 화면에 출력한다.
	%>
	<script>
	//폼값의 유효성 검증을 위한 함수. 입력값이 빈값인지 확인한다.
	function validateForm(form) {
		if(!form.user_id.value){
			alert("아이디를 입력하세요");
			form.id.focus();
			return false;
		}
		if(form.user_id.value==""){
			alert("패스워드를 입력하세요");
			form.passwd.focus();
			return false;
		}
	}
	</script>
<fieldset>
    <table border="0" cellpadding="40" cellspacing="0" width="100%">
        <tr>
            <td align="center" valign="middle">
                <table border="0" cellpadding="0" cellspacing="0" width="470">
                    <tr>
                    	<td align="center">
                    		<a href="../board/List.jsp"><img style="width: 30px" src="./images/main.jpg"/></a>
                    	</td>
                        <td align="center"><img src="./images/login_logo.gif" /></td>
                    </tr>
                </table>
                <form name="loginFrm" action="LoginProcess.jsp" method="post"
                	onsubmit="return validateForm(this);">
                <table width="470" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="350">
                            <input type="text" name="user_id" placeholder="아이디" class="user_input" />
                        </td>
                        <td width="120" rowspan="3" align="right">
                            <input type="image" src="./images/login_bt.gif" />
                        </td>
                    </tr>
                    <tr height="5">
                        <td></td>
                    </tr>
                    <tr>
                        <td>
                            <input type="password" name="user_pw" placeholder="****" class="user_input" />
                        </td>
                    </tr>
                </table>
                <div style="margin-top:15px;"></div>
                <div style="margin-top:15px;"></div>
                <table width="470" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="left">
                            <a href="#" onClick=""><img src="./images/login_member.gif" alt="아직도 회원이 아니세요?" /></a>
                        </td>
                        <td align="right">
                            <a href="./Find.jsp" onClick=""><img src="./images/login_idpw.gif" alt="아이디/비밀번호를 잊어버리셨어요?" /></a>
                        </td>
                    </tr>
           
                </table>
                </form>
                <%
				} else { //로그인 된 상태
				%>
					<%= session.getAttribute("UserName") %> 회원님, 로그인 하셨습니다. <br />
					<a href="../board/List.jsp">메인으로</a>
					<a href="Logout.jsp">[로그아웃]</a>
				<%
				}
				%>
                <div style="margin-top:30px;"></div>
            </td>
        </tr>
    </table>
</fieldset>
</body>
</html>