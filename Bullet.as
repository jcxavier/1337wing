//This is the basic skeleton that all classes must have
package{
	//we have to import certain display objects and events
	import flash.display.MovieClip;
	import flash.events.*;
	//this just means that Bullet will act like a MovieClip
	public class Bullet extends MovieClip{
		//VARIABLES
		//this will act as the root of the document
		//so we can easily reference it within the class
		private var _root:Object;
		//how quickly the bullet will move
		private var speed:int = 10;
		//this function will run every time the Bullet is added
		//to the stage
		public function Bullet(game:LeetWingGame){
			//adding events to this class
			//functions that will run only when the MC is added
			//addEventListener(Event.ADDED, beginClass);
			_root = MovieClip(game);
			//functions that will run on enter frame
			addEventListener(Event.ENTER_FRAME, eFrame);
		}
		//private function beginClass(event:Event):void{
		//	_root = MovieClip(root);
		//}
		private function eFrame(event:Event):void{
			//moving the bullet up screen
			x += speed;
			//making the bullet be removed if it goes off stage
			if(this.x > 1500){
				removeEventListener(Event.ENTER_FRAME, eFrame);
				
				if (_root.bulletContainer.contains(this))
					_root.bulletContainer.removeChild(this);
			}
		}
	}
}