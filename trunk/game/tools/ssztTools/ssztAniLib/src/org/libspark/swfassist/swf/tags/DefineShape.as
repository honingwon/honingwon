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
	import org.libspark.swfassist.swf.structures.ShapeWithStyle;
	
	public class DefineShape extends AbstractTag
	{
		public function DefineShape(code:uint = 0)
		{
			super(code != 0 ? code : TagCodeConstants.TAG_DEFINE_SHAPE);
		}
		
		private var _shapeId:uint = 0;
		private var _shapeBounds:Rect = new Rect();
		private var _shapes:ShapeWithStyle = new ShapeWithStyle();
		
		public function get shapeId():uint
		{
			return _shapeId;
		}
		
		public function set shapeId(value:uint):void
		{
			_shapeId = value;
		}
		
		public function get shapeBounds():Rect
		{
			return _shapeBounds;
		}
		
		public function set shapeBounds(value:Rect):void
		{
			_shapeBounds = value;
		}
		
		public function get shapes():ShapeWithStyle
		{
			return _shapes;
		}
		
		public function set shapes(value:ShapeWithStyle):void
		{
			_shapes = value;
		}
		
		public override function visit(visitor:TagVisitor):void
		{
			visitor.visitDefineShape(this);
		}
	}
}