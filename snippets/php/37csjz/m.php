<?php
//move the first line of 'a.txt' to 'b.txt'

$filename="a.txt";//定义操作文件
$delline=1; //要删除的行数
$farray=file($filename);//读取文件数据到数组中
$newfp = '';
$line = '';
for($i=0;$i<count($farray);$i++)
{   
    if(strcmp($i+1,$delline)==0)  //判断删除的行,strcmp是比较两个数大小的函数
    {   
		$line.=$farray[$i]; 
        continue;
    }   
    if(trim($farray[$i])<>"")  //删除文件中的所有空行
    {   
        $newfp.=$farray[$i];    //重新整理后的数据
    }   
}   
$fp=@fopen($filename,"w");//以写的方式打开文件
@fputs($fp,$newfp);
@fclose($fp);

$file = fopen("b.txt","a");
fwrite($file,$line);
fclose($file);
?>