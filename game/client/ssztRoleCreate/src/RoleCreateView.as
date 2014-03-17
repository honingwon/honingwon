package
{
	import fl.controls.ProgressBar;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TextEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	
	import ssztui.createRole.BgSceneAsset;
	import ssztui.createRole.CareerTipAsset;
	import ssztui.createRole.CreateBtnAsset;
	import ssztui.createRole.RandomBtnAsset;
	import ssztui.createRole.RoleBtnAsset1;
	import ssztui.createRole.RoleBtnAsset2;
	import ssztui.createRole.RoleBtnAsset3;
	import ssztui.createRole.RoleBtnAsset4;
	import ssztui.createRole.RoleBtnAsset5;
	import ssztui.createRole.RoleBtnAsset6;
	
	public class RoleCreateView extends Sprite
	{
		private var _data:Object;
		private var _bg:MovieClip;
		private var _btns:Array;
		private var _btnsClass:Array;
		private var _currentBtn:RoleSelectBtn;
		private var _createBtn:CreateBtnAsset;
		private var _field:TextField;
		private var _nick:String;
		private var _filterUtils:WordFilter;
		private var _alert:Object;
		private var _saizi:RandomBtnAsset;
		private var _careerTip:CareerTipAsset;
//		private var _loading:LoadingAsset;
		private var _currentBmp:Bitmap;
		private var _loadText:TextField;
		private var _isDispose:Boolean;
		private var _xingArr:Array;
		private var _ming1Arr:Array;
		private var _ming2Arr:Array;
		private var _tip:BaseTip;
		private var _tip2:TipII;
		
		public function RoleCreateView(data:Object)
		{
			_data = data;
			super();
			init();
			initEvent();
//			setSelected(_btns[int(Math.random() * 6)]);
			var arr:Array;
			var registerCareer:int = int(_data["commoncomfing"].createDefault.career.@value);
			var registerSex:int = int(_data["commoncomfing"].createDefault.sex.@value);
			if(registerCareer == 0 && registerSex == 0)
			{
				arr = _btns.slice(0);
			}
			else if(registerCareer == 0)
			{
				if(registerSex == 1)arr = [_btns[0],_btns[2],_btns[4]];
				else arr = [_btns[1],_btns[3],_btns[5]];
			}
			else if(registerSex == 0)
			{
				if(registerCareer == 1)arr = [_btns[0],_btns[1]];
				else if(registerCareer == 2)arr = [_btns[2],_btns[3]];
				else arr = [_btns[4],_btns[5]];
			}
			else
			{
				if(registerSex == 1)
				{
					if(registerCareer == 1)arr = [_btns[0]];
					else if(registerCareer == 2)arr = [_btns[2]];
					else arr = [_btns[4]];
				}
				else
				{
					if(registerCareer == 1)arr = [_btns[1]];
					else if(registerCareer == 2)arr = [_btns[3]];
					else arr = [_btns[5]];
				}
			}
			setSelected(arr[int(Math.random() * arr.length)]);
		}
		
		private function init():void
		{
			var mask:Shape = new Shape();
			mask.graphics.beginFill(0);
			mask.graphics.drawRect(-500,-500,3000,3000);
			mask.graphics.endFill();
			addChild(mask);
			
			_bg = new BgSceneAsset();
			addChild(_bg);
			
			_loadText = new TextField();
			_loadText.width = 20;
			_loadText.height = 13;
			_loadText.x = 590;
			_loadText.y = 285;
			_loadText.defaultTextFormat = new TextFormat("SimSun",12,0xffffff);
			addChild(_loadText);
			
			_btns = [];
			_btnsClass = [RoleBtnAsset1,RoleBtnAsset2,RoleBtnAsset3,RoleBtnAsset4,RoleBtnAsset5,RoleBtnAsset6];
			for(var i:int = 0; i < 3; i++)
			{
				for(var j:int = 0; j < 2; j++)
				{
					var btn:RoleSelectBtn = new RoleSelectBtn(i,j,_btnsClass[i*2+j]);
					_btns.push(btn);
//					btn.x = (1 - j) * 110 + 751;
//					btn.y = i * 105 + 126;
					btn.x = j * 74 + 813;
					btn.y = i * 85 + 132;
					addChild(btn);
					btn.addEventListener(MouseEvent.CLICK,btnClickHandler);
					btn.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
					btn.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
				}

			}
			
			_createBtn = new CreateBtnAsset();
			_createBtn.x = 488;
			_createBtn.y = 483;
			_createBtn.gotoAndStop(1);
			addChild(_createBtn);
//			_createBtn._ef.mouseEnabled = false;
//			_createBtn.mouseChildren = false;
			
			_saizi = new RandomBtnAsset();
			_saizi.x = 693;
			_saizi.y = 413;
			_saizi.gotoAndStop(1);
			addChild(_saizi);
			_createBtn.buttonMode = _saizi.buttonMode = true;
			
			_field = new TextField();
			_field.type = TextFieldType.INPUT;
			_field.width = 110;
			_field.height = 20;
			_field.x = 565;
			_field.y = 416;
			var format:TextFormat = new TextFormat("SimSun",14,0xffcc00,null,null,null,null,null,TextFormatAlign.CENTER);
			_field.setTextFormat(format);
			_field.defaultTextFormat = format;
			addChild(_field);
			
			_careerTip = new CareerTipAsset();
			_careerTip.x = 382;
			_careerTip.y = 140;
			addChild(_careerTip);
			
			_filterUtils = new WordFilter();
			_filterUtils.setup(_data["filterword"] as Array);
			
			_alert = _data["alert"];
			
			var urlloader:URLLoader = new URLLoader();
			urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			urlloader.addEventListener(Event.COMPLETE,nickLoadComplete);
			urlloader.addEventListener(IOErrorEvent.IO_ERROR,nickIoerrorHandler);
			urlloader.load(new URLRequest(_data["clientPath"]+"name.txt"));
			
			_tip = new BaseTip(this);
			_tip2 = new TipII();
			_tip2.x = 725;
			_tip2.y = 511;
			_tip2.setValue("");
			addChild(_tip2);
		}
		
		private function initEvent():void
		{
			_createBtn.addEventListener(MouseEvent.CLICK,createClickHandler);
			_createBtn.addEventListener(MouseEvent.MOUSE_OVER,createOverHandler);
			_createBtn.addEventListener(MouseEvent.MOUSE_DOWN,createDownHandler);
			_createBtn.addEventListener(MouseEvent.MOUSE_UP,createUpHandler);
			_createBtn.addEventListener(MouseEvent.MOUSE_OUT,createOutHandler);
			_saizi.addEventListener(MouseEvent.CLICK,saiziClickHandler);
			_saizi.addEventListener(MouseEvent.MOUSE_OVER,saiziOverHandler);
			_saizi.addEventListener(MouseEvent.MOUSE_DOWN,saiziDownHandler);
			_saizi.addEventListener(MouseEvent.MOUSE_UP,saiziUpHandler);
			_saizi.addEventListener(MouseEvent.MOUSE_OUT,saiziOutHandler);
			_field.addEventListener(TextEvent.TEXT_INPUT,textInputHandler);
		}
		private function stageResizeHandler(evt:Event):void
		{
			var vx:int = this.stage.stageWidth - 1200;
			var vy:int = this.stage.stageHeight - 600;
			this.x = vx <-400 ? -400:vx/2;
			this.y = vx <-50 ? -50:vy/2;
		}
		
		private function removeEvent():void
		{
			_createBtn.removeEventListener(MouseEvent.CLICK,createClickHandler);
			_createBtn.removeEventListener(MouseEvent.MOUSE_OVER,createOverHandler);
			_createBtn.removeEventListener(MouseEvent.MOUSE_DOWN,createDownHandler);
			_createBtn.removeEventListener(MouseEvent.MOUSE_UP,createUpHandler);
			_createBtn.removeEventListener(MouseEvent.MOUSE_OUT,createOutHandler);
			_saizi.removeEventListener(MouseEvent.CLICK,saiziClickHandler);
			_saizi.removeEventListener(MouseEvent.MOUSE_OVER,saiziOverHandler);
			_saizi.removeEventListener(MouseEvent.MOUSE_DOWN,saiziDownHandler);
			_saizi.removeEventListener(MouseEvent.MOUSE_UP,saiziUpHandler);
			_saizi.removeEventListener(MouseEvent.MOUSE_OUT,saiziOutHandler);
			_field.removeEventListener(TextEvent.TEXT_INPUT,textInputHandler);
		}
		
		private function createOverHandler(evt:MouseEvent):void{_createBtn.gotoAndStop(2);_createBtn._ef.visible = false;}
		private function createDownHandler(evt:MouseEvent):void{_createBtn.gotoAndStop(3);}
		private function createUpHandler(evt:MouseEvent):void{_createBtn.gotoAndStop(2);}
		private function createOutHandler(evt:MouseEvent):void{
			if(_createBtn && _createBtn._ef)
			{
				_createBtn.gotoAndStop(1);
				_createBtn._ef.visible = true;
			}
		}
		
		private function saiziOverHandler(evt:MouseEvent):void{_saizi.gotoAndStop(2);}
		private function saiziDownHandler(evt:MouseEvent):void{_saizi.gotoAndStop(3);}
		private function saiziUpHandler(evt:MouseEvent):void{_saizi.gotoAndStop(2);}
		private function saiziOutHandler(evt:MouseEvent):void{_saizi.gotoAndStop(1);}
		
		private function textInputHandler(evt:TextEvent):void
		{
			_tip2.setValue("");
		}
		
		private function nickLoadComplete(evt:Event):void
		{
			var loader:URLLoader = evt.currentTarget as URLLoader;
			loader.removeEventListener(Event.COMPLETE,nickLoadComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,ioerrorHandler);
			if(_isDispose)return;
			var data:ByteArray = loader.data as ByteArray;
			data.position = 0;
			data.uncompress();
			data.position = 0;
			var t:String = data.readUTFBytes(data.length);
			var arr:Array = t.split("|");
			_xingArr = arr[0].split(",");
			_ming1Arr = arr[1].split(",");
			_ming2Arr = arr[2].split(",");
			if(_field.text == "")
				setRndNick();
		}
		private function nickIoerrorHandler(evt:IOErrorEvent):void
		{
			var loader:URLLoader = evt.currentTarget as URLLoader;
			loader.removeEventListener(Event.COMPLETE,nickLoadComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,ioerrorHandler);
		}
		
		private function setRndNick():void
		{
			if(!_ming1Arr) return;
			var nick:String = _xingArr[int(Math.random() * _xingArr.length)];
			if(_currentBtn.sex)
			{
				nick += _ming1Arr[int(Math.random() * _ming1Arr.length)];
			}
			else
			{
				nick += _ming2Arr[int(Math.random() * _ming2Arr.length)];
			}
			_field.text = nick;
		}
		
		private function btnClickHandler(evt:MouseEvent):void
		{
			setSelected(evt.currentTarget as RoleSelectBtn);
		}
		private function mouseOverHandler(evt:MouseEvent):void
		{
			var btn:RoleSelectBtn = evt.currentTarget as RoleSelectBtn;
			switch(btn.career)
			{
				case 0:
					_tip.setTips("<font color='#ffff00'>岳王宗</font>：<br />擅长用枪，近战高攻。");
					break;
				case 1:
					_tip.setTips("<font color='#ffff00'>花间派</font>：<br />擅长用扇，法攻群伤。");
					break;
				case 2:
					_tip.setTips("<font color='#ffff00'>唐门</font>：<br />擅长暗器，远程高爆。");
					break;
			}			
			_tip.x = btn.x + 50;
			_tip.y = btn.y + 60;
			_tip.show();
		}
		private function mouseOutHandler(evt:MouseEvent):void
		{
			_tip.hide();
		}
		
		private function setSelected(btn:RoleSelectBtn):void
		{
			if(_currentBtn == btn)return;
			var createName:Boolean = false;
			if(_currentBtn && btn && _currentBtn.sex != btn.sex)
			{
				createName = true;
				
			}
			if(_currentBtn)_currentBtn.selected = false;
			_currentBtn = btn;
			_currentBtn.selected = true;
			if(createName)
			{
				_field.text = "";
				setRndNick();
			}
			_careerTip.gotoAndStop(_currentBtn.career + 1);
//			addChild(_loading);
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderCompleteHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,loadProgressHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioerrorHandler);
			loader.load(new URLRequest(_data["sitePath"] + "img/createRole/" + (_currentBtn.career + 1) + (_currentBtn.sex ? "1" : "2") + ".png"));
		}
		
		private function ioerrorHandler(evt:IOErrorEvent):void
		{
			trace(evt.text);
//			if(_loading.parent)_loading.parent.removeChild(_loading);
			var loaderInfo:LoaderInfo = evt.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE,loaderCompleteHandler);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS,loadProgressHandler);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioerrorHandler);
		}
		private function loadProgressHandler(evt:ProgressEvent):void
		{
			var percentLoaded:Number = evt.bytesLoaded/evt.bytesTotal;
			percentLoaded = Math.round(percentLoaded * 100);
			_loadText.text = percentLoaded+"%";
		}
		private function loaderCompleteHandler(evt:Event):void
		{
			_loadText.text = "";
//			if(_loading.parent)_loading.parent.removeChild(_loading);
			var loaderInfo:LoaderInfo = evt.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE,loaderCompleteHandler);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS,loadProgressHandler);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioerrorHandler);
			if(_isDispose)return;
			if(loaderInfo.url == _data["sitePath"] + "img/createRole/" + (_currentBtn.career + 1) + (_currentBtn.sex ? "1" : "2") + ".png")
			{
				var sex:Boolean = _currentBtn.sex;
				if(_currentBmp && _currentBmp.parent)
					_currentBmp.parent.removeChild(_currentBmp);
				_currentBmp = loaderInfo.loader.content as Bitmap;
				_currentBmp.x = 359;
				_currentBmp.y = 112;
				addChild(_currentBmp);
//				if(sex)
//				{
//					if(_currentBtn.career == 0)
//					{
//						_currentBmp.x = 172;
//						_currentBmp.y = 60;
//					}
//					else if(_currentBtn.career == 1)
//					{
//						_currentBmp.x = 250;
//						_currentBmp.y = 37;
//					}
//					else if(_currentBtn.career == 2)
//					{
//						_currentBmp.x = 213;
//						_currentBmp.y = 13;
//					}
//				}
//				else
//				{
//					if(_currentBtn.career == 0)
//					{
//						_currentBmp.x = 194;
//						_currentBmp.y = 16;
//					}
//					else if(_currentBtn.career == 1)
//					{
//						_currentBmp.x = 278;
//						_currentBmp.y = 21;
//					}
//					else if(_currentBtn.career == 2)
//					{
//						_currentBmp.x = 278;
//						_currentBmp.y = 9;
//					}
//				}
				if(_careerTip.parent)
				{
					_careerTip.parent.swapChildren(_careerTip,_currentBmp);
				}
			}
		}
		
		private function createClickHandler(evt:MouseEvent):void
		{
			if(_field.text == "")
			{
//				_alert.show("请输入角色名",this);
				_tip2.setValue("请输入角色名!");
			}
			else
			{
				var n:int = _filterUtils.checkLen(_field.text);
				if(n < 4)
				{
//					_alert.show("角色名称不能少于4个字符(2个汉字)。",this);
					_tip2.setValue("角色名称不能少于4个字符(2个汉字)!");
					return;
				}
				else if(n > 14)
				{
//					_alert.show("角色名字最多为14个字符(7个汉字)。",this);
					_tip2.setValue("角色名字最多为14个字符(7个汉字)!");
					return;
				} 
				var regEx:RegExp = /([^a-zA-Z0-9\u4E00-\u9FA5])+/;
				if (regEx.test(_field.text))
				{
					_tip2.setValue("角色名必须是中英文数字的组成!");
					return;
				}
				if(!_filterUtils.checkNameAllow(_field.text))
				{
//					_alert.show("角色名包含非法字符。",this);
					_tip2.setValue("角色名包含非法字符!");
					return;
				}
				_nick = _field.text;
				_data["createFunc"](_currentBtn.career + 1,_currentBtn.sex,_nick,socketBack);
			}
		}
		private function saiziClickHandler(evt:MouseEvent):void
		{
			_field.text = "";
			setRndNick();
			
			_tip2.setValue("");
		}
		private function socketBack(data:ByteArray):void
		{
			if(data.readBoolean())
			{
				trace(data.readUTF());
				data.readShort();
				var t:Number = data.readShort();
				t =  (t << 24) * 256 + data.readUnsignedInt();
				_data["callback"](_nick,t);
			}
			else
			{
//				trace(data.readUTF());
				var tt:String = data.readUTF();
				if(tt == "失败")
				{
					//_alert.show("该用户名已经被注册！",this);
					_tip2.setValue("该用户名已经被注册!");
				}
				else
				{
					//_alert.show(tt,this);
					_tip2.setValue(tt);
				}
			}
		}
		
		public function dispose():void
		{
			removeEvent();
			for each(var i:RoleSelectBtn in _btns)
			{
				i.removeEventListener(MouseEvent.CLICK,btnClickHandler);
				i.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
				i.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
				i.dispose();
			}
			if(_bg){
				_bg.parent.removeChild(_bg);
				_bg = null;
			}
			_btns = null;
			_currentBtn = null;
			_loadText = null;
			if(_createBtn)
			{
				_createBtn.parent.removeChild(_createBtn);
				_createBtn = null;
			}
			_data = null;
			_filterUtils = null;
			_isDispose = true;
			if(_alert)
			{
				_alert = null;
			}
			_saizi = null;
			_careerTip = null;
//			_loading = null;
			_xingArr = null;
			_ming1Arr = null;
			_ming2Arr = null;
			if(_tip)
			{
				_tip.dispose();
				_tip = null;
			}
			_tip2 = null;
			if(parent)parent.removeChild(this);
		}
	}
}