
$(function() {
    if (document.getElementById("updateForm") != null) { 
        const firebaseauth = firebase.auth();  
        const updateForm = document.querySelector('#updateForm');
        let btn = document.getElementById("updateSubmit");
        btn.addEventListener('click', (e) => {
        e.preventDefault();
        
        // get user info
        const email = updateForm['update-email'].value;
        
        firebaseauth.onAuthStateChanged(user => {
            if (user) {
                var user = firebase.auth().currentUser;
                user.updateEmail(email).then(() => {
                    $("#update-email").removeAttr("name");        
                    $("#updateForm").append(
                        $('<input type="hidden" name="user-email-token">').val(user.email)                            
                    ); //取得したトークンを送信できる状態にします
                    document.inputForm.submit();  
                    alert("Successful editing!")
                }).catch((error) => {
                    alert(`アカウントを編集できませんでした (${error})`);
                });              
            } else {
                console.log('user logged out')
            }
        });
        });
    }
    if (document.getElementById("destroyButton") != null) { 
        let destroyBtn = document.getElementById("destroyButton");
        destroyBtn.addEventListener('click', (e) => {
            e.preventDefault();        
          
            firebaseauth.onAuthStateChanged(user => {
              if (user) {
                  var user = firebase.auth().currentUser;
                  user.delete().then(function() {
                      alert("Delate account!")
                      var href = $(destroyBtn).attr('href');
                      location.href = href; 
                  }).catch((error) => {
                      alert(`アカウントを削除できませんでした (${error})`);
                    });              
              } else {
                  console.log('user logged out')
              }
          });
          });
    }
    
});
