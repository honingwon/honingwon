package sszt.role.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.player.DetailPlayerInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.role.RoleModule;
	import sszt.role.mediator.RoleMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MPanel2;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.labelField.MLabelField2Bg;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.BorderAssetTip1;
	import ssztui.ui.RoleTitle;
	
	/**
	 * 人物面板
	 * */
	public class RolePropertyPanel extends MPanel
	{
		private var _roleMediator:RoleMediator;
//		private var _labels:Vector.<String>;
//		private var _btns:Vector.<MCacheTab1Btn>;
//		private var _classes:Vector.<Class>;
//		private var _panels:Vector.<IRolePanelView>;
		private var _labels:Array;
		private var _btns:Array;
		private var _classes:Array;
		private var _panels:Array;
		/**
		 * 0 属性面板 1 穴位面板
		 */
		private var _currentIndex:int = -1;
		private var _bg:IMovieWrapper;
		private var _sideBg:MovieClip;
		public var rolePlayerId:Number;
		
		private var _assetsComplete:Boolean;
		
		public function RolePropertyPanel(roleMediator:RoleMediator,argRolePlayerId:Number, selectIndex:int = 0)
		{
			_roleMediator = roleMediator;
			rolePlayerId = argRolePlayerId;
//			_currentIndex = selectIndex;
			
			super(new MCacheTitle1("",new Bitmap(new RoleTitle())),true,-1,true,false);
			
			var x:int = CommonConfig.GAME_WIDTH / 2 - 459;
			var y:int = CommonConfig.GAME_HEIGHT / 2 - 445 / 2
			move(x,y);
			
			initialTab(selectIndex);
		}
		
		public function assetsCompleteHandler():void
		{	
			_assetsComplete = true;
			if(_currentIndex != -1 && _panels[_currentIndex])
			{
				(_panels[_currentIndex] as IRolePanelView).assetsCompleteHandler();
			}
		}
		override protected  function configUI():void
		{
			super.configUI();
			setContentSize(459,415);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,25,443,382)),								
			]);
			addContent(_bg as DisplayObject);
			
//			addContent(FightUpgradePanel.getInstance());
			
		}
		
		private function initialTab(selectIndex:int):void
		{
			if(rolePlayerId==GlobalData.selfPlayer.characterId)
				_labels = [LanguageManager.getWord("ssztl.pet.property"),LanguageManager.getWord("ssztl.role.veins"),LanguageManager.getWord("ssztl.role.call"),LanguageManager.getWord("ssztl.scene.exchange")];	
			else
				_labels = [LanguageManager.getWord("ssztl.pet.property"),LanguageManager.getWord("ssztl.role.veins")];

			
			var poses:Array = [new Point(15,0),new Point(72,0),new Point(129,0),new Point(186,0)];
			_btns = new Array();
			
			for(var i:int = 0; i < _labels.length; i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,1,_labels[i]);
				btn.move(poses[i].x,poses[i].y);
				addContent(btn);
				_btns.push(btn);
				btn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			
	_classes = [CharacterPanel,VeinsPanel,TitlePanel,ExchangePanel];

			if(selectIndex >= _classes.length || selectIndex < 0)
				selectIndex = 0;
			_panels = new Array();
			setIndex(0);
			setIndex(selectIndex);
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			var index:int = _btns.indexOf(e.currentTarget as MCacheTabBtn1);
			setIndex(index);
		}
		public function skipPage(index:int):void
		{
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
				if(_classes[_currentIndex] == VeinsPanel && rolePlayerId != GlobalData.selfPlayer.userId)
				{
					_panels[_currentIndex] = new VeinsOthersPanel(_roleMediator,rolePlayerId);
				}
				else
				{
					_panels[_currentIndex] = new _classes[_currentIndex](_roleMediator,rolePlayerId);
				}
				_panels[_currentIndex].move(9,26);
				if(_assetsComplete)
				{
					(_panels[_currentIndex] as IRolePanelView).assetsCompleteHandler();
				}
			}
			addContent(_panels[_currentIndex] as DisplayObject);
			_panels[_currentIndex].show();
		}
		
		override public function dispose():void
		{
			_roleMediator = null;
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
			if(_sideBg)
			{
				_sideBg = null;
			}
			super.dispose();
		}
	}
}