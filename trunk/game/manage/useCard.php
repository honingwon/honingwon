<?php

include_once("view/common.php");  
require_once(DATALIB . '/SqlResult.php');
require_once(DATACONTROL . '/BMAccount/EventLog.php');

$cardSN = '';
$userName = '';
$ip = '';
$serverId = 0;

if(isset($_GET['cardSN']))
{
	$cardSN = $_GET['cardSN'];
}
if(isset($_GET['userName']))
{
	$userName = $_GET['userName'];
}
if(isset($_GET['ip']))
{
	$ip = $_GET['ip'];
}
if(isset($_GET['serverId']))
{
	$serverId = $_GET['serverId'];
}

$sql = sprintf("CALL ChargeCard('%s','%s','%s',%d);",$cardSN,$userName,$ip,$serverId);
//�����ֵ�ɹ������ؿ����ͣ����򷵻�0��
$r = sql_fetch_one_cell($sql);
//�����ֵ�ɹ�
if($r > 0)
{
	//һ�ֿ�ֻ����һ�����ߣ�һ��Ϊ�����
	$sql2 = 'select a.bm_ItemGID,b.cd_CardItemNum from bm_item a, cd_cardaffixitem b where b.cd_CardTypeID = '.$r.' and a.bm_ItemID = b.bm_ItemID';
	$r2 = sql_fetch_one($sql2);
	echo 1;
	//echo $r2[1];
	//echo $r2[0];	
}
else
{
	echo 0;
}
?>