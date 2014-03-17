package sszt.openActivity.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.data.openActivity.OpenActivityUtils;
	import sszt.ui.progress.ProgressBar;
	
	/**
	 *  
	 * @author chendong
	 * 
	 */	
	public class ProgressBar2 extends ProgressBar
	{
		private var _type:int=0;
		public function ProgressBar2(type:int,asset:DisplayObject, currentValue:int, totalValue:int, width:int, height:int, isShowTxt:Boolean, isShowPercent:Boolean, background:DisplayObject=null)
		{
			_type = type;
			_mask = new Sprite();
			
			addChild(_mask);
			
			super(asset, currentValue, totalValue, width, height, isShowTxt, isShowPercent, background);
			_asset.mask = _mask;
		}
		
		override protected function updateAssetWidth():void
		{
			// TODO Auto Generated method stub
//			super.updateAssetWidth();
			
			var opAct:Array = OpenActivityUtils.getActivityArray(_type);
			var i:int = 0;
			var tw:int;
			var preActivityInfo:OpenActivityTemplateListInfo;
			var currctivityInfo:OpenActivityTemplateListInfo;
			for(;i<opAct.length;i++)
			{
				currctivityInfo = opAct[i];
				if(opAct[i-1])
				{
					preActivityInfo = opAct[i-1];
					if(_currentValue <= currctivityInfo.need_num)
					{
						tw = (_currentValue - preActivityInfo.need_num)/(currctivityInfo.need_num - preActivityInfo.need_num) * _width / opAct.length + i*_width / opAct.length;
						break;
					}
				}
				else
				{
					if(_currentValue <= currctivityInfo.need_num)
					{
						tw = (_currentValue/currctivityInfo.need_num) * _width / opAct.length;
						break;
					}
				}
			}
//			var pre:int = opAct[i-1]?opAct[i-1].need_num:0;
//			trace(opAct[i].need_num+","+_currentValue);
//			tw = 66*i + 66*((_currentValue-pre)/(opAct[i].need_num-pre));
			
//			if(_currentValue <888)
//			{
//				tw = (_currentValue/888) * (1/7) *_width;
//			}
//			else if(_currentValue <2888)
//			{
//				tw = (_currentValue-888)/(2888-888) * (1/7) *_width + (1/7)*_width;
//			}
//			else if(_currentValue <4888)
//			{
//				tw = (_currentValue-2888)/(4888-2888) * (1/7) *_width + (2/7)*_width;
//			}
//			else if(_currentValue <9888)
//			{
//				tw = (_currentValue-4888)/(9888-4888) * (1/7) *_width + (3/7)*_width;
//			}
//			else if(_currentValue <28888)
//			{
//				tw = (_currentValue-28888)/(28888-9888) * (1/7) *_width + (4/7)*_width;
//			}
//			else if(_currentValue <48888)
//			{
//				tw = (_currentValue-48888)/(48888-28888) * (1/7) *_width + (5/7)*_width;
//			}
//			else if(_currentValue <68888)
//			{
//				tw = (_currentValue-68888)/(68888-48888) * (1/7) *_width + (6/7)*_width;
//			}
			
//			var mWidth:int = 0;
//			if(_perTotalValue == 0)
//				mWidth = _width;
//			else 
//				mWidth = _perValue*(_perTotalValue*_width);
			
			_mask.graphics.clear();
			_mask.graphics.beginFill(0,0);
			_mask.graphics.drawRect(0,0,tw,_height);
			_mask.graphics.endFill();
			_mask.mouseEnabled = false;
			_mask.mouseChildren = true;
			
		}
		
		
		
	}
}