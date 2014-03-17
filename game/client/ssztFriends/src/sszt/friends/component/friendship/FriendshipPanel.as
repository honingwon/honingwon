package sszt.friends.component.friendship
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.friendship.FriendshipTemplateInfo;
	import sszt.core.data.friendship.FriendshipTemplateList;
	import sszt.friends.mediator.FriendsMediator;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.panel.IPanel;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.friends.NearTitleAsset;
	
	public class FriendshipPanel extends MPanel implements IPanel
	{
		private var _mediator:FriendsMediator;
		private var _bg:IMovieWrapper;
		private var _tile:MTile;
		private var _cellList:Array
		private var _description:MAssetLabel;
		
		public static const DEFAULT_WIDTH:int = 260;
		public static const DEFAULT_HEIGHT:int = 280;
		
		public function FriendshipPanel(mediator:FriendsMediator)
		{
			super(new MCacheTitle1("",new Bitmap(new NearTitleAsset())),true,-1);
			_mediator = mediator;
			initView();
			initEvent();
			initData();
		}
		
		override protected function configUI():void
		{
			// TODO Auto Generated method stub
			super.configUI();
		}
		
		public function initView():void
		{
			setContentSize(DEFAULT_WIDTH,DEFAULT_HEIGHT);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8, 2, DEFAULT_WIDTH-16, DEFAULT_HEIGHT-10)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12, 6, DEFAULT_WIDTH-24, 178)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12, 183, DEFAULT_WIDTH-24, 25),new MCacheCompartLine2()),
			]);
			addContent(_bg as DisplayObject);
			
			_cellList = [];
			_tile = new MTile(220,28,1);
			_tile.setSize(220,168);
			_tile.move(17,11);
			_tile.itemGapH = 0;
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			addContent(_tile);
			
			_description = new MAssetLabel("", MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_description.setLabelType([new TextFormat("SimSun",12,0xe4c590,null,null,null,null,null,null,null,null,null,5)]);
			_description.wordWrap = true;
			_description.setSize(DEFAULT_WIDTH-32,100);
			_description.move(17, 190);
			addContent(_description);
			_description.setHtmlValue("组队加成：好友友好度达到一定级别，与好友组队可触发属性加成。\n友好度获得：好友间可通过赠送鲜花、组队击杀boss增加友好度。");
		}
		
		public function initEvent():void
		{
			
		}
		
		public function initData():void
		{
			clearData();
			var friendshipTemplate:FriendshipTemplateInfo;
			var friendshipItem:FriendshipItemView;
			var i:int = 0;
			for(;i<FriendshipTemplateList._friendshipArray.length;i++)
			{
				friendshipTemplate = FriendshipTemplateList._friendshipArray[i];
				friendshipItem = new FriendshipItemView(friendshipTemplate);
				_tile.appendItem(friendshipItem);
				_cellList.push(friendshipItem);
			}
		}
		
		public function clearData():void
		{
			var i:int = 0;
			if (_cellList)
			{
				i = 0;
				while (i < _cellList.length)
				{
					_cellList[i].dispose();
					i++;
				}
				_cellList = [];
			}
			if(_tile)
			{
				_tile.disposeItems()
			}
		}
		
		public function removeEvent():void
		{
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			removeEvent();
			super.dispose();
		}
		
		
	}
}