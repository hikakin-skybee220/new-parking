document.addEventListener("turbolinks:load" 
, function () {
$(function() {

// listen for auth status changes
const auth = firebase.auth();
auth.onAuthStateChanged(user => {
    if (user) {
        console.log('user logged in: ', user)        
    } else {
        console.log('user logged out')
    }
});
const logout = document.querySelector('#logout');
logout.addEventListener('click', (e) => {
    e.preventDefault();
    auth.signOut().then(()=> {
        var href = $('#logout').attr('href');
        location.href = href;
    }).catch( (error)=>{
        alert(`ログアウト時にエラーが発生しました (${error})`);
    });
});
const smlogout = document.querySelector('#sm-logout');
smlogout.addEventListener('click', (e) => {
    e.preventDefault();
    auth.signOut().then(()=> {
        var href = $('#sm-logout').attr('href');
        location.href = href;
    }).catch( (error)=>{
        alert(`ログアウト時にエラーが発生しました (${error})`);
    });
});

});
})