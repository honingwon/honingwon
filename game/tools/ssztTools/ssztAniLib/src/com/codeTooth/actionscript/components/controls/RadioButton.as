package com.codeTooth.actionscript.components.controls
{
	import flash.utils.Dictionary;

	public class RadioButton extends LabelSwitchButton
	{	
		public function RadioButton()
		{
			addRadioButton(this);
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 重写是否可选
		//--------------------------------------------------------------------------------------------------------------------------
		
		override public function set selected(bool:Boolean):void
		{
			if(bool)
			{
				super.selected = bool;
				
				if( _selected != bool)
				{
					selectRadioButton(this);
				}
			}
		}
		
		override protected function clickExecute():void
		{
			if(!_selected)
			{
				super.clickExecute();
				
				if(!_selected)
				{
					setSelectedInternal(true);
				}
				
				selectRadioButton(this);
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 单选按钮所在的组
		//--------------------------------------------------------------------------------------------------------------------------
		
		private var _group:Object;
		
		public function set group(group:Object):void
		{
			if(_group != group)
			{
				_group = group;
				
				removeRadioButton(this);
				addRadioButton(this);
			}
		}
		
		public function get group():Object
		{
			return _group;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------
		// 单选按钮的组管理
		//--------------------------------------------------------------------------------------------------------------------------
		
		private static  var _groups:Dictionary = new Dictionary();
		
		private static function selectRadioButton(radioButton:RadioButton):void
		{
			var group:Array = getGroup(radioButton.group);
			
			for each(var aRadioButton:RadioButton in group)
			{
				if(radioButton != aRadioButton)
				{
					aRadioButton.setSelectedInternal(false);
				}
			}
		}
		
		private static function addRadioButton(radioButton:RadioButton):void
		{
			var group:Array = getGroup(radioButton.group);
			group.push(radioButton);
		}
		
		private static function removeRadioButton(radioButton:RadioButton):void
		{
			var group:Array = getGroup(radioButton.group);
			var numberRadioButtons:int = group.length;
			
			for(var i:int = 0; i < numberRadioButtons; i++)
			{
				if(group[i] == radioButton)
				{
					group.splice(i, 1);
					
					if(group.length == 0)
					{
						delete _groups[radioButton.group];
					}
					
					break;
				}
			}
		}
		
		private static function getGroup(group:Object):Array
		{
			if(_groups[group] == undefined)
			{
				_groups[group] = new Array();
			}
			
			return _groups[group];
		}
	}
}