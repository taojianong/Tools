package com.ui.item {
	import com.ui.componet.item.ItemRenderer;
	import com.ui.componet.Label;
	import flash.events.MouseEvent;
	
	/**
	 * 工具列表条目
	 * @author taojianlong 2014-2-23 19:42
	 */
	public class ToolItem extends ItemRenderer {
		
		private var lab:Label;
		
		public function ToolItem() {
			
			super(200, 30,0xff0000,0.5);
			
			lab = new Label();
			lab.width = 200;
			lab.y = 5;
			
			this.addChild(lab);
			this.addEventListener( MouseEvent.MOUSE_OVER , mouseHandler );
			this.addEventListener( MouseEvent.MOUSE_OUT , mouseHandler );
			this.addEventListener( MouseEvent.MOUSE_DOWN , mouseHandler );
			this.addEventListener( MouseEvent.MOUSE_UP , mouseHandler );
		}
		
		private function mouseHandler( event:MouseEvent ):void {	
			
			if ( event.type == MouseEvent.MOUSE_OVER ) {
				this.isOver = true;
			}
			else if ( event.type == MouseEvent.MOUSE_DOWN ) {
				this.isDown = true;
			}
			else {
				this.drawRect( _width , _height , _backColor , _backAlpha );
			}			
		}
		
		private function set isOver( value:Boolean ):void {
			
			if ( value ) {
				this.drawRect( _width , _height , 0x00ff00 , _backAlpha );
			}
			else {
				this.drawRect( _width , _height , _backColor , _backAlpha );
			}			
		}
		
		private function set isDown( value:Boolean ):void {
			
			if ( value ) {
				this.drawRect( _width , _height , 0x0000ff , _backAlpha );
			}
			else {
				this.drawRect( _width , _height , _backColor , _backAlpha );
			}			
		}
		
		override public function get data():Object {
			
			return super.data;
		}
		
		override public function set data(value:Object):void {
			
			super.data = value;
			
			if ( _data ) {
				this.label = _data.label;
			}			
		}
		
		public function set label(text:String):void {
			
			lab.text = text;
		}
		
		public function get label():String {
			
			return lab.text;
		}
	}

}