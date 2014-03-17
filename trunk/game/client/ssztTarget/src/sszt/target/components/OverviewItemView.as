package sszt.target.components
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.target.TargetData;
	import sszt.core.data.target.TargetTemplatInfo;
	import sszt.core.data.target.TargetTemplateList;
	import sszt.core.data.target.TargetUtils;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.panel.IPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.progress.ProgressBar;
	
	import ssztui.ui.ProgressBar3Asset;
	import ssztui.ui.ProgressBarExpAsset;
	import ssztui.ui.ProgressTrackAsset;
	
	/**
	 * 成就总览 ItemView 
	 * @author chendong
	 * 
	 */	
	public class OverviewItemView extends Sprite implements IPanel
	{
		private var _bar:Sprite;
		/**
		 * 完成进度:
		 */		
		private var _completeProgress:MAssetLabel;
		
		/**
		 * 完成点数:{1}
		 */		
		private var _completeNum:MAssetLabel;
		
		/**
		 * 进度条
		 */
		private var _progressBar:ProgressBar;
		
		private var _currentType:int = 1;
		/**
		 *单个成就分类，完成的总点数 
		 */
		private var _completedNum:int = 0;
		
		public function OverviewItemView(type:int)
		{
			super();
			_currentType = type;
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			_bar = MBackgroundLabel.getDisplayObject(new Rectangle(91,6,113,17),new ProgressTrackAsset()) as Sprite;
			addChild(_bar);
				
			_completeProgress = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT);
			_completeProgress.move(18,6);
			addChild(_completeProgress);
			
			_progressBar = new ProgressBar(new Bitmap(new ProgressBarExpAsset()),0,0,121,11,true,false);
			_progressBar.move(94,9);
			addChild(_progressBar);
			
			_completeNum = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT);
			_completeNum.textColor = 0xecd099;
			_completeNum.move(212,6);
			addChild(_completeNum);
		}
		
		public function initEvent():void
		{
		}
		
		public function initData():void
		{
			switch(_currentType)
			{
				case 1:
					_completeProgress.setValue(LanguageManager.getWord("ssztl.target.ach1") + "：");
					break;
				case 2:
					_completeProgress.setValue(LanguageManager.getWord("ssztl.target.ach2") + "：");
					break;
				case 3:
					_completeProgress.setValue(LanguageManager.getWord("ssztl.target.ach3") + "：");
					break;
				case 4:
					_completeProgress.setValue(LanguageManager.getWord("ssztl.target.ach4") + "：");
					break;
				case 5:
					_completeProgress.setValue(LanguageManager.getWord("ssztl.target.ach5") + "：");
					break;
				case 6:
					_completeProgress.setValue(LanguageManager.getWord("ssztl.target.ach6") + "：");
					break;
				case 7:
					_completeProgress.setValue(LanguageManager.getWord("ssztl.target.ach7") + "：");
					break;
				case 8:
					_completeProgress.setValue(LanguageManager.getWord("ssztl.target.ach8") + "：");
					break;
			}
			_progressBar.setValue(TargetUtils.getAchTypeNum(_currentType),getAchInt(_currentType));
			_completeNum.setValue("成就点：" + _completedNum.toString());
		}
		
		private function getAchInt(currentType:int):int
		{
			var achInt:int = 0;
			var achInfo:TargetTemplatInfo;
			var achTemplateArray:Array = TargetUtils.getAchTemplateData(currentType);
			var targetData:TargetData = null;
			//完成已领取
			for each (achInfo in achTemplateArray)
			{
				targetData = GlobalData.targetInfo.achByIdDic[achInfo.target_id];
				if(targetData && targetData.isFinish && targetData.isReceive)
				{
					achInt ++;
					_completedNum += achInfo.achievement;
				}
			}
			return achInt;
		}
		
		public function clearData():void
		{
		}
		
		public function removeEvent():void
		{
		}
		
		public function dispose():void
		{
			
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
	}
}