package com.ui.plate {
	
	import com.file.FileData;
	import com.greensock.easing.Elastic;
	import com.greensock.layout.AutoFitArea;
	import com.greensock.TweenLite;
	import com.pool.ObjectPool;
	import com.ui.componet.base.BaseSprite;
	import com.ui.componet.Slider;
	import com.ui.item.FileItem;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 显示文件条目的模块
	 * @author taojianlong 2013-3-31 18:16
	 */
	public class FilePlate extends BaseSprite {
		
		public static const linkArr:Array = []; //用于检测是否有相同的链接名
		
		private const ROW:int = 4;
		private var _fileItemList:Array = [];
		private var _width:Number;
		private var _height:Number;
		
		private var fileItem:FileItem;
		private var container:BaseSprite;
		private var silder:Slider; //滚动条		
		
		private var _backColor:uint = 0;
		
		public function FilePlate(width:Number = 400, height:Number = 300, backColor:uint = 0xcccccc, backAlpha:Number = 0.5) {
			_width = width;
			_height = height;
			_backColor = backColor;
			super(_width, _height, backColor, backAlpha);
			
			container = new BaseSprite;
			container.drawRect(_width, _height, _backColor, 0);
			this.addChild(container);
			
			silder = new Slider();
			silder.offsetValue = 10;
			silder.height = _height;
			silder.visible = false;
			//silder.target = container;
			silder.x = _width - silder.width;
			this.addChild(silder);
		}
		
		override protected function addToStageHandler(event:Event):void {
			
			super.addToStageHandler(event);
			
			silder.target = container;
			silder.setMask( _width , _height , 0 , 0 );
		}
		
		public function get plateWidth():Number {
			
			return _width;
		}
		
		public function get plateHeight():Number {
			
			return _height;
		}
		
		public function set fileItemList(value:Array):void {
			
			_fileItemList = [];
			if (value == null || value.length == 0)
				return;
			
			silder.slipTo(0);
			container.graphics.clear();
			container.removeAll();
			var i:int;
			var fileData:FileData;
			value = value.sortOn("linkName");
			for (i = 0; i < value.length; i++) {
				
				fileData = value[i];
				
				fileItem = ObjectPool.getObjectPool(FileItem).getObject() as FileItem;
				fileItem.id = fileData ? fileData.linkName : "linkName_" + i;
				fileItem.fileData = fileData;
				fileItem.alpha = 0;
				fileItem.x = 20 + int(i % ROW) * (fileItem.width + 5);
				fileItem.y = 10 + int(i / ROW) * (fileItem.height + 5);
				_fileItemList.push(fileItem);
				
				container.addChild(fileItem);
			}
			fileItem = null;
			renderFileItem();
		}
		
		private var _mousePoint:Point = new Point;
		
		//获取当前鼠标点所在条目对应的点
		public function get mousePoint():Point {
			
			var i:int = 0;
			var rect:Rectangle = new Rectangle(0, 0, 80, 80);
			var px:Number = 0;
			var py:Number = 0;
			for (i = 0; i < 16; i++) {
				rect.x = 30 + int(i % ROW) * (rect.width + 5);
				rect.y = 10 + int(i / ROW) * (rect.height + 5);
				if (rect.contains(this.mouseX, this.mouseY)) {
					_mousePoint.x = rect.x;
					_mousePoint.y = rect.y;
					break;
				}
			}
			return _mousePoint;
		}
		
		private function renderFileItem():void {
			
			var renderItem:FileItem = _fileItemList.shift();
			if (renderItem) {
				renderItem.alpha = 0;
				TweenLite.to(renderItem, 1, {alpha: 1, ease: Elastic.easeOut, onUpdate: function():void {
					//trace(  );
						if (renderItem.alpha >= 0.5) {
							renderFileItem();
						}
					}});
			}
		}
		
		public function getFileDataXML():XML {
			
			var xml:XML =   <data></data>;
			var renderItem:FileItem;
			var i:int;
			var xmlNode:XML;
			for (i = 0; i < container.numChildren; i++) {
				renderItem = container.getChildAt(i) as FileItem;
				if (renderItem && renderItem.fileData) {
					//<bitmap file="bin/image/9ria.jpg" quality="80" class="JPGBitmap"/>
					xmlNode =   <bitmap file={renderItem.fileData.path} quality={renderItem.fileData.quality} class={renderItem.fileData.linkName}/>;
					xml.appendChild(xmlNode);
				}
			}
			return xml;
		}
		
		private var area:AutoFitArea;
		private var bmp:Bitmap;
		private var clickPoint:Point = new Point; //当前点击的点
		
		public function showBigImage(fileItem:FileItem):void {
			
			if (area == null) {
				area = new AutoFitArea(this);
				area.previewColor = 0xcc0000;
				area.preview = false;
			}
			
			this.fileItem = fileItem;
			if (this.fileItem == null)
				return;
			bmp = this.fileItem.fileData.data as Bitmap;
			if (bmp) {
				
				bmp.x = fileItem.x;
				bmp.y = fileItem.y;
				this.addChild(bmp);
				
				this.mouseChildren = false;
				//area = new AutoFitArea( this , bmp.x , bmp.y , fileItem.itemWidth , 40, 0xCC0000);
				clickPoint.x = fileItem.x;
				clickPoint.y = fileItem.y + container.y;
				area.x = clickPoint.x; // bmp.x;
				area.y = clickPoint.y; // bmp.y;
				area.width = fileItem.itemWidth;
				area.height = 40;
				area.attach(bmp);
				area.alpha = 0;
				
				TweenLite.to(area, 1, {x: 0, y: 0, width: this.plateWidth, height: this.plateHeight, alpha: 1, onComplete: function():void {
						area.preview = true;
					}});
			}
		}
		
		public function hideBigImage():void {
			
			if (this.fileItem) {
				
				if (area == null)
					return;
				//area.preview = true;
				TweenLite.to(area, 1, {x: clickPoint.x, y: clickPoint.y, width: fileItem.itemWidth, height: 40, alpha: 0, onComplete: complete});
			}
		}
		
		private function complete():void {
			area.preview = false;
			this.fileItem = null;
			this.mouseChildren = true;
			if (bmp && this.contains(bmp)) {
				this.removeChild(bmp);
			}
		}
	}
}