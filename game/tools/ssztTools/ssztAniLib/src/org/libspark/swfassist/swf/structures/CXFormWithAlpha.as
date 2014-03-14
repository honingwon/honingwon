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

package org.libspark.swfassist.swf.structures
{
	import flash.geom.ColorTransform;
	
	public class CXFormWithAlpha extends CXForm
	{
		private var _alphaMul:int = 1.0;
		private var _alphaAdd:int = 0.0;
		
		// SB
		public function get alphaMultiplication():int
		{
			return _alphaMul;
		}
		
		public function set alphaMultiplication(value:int):void
		{
			_alphaMul = value;
		}
		
		// SB
		public function get alphaAddition():int
		{
			return _alphaAdd;
		}
		
		public function set alphaAddition(value:int):void
		{
			_alphaAdd = value;
		}
		
		public override function toNativeColorTransform():ColorTransform
		{
			var tf:ColorTransform = super.toNativeColorTransform();
			
			tf.alphaMultiplier = alphaMultiplication;
			tf.alphaOffset = alphaAddition;
			
			return tf;
		}
	}
}