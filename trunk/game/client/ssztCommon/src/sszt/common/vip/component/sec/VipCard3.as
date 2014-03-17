package sszt.common.vip.component.sec
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.vip.BoxBgAsset;
	
	public class VipCard3 extends MSprite
	{
		private var _bg:IMovieWrapper;
		private var _txtPrivilege:MAssetLabel;
		private var _sp:MScrollPanel;
		private var _txtTag1:MAssetLabel;
		private var _txtTag:MAssetLabel;
		
		public function VipCard3()
		{
			super();
			initView();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(	BackgroundType.DISPLAY, new Rectangle(9,61,328,213), new BoxBgAsset() as MovieClip),
			]);
			addChild(_bg as DisplayObject);
			
			_txtTag = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_txtTag.setLabelType([new TextFormat("Microsoft Yahei Font",14,0x00ff00,true)]);
			_txtTag.move(164,8);
			addChild(_txtTag); 
			_txtTag.setValue(LanguageManager.getWord("ssztl.basic.normalVipPlayer"));
			
			_sp = new MScrollPanel();
			_sp.setSize(320,205);
			_sp.move(13,65);
			_sp.verticalScrollPolicy = ScrollPolicy.AUTO;
			addChild(_sp);  
			
			_txtPrivilege = new MAssetLabel('', MAssetLabel.LABEL_TYPE20,'left');
			_txtPrivilege.setLabelType([new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,6)]);
			_txtPrivilege.move(5,5);
			_sp.getContainer().addChild(_txtPrivilege);
			_txtPrivilege.htmlText = LanguageManager.getWord('ssztl.common.weekVipDescript');
			_sp.getContainer().height += _txtPrivilege.height+5;
			
			_sp.update(-1,_sp.getContainer().height);
			
			_txtTag1 = new MAssetLabel("", MAssetLabel.LABEL_TYPE_TAG,'left');
			_txtTag1.move(14,38);
			addChild(_txtTag1);
			_txtTag1.setHtmlValue(LanguageManager.getWord('ssztl.vip.weekTitle'));
		}
		
		public function hide():void
		{
			if(parent) parent.removeChild(this);
		}
		
		override public function dispose():void
		{
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_txtPrivilege)
			{
				_txtPrivilege = null;
			}
			if(_sp)
			{
				_sp.dispose();
				_sp = null;
			}
			_txtTag = null;
			_txtTag1 = null;
			super.dispose();
		}
	}
}