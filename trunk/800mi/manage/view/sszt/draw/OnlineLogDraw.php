<?php

 require_once('../Utils.class');
require_once('../../../view/common.php');

require_once('../provider/DataAnalysisManageProvider.php');

	$plat = $_GET["plat"];
	$server = $_GET["server"];
	$dateTime = $_GET["dateTime"];
	$imgWidth = $_GET["imgWidth"];
	if($dateTime == "0")
	{
		$dateTime = date("Y-m-d",mktime());
	}
	$r_dataResult =  DataAnalysisManageProvider::dataMentods_onlineManageNumber($dateTime,$server);

	if(!($r_dataResult->Success))
	{
		die("数据错误");
	}
	$dbData = $r_dataResult->DataList;
	
	
	// 准备作图数据
	$XAxis = array();$OLNum = array();
	
	$maxNumberIndex= date("H:i",$dbData[1][0][0]);
	$maxNumber = $dbData[1][0][1];
	for($p=0;$p <count($dbData[0]);$p++)
	{
		$data_server = $dbData[0][$p];
		for($i=0;$i <count($data_server);$i++)
		{
			if($i == 0)
			{
				$XAxis[] = date("H:i",$data_server[$i]);
			}
			else
			{
				$OLNum[] = $data_server[$i];
			}
		}
	}

	$pChartDataSet = new pData;
  	$pChartDataSet->AddPoint($XAxis,"Serie1");
  	$pChartDataSet->AddPoint($OLNum,"Serie2");
  	$pChartDataSet->AddSerie("Serie2");    
  	$pChartDataSet->RemoveSerie("Serie1");
  	$pChartDataSet->SetAbsciseLabelSerie("Serie1");  
	$pChartDataSet->SetYAxisName("在\n线\n人\n数\n//\n人");
	$pChartDataSet->SetYAxisFormat("floor");
	$pChartDataSet->SetXAxisFormat("number");  

	// 设置作图区域
	$pChartGraph = new pChart($imgWidth,253); 
	$pChartGraph->drawGraphAreaGradient(90,90,90,90,TARGET_BACKGROUND); 
  	$pChartGraph->setGraphArea(70,30,$imgWidth + 70 - 90,253 + 30 - 80);  
  	$pChartGraph->setFontProperties(DRAWFONE_PATH,8);
  	$pChartGraph->drawScale($pChartDataSet->GetData(),$pChartDataSet->GetDataDescription(),SCALE_NORMAL,250,250,250,TRUE,0,0,FALSE,1);
	
	// 开始作图
	$pChartGraph->setColorPalette(0,0,255,255);
	$pChartGraph->drawGraphAreaGradient(40,40,40,-50);
	$pChartGraph->drawGrid(1,TRUE,115,115,115,10);
	$pChartGraph->setShadowProperties(3,3,0,0,0,30,4);
	$pChartGraph->drawFilledLineGraph($pChartDataSet->GetData(),$pChartDataSet->GetDataDescription(),25);
	$pChartGraph->clearShadow();  
  	$pChartGraph->setFontProperties(DRAWFONE_PATH,10);   
	$pChartGraph->drawTitle($imgWidth/2,22,"实时在线人数查询(".$dateTime.") 峰值( ".$maxNumberIndex.", ".$maxNumber."人 )",255,255,255,585);	
	$pChartGraph->writeValues($pChartDataSet->GetData(),$pChartDataSet->GetDataDescription(),"Serie2");   
	
	// 结束
	$pChartGraph->Stroke();
//	$pChartGraph->Render("RealTimeOnLine.png");
//	echo "<img src = 'RealTimeOnLine.png'>";
	
//	$fileNameTxt = "Cache/XYInfo.".$plat.$server.$dateTime.".txt";
//	$file = fopen($fileNameTxt,"w");
//	$info = $pChartGraph->DivisionWidth.",".$pChartGraph->GArea_Y2.",".$pChartGraph->VMin.",".$pChartGraph->DivisionRatio;
//	fwrite($file,$info);
//	fclose($file);
?>
	



