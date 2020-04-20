package en;

@:enum
abstract State(Int) {
  var IDLE = 0;
  var WALK = 1;

  public inline function new( v : Int ){
    this = v;
  }

  public inline function getIndex() : Int {
    return this;
  }

  inline public static var LENGTH = 2;
}


class Hero extends Entity {
  var ca : dn.heaps.Controller.ControllerAccess;
  var direction : Direction;
  var state : State;
  var acc : Float;
  var kol : Int;
  public var health : Int;

  public function new(x,y) {
    super(x,y);

    kol = 0;

    this.ca = Main.ME.controller.createAccess("hero");
    this.direction = RIGHT;
    this.health = Const.HEALTH;
    acc = Const.SPEED;

    spr.anim.registerStateAnim("hero-walk-up", 3, 0.4, function() return isWalk() && direction == UP );
    spr.anim.registerStateAnim("hero-walk-diagonal-top-right", 3, 0.4, function() return isWalk() && (direction == UP_RIGHT || direction == UP_LEFT ));
    spr.anim.registerStateAnim("hero-walk-right", 3, 0.4, function() return isWalk() && (direction == RIGHT || direction == LEFT ));
    spr.anim.registerStateAnim("hero-walk-diagonal-down-right", 3, 0.4, function() return isWalk() && (direction == DOWN_RIGHT || direction == DOWN_LEFT ));
    spr.anim.registerStateAnim("hero-walk-down", 3, 0.4, function() return isWalk() && direction == DOWN );
    spr.anim.registerStateAnim("hero-idle", 2, 0.1, function() return isIdle() );
    spr.anim.registerStateAnim("skull", 1, 0.2, function() return isDead() );
  }

  inline function isIdle() {
    return state == IDLE && !isDead();
  }

  inline function isDead() {
    return health <= 0;
  }

  inline function isWalk() {
    return state == WALK && !isDead();
  }

  public function hit(dmg:Int) {
      health -= dmg;
      Game.ME.camera.shakeS(0.5);
      if ( isDead() ) {
      Main.ME.delayer.addF( function() {
        Main.ME.transition(Game.ME, function() new Outro());
        }, 40); }
  }

  override function dispose() { // call on garbage collection
    super.dispose();
    ca.dispose(); // release on destruction
  }

  override function fixedUpdate() { // the Entity main loop
    super.update();

    state = IDLE;

    if( !isDead() ){
      if( ca.dpadLeftDown() ) {
        if (centerX>=Const.GRID/2) {
          dx -= acc;
        }
        state = WALK;
      }

      if (! (centerX>=Const.GRID/2)){ dx = 0; cx = 0; xr = 0.5; }

      if( ca.dpadRightDown() ) {
        if ( centerX <= (level.wid - 0.5) * Const.GRID ) {
          dx += acc;
        }
        state = WALK;
      }

      if ( ! (centerX <= (level.wid - 0.5) * Const.GRID) ) {
        dx = 0; cx = level.wid-1; xr = 0.5;
      }

      if( ca.dpadUpDown() ) {
        if (headY >= 0) {
          dy -= acc;
        }
        state = WALK;
      }

      if (! (headY >= 0)) { dy = 0; cy = 0; yr = 1;}

      if( ca.dpadDownDown() ) {
        if (footY <= level.hei * Const.GRID) {
          dy += acc;
        }
        state = WALK;
      }

      if (! (footY <= level.hei * Const.GRID)) { dy = 0; cy = level.hei-1; yr = 1; }

      var angle = M.angTo(Game.ME.hero.centerX, Game.ME.hero.centerY, Game.ME.mouse.x, Game.ME.mouse.y );

      if (angle > -M.PI/8 && angle <= M.PI/8 ) {
        direction = RIGHT;
        set_dir(1);
      } else if (angle < -1/8*M.PI && angle >= -3/8*M.PI) {
        direction = UP_RIGHT;
        set_dir(1);
      } else if (angle < -3/8*M.PI && angle >= -5/8*M.PI) {
        direction = UP;
      } else if (angle < -5/8*M.PI && angle >= -7/8*M.PI) {
        direction = UP_LEFT;
        set_dir(-1);
      } else if (angle < -7/8*M.PI) {
        direction = LEFT;
        set_dir(-1);
      } else if (angle > 1/8*M.PI && angle <= 3/8*M.PI) {
        direction = DOWN_RIGHT;
        set_dir(1);
      } else if (angle > 3/8*M.PI && angle <= 5/8*M.PI) {
        direction = DOWN;
      } else if (angle > 5/8*M.PI && angle <= 7/8*M.PI) {
        direction = DOWN_LEFT;
        set_dir(-1);
      }

       if( xr>0.7 && level.hasCollision(cx+1,cy) ) {
         xr = 0.7;
         if (dx > 0) {
           dx/=2;
         }
       }
       if( xr>=0.6 && level.hasCollision(cx+1,cy) ) {
         if ( dx > 0 ) {
           dx/=4;
         }
       }
       if( xr<0.3 && level.hasCollision(cx-1,cy) ) {
         xr = 0.3;
         if (dx < 0) {
           dx/=2;
         }
       }
       if( xr<0.4 && level.hasCollision(cx-1,cy) ) {
         if (dx < 0) {
           dx/=4;
         }
       }

       if( yr>0.95 && level.hasCollision(cx,cy+1) ) {
         yr = 0.95;
         if (dy > 0) {
           dy/=2;
         }
       }
       if( yr>=0.8 && level.hasCollision(cx,cy+1) ) {
         if ( dy > 0 ) {
           dy/=4;
         }
       }
       if( yr<0.3 && level.hasCollision(cx,cy-1) ) {
         yr = 0.3;
         if (dy < 0) {
           dy/=2;
         }
       }
       if( yr<0.4 && level.hasCollision(cx,cy-1) ) {
         if (dy < 0) {
           dy/=4;
         }
       }
    }

  }

    override function hasCircCollWith(e:Entity) {
        if( e.destroyed ) return false;
        if( e.is(Pigeon) && !isDead() ) return true;
        return false;
    }
}
