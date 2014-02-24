<?php
/**
*	图形统计报表
	ary	应用类型
		type	统计报表类型：bing、heng、shu、quxian
		title	报表标题
		tip		统计点提示文字
		unit	统计点提示文字单位
		data	是二位数组表示内容，分别是text表示类型与value数值
		data示例：array(
							array(
								'text'	=> '提示1',
								'value'	=> 'asd21'
							)
						)
	使用示例：
chart.php
$ary	= array(
			'type'		=> 'quxian',		//类型
			'title'		=> '统计标题',
			'tip'		=> '统计月份：',
			'unit'		=> '人',
			'data'		=> array(
							array(
								'text'	=> '提示1',
								'value'	=> 'asd21'
							),
							array(
								'text'	=> '提示2',
								'value'	=> '32as'
							),
							array(
								'text'	=> '提示3',
								'value'	=> 345
							),
							array(
								'text'	=> '提示4',
								'value'	=> 23
							),
						),
			);
	echo aip_chart($ary);

index.html
<script type="text/javascript" src="swfobject.js"></script>
<script type="text/javascript">
var flashvars = {"data-file":'chart.php?type=quxian'}; //这里是数据
var params = {menu: "false",scale: "noScale",wmode:"opaque"}; 
swfobject.embedSWF("open-flash-chart.swf", "chart", "550px", "450px", "9.0.0","expressInstall.swf", flashvars,params);

</script>
*/



function aip_chart( $ary=array() ){
	//颜色设定
	$color_set = array("#ff0000","#00aa00","#0000ff","#ff9900","#ff00ff","#ff0000","#00aa00","#0000ff","#ff9900","#ff00ff","#ff0000","#00aa00","#0000ff","#ff9900","#ff00ff","#ff0000","#00aa00","#0000ff","#ff9900","#ff00ff");
	
	
	//区分类型
	switch($ary['type']){
		
		
		//圆饼
		case'bing':
			unset($K,$V,$i);
			$i	= 0;
			foreach ($ary['data'] AS $K=>$V) {
				$data_str[]	= array(
							'text'	=> $V['text'],				//标题
							'value'	=> (int)$V['value']		//数值
							);
			}
			
			
				$str = '{"title":{"text":"'.$ary['title'].'", "style":"font-size: 14px; font-family: Verdana; text-align: center;"}, 
					"legend":{"visible":true, "bg_colour":"#fefefe", "position":"right", "border":true, "shadow":true}, "bg_colour":"#ffffff", 
					"elements":[{"type":"pie", "tip":"'.$ary['tip'].' #val# '.$ary['unit'].'", "values":'.json_encode($data_str).', "radius":130, "highlight":"alpha", "animate":false, 
					"gradient-fill":true, "alpha":0.5, "no-labels":true, "colours":'.json_encode($color_set).'}]}';
		break;
		
		//横柱统计
		case'heng':
			unset($K,$V,$i);
			$i	= 0;
			foreach ($ary['data'] AS $K=>$V) {
				$i++;
				
				$name_str[]	= $V['text'];						//名称
				
				$data_str[]	= array(
								'right'		=> (int)$V['value'],//数值
								'colour'	=> $color_set[$i]	//色彩
							);
			   $x_count[$K] = $V['value'];						//数值数组用于获取最大值
			}
			
			//重新排序y轴坐标			
			$name_str_sort = array();			
			for($i=1; $i<=count($name_str); $i++){
				$name_str_sort[count($name_str)-$i] = $name_str[$i-1];
			}
			ksort($name_str_sort);
			
			//x轴总值
			$x_count = max($x_count)*1.2;

			//x轴递增值
			$x_step = (number_format($x_count/100))*10;
			
			$str = '{"title":{"text":"'.$ary['title'].'", "style":"font-size: 14px; font-family: Verdana; text-align: center;"}, 
					"tooltip":{"mouse":1}, "x_axis":{"steps":'.$x_step.', "min":0, "max":'.$x_count.'}, "y_axis":{"offset":1, "labels":'.json_encode($name_str_sort).'}, 
					"bg_colour":"#ffffff", "elements":[{"type":"hbar", "tip":"'.$ary['tip'].' #val# '.$ary['unit'].'", 
					"values":'.json_encode($data_str).'}]}';
		break;
		
		
		//竖柱统计
		case'shu':
			unset($K,$V,$i);
			$i	= 0;
			foreach ($ary['data'] AS $K=>$V) {
				$i++;
				
				$name_str[]	= $V['text'];						//名称
				
				$data_str[]	= (int)$V['value'];					//数值
				
				$y_count[$K] = $V['value'];						//数值数组用于获取最大值
			}
			
			//x轴总值
			$y_count = @max($y_count)*1.2;

			//x轴递增值
			$y_step = (number_format($y_count/100))*10;

			if(isset($ary['value']['max'])){
				$elements = '{"type":"bar_glass", "tip":"最大值: #val# '.$ary['unit'].'", "values":['.implode(',',$ary['value']['max']).'], "colour":"#00aa00"}, ';
				$elements .= '{"type":"bar_glass", "tip":"最小值: #val# '.$ary['unit'].'", "values":['.implode(',',$ary['value']['min']).'], "colour":"#ff0000"}, ';
				$elements .= '{"type":"bar_glass", "tip":"平均值: #val# '.$ary['unit'].'", "values":['.implode(',',$ary['value']['avg']).'], "colour":"#eeee00"}';
			}else{
				$elements = '{"type":"bar_glass", "tip":"在线人数: #val# '.$ary['unit'].'", "values":['.implode(',',$data_str).'], "colour":"#00aa00"}';
			}
			
			$str = '{"title":{"text":"'.$ary['title'].'", "style":"font-size: 14px; font-family: Verdana; text-align: center;"}, 
					"x_axis":{"labels":{"labels":'.json_encode($name_str).'}}, 
					"y_axis":{"steps":'.$y_step.', "max":'.$y_count.'}, "bg_colour":"#ffffff", "elements":['.$elements.']}';
		break;
		
		//曲线统计
		case'quxian':
			unset($K,$V,$i);
			$i	= 0;
			foreach ($ary['data'] AS $K=>$V) {
				$i++;
				
				$name_str[]	= $V['text'];						//名称
				
				$data_str[]	= (int)$V['value'];					//数值
				
				$y_count[$K] = $V['value'];						//数值数组用于获取最大值
			}
			
			//x轴总值
			$y_count = @max($y_count)*1.2;
			
			//x轴递增值
			$y_step = (number_format($y_count/100))*10;
			
			$str = '{"title":{"text":"'.$ary['title'].'", "style":"font-size: 14px; font-family: Verdana; text-align: center;"}, 
					"x_axis":{"labels":{"labels":'.json_encode($name_str).'}}, "y_axis":{"steps":'.$y_step.', "max":'.$y_count.'},
					"bg_colour":"#ffffff", "elements":[{"type":"area_line", "tip":"'.$ary['tip'].' #val# '.$ary['unit'].'", "values":['.implode(',',$data_str).'], 
					"colour":"#00aa00", "fill-alpha":0.30000001192092895, "fill":"#00aa00"}]}';
		break;
		
		
	}
	return $str;
}

/*
$ary	= array(
			'type'		=> $_GET['type'],
			'title'		=> '统计标题',
			'tip'		=> '统计月份：',
			'unit'		=> '人',
			'data'		=> array(
							array(
								'text'	=> '提示1',
								'value'	=> 'asd21'
							),
							array(
								'text'	=> '提示2',
								'value'	=> '32as'
							),
							array(
								'text'	=> '提示3',
								'value'	=> 345
							),
							array(
								'text'	=> '提示4',
								'value'	=> 23
							),
						),
			);
//echo aip_chart($ary);
*/

?>