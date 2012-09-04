package {
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class LeetWing extends MovieClip {
		public var creditsScreen:Credits;
		public var splashScreen:Splash;
		public var playScreen:LeetWingGame;
		public var gameOverScreen:GameOver;
		public var gameWinScreen:GameWin;
		public var unstructionsScreen:Unstructions;
		
		public var splashMovie:SplashAnimation;
		public var unstructionsMovie:UnstructionsAnimation;
		public var gameOverMovie:GameOverAnimation;
		public var gameWinMovie:GameWinAnimation;
		
		public var splashFrame:int;
		public var unstructionsFrame:int;
		public var gameOverFrame:int;
		public var gameWinFrame:int;
		
		public var menuMusic:Sound	= new MenuMusic();
		public var gameOver:Sound	= new GameOverMusic();
		public var gameWin:Sound	= new GameWinMusic();
		public var soundChannel:SoundChannel = new SoundChannel();
		
		public var splashTimer:Timer;
		public var soundOn:Boolean = true;
		
		public function LeetWing() {		
			showCredits();
		}
		
		public function turnSoundOff() {
			soundChannel.soundTransform = new SoundTransform(0);
			soundOn = false;
		}
		
		public function turnSoundOn() {
			soundChannel.soundTransform = new SoundTransform(1);
			soundOn = true;
		}
		
		public function showCredits()
		{
			var creditsSound:Sound = new CreditsMusic();
			creditsScreen = new Credits();
			addChild(creditsScreen);
			creditsSound.play();
			
			splashTimer = new Timer(4800, 1);
			splashTimer.addEventListener(TimerEvent.TIMER_COMPLETE, loadSplash);
			splashTimer.start();
		}
		
		public function loadSplash(e:TimerEvent):void
		{
			splashTimer.stop();
			removeChild(creditsScreen);
		
			soundChannel = menuMusic.play(0, 99);
			showSplash();
		}
		
		public function backSplash():void
		{
			if (gameOverScreen)
			{
				soundChannel.stop();
				removeChild(gameOverScreen);
				gameOverScreen = null;
			}
			if (gameWinScreen)
			{
				soundChannel.stop();
				removeChild(gameWinScreen);
				gameWinScreen = null;
			}
			soundChannel = menuMusic.play(0, 99);
			
			if (!soundOn)
				turnSoundOff();
			
			showSplash();
		}
			
		public function splashAnimation(e:Event)
		{
			splashFrame++;
			
			if (splashFrame > 30)
			{
				splashMovie.removeEventListener(Event.ENTER_FRAME, splashAnimation);
				removeChild(splashMovie);
				splashMovie = null;
				
				splashScreen = new Splash(this, soundOn);
				addChild(splashScreen);
			}
			else
				splashMovie.gotoAndStop(splashFrame);
		}
		
		public function showSplash()
		{			
			splashFrame = 0;
			splashMovie = new SplashAnimation();
			splashMovie.stop();
			splashMovie.addEventListener(Event.ENTER_FRAME, splashAnimation);

			if (unstructionsScreen) {
				removeChild(unstructionsScreen);
				unstructionsScreen = null;
			}
			addChild(splashMovie);
		}
		
		public function unstructionsAnimation(e:Event)
		{
			unstructionsFrame++;
			
			if (unstructionsFrame > 30)
			{
				unstructionsMovie.removeEventListener(Event.ENTER_FRAME, unstructionsAnimation);
				removeChild(unstructionsMovie);
				unstructionsMovie = null;
				
				unstructionsScreen = new Unstructions(this);
				addChild(unstructionsScreen);
			}
			else
				unstructionsMovie.gotoAndStop(unstructionsFrame);
		}
		
		public function showUnstructions() {
			unstructionsFrame = 0;
			unstructionsMovie = new UnstructionsAnimation();
			unstructionsMovie.stop();
			unstructionsMovie.addEventListener(Event.ENTER_FRAME, unstructionsAnimation);
			
			removeChild(splashScreen);
			splashScreen = null;
			
			addChild(unstructionsMovie);
		}
			
		public function gameOverAnimation(e:Event)
		{
			gameOverFrame++;
			
			if (gameOverFrame > 30)
			{
				gameOverMovie.removeEventListener(Event.ENTER_FRAME, gameOverAnimation);
				removeChild(gameOverMovie);
				gameOverMovie = null;
				
				gameOverScreen = new GameOver(this);
				addChild(gameOverScreen);
			}
			else
				gameOverMovie.gotoAndStop(gameOverFrame);
		}
			
		public function showGameOver() {
			soundChannel = gameOver.play();
			
			if (!soundOn)
				turnSoundOff();
			
			gameOverFrame = 0;
			gameOverMovie = new GameOverAnimation();
			gameOverMovie.stop();
			gameOverMovie.addEventListener(Event.ENTER_FRAME, gameOverAnimation);
			
			removeChild(playScreen);
			playScreen = null;
			
			addChild(gameOverMovie);
		}
		
		public function gameWinAnimation(e:Event)
		{
			gameWinFrame++;
			
			if (gameWinFrame > 30)
			{
				gameWinMovie.removeEventListener(Event.ENTER_FRAME, gameWinAnimation);
				removeChild(gameWinMovie);
				gameWinMovie = null;
				
				gameWinScreen = new GameWin(this);
				addChild(gameWinScreen);
			}
			else
				gameWinMovie.gotoAndStop(gameWinFrame);
		}
		
		public function showGameWin() {
			soundChannel = gameWin.play();
			
			if (!soundOn)
				turnSoundOff();
			
			gameWinFrame = 0;
			gameWinMovie = new GameWinAnimation();
			gameWinMovie.stop();
			gameWinMovie.addEventListener(Event.ENTER_FRAME, gameWinAnimation);
			
			removeChild(playScreen);
			playScreen = null;
			
			addChild(gameWinMovie);
		}
		
		public function playLW() {
			
			if (splashScreen) {
				removeChild(splashScreen);
				splashScreen = null;
			}
			if (unstructionsScreen) {
				removeChild(unstructionsScreen);
				unstructionsScreen = null;
			}
			if (gameOverScreen) {
				soundChannel.stop();
				removeChild(gameOverScreen);
				gameOverScreen = null;
			}
			if (gameWinScreen) {
				soundChannel.stop();
				removeChild(gameWinScreen);
				gameWinScreen = null;
			}
			
			soundChannel.stop();
			playScreen = new LeetWingGame(this, soundOn);
			addChild(playScreen);
		}
	}
}