package
{
	import flash.display.MovieClip;
	
	public class Destroyable extends MovieClip
	{
		public var hitPoints:int;
		public var xSpeed:Number;
		public var ySpeed:Number;
		public var typestr:String;
		
		public function Destroyable(xSpeed:Number, ySpeed:Number, dName:String, hp:int = 2)
		{
			this.xSpeed = xSpeed;
			this.ySpeed = ySpeed;
			this.typestr = dName;
			this.hitPoints = hp;
		}
	}
}
