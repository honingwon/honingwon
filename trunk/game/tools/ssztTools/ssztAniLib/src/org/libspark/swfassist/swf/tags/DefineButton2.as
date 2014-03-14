/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is the swfassist.
 *
 * The Initial Developer of the Original Code is
 * the BeInteractive!.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** */

package org.libspark.swfassist.swf.tags
{
	import org.libspark.swfassist.swf.structures.ButtonCondAction;
	import org.libspark.swfassist.swf.structures.ButtonRecord;
	
	public class DefineButton2 extends AbstractTag
	{
		public function DefineButton2(code:uint = 0)
		{
			super(code != 0 ? code : TagCodeConstants.TAG_DEFINE_BUTTON2);
		}
		
		private var _buttonId:uint = 0;
		private var _trackAsMenu:Boolean = false;
		private var _characters:Array = [];
		private var _actions:Array = [];
		
		public function get buttonId():uint
		{
			return _buttonId;
		}
		
		public function set buttonId(value:uint):void
		{
			_buttonId = value;
		}
		
		public function get trackAsMenu():Boolean
		{
			return _trackAsMenu;
		}
		
		public function set trackAsMenu(value:Boolean):void
		{
			_trackAsMenu = value;
		}
		
		public function get numCharacters():uint
		{
			return characters.length;
		}
		
		public function get characters():Array
		{
			return _characters;
		}
		
		public function set characters(value:Array):void
		{
			_characters = value;
		}
		
		public function get numActions():uint
		{
			return actions.length;
		}
		
		public function get actions():Array
		{
			return _actions;
		}
		
		public function set actions(value:Array):void
		{
			_actions = value;
		}
		
		public function clearCharacters():void
		{
			if (numCharacters > 0) {
				characters.splice(0, numCharacters);
			}
		}
		
		public function addCharacter(character:ButtonRecord):void
		{
			characters.push(character);
		}
		
		public function clearActions():void
		{
			if (numActions > 0) {
				actions.splice(0, numActions);
			}
		}
		
		public function addAction(action:ButtonCondAction):void
		{
			actions.push(action);
		}
		
		public override function visit(visitor:TagVisitor):void
		{
			visitor.visitDefineButton2(this);
		}
	}
}