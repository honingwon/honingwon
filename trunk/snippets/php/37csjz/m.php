<?php
//move the first line of 'a.txt' to 'b.txt'

$filename="a.txt";//��������ļ�
$delline=1; //Ҫɾ��������
$farray=file($filename);//��ȡ�ļ����ݵ�������
$newfp = '';
$line = '';
for($i=0;$i<count($farray);$i++)
{   
    if(strcmp($i+1,$delline)==0)  //�ж�ɾ������,strcmp�ǱȽ���������С�ĺ���
    {   
		$line.=$farray[$i]; 
        continue;
    }   
    if(trim($farray[$i])<>"")  //ɾ���ļ��е����п���
    {   
        $newfp.=$farray[$i];    //��������������
    }   
}   
$fp=@fopen($filename,"w");//��д�ķ�ʽ���ļ�
@fputs($fp,$newfp);
@fclose($fp);

$file = fopen("b.txt","a");
fwrite($file,$line);
fclose($file);
echo '<script>location.href = "http://9.qule.com/game.shtml?game=1026&zone=4"</script>'
?>