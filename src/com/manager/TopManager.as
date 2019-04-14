package com.manager {
	
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.pool.ObjectPool;
	import com.ui.componet.Image;
	import com.ui.componet.Label;
	import com.UIGlobal;
	import com.util.DMap;
	import flash.filters.GlowFilter;
	import flash.utils.setTimeout;
	
	/**
	 * 顶部管理 2013/7/12 9:54
	 *
	 * @author cl
	 */
	public class TopManager {
		
		private var infos:Array = [];
		private var isShow:Boolean = false;
		private var _isQuackly:Boolean = true;
		private var label:Label; //当前显示信息
		
		private var _allPos:Object = new Object();
		private var tweens:DMap = new DMap();
		
		/**
		 * 显示信息
		 *
		 * @param	text     显示信息
		 * @param	color    信息颜色
		 * @param	fontSize 字体大小
		 * @param	delay    延迟显示(秒)
		 * @param   endDelay 延迟结束显示时间,默认1秒
		 * @param	beginY   开始Y坐标
		 * @param	endY     结束Y坐标
		 * @param   complete 飘字完成事件
		 * @param	isRepeat 是否添加重复的信息
		 */
		public function showInfo( text:String , color:uint = 0xffffff, fontSize:int = 18 , delay:Number = 0 , beginY:Number = 370, endY:Number = 270 , complete:Function = null, isRepeat:Boolean = false , isQuackly:Boolean = false , endDelay:int = 1 ):void {
			
			if (!isRepeat && this.hasInfo(text)) {
				
				return;
			}
			
			if (text == null || text == "" || (text == currentLab && !isRepeat)) { //|| infos.indexOf(text) != -1
				
				return;
			}
			
			_isQuackly = isQuackly;
			
			var obj:Object = { text: text , delay: delay , endDelay:endDelay , color: color , fontSize: fontSize , beginY: beginY , endY: endY , complete: complete };
			
			if (infos.length == 0) {
				
				isShow = false;
			}
			
			infos.push(obj);
			
			//trace(infos.length + " / " + obj.text);
			if (!isShow) {
				
				//显示文本信息
				showText();
			}
		}
		
		private function showText():void {
			
			if (infos.length > 0) {
				
				label = new Label();
				label.isAutoSize = true;
				label.bold = true;
				
				var obj:Object = infos.shift();
				if (obj == null) {
					//clear();
					showText();
					return;
				}
				
				label.fontSize = obj.fontSize;
				label.textColor = obj.color;
				label.alpha = 0;
				label.htmlText = String(obj.text);
				label.x = (UIGlobal.STAGE_WIDTH - label.width) / 2;
				
				UIGlobal.topLayer.addElement(label);
				
				label.y = obj.beginY + (UIGlobal.topLayer.getChildIndex(label)) * 25;
				label.filters = [ new GlowFilter(0x000000) ];
				
				isShow = true;
				
				if (_isQuackly) {
					
					setTimeout(showText , 700);
				}
				
				var timelineMax:TimelineMax = new TimelineMax( { delay: obj.delay } );
				setTimeout(clear , obj.endDelay + 1200 , label);				
				timelineMax.append(TweenLite.to(label, 0.5, { alpha: 1, y: obj.endY + (UIGlobal.topLayer.getChildIndex(label)) * 25 } ));
				timelineMax.append(TweenLite.to(label, 2 , { alpha: 0, delay:obj.endDelay , onComplete: obj.complete } ));
				
				tweens.put( label , timelineMax );
				
			} else {				
				//clear();
			}
		}
		
		/**
		 * 隐藏消息
		 * @param text 
		 */
		public function hideInfo( text:String ):void {
			
			var lab:Label;
			for (var i:int = 0; i < UIGlobal.topLayer.numChildren;i++ ) {
				lab = UIGlobal.topLayer.getChildAt(i) as Label;
				if ( lab && lab.text == text ) {
					clear( lab );
					break;
				}
			}
		}
		
		/**当前显示文本**/
		private function get currentLab():String {
			
			return label != null ? label.text : "";
		}
		
		/**
		 * 是否有消息
		 * @param	text
		 * @return
		 */
		public function hasInfo(text:String):Boolean {
			
			for each (var obj:Object in infos) {
				if (obj != null && obj.text == text) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 清理
		 */
		public function clear(temLabel:Label):void {
			
			temLabel.text = "";
			var tm:TimelineMax = tweens.get( temLabel ) as TimelineMax;
			if (tm != null) {
				tm.stop();
				tm.clear();
				tm = null;
				tweens.remove( temLabel );
			}			
			UIGlobal.topLayer.removeElement(temLabel);
			if (UIGlobal.topLayer.numChildren == 0) {
				
				isShow = false;
			}
		}
		
		//-----------------------------------------------------------------
		private var _taskFly:Image;//接受任务飘字
		
		/**
		 * 开始飘字
		 * @param	startX 开始x坐标
		 * @param	startY 开始y坐标
		 * @param	endX 最终x坐标
		 * @param	endY 最终y坐标
		 */
		public function flyTaskIcon( startX:Number , startY:Number , endX:Number , endY:Number ):void {			
			
			_taskFly = _taskFly || ObjectPool.getObjectPool( Image ).getObject() as Image;
			_taskFly.sourceClass = "task_swf|mission_fly";
			_taskFly.scaleX = _taskFly.scaleY = 1;
			_taskFly.x = startX;
			_taskFly.y = startY;
			UIGlobal.topLayer.addElement(_taskFly);
			TweenLite.to(_taskFly , 1 , { x:endX , y:endY , scaleX:0.3 , scaleY:0.3 , onComplete:flyComplete } );
			
		}
		/**
		 * 飘完
		 */
		private function flyComplete():void {
			
			_taskFly.x = UIGlobal.stageWidth / 2;
			_taskFly.y = UIGlobal.stageHeight / 2;
			
			_taskFly.clear();
			UIGlobal.topLayer.removeElement( _taskFly , true );
			_taskFly = null;
		}
		
		//--------------------------------------------------------------------
		private static var instance:TopManager;
		public static function get Instance():TopManager {
			
			return instance = instance || new TopManager();
		}
	}

}