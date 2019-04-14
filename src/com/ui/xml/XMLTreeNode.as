package com.ui.xml {
	import com.pool.ObjectPool;
	import com.ui.componet.item.TreeItem;
	import com.ui.componet.item.TreeNode;
	import com.ui.componet.Label;
	import flash.display.DisplayObject;
	
	/**
	 * XML树节点
	 * @author taojianlong 2014-4-7 14:39
	 */
	public class XMLTreeNode extends TreeNode implements IXMLItem {
		
		private var txtLab:Label;
		
		private var _xml:XML; //当前节点XML数据
		
		private var attrs:Array = [];
		
		public function XMLTreeNode() {
			
			super(700, 20, 0xcccccc, 0.5);
		}
		
		override protected function init():void {
			
			txtLab = new Label();
			txtLab.height = 20;
			txtLab.color = 0xFF8040;
			//txtLab.showBorder( 0x00ff00 );			
			this.addChild(txtLab);
			
			super.init();
			
			lab.width = 100;
			txtLab.x = lab.x + lab.width;
			txtLab.width = this.width - lab.width - indLab.width - lab.x;
		
			//this.toolTipClass = 
		}
		
		override public function set width(value:Number):void {
			
			super.width = value;
			
			txtLab.width = this.width - lab.width - indLab.width - lab.x;
		}
		
		override public function addTreeItem(treeItem:TreeItem):void {
			
			super.addTreeItem(treeItem);
		}
		
		override public function removeTreeItem(treeItem:TreeItem):void {
			
			super.removeTreeItem(treeItem);			
		}
		
		/**
		 * 从1开始
		 * @param	iXmlItem
		 * @return
		 */
		public function getIndex( iXmlItem:IXMLItem ):int {
			
			return container.getChildIndex( iXmlItem as DisplayObject );
		}
		
		override public function get data():Object {
			
			return super.data;
		}
		
		override public function set data(value:Object):void {
			
			super.data = value;
			
			this.xml = XML(value);
			
			if (_xml.children().length() > 0) {
				addXMLNodes(_xml);
			}
		}
		
		/**
		 * 递归添加XML节点函数
		 * @param	xml
		 * @param	xmlTreeNode 默认
		 */
		private function addXMLNodes(xml:XML, xmlTreeNode:XMLTreeNode = null):void {
			
			if (xml) {
				var xmlList:XMLList = xml.children();
				if (xmlList.length() > 0) {
					
					var x:XML;
					for (var i:int = 0; i < xmlList.length(); i++) {
						x = xmlList[i];
						if (x == null) {
							continue;
						}
						if (x.children().length() > 0) {
							var xtn:XMLTreeNode = ObjectPool.getObjectPool(XMLTreeNode).getObject() as XMLTreeNode;
							xtn.xml = x;
							if (xmlTreeNode == null) {
								this.addTreeNode(xtn);
							} else {
								xmlTreeNode.addTreeNode(xtn);
							}
							addXMLNodes(x, xtn);
						} else {
							addXMLNodes(x, xmlTreeNode);
						}
					}
				} else {
					
					var xmlTreeItem:XMLTreeItem = ObjectPool.getObjectPool(XMLTreeItem).getObject() as XMLTreeItem;
					xmlTreeItem.data = xml;
					
					if (xmlTreeNode == null) {
						this.addTreeItem(xmlTreeItem);
					} else {
						xmlTreeNode.addTreeItem(xmlTreeItem);
					}
				}
			}
		}
		
		//------------------------------------------------------
		
		public function set xml(xml:XML):void {
			
			_xml = xml;
			
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
		
		/**
		 * 节点XML信息
		 */
		public function get xml():XML {
			
			return _xml;
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
			
			//updateXML();
			
			updateParentNodeXML();
		}
		
		private function updateXML():void {
			
			tipRect.toolTip = _xml ? _xml.toXMLString() : null;
			this.lab.text = _xml ? _xml.name() : null;
			this.txtLab.text = getAttrString(_xml);
		}
		
		//更新父节点XML
		public function updateParentNodeXML():void {			
			
			updateXML();
			
			if ( this.parentTreeNode ) {
				
				var index:int = XMLTreeNode( this.parentTreeNode ).getIndex( this );
				
				XMLTreeNode( this.parentTreeNode ).updateNodeXMLAt( index , this.xml );
			}
			
			if ( this.parentTree && this.parentTreeNode == null ) {
				XMLTree( this.parentTree ).updateXML();
				return;
			}			
		}
		
		/**
		 * 更新子节点XML数据
		 * @param index 子节点索引
		 * @param xml   更新的XML数据
		 */
		public function updateNodeXMLAt( index:int , xml:XML ):void {
			
			//var xml:XML   = XMLTreeNode( this.parentTreeNode ).xml;
			var xmlList:XMLList = this.xml.children();
			for ( var i:int = 0; i < xmlList.length();i++ ) {
				var x:XML = xmlList[i];
				if ( i == ( index - 1 ) ) {
					xmlList[i] = xml;
					//tipRect.toolTip = this.xml ? this.xml.toXMLString() : null;
					updateXML();
					break;
				}
			}
			
			/*if ( this.parentTreeNode != null ) {
				
				var ind:int = this.getIndex( this );
				
				XMLTreeNode( this.parentTreeNode ).updateNodeXMLAt( ind , this.xml );
			}*/
			
			updateParentNodeXML(); //更新父节点数据
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
		
		//------------------------------------------------------
	
	}

}