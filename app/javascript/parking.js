document.addEventListener("turbolinks:load" 
, function () {
$(function() {



  // FLASH FADEOUT
  setTimeout(function(){
    $('.alert , .notice').fadeOut();
  },3000);



let text = document.getElementById('finishTime');

function inputChange(){

  console.log(document.getElementById('park_start_on').textContent);
}
text.addEventListener('change', inputChange);

  // MODAL
  var scrollPos;//topからのスクロール位置
  $('#user-select-modal-button, #user-select-modal-finish-button, #user-select-modal-reserve-button').click(function() {
    scrollPos = $(window).scrollTop();//topからのスクロール位置を格納
    $('.user-select-modal-content').fadeIn();//モーダルをフェードイン
    $('.modal').fadeIn();
    $('body').addClass('fixed').css({ top: -scrollPos });//背景固定
    return false;//<a>を無効化
  });
  $('.overlay, .modal__close').click(function() {
    $('.user-select-modal-content').fadeOut();//モーダルをフェードアウト
    $('.modal').fadeOut();
    $('body').removeClass('fixed').css({ top: 0 });//背景固定を解除
    $(window).scrollTop(scrollPos);//元の位置までスクロール
    return false;//<a>を無効化
  });
  $('#parking-finish-modal-button').click(function() {
    scrollPos = $(window).scrollTop();//topからのスクロール位置を格納
    $('.parking-finish-modal-content').fadeIn();//モーダルをフェードイン
    $('.modal').fadeIn();
    $('body').addClass('fixed').css({ top: -scrollPos });//背景固定
    return false;//<a>を無効化
  });
  $('.overlay, .modal__close').click(function() {
    $('.parking-finish-modal-content').fadeOut();//モーダルをフェードアウト
    $('.modal').fadeOut();
    $('body').removeClass('fixed').css({ top: 0 });//背景固定を解除
    $(window).scrollTop(scrollPos);//元の位置までスクロール
    return false;//<a>を無効化
  });
  $('#purchase-new-account-button').click(function() {
    scrollPos = $(window).scrollTop();//topからのスクロール位置を格納
    $('.purchase-new-account-modal-content').fadeIn();//モーダルをフェードイン
    $('.modal').fadeIn();
    $('body').addClass('fixed').css({ top: -scrollPos });//背景固定
    return false;//<a>を無効化
  });
  $('.overlay, .modal__close').click(function() {
    $('.purchase-new-account-modal-content').fadeOut();//モーダルをフェードアウト
    $('.modal').fadeOut();
    $('body').removeClass('fixed').css({ top: 0 });//背景固定を解除
    $(window).scrollTop(scrollPos);//元の位置までスクロール
    return false;//<a>を無効化
  });

// HEADER
    var $win = $(window),
        $main = $('main'),
        $header = $('header'),
        headerHeight = $header.outerHeight(),   
        headerPos = $header.offset().top,     
        fixedClass = 'is-fixed',        
        nonBorder = 'non-border';
        
        $win.on('load scroll', function() {
            var value = $(this).scrollTop();
            if ( value > headerPos ) {
                $header.addClass(fixedClass);
                $main.css('margin-top', headerHeight);                
            } else {
                $header.removeClass(fixedClass);
                $main.css('margin-top', '0');             
            }
        });
        
//   SNS
  $('.sns-item-foo').hover(
        function(){
            $(this).find('i').animate({
                'font-size': '17px'
            },100);
        },
        function(){
            $(this).find('i').animate({
                'font-size': '13px'
            },100);
        }
    );

    // 「TOPに戻る」ボタンがクリックされた時の動きを指定します。
  $("#scroll_to_top").click(function() {
    // ページの一番上まで、アニメーション付きでスクロールさせます。
    // アニメーションの時間は300ミリ秒で、一定の速度（linear）で動かします。
    $('body, html').animate({scrollTop: 0}, 300, 'linear');
  });

  // 関数を変数「changeButtonState」に入れておきます。
  var changeButtonState = function() {
    // 「TOPに戻る」ボタンを取得します。
    var $toTopButton = $('#scroll_to_top');

    // 縦にどれだけスクロールしたかを取得します。
    var scrollTop = $(window).scrollTop();

    // ウィンドウの縦幅を取得します。
    var windowHeight = $(window).height();

    if (scrollTop >= windowHeight
        || ($(document).height() - windowHeight) <= scrollTop) {
      // ウィンドウの縦幅以上にスクロールしていた、
      // またはページの下端に達していた場合、
      // 「TOPに戻る」ボタンを表示します。
      $toTopButton.show();
    } else {
      // ウィンドウの縦幅以上にスクロールしていない場合、
      // 「TOPに戻る」ボタンを隠します。
      $toTopButton.hide();
    }
  }

  // ウィンドウをスクロール・ロード・リサイズしたときを契機に、
  // 「TOPに戻る】ボタンの表示・非表示を変更します。
  $(window).scroll(changeButtonState)
           .load(changeButtonState)
           .resize(changeButtonState);


  
    
});
})


$(function () {
  $('#nav-toggle').on('click', function () {
    $('body').toggleClass('open');

  });
  $('#gloval-nav nav ul li a').on('click', function () {
    $('body').removeClass('open');
  });
});

