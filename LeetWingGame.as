package
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.*;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;

	public class LeetWingGame extends MovieClip
	{		
		var mainClass:LeetWing;
		var zig:Zig;
		var curExplosion:ExplosionAnim;
		var nextEnemy:Timer;
		var nextStar:Timer;
		var difficulty:Timer;
		var finalBoss:Timer;
		var enemies:Array		= new Array();
		var stars:Array			= new Array();
		var explosions:Array	= new Array();
		var shield:Number		= 100.0;
		var speed:Number		= 15.0;
		var baseSpeed:Number	= 4.0;
		var starSpeed:Number	= 10.5;
		var enemyTime:Number	= 800;
		var acceleration:Number = 1.0;
		var soundOn:Boolean = true;
		
		public var soundtrack:Sound 	= new LevelMusic();
		public var crash:Sound			= new CrashMusic();
		public var laser:Sound			= new LaserMusic();
		var soundChannel:SoundChannel	= new SoundChannel();
		
		//this movieclip will hold all of the bullets
		var bulletContainer:MovieClip = new MovieClip();
		
		public function LeetWingGame(passedClass:LeetWing, sound:Boolean = true)
		{
			mainClass = passedClass;
			soundOn = sound;
			bossDisplay.text = "";
						
			if (soundOn)
				soundChannel = soundtrack.play(0, 99);
				
			zig = new Zig();
			zig.y = 300;
			addChild(zig);
			addChild(bulletContainer);
				
			Mouse.hide();			
			
			addEventListener(Event.ENTER_FRAME, moveMouse);
			addEventListener(MouseEvent.CLICK, shoot);
			
			generateNextEnemy();
			generateNextStar();
			
			difficulty = new Timer(10000);
			difficulty.addEventListener(TimerEvent.TIMER, increaseDifficulty);
			difficulty.start();
			
			finalBoss = new Timer(75000, 1);
			finalBoss.addEventListener(TimerEvent.TIMER_COMPLETE, finalBossAppear);
			finalBoss.start();
			
			addEventListener(Event.ENTER_FRAME, moveEnemies);
			addEventListener(Event.ENTER_FRAME, moveStars);
			addEventListener(Event.ENTER_FRAME, shieldHandler);
			addEventListener(Event.ENTER_FRAME, checkEndGame);
		}
		
		public function moveMouse(e:Event):void
		{
			zig.y = mouseY;
			zig.x = mouseX;
		}
		
		public function shoot(e:MouseEvent):void
		{
			if (soundOn)
				laser.play();
		
			var newBullet:Bullet = new Bullet(this);
			newBullet.x = zig.x + zig.width/2 - newBullet.width/2;
			newBullet.y = zig.y;
			bulletContainer.addChild(newBullet);
		}
		
		public function generateNextStar()
		{
			nextStar = new Timer(150 + Math.random()*100, 1);
			nextStar.addEventListener(TimerEvent.TIMER_COMPLETE, newStar);
			nextStar.start();
		}
		
		public function newStar(e:TimerEvent):void
		{
			var star:Star = new Star();
			star.x = this.width + 200;
			star.y = 1 + Math.random()*this.height;
			parent.addChild(star);
			stars.push(star);
			
			nextStar.start();
		}
		
		public function increaseDifficulty(e:TimerEvent)
		{
			speed += 1.5;
			baseSpeed += 0.50;
			enemyTime = Math.max(enemyTime - 50.0, 200.0);
		}
		
		public function finalBossAppear(e:TimerEvent)
		{
			difficulty.stop();
			nextEnemy.stop();
			nextEnemy = null;
			
			bossDisplay.text = "Golimar: 300";
			
			var boss:Destroyable = new FinalBoss(baseSpeed + Math.random()*speed, baseSpeed + Math.random()*speed, "boss", 300);
			boss.x = this.width + 600;
			boss.y = 200 + Math.random()*this.height / 2.0;
			enemies.push(boss);
			parent.addChild(boss);
		}
		
		public function generateNextEnemy()
		{
			nextEnemy = new Timer(200 + Math.random()*enemyTime, 1);
			nextEnemy.addEventListener(TimerEvent.TIMER_COMPLETE, newEnemy);
			nextEnemy.start();
		}
	
		public function newEnemy(e:TimerEvent):void
		{
			var enemy:Destroyable;
			
			var r:Number = Math.random();
			
			if (r < 0.2)
			{
				enemy = new Meteor1(Math.random()*speed + baseSpeed, Math.random()*speed*2 - speed, "meteor");
				enemy.y = 100 + Math.random()*this.height / 2.0;
			}
			else if (r < 0.4)
			{
				enemy = new Meteor2(Math.random()*speed + baseSpeed, Math.random()*speed*2 - speed, "meteor");
				enemy.y = 100 + Math.random()*this.height / 2.0;
			}
			else
			{
				enemy = new Unzig(Math.random()*speed + baseSpeed, 0, "unzig");
				enemy.y = 10 + Math.random()*this.height - 10;
			}
			
			enemy.x = this.width + 100;
			parent.addChild(enemy);
			enemies.push(enemy);
			
			if (nextEnemy)
				generateNextEnemy();
		}

		public function checkEndGame(e:Event)
		{
			if (shield < 1)
			{								
				removeEventListener(MouseEvent.CLICK, shoot);
				removeEventListener(Event.ENTER_FRAME, moveMouse);
				removeEventListener(Event.ENTER_FRAME, moveEnemies);
				removeEventListener(Event.ENTER_FRAME, moveStars);
				removeEventListener(Event.ENTER_FRAME, shieldHandler);
				removeEventListener(Event.ENTER_FRAME, checkEndGame);
			
				nextStar.stop();
				
				if (nextEnemy)
					nextEnemy.stop();
					
				difficulty.stop();
				finalBoss.stop();
				soundChannel.stop();
				
				
				while (this.numChildren)
					this.removeChildAt(0);
			
				for (var i:int = 0; i != enemies.length; i++)
					parent.removeChild(enemies[i]);
					
				for (var j:int = 0; j != stars.length; j++)
					parent.removeChild(stars[j]);
					
				for (var k:int = 0; k != explosions.length; k++)
					parent.removeChild(explosions[k]);
				
				Mouse.show();
				mainClass.showGameOver();
			}
			if (bossDisplay.text == "Golimar: 0")
			{
				removeEventListener(MouseEvent.CLICK, shoot);
				removeEventListener(Event.ENTER_FRAME, moveMouse);
				removeEventListener(Event.ENTER_FRAME, moveEnemies);
				removeEventListener(Event.ENTER_FRAME, moveStars);
				removeEventListener(Event.ENTER_FRAME, shieldHandler);
				removeEventListener(Event.ENTER_FRAME, checkEndGame);
				
				nextStar.stop();
				
				if (nextEnemy)
					nextEnemy.stop();
					
				difficulty.stop();
				finalBoss.stop();
				soundChannel.stop();
				
				addEventListener(Event.ENTER_FRAME, animateToCenter);
			}
		}
		
		public function animateToCenter(e:Event)
		{
			if (zig.y < this.height / 2.0)
				zig.y += 2;
			else if (zig.y > (this.height / 2.0 + 2.0))
				zig.y -= 2;
			else
			{
				removeEventListener(Event.ENTER_FRAME, animateToCenter);
				addEventListener(Event.ENTER_FRAME, goToEnd);
			}			
		}
		
		public function goToEnd(e:Event)
		{
			if (zig.x < (1024 + 200.0))
			{
				zig.x += acceleration;
				acceleration += 0.5;
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME, goToEnd);
				
				while (this.numChildren)
					this.removeChildAt(0);
			
				for (var i:int = 0; i != enemies.length; i++)
					parent.removeChild(enemies[i]);
					
				for (var j:int = 0; j != stars.length; j++)
					parent.removeChild(stars[j]);
					
				for (var k:int = 0; k != explosions.length; k++)
					parent.removeChild(explosions[k]);
				
				Mouse.show();
				mainClass.showGameWin();
			}
		}

		public function explode(expl:ExplosionAnim)
		{
			explosions.push(expl);
			parent.addChild(expl);
			var explosionTimer:Timer = new Timer(500, 1);
			
			function removeExplode(e:TimerEvent)
			{
				if (explosionTimer)
					explosionTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, removeExplode);
				if (parent && expl)
				{
					parent.removeChild(expl);
					explosions.splice(explosions.indexOf(expl), 1);
				}
			}
			
			explosionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, removeExplode);
			explosionTimer.start();
		}

		public function shieldHandler(e:Event)
		{
			// Shield color change
			if (shield >= 90) shieldDisplay.textColor = 0x00CCFF;
			else if (shield > 65) shieldDisplay.textColor = 0x33CC33;
			else if (shield > 30) shieldDisplay.textColor = 0xFFFF33;			
			else shieldDisplay.textColor = 0xFF0000;

			shieldDisplay.text = "Shield: " + new int(shield);

			if (shield < 100)
				shield += 0.05;
		}

		public function moveStars(e:Event)
		{
			for (var j:int = stars.length - 1; j >= 0; j--)
			{
				stars[j].x -= starSpeed;
				if (stars[j].x < -300)
				{
					parent.removeChild(stars[j]);
					stars.splice(j,1);
				}
			}
		}

		public function moveEnemies(e:Event)
		{			
			for(var i:int = enemies.length - 1; i >= 0; i--)
			{
				if (enemies[i].typestr == "boss")
				{
					if (enemies[i].x > (1024 - 100))
						enemies[i].x -= Math.abs(enemies[i].xSpeed);
					else
					{
						if (enemies[i].y < 100)
						{
							enemies[i].y = 100 + 10;
							enemies[i].ySpeed = baseSpeed * -2 - Math.random()*enemies[i].ySpeed;
							if (Math.random() > 0.5) enemies[i].xSpeed *= -1;
						}
						if (enemies[i].y > (this.height - 100 - 30))
						{
							enemies[i].y = this.height - 100 - 30 - 10;
							enemies[i].ySpeed = baseSpeed * 2 + Math.random()*enemies[i].ySpeed;
							if (Math.random() > 0.5) enemies[i].xSpeed *= -1;
						}
						if (enemies[i].x < 100)
						{
							enemies[i].x = 100+10;
							enemies[i].xSpeed = baseSpeed * -2 - Math.random()*enemies[i].xSpeed;
						}
						if (enemies[i].x > (1024 - 100 - 30))
						{
							enemies[i].x = 1024 - 100 - 30 - 10;
							enemies[i].xSpeed = baseSpeed * 2 + Math.random()*enemies[i].xSpeed;
						}
						
						enemies[i].x -= enemies[i].xSpeed;
						enemies[i].y -= enemies[i].ySpeed;
					}
				}
				else
				{
					enemies[i].x -= enemies[i].xSpeed;
					enemies[i].y -= enemies[i].ySpeed;
				
					if ((enemies[i].y < 10) || (enemies[i].y > (this.height - 10)))
						enemies[i].ySpeed *= -1;
				}
			
				if (enemies[i].x < -300)
				{
					parent.removeChild(enemies[i]);
					enemies.splice(i,1);
					continue;
				}
				if (enemies[i].hitTestObject(zig))
				{
					if (enemies[i].typestr == "meteor") shield -= 60;
					if (enemies[i].typestr == "unzig") shield -= 45;
					if (enemies[i].typestr == "boss") shield -= 100;
					
					shield = Math.max(shield, 0);
					
					parent.removeChild(enemies[i]);
					var explosion:ExplosionAnim = new ExplosionAnim();
					explosion.x = enemies[i].x;
					explosion.y = enemies[i].y;
					enemies.splice(i,1);
					
					if (shield >= 1)
						explode(explosion);					
					
					if (soundOn)
						crash.play();
						
					break;
				}

				//checking if it is touching any bullets
				//we will have to run a for loop because there will be multiple bullets
				if (bulletContainer.numChildren > 0)
				{
					for(var k:int = 0; k < bulletContainer.numChildren; k++)
					{
					//for(var k:int=bulletContainer.numChildren;k>0;k--){
						//numChildren is just the amount of movieclips within the bulletContainer.
						//we define a variable that will be the bullet that we are currently hit testing.
						var bulletTarget:MovieClip = bulletContainer.getChildAt(k) as MovieClip;
						
						if(enemies[i].hitTestObject(bulletTarget))
						{
							enemies[i].hitPoints--;
							
							if (enemies[i].typestr == "boss")
								bossDisplay.text = "Golimar: " + new int(enemies[i].hitPoints);
								
							//also remove the bullet and its listeners
							bulletContainer.removeChild(bulletTarget);
							
							if (enemies[i].hitPoints <= 0)
							{
								//remove enemy from the stage if it touches a bullet
								parent.removeChild(enemies[i]);
								explosion = new ExplosionAnim();
								explosion.x = enemies[i].x;
								explosion.y = enemies[i].y;
								enemies.splice(i,1);
								explode(explosion);
								
								if (soundOn)
									crash.play();
								
								break;
							}
						}
					}				
				}
			}
		}
	}
}
