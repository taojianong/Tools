package com.ui.xml {
	import com.ui.componet.item.TreeItem;
	import com.ui.componet.Label;
	import com.util.DMap;
	
	/**
	 * XML树节点条目
	 * @author taojianlong 2014-4-7 16:31
	 */
	public class XMLTreeItem extends TreeItem implements IXMLItem {
		
		private var namLab:Label;
		private var lab:Label; //显示文本
		
		private var _xml:XML; //当前读取XML信息
		
		private var attrs:Array = [];
		
		public function XMLTreeItem() {
			
			super(700, 20);
			
			namLab = new Label();
			namLab.width = 100;
			
			lab = new Label();
			lab.width = this.width - namLab.width;
			lab.height = 20;
			lab.color = 0xFF8040;
			//lab.showBorder();
			lab.x = namLab.width;
			
			this.addElement(namLab);
			this.addElement(lab);
			
			this.mouseChildren = false;
		}
		
		override public function get data():Object {
			
			return super.data;
		}
		
		override public function set data(value:Object):void {
			
			super.data = value;
			
			this.xml = XML(value);
		}
		
		//----------------------------------
		
		public function set xml(value:XML):void {
			
			_xml = value;
			
			if (_xml) {
				var xl:XMLList = _xml.attributes();
				if (xl) {
					var x:XML;
					for (var i:int = 0; i < xl.length(); i++) {
						x = xl[i];
						if (x) {
							var o:Object = {prop: x.name(), value: x.toXMLString()};
							attrs.push(o);
						}
					}
				}
			} else {
				attrs = [];
			}
			
			updateXML();		
		}
		
		public function get xml():XML {
			
			return _xml;
		}
		
		private function updateXML():void {
			
			this.toolTip = _xml ? _xml.toXMLString() : null;
			namLab.text = _xml ? _xml.name() : "";
			lab.text = getAttrString(_xml);
		}
		
		private function getAttrString(xml:XML):String {
			if (xml) {
				var list:Array = [];
				var str:String = "";
				var xl:XMLList = xml.attributes();
				if (xl) {
					var x:XML;
					for (var i:int = 0; i < xl.length(); i++) {
						x = xl[i];
						if (x) {
							str = x.name() + "='" + x.toXMLString() + "'";
							list.push(str);
						}
					}
				}
				str = list.join(" ");
				return str;
			} else {
				return "";
			}
		}
		
		public function setXMLValue( prop:String , value:String ):void {
			
			for each( var o:Object in attrs ) {
				if ( o.prop == prop ) {
					o.value = value;
				}
			}
			
			var xmlList:XMLList = this.xml.attribute( prop );
			if ( xmlList && xmlList.length() > 0 ) {
				xmlList[0] = value;
			}
			
			updateXML();
			
			updateParentNodeXML();
		}
		
		//更新父节点XML
		private function updateParentNodeXML():void {			
			
			if ( this.parentTreeNode == null ) {
				return;
			}
			
			var index:int = XMLTreeNode( this.parentTreeNode ).getIndex( this );
			XMLTreeNode( this.parentTreeNode ).updateNodeXMLAt( index , this.xml );
			/*var xml:XML   = XMLTreeNode( this.parentTreeNode ).xml;
			var xmlList:XMLList = xml.children();
			for ( var i:int = 0; i < xmlList.length();i++ ) {
				var x:XML = xmlList[i];
				if ( i == ( index - 1 ) ) {
					xmlList[i] = this.xml;
					this.parentTreeNode.update();
					break;
				}
			}*/
		}
		
		public function getXMLValueOf( prop:String ):String {
			
			for each( var o:Object in attrs ) {
				if ( o.prop == prop ) {
					return o.value;
				}
			}			
			return null;
		}
		
		public function get attrCount():int {
			
			return attrs.length;
		}
		
		public function get attributes():Array {
			
			return attrs;
		}
		
		override public function clear():void {
			
			super.clear();
			
			_xml = null;
			
			attrs = [];
		}
	}

}