package rock_on
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import models.Creature;
	
	import world.Point3D;
	import world.World;
	import world.WorldEvent;

	public class StationListener extends Passerby
	{
		public var _listeningStation:ListeningStation;
		public var listeningStationFront:Point3D;
		public var isEnRoute:Boolean;
		[Bindable] public var _passerbyManager:PasserbyManager;
		
		public function StationListener(movieClipStack:MovieClip, passerbyManager:PasserbyManager, layerableOrder:Array=null, creature:Creature=null, personScale:Number=1, source:Array=null)
		{
			super(movieClipStack, layerableOrder, creature, personScale, source);
			_passerbyManager = passerbyManager;
			isEnRoute = true;
		}
		
		override public function tryDestination():Point3D
		{
			getStationFront();
			return listeningStationFront;				
		}
		
		public function getStationFront():void
		{					
			listeningStationFront = new Point3D(Math.floor(_listeningStation.x + _listeningStation.structure.width/2 + 1 + Math.round(Math.random()*_listeningStation.radius.x)), 0, Math.floor(_listeningStation.z - _listeningStation.structure.depth/2 + Math.round(Math.random()*_listeningStation.radius.x*2)+1));							
//			if (booth.rotation == 0)
//			{
//				fpFront = new Point3D(Math.floor(fp.collidable.right + (fp.currentQueue + 1)), Math.floor(fp.collidable.y), Math.floor(fp.collidable.z));			
//			}
//			else
//			{
				// This needs to change
			while (_myWorld.pathFinder.establishPeopleOccupiedSpaces().contains(_myWorld.pathFinder.mapPointToPathGrid(listeningStationFront)))
			{
				listeningStationFront = new Point3D(Math.floor(_listeningStation.x + _listeningStation.structure.width/2 + 1 + Math.round(Math.random()*_listeningStation.radius.x)), 0, Math.floor(_listeningStation.z - _listeningStation.structure.depth/2 + Math.round(Math.random()*_listeningStation.radius.x*2)+1));			
			}
//			listeningStationFront = new Point3D(Math.floor(_listeningStation.structure.width/2 + _listeningStation.x + (_listeningStation.currentQueue + 1)), 0, Math.floor(_listeningStation.structure.depth/4 + _listeningStation.z));							
//			}	
		}
		
		public function standFacingStation():void
		{
			if (worldCoords.x > listeningStation.x)
			{
				if (worldCoords.z > listeningStation.z)
				{
					doRandomStandAnimation(0.5, 0.1, 0.1, 0.3);
				}
				else if (worldCoords.z == listeningStation.z)
				{
					doRandomStandAnimation(0.1, 0.1, 0.1, 0.7);
				}
				else
				{
					doRandomStandAnimation(0.1, 0.1, 0.5, 0.3);
				}
			}
			else
			{
				if (worldCoords.z > listeningStation.z)
				{
					doRandomStandAnimation(0.5, 0.3, 0.1, 0.1); 
				}
				else if (worldCoords.z == listeningStation.z)
				{
					doRandomStandAnimation(0.1, 0.7, 0.1, 0.1);
				}				
				else
				{
					doRandomStandAnimation(0.1, 0.3, 0.5, 0.1);
				}
			}
		}
		
		public function doRandomStandAnimation(towardProbability:Number, towardReflectProbability:Number, awayProbability:Number, awayReflectProbability:Number):void
		{
			var temp:Number = Math.random();
			if (temp < towardProbability)
			{
				movieClipStack.scaleX = orientation;
				doAnimation("stand_still_toward");
			}
			else if (temp < (towardProbability + towardReflectProbability))
			{
				movieClipStack.scaleX = -(orientation);
				doAnimation("stand_still_toward");
			}
			else if (temp < (towardProbability + towardReflectProbability + awayProbability))
			{
				movieClipStack.scaleX = orientation;
				doAnimation("stand_still_away");
			}
			else if (temp < (towardProbability + towardReflectProbability + awayProbability + awayReflectProbability))
			{
				movieClipStack.scaleX = -(orientation);
				doAnimation("stand_still_away");
			}
		}  
		
		private function onFinalDestinationReached(evt:WorldEvent):void
		{
			if (isEnRoute)
			{
				isEnRoute = false;
				_listeningStation.hasCustomerEnRoute = false;
			}
		}
		
		override public function startStopState():void
		{
			state = Person.STOP_STATE;
			standFacingStation();
			if (Math.random() > .95)
			{
				// Some test based on stationType will happen here		
			}
			else
			{
				var listeningTime:int = 2000 + Math.random()*2000;
				stopTime = new Timer(listeningTime);
				stopTime.addEventListener(TimerEvent.TIMER, leave);
				stopTime.start();			
			}
		}
		
		override public function startLeavingState():void
		{
			state = Person.LEAVING_STATE;
			var destination:Point3D = setLeaveDestination();
			movePerson(destination, true);				
		}
		
		public function setLeaveDestination():Point3D
		{
			var leaveDestination:Point3D;
			if (Math.random() < 0.5)
			{
				leaveDestination = new Point3D(Math.round(PasserbyManager.VENUE_BOUND_X + Math.random()*(_myWorld.tilesWide - PasserbyManager.VENUE_BOUND_X)), 0, 0);
			}
			else
			{
				leaveDestination = new Point3D(Math.round(PasserbyManager.VENUE_BOUND_X + Math.random()*(_myWorld.tilesWide - PasserbyManager.VENUE_BOUND_X)), 0, _myWorld.tilesDeep);
			}
			return leaveDestination;
		}
		
		public function set listeningStation(val:ListeningStation):void
		{
			_listeningStation = val;
			_listeningStation.hasCustomerEnRoute = true;
		}					
		
		public function get listeningStation():ListeningStation
		{
			return _listeningStation;
		}	
		
		override public function set myWorld(val:World):void
		{
			if(!_myWorld)
			{
				_myWorld = val;
				_myWorld.addEventListener(WorldEvent.FINAL_DESTINATION_REACHED, onFinalDestinationReached);				
			}
			else
				throw new Error("Where's the world?");			
		}	
		
	}
}