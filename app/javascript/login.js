
$(function() {    
    if (document.getElementById("loginForm") != null) { 
    const auth = firebase.auth();
    // login
    const loginForm = document.querySelector('#loginForm');
    loginForm.addEventListener('submit', (e) => {
        e.preventDefault();
    
        // get user info
        const email = loginForm['login-email'].value;
        const password = loginForm['login-password'].value;
    
        auth.signInWithEmailAndPassword(email, password).then(cred => { 
            var user = firebase.auth().currentUser;        
            $("#login-email").removeAttr("name");
            $("#login-password").removeAttr("name");//データを自サーバにpostしないように削除
            $("#loginForm").append(
                $('<input type="hidden" name="user-email-token">').val(user.email),
                $('<input type="hidden" name="user-uid-token">').val(user.uid)                 
            ); //取得したトークンを送信できる状態にします
            document.inputForm.submit();  
            alert("Successful login!")
        }).catch((error) => {        
            var errorMessage = error.message;
            alert(`ログインできませんでした (${errorMessage})`);
          });
    });
    }
});
