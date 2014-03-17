/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-9-29 上午9:56:01 
 * 
 */ 
package sszt.club.components.clubMain.pop.sec.src
{
	import fl.controls.RadioButton;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.club.mediators.ClubMediator;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class AppointmentView extends MSprite
	{
		private var _mediator:ClubMediator;
		private var _bgasset:IMovieWrapper;
		private var _id:Number;
		private var _duty:int;
		private var _okBtn:MCacheAssetBtn1;
		private var _cancelBtn:MCacheAssetBtn1;
		
		private var _radioBtn1:RadioButton;
		private var _radioBtn2:RadioButton;
		private var _radioBtn3:RadioButton;
		
		
		public function AppointmentView(mediator:ClubMediator)
		{
			_mediator = mediator;
		
			super();
			initView();
		}
		
		public function setInfo(id:Number,duty:int):void
		{
			_id = id;
			_duty = duty;
			
			switch(_duty)
			{
				case 2:
					_radioBtn1.selected = true;
					break;
				case 3:
					_radioBtn2.selected = true;
					break;
				default:
					_radioBtn3.selected = true;
					break;
			}
			
		}
		
		
		private function initView():void
		{
			_bgasset = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_4,new Rectangle(0,0,120,135)),
//				new BackgroundInfo(BackgroundType.BORDER_9,new Rectangle(8,23,114,61))
			]);
			addChild(_bgasset as DisplayObject);
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(33,9,60,18),new MAssetLabel(LanguageManager.getWord("ssztl.club.clubJob"),MAssetLabel.LABEL_TYPE_TITLE)));
			
			
			_radioBtn1 = new RadioButton();
			_radioBtn1.label = LanguageManager.getWord("ssztl.club.subClubLeader");
			_radioBtn1.setSize(90,18);
			_radioBtn1.move(15,32);
			addChild(_radioBtn1);
			
			_radioBtn2 = new RadioButton();
			_radioBtn2.label = LanguageManager.getWord("ssztl.club.zhanglao");
			_radioBtn2.setSize(90,18);
			_radioBtn2.move(15,52);
			addChild(_radioBtn2);
			
			
			_radioBtn3 = new RadioButton();
			_radioBtn3.label = LanguageManager.getWord("ssztl.common.crowd");
			_radioBtn3.setSize(90,18);
			_radioBtn3.move(15,72);
			addChild(_radioBtn3);
			
			
			_okBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.sure"));
			_okBtn.move(16,100);
			addChild(_okBtn);
			
			_cancelBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.cannel"));
			_cancelBtn.move(64,100);
			addChild(_cancelBtn);
			
			
			initEvent();
			
		}
		
		private function initEvent():void
		{
			_okBtn.addEventListener(MouseEvent.CLICK,okClickHandler);
			_cancelBtn.addEventListener(MouseEvent.CLICK,hideHandler);
		}
		private function removeEvent():void
		{
			_okBtn.removeEventListener(MouseEvent.CLICK,okClickHandler);
			_cancelBtn..removeEventListener(MouseEvent.CLICK,hideHandler);
			
		}
		public function show():void
		{
//			GlobalAPI.layerManager.getPopLayer().addChild(this);
//			GlobalAPI.layerManager.getPopLayer().stage.addEventListener(MouseEvent.CLICK,hideHandler);
		}
		
		private function hideHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			hide();
		}
		private function okClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var duty:int = _duty;
			if(_radioBtn1.selected)
			{
				duty = ClubDutyType.VICEMASTER;
			}
			else if(_radioBtn2.selected)
			{
				duty = ClubDutyType.HONOR;
			}
			else if(_radioBtn3.selected)
			{
				duty = ClubDutyType.PREPARE;
			}
			
			_mediator.clubDutyChange(_id,duty);
			hide();
		}
		
		public function hide():void
		{
			if(this.parent)this.parent.removeChild(this);
//			GlobalAPI.layerManager.getPopLayer().stage.removeEventListener(MouseEvent.CLICK,hideHandler);
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			if(_bgasset)
			{
				_bgasset.dispose();
				_bgasset = null;
			}
			if(_okBtn)
			{
				_okBtn.dispose();
				_okBtn = null;
			}
			if(_cancelBtn)
			{
				_cancelBtn.dispose();
				_cancelBtn = null;
			}
			_radioBtn1 = null;
			_radioBtn2 = null;
			_radioBtn3 = null;
//			if(_list)
//			{
//				for(var i:int = 0; i < _list.length; i++)
//				{
//					_list[i].removeEventListener(MouseEvent.CLICK,itemClickHandler);
//					_list[i].dispose();
//				}
//			}
//			_list = null;
		}
		
	}
}