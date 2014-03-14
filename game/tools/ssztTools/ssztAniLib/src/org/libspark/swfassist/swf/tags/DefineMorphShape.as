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
	import org.libspark.swfassist.swf.structures.MorphFillStyleArray;
	import org.libspark.swfassist.swf.structures.MorphLineStyles;
	import org.libspark.swfassist.swf.structures.Shape;
	
	public class DefineMorphShape extends AbstractTag
	{
		public function DefineMorphShape(code:uint = 0)
		{
			super(code != 0 ? code : TagCodeConstants.TAG_DEFINE_MORPH_SHAPE);
		}
		
		private var _characterId:uint = 0;
		private var _startBounds:Rect = new Rect();
		private var _endBounds:Rect = new Rect();
		private var _morphFillStyles:MorphFillStyleArray = new MorphFillStyleArray();
		private var _morphLineStyles:MorphLineStyles = new MorphLineStyles();
		private var _startEdges:Shape = new Shape();
		private var _endEdges:Shape = new Shape();
		
		public function get characterId():uint
		{
			return _characterId;
		}
		
		public function set characterId(value:uint):void
		{
			_characterId = value;
		}
		
		public function get startBounds():Rect
		{
			return _startBounds;
		}
		
		public function set startBounds(value:Rect):void
		{
			_startBounds = value;
		}
		
		public function get endBounds():Rect
		{
			return _endBounds;
		}
		
		public function set endBounds(value:Rect):void
		{
			_endBounds = value;
		}
		
		public function get morphFillStyles():MorphFillStyleArray
		{
			return _morphFillStyles;
		}
		
		public function set morphFillStyles(value:MorphFillStyleArray):void
		{
			_morphFillStyles = value;
		}
		
		public function get morphLineStyles():MorphLineStyles
		{
			return _morphLineStyles;
		}
		
		public function set morphLineStyles(value:MorphLineStyles):void
		{
			_morphLineStyles = value;
		}
		
		public function get startEdges():Shape
		{
			return _startEdges;
		}
		
		public function set startEdges(value:Shape):void
		{
			_startEdges = value;
		}
		
		public function get endEdges():Shape
		{
			return _endEdges;
		}
		
		public function set endEdges(value:Shape):void
		{
			_endEdges = value;
		}
		
		public override function visit(visitor:TagVisitor):void
		{
			visitor.visitDefineMorphShape(this);
		}
	}
}