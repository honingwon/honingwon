<?php
$body = "仅支持css、js。";

$sleep = (int)($_REQUEST["sleep"]);
$type = $_REQUEST["type"];

if(!$sleep) exit("sleep参数必须指定并且是大于0的整数。");
if(!$type) exit("请指定type参数。");

switch ($type)
{
case "css":
  $body = "strong{color:red}";
  header("Content-Type:text/css");
  break;  
case "js":
  $body = "document.body.innerHTML += '<strong>我是延迟" . $sleep ."秒的Javascript脚本。</strong>'";
  header("Content-Type:application/x-javascript");
  break;
//default: 
  //默认Content-Type为text/html
}

echo $body;
sleep($sleep);
?>