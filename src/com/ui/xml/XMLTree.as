package com.ui.xml {
	
	import com.manager.FileManager;
	import com.manager.TopManager;
	import com.manager.UIManager;
	import com.pool.ObjectPool;
	import com.ui.componet.item.TreeItem;
	import com.ui.componet.item.TreeNode;
	import com.ui.componet.Tree;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	
	/**
	 * XML树
	 * @author taojianlong 2014-4-7 14:32
	 */
	public class XMLTree extends Tree {
		
		protected var modifyItem:NativeMenuItem = new NativeMenuItem("modify"); //修改节点
		protected var saveItem:NativeMenuItem = new NativeMenuItem("save"); //保存XML节点
		
		//private var mainTreeNode:XMLTreeNode;
		
		private var _xmlList:Array = [];//XML文件列表数
		
		public function XMLTree() {
			
			super(700, 400, 0, 0.5);
		}
		
		override protected function initTree():void {
			
			super.initTree();
			
			this.itemRenderer = XMLTreeNode;
		}
		
		//-------------------------右键-----------------------
		
		override protected function rightClickTreeNode(treeNode:TreeNode):void {
			
			if (treeNode == null)
				return;
			
			App.nativeMenu.addItem(addNode);
			App.nativeMenu.addItem(addItem);
			App.nativeMenu.addItem(modifyItem);
			App.nativeMenu.addItem(saveItem);		
			App.nativeMenu.addItem(deleteItem);
		}
		
		override protected function rightClickTreeItem(treeItem:TreeItem):void {
			
			if (treeItem == null)
				return;
			
			App.nativeMenu.addItem(modifyItem);
			App.nativeMenu.addItem(saveItem);
			App.nativeMenu.addItem(deleteItem);
		}
		
		public function addToXMLList( xml:XML ):void {
			
			if ( xml == null ) {
				return;
			}
			
			var mainTreeNode:XMLTreeNode = new XMLTreeNode();
			mainTreeNode.id = "mainTreeNode_" + this.xmlTreeNodes;
			mainTreeNode.parentTree = this;
			mainTreeNode.parentTreeNode = null;
			mainTreeNode.data = xml;
			this.addTreeNode(mainTreeNode);
			
			_xmlList.push( xml );
		}
		
		public function get xmlList():Array {
		
			return _xmlList;
		}
		
		/*private var _xml:XML = null; //XML配置文件		
		public function set xml(value:XML):void {
			
			_xml = value;
			trace("" + _xml);
			clear();
			this.clearNodes();
			
			var mainTreeNode:XMLTreeNode = new XMLTreeNode();
			mainTreeNode.id = "mainTreeNode_" + this.xmlTreeNodes;
			mainTreeNode.parentTree = this;
			mainTreeNode.parentTreeNode = null;
			mainTreeNode.data = _xml;
			this.addTreeNode(mainTreeNode);
		}
		public function get xml():XML {
			
			return _xml;
		}*/
		
		/**
		 * XML树节点数
		 */
		public function get xmlTreeNodes():int {
			
			var j:int = 0;
			for (var i:int = 0; i < this.numChildren; i++) {
				var target:* = this.getChildAt(i);
				if (target is XMLTreeNode) {
					j++;
				}
			}
			return j;
		}
		
		public function updateXML():void {
			
			//var xmlList:XMLList = _xml.children();
			var treeNode:TreeNode;			
			for (var i:int = 1; i < container.numChildren; i++) {
				treeNode = container.getChildAt(i) as TreeNode;				
			}			
			//trace("" + _xml);
		}
		
		/**
		 * 点击右键菜单条目
		 * @param	event
		 */
		override protected function handleMenuClick(event:Event):void {
			
			var nativeMenuItem:NativeMenuItem = event.target as NativeMenuItem;
			switch (nativeMenuItem && nativeMenuItem.label) {
				
				case "delete": 
					if (rightTreeItem) {
						
						if (rightTreeItem.parent.parent is TreeNode) {
							
							TreeNode(rightTreeItem.parent.parent).removeTreeItem(rightTreeItem);
						}
					} else if (rightTreeNode) {
						if (rightTreeNode.parent.parent is XMLTree) {
							XMLTree(rightTreeNode.parent.parent).removeTreeNode(rightTreeNode);
						} else if (rightTreeNode.parent.parent is TreeNode) {
							TreeNode(rightTreeNode.parent.parent).removeTreeNode(rightTreeNode);
						}
					}
					rightTreeNode = null;
					rightTreeItem = null;
					break;
				
				//添加TreeNode条目
				case "add node": 
					if (rightTree) {
						rightTree.addTreeNode(ObjectPool.getObjectPool(itemRenderer).getObject() as TreeNode);
					} else if (rightTreeNode) {
						rightTreeNode.addTreeNode(ObjectPool.getObjectPool(itemRenderer).getObject() as TreeNode);
					}
					break;
				
				//添加TreeItem条目
				case "add item": 
					if (rightTreeNode) {
						rightTreeNode.addTreeItem(ObjectPool.getObjectPool(XMLTreeItem).getObject() as XMLTreeItem);
					}
					break;
				
				//修改	
				case "modify": 
					if (rightTreeItem) {
						UIManager.Instance.openXMLItemReadUI(rightTreeItem as IXMLItem);
					} else if (rightTreeNode) {
						UIManager.Instance.openXMLItemReadUI(rightTreeNode as IXMLItem);
					}
					break;
					
				case "save":
					if (rightTreeItem) {
						FileManager.Instance.openFileAndSaveXML( XMLTreeItem(rightTreeItem).xml , saveXML );
					} else if (rightTreeNode) {
						FileManager.Instance.openFileAndSaveXML( XMLTreeNode(rightTreeNode).xml , saveXML );
					}					
					break;
			}
		}
		
		private function saveXML():void {			
			
			TopManager.Instance.showInfo("保存XML成功.");
		}
		
		override public function clearNodes():void {
			
			while ( _xmlList && _xmlList.length > 0 )  {
				_xmlList.shift();
			}
			
			super.clearNodes();
		}
		
		override public function clear():void {
			
			super.clear();
			
			this.clearNodes();
		
			//this.removeTreeNode(mainTreeNode);
		
			//mainTreeNode = null;
		}
	}

}