package en;

class Hero extends Entity {
  var ca : dn.heaps.Controller.ControllerAccess;
  var direction : Direction;

  public function new(x,y) {
    super(x,y);

    this.ca = Main.ME.controller.createAccess("hero");
    this.direction = RIGHT;

    spr.anim.registerStateAnim("hero-idle", 1, 0.4, function() return true );
  }

  override function dispose() { // call on garbage collection
    super.dispose();
    ca.dispose(); // release on destruction
  }

  override function update() { // the Entity main loop
    super.update();

    if( ca.dpadLeftDown() ) {
      dx -= 0.02*tmod;
      direction = LEFT;
    }

    if( ca.dpadRightDown() ) {
      dx += 0.02*tmod;
      direction = RIGHT;
    }

    if( ca.dpadUpDown() ) {
      dy -= 0.02*tmod;
      direction = UP;
    }

    if( ca.dpadDownDown() ) {
      dy += 0.02*tmod;
      direction = DOWN;
    }
  }
}
