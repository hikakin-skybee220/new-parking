document.addEventListener("turbolinks:load" 
, function () {
$(function() {
    if (document.getElementById("firebaseui-auth-container") != null) { 
    var ui = new firebaseui.auth.AuthUI(firebase.auth());
    var uiConfig = {
        callbacks: {            
            signInSuccessWithAuthResult: (authResult, redirectUrl) => {
              authResult.user.getIdToken(true)
                .then((idToken) => { railsLogin(authResult.additionalUserInfo.isNewUser, idToken) })
                .catch((error)  => { console.log(`Firebase getIdToken failed!: ${error.message}`) });
              return false; // firebase側にログイン後はリダイレクトせず、railsへajaxでリクエストを送る
            },
            uiShown: () => { document.getElementById('loader').style.display = 'none' }
          },
          signInFlow: 'redirect',
          signInOptions: [
            firebase.auth.GoogleAuthProvider.PROVIDER_ID // Google認証
          ],
          tosUrl: '',
          // Privacy policy url/callback.
          privacyPolicyUrl: function() {
            window.location.assign('');
          }
        };
      　// ログイン画面表示
        ui.start('#firebaseui-auth-container', uiConfig);

      
      var csrfTokenObj = () => {
        return { "X-CSRF-TOKEN": $('meta[name="csrf-token"]').attr('content') };
      }
      
      var authorizationObj = (idToken) => {
        return { "Authorization": `Bearer ${idToken}` };
      }
      
      var railsLogin = (isNewUser, idToken) => {
        var url = isNewUser ? "/accounts" : "/login/googlecreate";        
        var headers = Object.assign(csrfTokenObj(), authorizationObj(idToken));
        $.ajax({url: url, type: "POST", headers: headers})
          .done((data) => { console.log("Rails login!")      })
          .fail((data) => { console.log("Rails login failed!") });
      }
    }
});
})