package com.ui.xml {
	
	import com.manager.FileManager;
	import com.manager.TopManager;
	import com.manager.UIManager;
	import com.ui.BaseUI;
	import com.ui.componet.Button;
	import com.ui.componet.Container;
	import com.ui.UIEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * XML解析器
	 * @author taojianlong 2014-4-6 20:55
	 */
	public class XMLParserUI extends BaseUI {
		
		private var xml:XML = <data>
				<Button id="readXML" x="300" y="500" label="读取XML" outSourceClass="common|blue_btn_out" overSourceClass="common|blue_btn_over" downSourceClass="common|blue_btn_down" />
				<Button id="saveXML" x="400" y="500" label="保存XML" outSourceClass="common|blue_btn_out" overSourceClass="common|blue_btn_over" downSourceClass="common|blue_btn_down" />
				<Button id="clearBtn" x="500" y="500" label="清空树" outSourceClass="common|blue_btn_out" overSourceClass="common|blue_btn_over" downSourceClass="common|blue_btn_down" />
				<Button id="closeBtn" x="730" y="5" label="" outSourceClass="common|close_out" overSourceClass="common|close_over" downSourceClass="common|close_down" />
			</data>
			
		private var cont:Container;
		private var xmlTree:XMLTree;
		
		//private var _xml:XML;//当前读取的XML文件
		
		public function XMLParserUI() {
			
			super(xml, 800, 600, 0x808080 , 0.8);
		}
		
		override protected function createComplete(event:UIEvent):void {
			
			super.createComplete(event);
			
			cont = this.getElementById("cont");
			
			initUI();
		}
		
		private function initUI():void {
			
			xmlTree   = new XMLTree();
			xmlTree.x = 50;
			xmlTree.y = 100;
			
			this.addElement( xmlTree );
		}
		
		override protected function addToStageHandler(event:Event):void {
			
			super.addToStageHandler(event);
		}
		
		override protected function removeFromStageHandler(event:Event):void {
			
			super.removeFromStageHandler(event);
		}
		
		override protected function clickHandler(event:MouseEvent):void {
			
			super.clickHandler( event );
			
			var btn:Button = event.target as Button;
			
			clickBtn( btn );
		}
		
		private function clickBtn( btn:Button ):void {
			
			switch (btn && btn.id) {
				
				//关闭界面
				case "closeBtn": 
					UIManager.Instance.closeXMLParserUI();
					break;
				
				//读取XML
				case "readXML": 
					FileManager.Instance.openXMLFile( readXML );
					break;
				
				//保存XML
				case "saveXML":
					//FileManager.Instance.openFileAndSaveXML( _xml , saveXML );
					break;
					
				//清空树
				case "clearBtn":
					xmlTree.clearNodes();
					break;
			}
		}		
		
		private function readXML( xml:XML = null ):void {
			
			xmlTree.addToXMLList( xml );
		}
		
		private function saveXML():void {			
			
			TopManager.Instance.showInfo("保存XML成功.");
		}
	}
}