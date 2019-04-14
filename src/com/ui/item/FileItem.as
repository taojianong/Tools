package com.ui.item {
	
	import com.file.FileData;
	import com.ui.componet.base.ItemBase;
	import com.ui.componet.Image;
	import com.ui.componet.TextInput;
	import com.ui.plate.FilePlate;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.geom.Matrix;
	import flash.text.TextFormatAlign;
	
	/**
	 * 图片显示条目 2013-3-31 17:59
	 * 设计显示对应图片，可以设置图片链接名
	 * @author taojianlong
	 */
	public class FileItem extends ItemBase {
		
		private var _fileDara:FileData;
		private var _isLock:Boolean = false;
		
		private var img:Image;
		private var linkTxt:TextInput; //链接名
		private var qulaTxt:TextInput; //质量		
		
		public function FileItem(width:Number = 80, height:Number = 80) {
			
			super(width, height);
			
			img = new Image;
			
			linkTxt = new TextInput;
			linkTxt.width = 55;
			linkTxt.algin = TextFormatAlign.CENTER;
			linkTxt.y = 55;
			linkTxt.maxChars = 10;
			//linkTxt.text = "link_name";
			linkTxt.addEventListener(Event.CHANGE, changeHandler);
			linkTxt.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			linkTxt.id = "linkTxt";
			
			qulaTxt = new TextInput;
			qulaTxt.width = 25;
			qulaTxt.algin = TextFormatAlign.CENTER;
			qulaTxt.x = 55;
			qulaTxt.y = 55;
			qulaTxt.restrict = "0-9";
			qulaTxt.maxChars = 3;
			qulaTxt.text = "100";
			qulaTxt.id = "qulaTxt";
			
			this.addChild(img);
			this.addChild(linkTxt);
			this.addChild(qulaTxt);
		}
		
		private function focusOutHandler(event:FocusEvent):void {
			
			if (FilePlate.linkArr.indexOf(linkTxt.text) != -1) {
				
				linkTxt.text = this.id;
				_fileDara.linkName = this.id;
				//throw("已有相同的链接名");
			}
		}
		
		private function changeHandler(event:Event):void {
			
			var txt:TextInput = event.target as TextInput;
			switch (txt && txt.id) {
				case "linkTxt": 
					if (_fileDara)
						_fileDara.linkName = linkTxt.text;
					break;
				case "qulaTxt": 
					if (_fileDara)
						_fileDara.quality = qulaTxt.text;
					break;
			}
		}
		
		override protected function addToStageHandler(event:Event):void {
			
			super.addToStageHandler(event);
			
			linkTxt.text = this.id;
			_fileDara.linkName = this.id;
			FilePlate.linkArr.push(linkTxt.text);
		}
		
		public function set fileData(value:FileData):void {
			
			_fileDara = value;
			if (_fileDara) {
				fillFileBitmap(_fileDara.data);
				linkTxt.text = this.id;
				_fileDara.linkName = this.linkTxt.text;
				_fileDara.quality = this.qulaTxt.text;
			}
			this.isLock = _fileDara == null;
		}
		
		public function get fileData():FileData {
			
			return _fileDara;
		}
		
		public function set isLock(value:Boolean):void {
			
			_isLock = value;
			
			this.mouseChildren = !value;
			this.mouseEnabled = !value;
		}
		
		/**
		 * 是否锁定
		 */
		public function get isLock():Boolean {
			
			return _isLock;
		}
		
		public function fillFileBitmap(bitmap:*):void {
			
			if (bitmap && (bitmap is Bitmap || bitmap is BitmapData)) {
				
				var bmpInitWidth:Number = bitmap is Bitmap ? Bitmap( bitmap ).width : bitmap.width;
				var bmpInitHeight:Number = bitmap is Bitmap ? Bitmap( bitmap ).height : bitmap.height;
				var scrollX:Number = 50 / bmpInitWidth ;
				var scrollY:Number = 40 / bmpInitHeight ;
				var bmpWidth:Number = bitmap is Bitmap ? Bitmap( bitmap ).width * scrollX  : bitmap.width * scrollX;
				var bmpHeight:Number = bitmap is Bitmap ? Bitmap( bitmap ).width * scrollY  : bitmap.width * scrollY;
				
				var bmd:BitmapData = new BitmapData( bmpWidth , bmpHeight );
				var matrix:Matrix = new Matrix;
				matrix.scale( scrollX , scrollY );
				bmd.draw( bitmap , matrix , null , null , null , false );				
				img.source = bmd;
				
				//img.source = bitmap;
				
				//var area:AutoFitArea = new AutoFitArea( this , 0 , 2 , _width , 40 , 0xCC0000 );
				//area.attach( img );
				//area.preview = true;
				
				//img.x = ( this.itemWidth - bmd.width ) / 2;
				//img.y = 2;// ( this.itemHeight - bmd.height ) / 2;
			}
		}
	}

}