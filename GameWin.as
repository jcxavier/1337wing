package {
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	public class GameWin extends Sprite {
		public var mainClass:LeetWing;
		public function GameWin(passedClass:LeetWing) {
			mainClass = passedClass;
			playAgainButton.addEventListener(MouseEvent.CLICK, playAgainButtonClicked);
			backButton.addEventListener(MouseEvent.CLICK, backButtonClicked);
		}
		public function playAgainButtonClicked(event:MouseEvent) {
			mainClass.playLW();
		}
		public function backButtonClicked(event:MouseEvent) {
			mainClass.backSplash();
		}
	}
}