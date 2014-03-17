package sszt.target.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.target.TargetData;
	import sszt.core.data.target.TargetTemplatInfo;
	import sszt.core.data.target.TargetTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.target.TargetGetAwardSocketHandler;
	import sszt.events.ModuleEvent;
	import sszt.events.TargetMediaEvents;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.panel.IPanel;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.progress.ProgressBar;
	
	import ssztui.target.ItemAchBgAsset;
	import ssztui.target.ItemBoxAsset;
	import ssztui.target.ItemDoneAsset;
	import ssztui.target.SealHasAsset;
	import ssztui.ui.ProgressBar3Asset;
	import ssztui.ui.ProgressBarExpAsset;
	import ssztui.ui.ProgressTrackAsset;
	
	/**
	 * 成就 ItemView 
	 * @author chendong
	 * 
	 */	
	public class AchItemView extends Sprite implements IPanel
	{
		private var _bg:IMovieWrapper;
		
		private var _bar:Sprite;
		
		/**
		 * 成就名称
		 */		
		private var _achName:MAssetLabel;
		/**
		 * 成就目标:
		 */		
		private var _achTarget:MAssetLabel;
		/**
		 * 成就点数:
		 */		
		private var _achNum:MAssetLabel;
		
		/**
		 * 奖励
		 */		
		private var _achReward:MAssetLabel;
		
		/**
		 * 进度条
		 */
		private var _progressBar:ProgressBar;
		
		/**
		 * 领取奖励按钮 
		 */
		private var _btnGet:MCacheAssetBtn1;
		
		/**
		 * 已领印章
		 */
		private var _sealHas:Bitmap;
		/**
		 * 成就类型 1 
		 */
		private var _achType:int = 1;
		/**
		 * 当前所选择目标
		 */
		public var _info:TargetTemplatInfo;
		/**
		 * 完成图标
		 */
		private var _iconComplete:Bitmap;
		
		/**
		 * 成就图片 
		 */
		private var _achBitmap:Bitmap;
		/**
		 * 图片路径 
		 */		
		private var _picPath:String;
		
		public function AchItemView(info:TargetTemplatInfo)
		{
			super();
			_info = info;
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(0,0,479,66)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(70,32,275,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(6,6,54,54),new Bitmap(new ItemBoxAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(352,14,39,40),new Bitmap(new ItemAchBgAsset())),
			]); 
			addChild(_bg as DisplayObject);
			
			_achName = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_achName.move(66,12);
			addChild(_achName);
			
			_achTarget = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_achTarget.move(160,12);
			addChild(_achTarget);
			
			_achNum = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_achNum.setLabelType([new TextFormat("Tahoma",14,0xffcc33,true)]);
			_achNum.move(370,20);
			addChild(_achNum);
//			_achNum.setValue("90");
			
			_achReward = new MAssetLabel("",MAssetLabel.LABEL_TYPE21,TextFormatAlign.LEFT);
			_achReward.move(66,38);
			addChild(_achReward);
//			_achReward.setHtmlValue(
//				LanguageManager.getWord("ssztl.common.award") + "：" +
//				LanguageManager.getWord("ssztl.common.bindCopper2") + "+6854" + "\t" +
//				LanguageManager.getWord("ssztl.common.lifeUpLine") + "+5222"
//			);
			
			_bar = MBackgroundLabel.getDisplayObject(new Rectangle(408,25,60,15),new ProgressTrackAsset()) as Sprite;
			addChild(_bar);
			
			_progressBar = new ProgressBar(new Bitmap(new ProgressBarExpAsset()),0,0,54,9,true,true);
			_progressBar.move(411,28);
			addChild(_progressBar);
			
			_sealHas = new Bitmap(new SealHasAsset());
			_sealHas.x = 398;
			_sealHas.y = 12;
			addChild(_sealHas);
			_sealHas.visible = false;
			
			_achBitmap = new Bitmap();
			_achBitmap.x = _achBitmap.y = 11;
			addChild(_achBitmap);
			
			_btnGet = new MCacheAssetBtn1(0,1,LanguageManager.getWord("ssztl.common.getLabel"));
			_btnGet.move(408,20);
			addChild(_btnGet);
			
			_iconComplete = new Bitmap(new ItemDoneAsset());
			_iconComplete.x = _iconComplete.y = 5;
			addChild(_iconComplete);
			_iconComplete.visible = false;
		}
		
		public function initEvent():void
		{
			_btnGet.addEventListener(MouseEvent.CLICK,getAchReward);
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getAchAwardAch);
		}
		
		public function initData():void
		{
			var targetData:TargetData = GlobalData.targetInfo.achByIdDic[_info.target_id];
			var targetTemplatInfo:TargetTemplatInfo = TargetTemplateList.getTargetByIdTemplate(int(_info.target_id));
			if(targetData && targetData.isFinish && !targetData.isReceive)//完成未领取
			{
				_btnGet.visible = true;
				_iconComplete.visible = true;
				_bar.visible = _progressBar.visible = false;
			}
			else if(targetData && !targetData.isFinish && !targetData.isReceive) //在完成过程当中
			{
				_btnGet.visible = false;
				_bar.visible = _progressBar.visible = true;
				_progressBar.setValue(targetTemplatInfo.totalNum,targetData.num);
			}
			else if(!targetData) //未完成未领取
			{
				_btnGet.visible = false;
				_bar.visible = _progressBar.visible = true;
				_progressBar.setValue(targetTemplatInfo.totalNum,0);
			}
			else if(targetData && targetData.isFinish && targetData.isReceive) //完成已领取
			{
				_bar.visible = _progressBar.visible = false;
				_btnGet.visible = false;
				_sealHas.visible = true;
				_iconComplete.visible = true;
			}
			
			_achName.setValue(_info.title);
			_achTarget.setValue(_info.tip);
			_achNum.setValue(_info.achievement.toString());
			_achReward.setHtmlValue(
				LanguageManager.getWord("ssztl.common.award") + "：" +
				LanguageManager.getWord("ssztl.common.bindYuanBao") + "+"+ _info.bindYuanbao.toString() + "\t" +
				LanguageManager.getWord("ssztl.common.lifeUpLine") + "+"+ _info.attribute
			);
//			_achBindYuanbao.setValue(_info.bindYuanbao.toString());
//			_achHpTop.setValue(_info.attribute);
			
			if(_info.taclass == 8) //试炼成就隐藏进度条
			{
				_bar.visible = _progressBar.visible = false;
			}
			_picPath = GlobalAPI.pathManager.getTargetPath(targetTemplatInfo.pic.toString());
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
		}
		
		private function loadAvatarComplete(data:BitmapData):void
		{
			_achBitmap.bitmapData = data;
		}	
		
		private function getAchReward(evt:MouseEvent):void
		{
			TargetGetAwardSocketHandler.getTargetAwardById(_info.target_id);
		}
		
		public function clearData():void
		{
			_btnGet.removeEventListener(MouseEvent.CLICK,getAchReward);
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getAchAwardAch);
		}
		
		private function getAchAwardAch(evt:ModuleEvent):void
		{
			if(TargetTemplateList.getTargetByIdTemplate(int(evt.data.targetId)).type == _achType && int(evt.data.targetId) == _info.target_id)
			{
				_sealHas.visible = true;
				_btnGet.visible = false;
			}
		}
		
		public function removeEvent():void
		{
		}
		
		public function dispose():void
		{
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
	}
}