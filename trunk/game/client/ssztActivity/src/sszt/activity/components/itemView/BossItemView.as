package sszt.activity.components.itemView
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.activity.data.ActivityRewardsType;
	import sszt.activity.data.BossItemInfo;
	import sszt.constData.BossType;
	import sszt.constData.CategoryType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.BossTemplateInfo;
	import sszt.core.data.map.MapTemplateInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.assets.AssetSource;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.activity.DotIconExpAsset;
	import ssztui.activity.DotIconItemAsset;
	import ssztui.activity.DotIconLifeExpAsset;
	import ssztui.activity.DotIconMoneyAsset;
	import ssztui.activity.IconDeathAsset;
	
	public class BossItemView extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _boader:IMovieWrapper;
		public var sortFieldBossType:int;
		public var sortFieldBossMapId:int;
		public var sortFieldBossLevel:int;
		
		private var _info:BossTemplateInfo;
		private var _mapInfo:MapTemplateInfo;
		private var _bossItemInfo:BossItemInfo;
		
		private var _selected:Boolean;
		
		private var _header:Bitmap;
		private var _picPath:String;
		private var _death:Bitmap;
		
		public function BossItemView(info:BossTemplateInfo)
		{
			super();
			
			_info = info;
			_mapInfo = MapTemplateList.getMapTemplate(_info.mapId);
			
			sortFieldBossType = _info.type;
			sortFieldBossMapId = _info.mapId;
			sortFieldBossLevel = _info.level;
			
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			this.buttonMode = this.mouseChildren = true;
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,50,50),new Bitmap(CellCaches.getCellBigBg())),
			]);
			addChild(_bg as DisplayObject);
			
			_header = new Bitmap();
			_header.x = _header.y = 3;
			addChild(_header);
			
			_picPath = GlobalAPI.pathManager.getWorldBossPath("header_" + _info.id.toString());
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
			
			_boader = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_15,new Rectangle(0, 0, 50, 50)),
			]);
			addChild(_boader as DisplayObject);
			_boader.visible = false;
			
			_death = new Bitmap(new IconDeathAsset());
			_death.y = 38;
			addChild(_death);
			
			_death.visible = false;
		}
		private function loadAvatarComplete(data:BitmapData):void
		{
			_header.bitmapData = data;
		}
		
		private function initEvent():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		private function removeEvent():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		public function set bossItemInfo(value:BossItemInfo):void
		{
			if(value == _bossItemInfo)return;
			_bossItemInfo = value;
			if(_bossItemInfo)
			{
				if(_bossItemInfo.isLive)
				{
					_header.filters = [];
					_death.visible = false;
				}
				else
				{
					
					if(_info.type == BossType.INTERVAL)//固定间隔时间刷新boss
					{
					}
					else//固定时间点刷新
					{
						//几点时刷新
					}
					_header.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
					_death.visible = true;
				}
			}
			else
			{
			}
		}
		public function get bossItemInfo():BossItemInfo
		{
			return _bossItemInfo;
		}
		
		private function overHandler(e:MouseEvent):void
		{
			if(!_bossItemInfo)return;
			var live:String = "";
			if(!_bossItemInfo.isLive) live = " <font color='#ff6600'>(" + LanguageManager.getWord("ssztl.common.dead") + ")</font>";
				
			TipsUtil.getInstance().show(_info.name + live,null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		
		private function outHandler(eevt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function transferCloseHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				BuyPanel.getInstance().show([CategoryType.TRANSFER],new ToStoreData(103));
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value) return;
			_selected = value;
			if(_selected)
			{
				_boader.visible = true;
			}else
			{
				_boader.visible = false;
			}
		}
		
		public function get info():BossTemplateInfo
		{
			return _info;
		}
		
		public function dispose():void
		{
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
			removeEvent();		
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_boader)
			{
				_boader.dispose();
				_boader = null;
			}
			if(_death && _death.bitmapData)
			{
				_death.bitmapData.dispose();
				_death = null;
			}
			_header = null;
			if(parent) parent.removeChild(this);
		}
	}
}