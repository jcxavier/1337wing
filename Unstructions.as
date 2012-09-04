package {
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	public class Unstructions extends Sprite
	{
		public var mainClass:LeetWing;
		public function Unstructions(passedClass:LeetWing)
		{
			mainClass = passedClass;
			playButton.addEventListener(MouseEvent.CLICK, onPlayButtonClicked);
			backButton.addEventListener(MouseEvent.CLICK, onBackButtonClicked);
		}
		public function onPlayButtonClicked(event:MouseEvent)
		{
			mainClass.playLW();
		}
		public function onBackButtonClicked(event:MouseEvent)
		{
			mainClass.showSplash();
		}
	}
}