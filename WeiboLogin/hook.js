console.log("hook.js begin");
$('.login_btn').on('click',function()
                   {
                       var username = $('#userId').val();
                       var password = $('#passwd').val();
                       console.log("got username=" + username + " / " + "password=" + password);
                       //alert(username + ":" + password);
                       document.location = "myapp:" + "myfunction:" + username + ":" + password;
                   });
console.log("hook.js end");