
$(function() {
    if (document.getElementById("newPasswordForm") != null) { 
        const auth = firebase.auth();    
        // signup
        const signupForm = document.querySelector('#signupForm');
        let btn = document.getElementById("signupSubmit");
        btn.addEventListener('click', (e) => {
        e.preventDefault();
        
        // get user info
        const email = signupForm['signup-email'].value;
        const password = signupForm['signup-password'].value;
        
        // sign up the user
        auth.createUserWithEmailAndPassword(email, password).then((user) => {         
                var user = firebase.auth().currentUser;        
                $("#signup-email").removeAttr("name");
                $("#signup-password").removeAttr("name");//データを自サーバにpostしないように削除
                $("#signupForm").append(
                    $('<input type="hidden" name="user-email-token">').val(user.email),
                    $('<input type="hidden" name="user-uid-token">').val(user.uid)                 
                ); //取得したトークンを送信できる状態にします
                document.inputForm.submit();  
                alert("Create account!")
            }).catch((error) => {        
                var errorMessage = error.message;
                alert(`アカウントを作成できませんでした (${errorMessage})`);
            });
        });
    }
});
