package sszt.swordsman.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mx.core.mx_internal;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.scene.BaseSceneObjInfo;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.swordsman.mediator.SwordsmanMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MPanel;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.swordsman.IntervalLineAsset;
	import ssztui.swordsman.TagBgAsset;
	import ssztui.swordsman.TitleAsset;
	import ssztui.swordsman.TokenIconAsset1;
	import ssztui.swordsman.TokenIconAsset2;
	import ssztui.swordsman.TokenIconAsset3;
	import ssztui.swordsman.TokenIconAsset4;
	import ssztui.ui.SmallBtnAmountDownAsset;
	import ssztui.ui.SmallBtnAmountUpAsset;
	import ssztui.ui.SplitCompartLine2;
	
	public class SwordsmanPanel extends MPanel implements ITick
	{
		private var _bg:IMovieWrapper;
		
		private var _contentGg:Bitmap;
		private var _mediator:SwordsmanMediator;

		private var _labels:Array;
		private var _btns:Array;
		private var _classes:Array;
		private var _panels:Array;
		private var _currentIndex:int = -1;
		private var _assetsComplete:Boolean;
		
		
		private var _index:int = 0;
		
		private var _npcInfo:NpcTemplateInfo;
		
		public function SwordsmanPanel(mediator:SwordsmanMediator,index:int) 
		{
			super(new MCacheTitle1("",new Bitmap(new TitleAsset())),true,-1,true,true);
			_mediator = mediator;
			_index = index;
			_npcInfo = NpcTemplateList.getNpc(102112);
			initialTab(_index);
			initView();
			initEvent();
		}
		
		public function assetsCompleteHandler():void
		{	
			_assetsComplete = true;
			if(_currentIndex != -1 && _panels[_currentIndex])
			{
				(_panels[_currentIndex] as ISwordsmanPanelView).assetsCompleteHandler();
			}
		}
		
		public function update(times:int, dt:Number=0.04):void
		{
			
		}
		
		override protected function configUI():void
		{
			// TODO Auto Generated method stub
			super.configUI();
			setContentSize(479,435);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,25,463,402)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,29,455,231)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,259,459,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,389,459,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,264,130,29),new Bitmap(new TagBgAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(134,90,2,148),new Bitmap(new IntervalLineAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(239,90,2,148),new Bitmap(new IntervalLineAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(344,90,2,148),new Bitmap(new IntervalLineAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(49,97,66,66),new Bitmap(new TokenIconAsset1())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(154,97,66,66),new Bitmap(new TokenIconAsset2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(259,97,66,66),new Bitmap(new TokenIconAsset3())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(364,97,66,66),new Bitmap(new TokenIconAsset4())),
				
			]);
			addContent(_bg as DisplayObject);
		}
		
		private function initView():void
		{
			
		}
		
		private function initEvent():void
		{
			GlobalData.selfScenePlayerInfo.addEventListener(BaseSceneObjInfoUpdateEvent.MOVE,selfMoveHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneHandler);
		}
		
		private function initialTab(selectIndex:int):void
		{
			_labels = [LanguageManager.getWord("ssztl.swordsMan.releaseSwordsman"),LanguageManager.getWord("ssztl.swordsMan.receiveSwordsman")];			
			
			var poses:Array = [new Point(15,0),new Point(100,0)];
			_btns = new Array();
			
			for(var i:int = 0; i < _labels.length; i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,3,_labels[i]);
				btn.move(poses[i].x,poses[i].y);
				addContent(btn);
				_btns.push(btn);
				btn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			
			_classes = [ReleaseSwordsman,ReceiveSwordsman];
			if(selectIndex >= _classes.length || selectIndex < 0)
				selectIndex = 0;
			_panels = new Array();
//			setIndex(selectIndex);
			setIndex(getIndex());
		}
		
		private function getIndex():int
		{
			var index:int = 0;
			var _taskType:int = 11;
			var list:Array;
			var info:TaskItemInfo;
			//领取江湖令 未提交的 （完成未提交，领取未完成）
			if(GlobalData.taskInfo.getTaskByTaskType(_taskType) != null)
			{
				list = GlobalData.taskInfo.getTaskByTaskType(_taskType);
				var flag:Boolean = false;
				for each(info in list)
				{
					if(info.isExist && !info.isFinish)
					{
						flag = true;
						break;
					}
				}
				if(flag)
				{
					index = 1;
				}
			}
			//江湖令发布次数为0的时候，打开面板直接跳到【接受】选项卡。
			var count:int = 0;
			count = 5 - (int(GlobalData.tokenInfo.publishArray[0]) + int(GlobalData.tokenInfo.publishArray[1]) + int(GlobalData.tokenInfo.publishArray[2])
				+ int(GlobalData.tokenInfo.publishArray[3]))
			if(count == 0)
			{
				index = 1;
			}
			return index;
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			var index:int = _btns.indexOf(e.currentTarget as MCacheTabBtn1);
			setIndex(index);
		}
		
		private function setIndex(index:int):void
		{
			if(_currentIndex == index)return;
			if(_currentIndex > -1)
			{
				if(_panels[_currentIndex])
				{
					_panels[_currentIndex].hide();
				}
				_btns[_currentIndex].selected = false;
			}
			_currentIndex = index;
			_btns[_currentIndex].selected = true;
			if(_panels[_currentIndex] == null)
			{
				_panels[_currentIndex] = new _classes[_currentIndex](_mediator);
				_panels[_currentIndex].move(9,26);
				if(_assetsComplete)
				{
					(_panels[_currentIndex] as ISwordsmanPanelView).assetsCompleteHandler();
				}
			}
			addContent(_panels[_currentIndex] as DisplayObject);
			_panels[_currentIndex].show();
		}
		
		private function selfMoveHandler(e:BaseSceneObjInfoUpdateEvent):void
		{
			if(_npcInfo == null)return;
			var selfInfo:BaseSceneObjInfo = e.currentTarget as BaseSceneObjInfo;
			var dis:Number = Math.sqrt(Math.pow(selfInfo.sceneX - _npcInfo.sceneX,2) + Math.pow(selfInfo.sceneY - _npcInfo.sceneY,2));
			if(dis > CommonConfig.NPC_PANEL_DISTANCE)
				dispose();
		}
		
		private function changeSceneHandler(e:SceneModuleEvent):void
		{
			dispose();
		}
		
		private function removeEvent():void
		{
			GlobalData.selfScenePlayerInfo.removeEventListener(BaseSceneObjInfoUpdateEvent.MOVE,selfMoveHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneHandler);
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			_mediator = null;
			_labels = null;
			for each(var i:MCacheTabBtn1 in _btns)
			{
				i.removeEventListener(MouseEvent.CLICK,btnClickHandler);
				i.dispose();
				i = null;
			}
			_classes = null;
			
			for(var j:int = 0;j<_panels.length;j++)
			{
				if(_panels[j]!=null)
				{
					_panels[j].dispose();
					_panels[j] = null;
				}
			}
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			super.dispose();
		}
	}
}