package com.ui {
	
	/**
	 * 基本UI
	 * @author taojianlong 2014-4-7 1:00
	 */
	public class BaseUI extends UIContainer {
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		public function BaseUI(file:*, width:Number = 0, height:Number = 0, back:uint = 0x000000, backAlpha:Number = 0.5) {
			
			_width = width;
			_height = height;
			
			super(file);
			
			if (width > 0 && height > 0) {
				
				this.drawRect(width, height, back, backAlpha);
			}
		}
		
		override public function get width():Number {
			
			return _width;
		}
		
		override public function get height():Number {
			
			return _height;
		}
		
		override protected function createComplete(event:UIEvent):void {
			
			super.createComplete(event);
		}
	}

}