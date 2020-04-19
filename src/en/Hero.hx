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

  public function new(x,y) {
    super(x,y);

    this.ca = Main.ME.controller.createAccess("hero");
    this.direction = RIGHT;

    spr.anim.registerStateAnim("hero-walk-up", 2, 0.4, function() return isWalk() && direction == UP );
    spr.anim.registerStateAnim("hero-walk-diagonal-top-right", 2, 0.4, function() return isWalk() && (direction == UP_RIGHT || direction == UP_LEFT ));
    spr.anim.registerStateAnim("hero-walk-right", 2, 0.4, function() return isWalk() && (direction == RIGHT || direction == LEFT ));
    spr.anim.registerStateAnim("hero-walk-diagonal-down-right", 2, 0.4, function() return isWalk() && (direction == DOWN_RIGHT || direction == DOWN_LEFT ));
    spr.anim.registerStateAnim("hero-walk-down", 2, 0.4, function() return isWalk() && direction == DOWN );
    spr.anim.registerStateAnim("hero-idle", 1, 0.1, function() return isIdle() );
  }

  inline function isIdle() {
    return state == IDLE;
  }

  inline function isWalk() {
    return state == WALK;
  }

  override function dispose() { // call on garbage collection
    super.dispose();
    ca.dispose(); // release on destruction
  }

  override function update() { // the Entity main loop
    super.update();

    state = IDLE;

    if( ca.dpadLeftDown() ) {
      dx -= 0.02*tmod;
      direction = LEFT;
      state = WALK;
      set_dir(-1);
    }

    if( ca.dpadRightDown() ) {
      dx += 0.02*tmod;
      direction = RIGHT;
      state = WALK;
      set_dir(1);
    }

    if( ca.dpadUpDown() ) {
      dy -= 0.02*tmod;
      direction = UP;
      state = WALK;
    }

    if( ca.dpadDownDown() ) {
      dy += 0.02*tmod;
      direction = DOWN;
      state = WALK;
    }

    if (ca.dpadLeftDown() && ca.dpadUpDown()) {
      direction = UP_LEFT;
    }
    if (ca.dpadLeftDown() && ca.dpadDownDown()) {
      direction = DOWN_LEFT;
    }
    if (ca.dpadRightDown() && ca.dpadUpDown()) {
      direction = UP_RIGHT;
    }
    if (ca.dpadRightDown() && ca.dpadDownDown()) {
      direction = DOWN_RIGHT;
    }
  }
}
