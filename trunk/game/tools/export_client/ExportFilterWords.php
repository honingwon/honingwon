<?php
require_once(dirname(__FILE__).'/api/Provider.php');
require_once(dirname(__FILE__).'/lib/SqlResult.php');
require_once(dirname(__FILE__).'/Package/PackageIn.php');
require_once(dirname(__FILE__).'/Package/PHPPack.php');

ini_set("memory_limit","-1");

$fp = fopen("FilterContentList.data",'wb')or die("cannot open FilterContentList.data"); 
$str = pack("C",0); 		//v
fwrite($fp,$str);
$str = pack("C",0); 		//v
fwrite($fp,$str);
$str = pack("C",1); 		//v
fwrite($fp,$str);

$d = Provider::getInstance()->getFilterContent();
sava($d,$fp);
	



fclose($fp);
echo "export suc","\n";




function sava($d,$fp){
	$pk = new PackageIn();
	
	$r = $d->DataList;
	$count = count($r);
	$lable = $d->Tag;
	$pk->writeInt($count);
	for ($i = 0 ; $i < $count; $i++){
		foreach($r[$i] as $key=>$value){
			switch($lable[$key]){
				case "int" :
					$pk->writeInt($value);
					break;
				case "string" :
					$pk->writeUTF($value);
					break;
				case "byte" :
					$pk->writeByte($value);
					break;
				case "short" :
					$pk->writeShort($value);
					break;
			}
		}	
	}
	

	mypack($fp,$pk->data->format,$pk->data->params);
	
}




function mypack($fp,$format,$params)
{
	
	
	$fun = "\$str = pack('".$format."',".join(",",$params).");";
	
	eval ($fun);  
  	
	fwrite($fp,$str);
	
}

?>
