package sszt.scene.components.copyIsland
{
	import fl.core.InvalidationType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.button.MSelectButton;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.mcache.btns.MCacheAsset4Btn;
	import sszt.ui.mcache.btns.selectBtns.MCacheSelectBtn;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.data.task.TaskConditionType;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskItemInfoUpdateEvent;
	import sszt.core.data.task.TaskListUpdateEvent;
	import sszt.core.data.task.TaskStateChecker;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.data.task.TaskType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.tips.GuideTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.smIsland.CopyIslandMainInfoSocketHandler;
	import mhsm.ui.LeftBtnAsset;

	public class CopyIslandFollowPanel extends MSprite
	{
			private var _titleBg:Bitmap;
			private var _smallBg:IMovieWrapper;
			private var _dragBtn:Sprite;
			private var _mediator:SceneMediator;
			private var _labels:Array;
			private var _btns:Array;
			private var _resetBtn:MBitmapButton;
			private var _smallBtn:MBitmapButton;
			private var _showBtn:MBitmapButton;
			private var _container:Sprite;
			private var _container2:Sprite;
			private var _panels:Array;
			private var _classes:Array;
			private var _currentIndex:int = -1;
			
			public function CopyIslandFollowPanel(mediator:SceneMediator)
			{
				_mediator = mediator;
				super();
				init();
				initEvent();
//				CopyIslandMainInfoSocketHandler.send();
			}
			
			private function init():void
			{
				x = CommonConfig.GAME_WIDTH - 230;
				y = 216;
				mouseEnabled = false;
				
				_container = new Sprite();
				addChild(_container);
				_container2 = new Sprite();
				addChild(_container2);
				_container.mouseEnabled = _container2.mouseEnabled = false;
				_container2.visible = false;
				
				_titleBg = new Bitmap(AssetUtil.getAsset("mhsm.task.FollowPanelTitleBarAsset") as BitmapData);
				_container.addChild(_titleBg);
				
				
				_dragBtn = new Sprite();
				_dragBtn.addChild(new Bitmap(AssetUtil.getAsset("mhsm.task.FollowPanelTitleDragAsset") as BitmapData));
				_dragBtn.x = 8;
				_dragBtn.y = 6;
				_dragBtn.buttonMode = true;
				_dragBtn.tabEnabled = false;
				_container.addChild(_dragBtn);
				
				_resetBtn = new MBitmapButton(AssetUtil.getAsset("mhsm.task.FollowPanelResetBtnAsset"));
				_resetBtn.move(185,7);
				_container.addChild(_resetBtn);
				
				_smallBtn = new MBitmapButton(AssetUtil.getAsset("mhsm.task.FollowPanelSmallBtnAsset") as BitmapData);
				_smallBtn.move(210,8);
				_container.addChild(_smallBtn);
				
				_showBtn = new MBitmapButton(AssetUtil.getAsset("mhsm.task.FollowPanelSmallBtnAsset") as BitmapData);
				_showBtn.move(20,6);
				_showBtn.scaleX = -1;
				_container2.addChild(_showBtn);
				
				//			_labels = Vector.<String>(["任务追踪","可接任务"]);
				//			var poses:Vector.<Point> = Vector.<Point>([new Point(34,7),new Point(102,7)]);
				//			_btns = new Vector.<MCacheSelectBtn>();
				//			_labels = ["任务追踪","可接任务"];
				_labels = [LanguageManager.getWord("ssztl.scene.overGateCondition"),LanguageManager.getWord("ssztl.scene.overGateAward")];
				var poses:Array = [new Point(40,7),new Point(112,7)];
				_btns = [];
				_classes = [CIslandConditionPanel,CIslandRewardPanel];
				_panels = [];
				for(var i:int = 0; i < _labels.length; i++)
				{
					var btn:MCacheSelectBtn = new MCacheSelectBtn(0,3,_labels[i]);
					btn.move(poses[i].x,poses[i].y);
					_container.addChild(btn);
					_btns.push(btn);
				}
				setIndex(0);
			}
			
			private function initEvent():void
			{
				for(var i:int = 0; i < _btns.length; i++)
				{
					_btns[i].addEventListener(MouseEvent.CLICK,tabBtnClickHandler);
				}
				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
				_dragBtn.addEventListener(MouseEvent.MOUSE_DOWN,dragBtnDownHandler);
				_resetBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
				_smallBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
				_showBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
				GlobalAPI.layerManager.getPopLayer().stage.addEventListener(MouseEvent.MOUSE_UP,dragStopHandler);
			}
			
			private function removeEvent():void
			{
				for(var i:int = 0; i < _btns.length; i++)
				{
					_btns[i].removeEventListener(MouseEvent.CLICK,tabBtnClickHandler);
				}
				_dragBtn.removeEventListener(MouseEvent.MOUSE_DOWN,dragBtnDownHandler);
				_resetBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
				_smallBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
				_showBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
				ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
				GlobalAPI.layerManager.getPopLayer().stage.removeEventListener(MouseEvent.MOUSE_UP,dragStopHandler);
			}
			
			private function gameSizeChangeHandler(e:CommonModuleEvent):void
			{
				if(_container.visible == true)
					x = CommonConfig.GAME_WIDTH - 230;
				else if(_container2.visible == true)
					x = CommonConfig.GAME_WIDTH - 27;
			}
			
			private function tabBtnClickHandler(e:MouseEvent):void
			{
				var index:int = _btns.indexOf(e.currentTarget as MCacheSelectBtn);
				setIndex(index);
			}
			
			public function setIndex(argIndex:int):void
			{
				if(_currentIndex == argIndex)return;
				if(_currentIndex != -1)
				{
					_btns[_currentIndex].selected = false;
					if(_panels[_currentIndex])
					{
						_panels[_currentIndex].hide();
					}
				}
				_currentIndex = argIndex;
				_btns[_currentIndex].selected = true;
				if(!_panels[_currentIndex])
				{
					_panels[_currentIndex] = new _classes[_currentIndex](_mediator);
					_panels[_currentIndex].move(8,28);
				}
				addChild(_panels[_currentIndex]);
				_panels[_currentIndex].show();
			}
			
			private function dragBtnDownHandler(e:MouseEvent):void
			{
				this.startDrag(false,new Rectangle(0,0,CommonConfig.GAME_WIDTH - this.width,CommonConfig.GAME_HEIGHT - this.height));
			}
			
			private function dragStopHandler(e:MouseEvent):void
			{
				this.stopDrag();
			}
			
			private function btnClickHandler(e:MouseEvent):void
			{
				SoundManager.instance.playSound(SoundManager.COMMON_BTN);
				switch(e.currentTarget)
				{
					case _resetBtn:
						this.x = CommonConfig.GAME_WIDTH - 230;
						this.y = 216;
						break;
					case _smallBtn:
						hide();
						break;
					case _showBtn:
						show();
						break;
//					case _setsizeBtn:
//						_isBigSize = !_isBigSize;
//						_setsizeBtn.selected = _isBigSize;
//						if(_isBigSize)
//						{
//							_shape.graphics.clear();
//							_shape.graphics.beginFill(0,0.6);
//							_shape.graphics.drawRect(0,0,200,310);
//							_shape.graphics.endFill();
//							_listView.setSize(218,297);
//							_listView.update();
//							_setsizeBtn.y = 327;
//						}
//						else
//						{
//							_shape.graphics.clear();
//							_shape.graphics.beginFill(0,0.6);
//							_shape.graphics.drawRect(0,0,200,141);
//							_shape.graphics.endFill();
//							_listView.setSize(218,130);
//							_listView.update();
//							_setsizeBtn.y = 161;
//						}
//						break;
				}
			}
			
			public function show():void
			{
				this.x = CommonConfig.GAME_WIDTH - 230;
				this.y = 216;
				_container.visible = true;
				_container2.visible = false;
			}
			
			public function hide():void
			{
				this.x = CommonConfig.GAME_WIDTH - 25;
				this.y = 216;
				_container.visible = false;
				_container2.visible = true;
			}
			
			override public function get width():Number
			{
				return _container.width;
			}
			
			override public function get height():Number
			{
				return _container.height;
			}
			
			override public function dispose():void
			{
				removeEvent();
				if(_resetBtn)
				{
					_resetBtn.dispose();
					_resetBtn = null;
				}
				if(_smallBtn)
				{
					_smallBtn.dispose();
					_smallBtn = null;
				}
				if(_showBtn)
				{
					_showBtn.dispose();
					_showBtn = null;
				}
				if(_smallBg)
				{
					_smallBg.dispose();
					_smallBg = null;
				}
				if(_btns)
				{
					for each(var btn:MCacheSelectBtn in _btns)
					{
						btn.dispose();
					}
				}
				_btns = null;
				for(var j:int = 0;j < _panels.length;j++)
				{
					if(_panels[j])
					{
						_panels[j].dispose();
						_panels[j] = null;
					}
				}
				_panels = null;
				_classes = null;
				_container = null;
				_container2 = null;
				_labels = null;
				_dragBtn = null;
				_titleBg = null;
//				_mediator.copyIslandInfo.clearCIMaininfo();
				_mediator = null;
				super.dispose();
			}
	}
}