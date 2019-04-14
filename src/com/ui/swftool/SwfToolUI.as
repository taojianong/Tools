package com.ui.swftool {
	
	import com.file.FileData;
	import com.manager.FileManager;
	import com.manager.UIManager;
	import com.ui.BaseUI;
	import com.ui.componet.Button;
	import com.ui.item.FileItem;
	import com.ui.plate.FilePlate;
	import com.ui.UIEvent;
	import flash.events.MouseEvent;
	
	/**
	 * 主界面 
	 * @author taojianlong 2013-12-15 23:22
	 */
	public class SwfToolUI extends BaseUI {
		
		private var xml:XML = <data>
			<Button id="openSwf" label="打开SWF" x="300" y="500" />
			<Button id="save" label="保存SWF" x="400" y="500" />
			<Button id="mOpen" label="批量打开" x="500" y="500"  />
			<Button id="closeBtn" x="730" y="5" label="" outSourceClass="common|close_out" overSourceClass="common|close_over" downSourceClass="common|close_down" />
		</data>
		
		public var filePlate:FilePlate;
		
		public function SwfToolUI() {
			
			super( xml , 800 , 600 );
		}
		
		override protected function createComplete(event:UIEvent):void {
			
			super.createComplete(event);
			
			filePlate = new FilePlate;
			filePlate.x = (800 - filePlate.width) / 2;
			filePlate.y = 50;
			this.addChild(filePlate);
		}
		
		override protected function clickHandler(event:MouseEvent):void {
			super.clickHandler(event);
			var btn:Button = event.target as Button;
			var fileItem:FileItem = event.target as FileItem;
			var filePlate:FilePlate = event.target as FilePlate;
			clickButton(btn);
			clickFileItem(fileItem);
			if (filePlate) {
				filePlate.hideBigImage();
			}
		}
		
		private function clickButton(btn:Button):void {
			
			if (btn == null)
				return;
			switch (btn.id) {
				
				//打开SWF文件
				case "openSwf":
					FileManager.Instance.openSwf( showSwfSource );
					break;
					
				//保存swf文件
				case "save": 
					FileManager.Instance.saveSwf();
					break;
					
				//打开多个文件
				case "mOpen": 
					FileManager.Instance.openMultiFile(["jpg", "png"]);
					break;
					
				case "closeBtn":
					UIManager.Instance.closeSwfToolUI();
					break;
			}
		}
		
		/**
		 * 显示SWF中图片资源
		 * @param	arr
		 */
		private function showSwfSource( arr:Array ):void {
			
			if (arr == null) return;
			
			var list:Array = [];
			var fileData:FileData;
			for ( var i:int = 0; i < arr.length;i++ ) {
				fileData = new FileData( null , false );
				fileData.data = arr[i];
				fileData.linkName = fileData.data.name;
				list.push( fileData );
			}
			
			filePlate.fileItemList = list;
		}
		
		private function clickFileItem(fileItem:FileItem):void {
			
			if (fileItem == null)
				return;
			//var bmp:Bitmap = fileItem.fileData.data as Bitmap;
			filePlate.showBigImage(fileItem);
		}
	}
}