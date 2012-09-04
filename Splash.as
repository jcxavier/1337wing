package {
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	public class Splash extends Sprite
	{
		public var mainClass:LeetWing;
		public var sound:Boolean;
		
		public function Splash(passedClass:LeetWing, soundOn:Boolean) {
			mainClass = passedClass;
			sound = soundOn;
			
			if (!sound)
				soundButton.alpha = 0.5;
			
			playButton.addEventListener(MouseEvent.CLICK, onPlayButtonClicked);
			unstructionsButton.addEventListener(MouseEvent.CLICK, onUnstructionsButtonClicked);
			soundButton.addEventListener(MouseEvent.CLICK, onSoundButtonClicked);
		}
		public function onPlayButtonClicked(event:MouseEvent) {
			mainClass.playLW();
		}
		public function onUnstructionsButtonClicked(event:MouseEvent) {
			mainClass.showUnstructions();
		}
		public function onSoundButtonClicked(event:MouseEvent) {
			if (sound)
			{
				sound = false;
				mainClass.turnSoundOff();
				soundButton.alpha = 0.5;
			}
			else
			{
				sound = true;
				mainClass.turnSoundOn();
				soundButton.alpha = 1;
			}
		}
	}
}