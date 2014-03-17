/**
 * 喇叭面板 
 */
package sszt.chat.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import mx.states.AddChild;
	
	import sszt.chat.mediators.ChatMediator;
	import sszt.constData.CommonConfig;
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.chat.ChatInfoUpdateEvent;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.richTextField.RichTextFormatInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.RichTextUtil;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.richTextField.RichTextField;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	
	import ssztui.chat.TrumpetAsset;
	
	public class ChatSpeakerPanel implements ITick
	{
		private var _mediator:ChatMediator;
		private var _icon:Bitmap;
		private var _bgasset:Bitmap;
		private var _textfield:RichTextField;
		private var _isBig:Boolean;
		private var _showTime:int;
		private var _container:DisplayObjectContainer;
		private var _effect:BaseLoadEffect;
		private var _box:MSprite;
		
		private var _isChatShow:Boolean = true;
		
		
		public function ChatSpeakerPanel(mediator:ChatMediator,container:DisplayObjectContainer)
		{
			_mediator = mediator;
			_container = container;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			_box = new MSprite();
			_container.addChild(_box);
			_bgasset = new Bitmap(new BitmapData(1,1,true,0x50000000));
			_bgasset.x = 1;
			_bgasset.y = 0;
			_bgasset.width = 291;
			_bgasset.height = 45;
			
			_icon = new Bitmap(new TrumpetAsset() as BitmapData);
			_icon.x = 5;
			_icon.y = 4;
			
//			_bgasset = BackgroundUtils.setBackground([new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,285,46),new Bitmap(t))]);
			gameSizeChangeHandler(null);
//			addChild(_bgasset as DisplayObject);
		}
		
		private function initEvent():void
		{
			GlobalData.chatInfo.addEventListener(ChatInfoUpdateEvent.SPEAKERPANEL_UPDATE,updateHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function removeEvent():void
		{
			GlobalData.chatInfo.removeEventListener(ChatInfoUpdateEvent.SPEAKERPANEL_UPDATE,updateHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			var _m:int = CommonConfig.GAME_WIDTH >1250?0:60;
			if(_isChatShow)
			{
				if(_isBig)
					_box.y = CommonConfig.GAME_HEIGHT - 360 - _m;
				else
					_box.y = CommonConfig.GAME_HEIGHT - 260 - _m;
			}
			else
			{
				_box.y = CommonConfig.GAME_HEIGHT - 110 - _m;
			}
//			if(_textfield)
//			{
//				if(_textfield.height < 27)
//					_textfield.y = _bgasset.y + 14;
//				else _textfield.y = _bgasset.y + 2;
//			}
			
//			x = 1;
//			y = CommonConfig.GAME_HEIGHT - 305;
		}
		
		private function updateHandler(e:ChatInfoUpdateEvent):void
		{
			showMessage(e.data as ChatItemInfo);
		}
		
		private function showMessage(info:ChatItemInfo):void
		{
			if(info == null)return;
			if(!_bgasset.parent)_box.addChild(_bgasset as DisplayObject);
			if(!_icon.parent)_box.addChild(_icon as DisplayObject);
//			if(_effect == null)
//			{	
//				_effect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.SPEAKER_EFFECT));
//			}
//			_effect.move(_bgasset.x + 45,_bgasset.y + 20);
//			_container.addChild(_effect);
//			_effect.play();
			
			if(!_effect)
			{
				_effect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.SPEAKER_EFFECT));
				_effect.move(1,-2);
//				_effect.addEventListener(Event.COMPLETE,efCompleteHandler);
				_effect.play(SourceClearType.TIME,300000);
				_box.addChild(_effect);
			}
			
			if(_textfield)
			{
				_textfield.dispose();
			}
			_textfield = RichTextUtil.getChatRichText(info);
			_textfield.x = 27;
			_textfield.y = 6;
//			if(_textfield.height < 34)
//				_textfield.y = _bgasset.y + 14;
//			else _textfield.y = _bgasset.y + 2;
			_box.addChild(_textfield);
			
			_showTime = getTimer();
			GlobalAPI.tickManager.addTick(this);
		}
		
		private function efCompleteHandler(evt:Event):void
		{
		}
		
		private function hide():void
		{
			if(_textfield)
			{
				_textfield.dispose();
			}
			if(_bgasset && _bgasset.parent)
			{
				_bgasset.parent.removeChild(_bgasset as DisplayObject);
			}
			if(_icon && _icon.parent)
			{
				_icon.parent.removeChild(_icon as DisplayObject);
			}
			if(_effect && _effect.parent)
			{
				_effect.parent.removeChild(_effect);
			}
			_effect.dispose();
			_effect = null;
		}
		
		public function updatePanelVisible(value:Boolean):void
		{
			_isChatShow = value;//!_isChatShow;
			gameSizeChangeHandler(null);
		}
		
		public function setPanelSize(value:Boolean):void
		{
			_isBig = value;//!_isBig;
			gameSizeChangeHandler(null);
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(getTimer() - _showTime > 20000)
			{
				hide();
				GlobalAPI.tickManager.removeTick(this);
			}
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_box && _box.parent)
			{
				_box.parent.removeChild(_box);
				_box = null;
			}
			if(_bgasset && _bgasset.bitmapData)
			{
				_bgasset.bitmapData.dispose();
				_bgasset = null;
			}
			if(_icon && _icon.bitmapData)
			{
				_icon.bitmapData.dispose();
				_icon = null;
			}
			if(_textfield)
			{
				_textfield.dispose();
				_textfield = null;
			}
			if(_effect)
			{
				_effect.dispose();
				_effect = null;
			}
			_mediator = null;
		}
	}
}