<?php
  	include_once("../../common.php"); 
  	require_once(DATACONTROL . '/BMAccount/IsLogin.php'); 
 	require_once(DATACONTROL . '/BMAccount/ModuleManageProvider.php'); 
 	require_once(DATAMODEL . '/BMAccount/ModuleMDL.php'); 	 			
 	
 	if(!isset($_POST["method"])){
 		exit;
 	}
 	$methods = $_POST["method"];
 	switch($methods)
 	{
 		case "Mlist":
 			$result = ModuleManageProvider::getInstance()->ListAllModule();
 			echo json_encode($result);
 			break;
 		case "row":
 			$resultrow = ModuleManageProvider::getInstance()->GetOneModule($_POST["ID"]);
 			echo json_encode($resultrow);
 			break;
 		case "Add":
 			$FmoduleID = $_POST["ID"];
 			$resultAdd = ModuleManageProvider::getInstance()->AddModule($_POST["name"],$_POST["ID"],
 			 			$_POST["lev"],$_POST["url"],$_POST["furl"],$_POST["pri"],$_POST["state"],$_POST["dec"]);
 			echo json_encode($resultAdd);
 			break;
 		case "Edit":
 			$editArray  = array("bm_ModuleName" => $_POST["name"],"bm_ModuleLevel" => $_POST["lev"],
 								"bm_ModuleUrl" => $_POST["url"],"bm_FModuleUrl" => $_POST["furl"],
 								"bm_ModulePRI" => $_POST["pri"],"bm_ModuleState" => $_POST["state"],"bm_ModuleRemark" =>$_POST["dec"]);
 			$resultEdit = ModuleManageProvider::getInstance()->UpdateModule($_POST["ID"],$editArray);
			echo json_encode($resultEdit);
 			break;
 		case "Del":
 			$delresult = ModuleManageProvider::getInstance()->DelModule($_POST["ID"]);
 			echo json_encode($delresult);
 			break;
 	}
?>