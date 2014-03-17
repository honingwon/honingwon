package sszt.box.components
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.constData.CategoryType;
	import sszt.constData.LayerType;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	
	public class BoxTempCell2 extends BaseCell
	{
		private var _name:String;
		
		public function BoxTempCell2(info:ILayerInfo=null,name:String = "", showLoading:Boolean=true, autoDisposeLoader:Boolean=true, fillBg:int=-1)
		{
			_name = name;
			super(info, showLoading, autoDisposeLoader, fillBg);
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(info)
			{
				var item:ItemTemplateInfo = ItemTemplateInfo(info);
				var str:String = "<font color='#"+ CategoryType.getQualityColorString(item.quality) +"'>" + item.name + "<font>\n" ;
				str += "<font color='#35c3f7'>"+LanguageManager.getWord("ssztl.box.getAccount")+"：" + _name + "<font>\n" ;
				TipsUtil.getInstance().show(str,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
			}
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		

	}
}