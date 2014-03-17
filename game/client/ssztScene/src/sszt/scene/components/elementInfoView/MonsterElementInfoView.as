/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-9-26 下午5:55:11 
 * 
 */ 
package sszt.scene.components.elementInfoView
{
	import flash.display.Bitmap;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.MapElementType;
	import sszt.scene.mediators.ElementInfoMediator;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.progress.ProgressBar1;
	
	public class MonsterElementInfoView extends BaseElementInfoView
	{
		public function MonsterElementInfoView(mediator:ElementInfoMediator)
		{
			super(mediator);
		}
		
		override protected function initBg():void
		{
			super.initBg();
			
			_bg.bitmapData = getBgAsset3();
		}
		
		
		override protected function initHead(change:Boolean = true):void
		{
			super.initHead(change);
			
		}
		
		override protected function initNameField():void
		{
			_nameField = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.CENTER);
			_nameField.textColor = 0xfffccc;
			_nameField.selectable = false;
			_nameField.mouseEnabled = false;
			addChild(_nameField);
		}
		
		override protected function initLevelField():void
		{
			_levelField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER);
			_levelField.setLabelType([new TextFormat("Tahoma",22,0xFFFCCC,true)]);
			_levelField.selectable = false;
			_levelField.mouseEnabled = false;
			addChild(_levelField);
		}
		
		override protected function initProgressBar():void
		{
			_hpBar = new ProgressBar1(new Bitmap(BaseElementInfoView.getHpBgAsset3()),1,1,128,13,true,false);
			addChild(_hpBar);
		}
		
		override protected function layout():void
		{
			_bg.y = 15;
			
			_hpBar.move(59,47);
			_levelField.move(32,37);			
			_nameField.move(120,27);
			_closeBtn.move(185,26);
			
		}
		
		override public function elementType():int
		{
			return MapElementType.MONSTER;
		}
		
	}
}