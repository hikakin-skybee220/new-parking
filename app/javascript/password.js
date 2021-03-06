
$(function() {
    if (document.getElementById("newPasswordForm") != null) { 
        const auth = firebase.auth();  
        const newPasswordForm = document.querySelector('#newPasswordForm');
        let btn = document.getElementById("newPasswordSubmit");
        btn.addEventListener('click', (e) => {
        e.preventDefault();
        const emailAddress = newPasswordForm['password-email'].value;  
        auth.sendPasswordResetEmail(emailAddress).then(function() {
            // Email sent.
            var href = $('#newPasswordForm').attr('action');
            location.href = href; 
            console.log(`メールを送信しました`);
        }).catch(function(error) {
            console.log(`メールを送信できませんでした (${error})`);
        });
        });
    }
    
});
