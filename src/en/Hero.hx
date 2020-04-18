package en;

class Hero extends Entity {
  var ca : dn.heaps.Controller.ControllerAccess;

  public function new(x,y) {
    super(x,y);

    this.ca = Main.ME.controller.createAccess("hero");

    // Some default rendering for our character
    spr.set("fxCircle");
  }

  override function dispose() { // call on garbage collection
    super.dispose();
    ca.dispose(); // release on destruction
  }

  override function update() { // the Entity main loop
    super.update();

    if( ca.dpadLeftDown() )
      dx -= 0.02*tmod;

    if( ca.dpadRightDown() )
      dx += 0.02*tmod;

    if( ca.dpadUpDown() )
      dy -= 0.02*tmod;

    if( ca.dpadDownDown() )
      dy += 0.02*tmod;
  }
}
