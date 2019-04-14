package com.ui.xml {
	import com.ui.componet.base.ItemBase;
	import com.ui.componet.TextInput;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	/**
	 * XML属性条目
	 * @author taojianlong 2014-4-12 19:17
	 */
	public class XMLAttrItem extends ItemBase {
		
		private var _target:IXMLItem; //操作的IXMLItem条目对象
		
		private var namTxt:TextInput;
		private var attTxt:TextInput;
		
		public function XMLAttrItem() {
			
			super( 100 , 20 , 0 , 0.8 );
			
			namTxt = new TextInput();
			namTxt.width = 50;
			namTxt.x = 0;
			namTxt.border = false;
			namTxt.color = 0xff0000;
			namTxt.verticalCenter = 0;
			namTxt.focusEnabled = false;
			
			attTxt = new TextInput();
			attTxt.width = 50;
			attTxt.x = namTxt.x + namTxt.width;
			attTxt.border = false;
			attTxt.color = 0x00ff00;
			attTxt.verticalCenter = 0;
			
			this.addChild(namTxt);
			this.addChild(attTxt);
			
			namTxt.addEventListener(FocusEvent.FOCUS_IN, foucsHandler);
			namTxt.addEventListener(FocusEvent.FOCUS_OUT, foucsHandler);
			attTxt.addEventListener(FocusEvent.FOCUS_IN, foucsHandler);
			attTxt.addEventListener(FocusEvent.FOCUS_OUT, foucsHandler);
			
			this.showBorder( 0x804040 , false );
		}
		
		public function set target( value:IXMLItem ):void {
			
			_target = value;
		}
		
		public function get target():IXMLItem {
			
			return _target;
		}
		
		private function foucsHandler(event:FocusEvent):void {
			
			var target:* = event.target;
			if (target == namTxt) {
				if (event.type == FocusEvent.FOCUS_IN) {
					namTxt.border = true;
					namTxt.borderColor = 0xffffff;
				} else if (event.type == FocusEvent.FOCUS_OUT) {
					namTxt.border = false;
				}
			} else if (target == attTxt) {
				if (event.type == FocusEvent.FOCUS_IN) {
					attTxt.border = true;
					attTxt.borderColor = 0xffffff;
				} else if (event.type == FocusEvent.FOCUS_OUT) {
					attTxt.border = false;
					_target.setXMLValue( this.prop , this.value );
				}
			}
		}
		
		public function set prop(value:String):void {
			
			namTxt.text = value;
		}
		
		public function get prop():String {
			
			return namTxt.text;
		}
		
		public function set value(val:String):void {
			
			attTxt.text = val;
		}
		
		public function get value():String {
			
			return attTxt.text;
		}
		
		/**
		 * 属性字符串 prop='value'
		 */
		public function toAttrString():String {
			
			return this.prop + "='" + this.value + "'";
		}
		
		override public function clear():void {
			
			super.clear();
			
			namTxt.text = "";
			attTxt.text = "";
			_target = null;
		}
	}

}