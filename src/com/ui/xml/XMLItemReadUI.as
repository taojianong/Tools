package com.ui.xml {
	import com.manager.UIManager;
	import com.pool.ObjectPool;
	import com.ui.BaseUI;
	import com.ui.componet.Button;
	import com.ui.componet.Container;
	import com.ui.componet.Label;
	import com.ui.componet.TextInput;
	import com.ui.UIEvent;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	/**
	 * XML数据读取界面
	 * @author taojianlong 2014-4-7 23:04
	 */
	public class XMLItemReadUI extends BaseUI {
		
		private var uiXml:XML =   <data>
				<TextInput id="titTxt" width="800" height="20" border="false" focusEnabled="false" color="#00ff00" algin="center" />
				<Container id="cont" x="50" y="50" />
				<Button id="closeBtn" x="730" y="5" label="" outSourceClass="common|close_out" overSourceClass="common|close_over" downSourceClass="common|close_down" />
			</data>
		
		private var titTxt:TextInput;
		private var cont:Container;
		
		private var _xmlItem:IXMLItem;
		
		public function XMLItemReadUI() {
			
			super(uiXml, 800, 600);
		}
		
		override protected function createComplete(event:UIEvent):void {
			
			super.createComplete(event);
			
			cont = this.getElementById("cont");
			titTxt = this.getElementById("titTxt");
			
			titTxt.addEventListener( FocusEvent.FOCUS_IN , focusHandler );
			titTxt.addEventListener( FocusEvent.FOCUS_OUT , focusHandler );
		}
		
		private function focusHandler( event:FocusEvent ):void {
			
			var target:* = event.target;
			
			if ( target == titTxt ) {
				if ( event.type == FocusEvent.FOCUS_IN ) {
					titTxt.border = true;
					titTxt.borderColor = 0xffffff;
				}
				else if ( event.type == FocusEvent.FOCUS_OUT ) {
					titTxt.border = false;
				}
			}
		}
		
		public function set target(value:IXMLItem):void {
			
			_xmlItem = value;
			
			cont.removeAll( true );
			
			if (_xmlItem) {
				
				titTxt.text = _xmlItem.xml.name();
				titTxt.focusEnabled = false; //是否可输入名字
				
				var obj:Object;
				var xmlAttrItem:XMLAttrItem;
				var xGap:Number = 5;
				var yGap:Number = 1;
				for (var i:int = 0; i < _xmlItem.attributes.length; i++) {
					
					obj = _xmlItem.attributes[i];
					xmlAttrItem = ObjectPool.getObjectPool(XMLAttrItem).getObject() as XMLAttrItem;
					xmlAttrItem.clear();
					xmlAttrItem.prop = obj.prop;
					xmlAttrItem.value = obj.value;
					xmlAttrItem.x = int(i % 2) * (xmlAttrItem.width + xGap);
					xmlAttrItem.y = int(i / 2) * (xmlAttrItem.height + yGap);
					xmlAttrItem.target = _xmlItem					
					cont.addElement(xmlAttrItem);
				}				
			}
			else {
				titTxt.focusEnabled = true; //可输入名字
			}
		}		
		/**
		 * IXMLItem
		 */
		public function get target():IXMLItem {
			
			return _xmlItem;
		}
		
		public function get xml():XML {
			
			var xmlAttrItem:XMLAttrItem;
			var attrs:Array = [];
			for (var i:int = 0; i < _xmlItem.attributes.length; i++) {
				
				xmlAttrItem = cont.getChildAt(i) as XMLAttrItem;
				if ( xmlAttrItem ) {
					attrs.push( xmlAttrItem.toAttrString() );
				}
			}
			
			var xmlStr:String = "<" + titTxt.text + " " + attrs.join(" ") + " />";			
			
			return this.canInputXMLName ? XML( xmlStr ) : _xmlItem.xml;
		}
		
		/**
		 * 是否可输入XML节点name
		 * @return
		 */
		public function get canInputXMLName():Boolean {
			
			return titTxt.focusEnabled;
		}
		
		override protected function clickHandler(event:MouseEvent):void {
			
			super.clickHandler(event);
			
			var target:* = event.target;
			
			clickBtn( target as Button );
		}
		
		private function clickBtn( btn:Button ):void {
			
			switch( btn && btn.id ) {
				
				case "closeBtn":
					UIManager.Instance.closeXMLItemReadUI();
					break;
				
			}
		}
		
		override public function clear():void {
			
			super.clear();
			
			_xmlItem = null;
			
			titTxt.text = "";
			titTxt
		}
	}
}