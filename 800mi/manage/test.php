<?php
//echo phpinfo();
$str = "4,5,6|4,5,6";

$ary = explode('|',$str);
//print_r ($ary);

$key = explode(',',$ary[0]);
$value = explode(',',$ary[1]);

//print_r ($key);
//print_r ($value);

$list = array_combine($key,$value);

print_r ($list);

?>