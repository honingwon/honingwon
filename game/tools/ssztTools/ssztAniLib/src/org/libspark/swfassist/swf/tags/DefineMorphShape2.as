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
	import org.libspark.swfassist.swf.structures.Rect;
	
	public class DefineMorphShape2 extends DefineMorphShape
	{
		public function DefineMorphShape2(code:uint = 0)
		{
			super(code != 0 ? code : TagCodeConstants.TAG_DEFINE_MORPH_SHAPE2);
		}
		
		private var _startEdgeBounds:Rect = new Rect();
		private var _endEdgeBounds:Rect = new Rect();
		private var _useNonScalingStrokes:Boolean = false;
		private var _useScalingStrokes:Boolean = false;
		
		public function get startEdgeBounds():Rect
		{
			return _startEdgeBounds;
		}
		
		public function set startEdgeBounds(value:Rect):void
		{
			_startEdgeBounds = value;
		}
		
		public function get endEdgeBounds():Rect
		{
			return _endEdgeBounds;
		}
		
		public function set endEdgeBounds(value:Rect):void
		{
			_endEdgeBounds = value;
		}
		
		public function get useNonScalingStrokes():Boolean
		{
			return _useNonScalingStrokes;
		}
		
		public function set useNonScalingStrokes(value:Boolean):void
		{
			_useNonScalingStrokes = value;
		}
		
		public function get useScalingStrokes():Boolean
		{
			return _useScalingStrokes;
		}
		
		public function set useScalingStrokes(value:Boolean):void
		{
			_useScalingStrokes = value;
		}
		
		public override function visit(visitor:TagVisitor):void
		{
			visitor.visitDefineMorphShape2(this);
		}
	}
}