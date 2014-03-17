package sszt.scene.components.specials
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.collect.CollectTemplateInfo;
	import sszt.core.data.module.changeInfos.ToBoxData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.box.OpenBoxSocketHandler;
	import sszt.core.utils.JSUtils;
	import sszt.core.utils.MoneyChecker;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.interfaces.scene.IScene;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.SceneModule;
	import sszt.scene.components.sceneObjs.BaseSceneCollect;
	import sszt.scene.data.collects.CollectItemInfo;
	import sszt.scene.mediators.SceneMediator;
	
	public class CollectCopyView extends Sprite
	{
		private var _mediator:SceneMediator;
		private var _scene:IScene;
		private var _collectList:Array;
		private var _collectViews:Array;
		private var _effects:Array;
		private var _names:Array;
		private var _storeBtn:MCacheAsset1Btn;
		private var _surveyBtn:MCacheAsset1Btn;
		private var _showBtn:MCacheAsset1Btn;
		private var _completeEffect:BaseLoadEffect;
		private var _timeoutIndex:int = -1;
		
		public function CollectCopyView(scene:IScene,mediator:SceneMediator)
		{
			_scene = scene;
			_mediator = mediator;
			super();
			init();
		}
		
		private function init():void
		{
			_storeBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.common.taoBaoStore"));
			_storeBtn.addEventListener(MouseEvent.CLICK,storeClickHandler);
			GlobalAPI.layerManager.getTipLayer().addChild(_storeBtn);
			_surveyBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.common.overView"));
			_surveyBtn.addEventListener(MouseEvent.CLICK,surveyClickHandler);
			GlobalAPI.layerManager.getTipLayer().addChild(_surveyBtn);
			_showBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.scene.itemShow"));
			_showBtn.addEventListener(MouseEvent.CLICK,showClickHandler);
			GlobalAPI.layerManager.getTipLayer().addChild(_showBtn);
			updateBtnPos(null);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,updateBtnPos);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAIN_ITEM_UPDATE,gainItemUpdateHandler);
			
			var templateIds:Array = [1023,1023,1024,1024,1025,1025,1026,1026,1027,1027,1028,1028,1029,1029,1030,1030,1031,1031];
//			var poses:Array = [new Point(149,336),new Point(273,300),new Point(444,502),new Point(520,425),new Point(88,532),new Point(163,560),
//				new Point(924,230),new Point(1055,183),new Point(1064,368),new Point(1173,345),new Point(778,665),new Point(858,580),
//				new Point(1700,307),new Point(1800,332),new Point(2009,660),new Point(1957,548),new Point(1525,621),new Point(1618,562)
//			];
			var poses:Array = [new Point(149,336),new Point(273,300),new Point(88,532),new Point(163,560),new Point(424,502),new Point(500,425),
				new Point(1230,288),new Point(1137,350),new Point(778,665),new Point(858,580),new Point(924,160),new Point(1055,113),
				new Point(1700,307),new Point(1800,332),new Point(1525,621),new Point(1618,562),new Point(2009,660),new Point(1957,548)
			];
			_collectList = [];
			_collectViews = [];
			_effects = [];
			_names = [];
			for(var i:int = 0; i < poses.length; i++)
			{
				var item:CollectItemInfo = new CollectItemInfo();
				item.id = i;
				item.templateId = templateIds[i];
				item.setScenePos(poses[i].x,poses[i].y);
				_collectList.push(item);
			}
			initCollects();
			
			showClickHandler(null);
			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.HIDE_FOLLOW));
		}
		
		private function updateBtnPos(evt:CommonModuleEvent):void
		{
			_storeBtn.x = CommonConfig.GAME_WIDTH - 280;
			_surveyBtn.x = CommonConfig.GAME_WIDTH - 360;
			_showBtn.x = CommonConfig.GAME_WIDTH - 440;
			_storeBtn.y = _surveyBtn.y = _showBtn.y = 20;
		}
		
		private function storeClickHandler(evt:MouseEvent):void
		{
			SetModuleUtils.addBox(2);
		}
		private function surveyClickHandler(evt:MouseEvent):void
		{
			SetModuleUtils.addBox(4);
		}
		private function showClickHandler(evt:MouseEvent):void
		{
			SetModuleUtils.addBox(3);
		}
			
		private function getName(quality:int,name:String):TextField
		{
			var field:TextField = new TextField();
			field.width = 150;
			field.height = 50;
			field.mouseEnabled = field.mouseWheelEnabled = false;
			field.htmlText = "<font color='#" + CategoryType.getQualityColorString(quality) + "'>" + name + "</font>";
			field.filters = [new GlowFilter(0,1,2,2,4.5)];
			return field;
		}
		
		private function initCollects():void
		{
			for each(var i:CollectItemInfo in _collectList)
			{
				var item:BaseSceneCollect = new BaseSceneCollect(i);
				item.mouseEnabled = true;
				_scene.addChild(item);
				_collectViews.push(item);
				item.addEventListener(MouseEvent.CLICK,collectClickHandler);
				item.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
				item.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
				item.hideName(true);
				if(isOpen(i.getTemplate().id))
				{
					var effect:BaseLoadEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.COPY_COLLECT));
					effect.move(i.sceneX,i.sceneY - 45);
					_scene.addEffect(effect);
					effect.play(SourceClearType.CHANGESCENE_AND_TIME,300000);
					_effects.push(effect);
				}
				var field:TextField = getName(i.getTemplate().quality,i.getTemplate().name);
				field.x = i.sceneX - 30;
				field.y = i.sceneY - 75;
				_scene.addEffect(field);
				_names.push(field);
			}
		}
		
		private function isOpen(id:int):Boolean
		{
			return !(id == 1023 || id == 1024 || id == 1025);
		}
		
		private function collectClickHandler(evt:MouseEvent):void
		{
			var item:BaseSceneCollect = evt.currentTarget as BaseSceneCollect;
			var templateid:int = -1;
			var itemX:int = item.sceneX;
			var itemY:int = item.sceneY;
			if(item && item.getCollectItemInfo())
			{
				var template:CollectTemplateInfo = item.getCollectItemInfo().getTemplate();
				templateid = template.id;
				if(!isOpen(templateid))
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.oreUnBeing"));
					return;
				}
				else
				{
					var cost:int = getCost(templateid);
					if(GlobalData.selfPlayer.userMoney.yuanBao < cost)
					{
						//MAlert.show(LanguageManager.getWord("ssztl.common.isGoingCharge"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,buyHandler);
						QuickTips.show(LanguageManager.getWord('ssztl.common.yuanBaoNotEnough'));
					}
					else
					{
						MAlert.show("确定采集" + template.name + "，共需要消费" + getCost(templateid) + "元宝",LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,closeHandler);
					}
				}
			}
			function buyHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					JSUtils.gotoFill();
				}
			}
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					OpenBoxSocketHandler.sendOpenBox(getType(templateid));
					if(_completeEffect)
					{
						_completeEffect.dispose();
					}
					_completeEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.COPY_COLLECT_COMPLETE));
					_completeEffect.play(SourceClearType.CHANGESCENE_AND_TIME,200000);
					_completeEffect.move(itemX,itemY - 60);
					_scene.addEffect(_completeEffect);
					item.visible = false;
					_timeoutIndex = setTimeout(fleshItem,1000,item);
				}
			}
			function fleshItem(obj:DisplayObject):void
			{
				obj.visible = true;
				if(_timeoutIndex != -1)
				{
					clearTimeout(_timeoutIndex);
				}
			}
		}
		
		private function getCost(id:int):int
		{
			switch(id)
			{
				case 1023:return 5;
				case 1024:return 45;
				case 1025:return 225;
				case 1026:return 10;
				case 1027:return 95;
				case 1028:return 450;
				case 1029:return 20;
				case 1030:return 190;
				case 1031:return 900;
			}
			return 0;
		}
		
		private function getType(id:int):int
		{
			switch(id)
			{
				case 1023:return 1;
				case 1024:return 2;
				case 1025:return 3;
				case 1026:return 4;
				case 1027:return 5;
				case 1028:return 6;
				case 1029:return 7;
				case 1030:return 8;
				case 1031:return 9;
			}
			return 1;
		}
		
		private function mouseMoveHandler(evt:MouseEvent):void
		{
			var collect:BaseSceneCollect = evt.currentTarget as BaseSceneCollect;
			var template:CollectTemplateInfo = collect.getCollectItemInfo().getTemplate();
			TipsUtil.getInstance().show("采集" + template.name + "，有机会获得极品<font color='#" + CategoryType.getQualityColorString(template.quality) + "'>" + getTipString(template.id) + "</font>。",null,new Rectangle(evt.stageX + 20,evt.stageY + 20,0,0));
		}
		
		private function gainItemUpdateHandler(evt:CommonModuleEvent):void
		{
			var data:ToBoxData = evt.data as ToBoxData;
			SetModuleUtils.addBox(5,-1,data.list);
		}
		
		private function getTipString(id:int):String
		{
			switch(id)
			{
				case 1023:
				case 1024:
				case 1025:
					return "";
				case 1026:
				case 1027:
				case 1028:
//					return "40级紫色装备";
					return LanguageManager.getWord("ssztl.scene.purpleEquip40");
				case 1029:
				case 1030:
				case 1031:
//					return "60级紫色装备";
					return LanguageManager.getWord("ssztl.scene.purpleEquip60");
			}
			return "";
		}
		
		private function mouseOutHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		public function dispose():void
		{
			if(_storeBtn)
			{
				_storeBtn.removeEventListener(MouseEvent.CLICK,storeClickHandler);
				_storeBtn.dispose();
				_storeBtn = null;
			}
			if(_surveyBtn)
			{
				_surveyBtn.removeEventListener(MouseEvent.CLICK,surveyClickHandler);
				_surveyBtn.dispose();
				_surveyBtn = null;
			}
			if(_showBtn)
			{
				_showBtn.removeEventListener(MouseEvent.CLICK,showClickHandler);
				_showBtn.dispose();
				_showBtn = null;
			}
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,updateBtnPos);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAIN_ITEM_UPDATE,gainItemUpdateHandler);
			if(_timeoutIndex != -1)
			{
				clearTimeout(_timeoutIndex);
			}
			for each(var i:BaseSceneCollect in _collectViews)
			{
				if(i)
				{
					i.removeEventListener(MouseEvent.CLICK,collectClickHandler);
					i.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
					i.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
					i.dispose();
				}
			}
			_collectViews.length = 0;
			_collectList.length = 0;
			for each(var j:BaseLoadEffect in _effects)
			{
				if(j)
				{
					j.dispose();
				}
			}
			for each(var k:TextField in _names)
			{
				if(k && k.parent)k.parent.removeChild(k);
			}
			_names.length = 0;
			_effects.length = 0;
			_mediator = null;
			_scene = null;
			
			if(_completeEffect)
			{
				_completeEffect.dispose();
				_completeEffect = null;
			}
			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.SHOW_FOLLOW));
		}
	}
}
