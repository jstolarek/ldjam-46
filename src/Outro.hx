import hxd.Key;

class Outro extends dn.Process {
	public function new() {
		super(Main.ME);
		createRoot(Main.ME.root);

        var x = Const.WID * 0.5;
        var hei = Const.HEI;

		var tf = new h2d.Text(Assets.fontLarge, root);
		tf.text = "GAME OVER";
		tf.x = x;
		tf.y = hei*0.35;
        tf.textAlign = Center;

		var tf = new h2d.Text(Assets.fontMedium, root);
		tf.text = "Score: " + Game.ME.score;
		tf.x = x;
		tf.y = hei*0.55;
        tf.textAlign = Center;

		var tf = new h2d.Text(Assets.fontTiny, root);
		tf.text = "Click to play again";
		tf.x = x;
		tf.y = hei*0.8;
        tf.textAlign = Center;

		var i = new h2d.Interactive(w(), h(), root);
		i.onClick = function(_) {
          if (!cd.hasSetS("clicked", 9999)) {
              Main.ME.transition(this, function() new Intro(), 0xff<<24|0x120A11);
          }
        }
    }

    override function update() {
        super.update();

        if( !ui.Console.ME.isActive() && !ui.Modal.hasAny() ) {
            #if hl
            // Exit
            if( Main.ME.ca.isKeyboardPressed(Key.ESCAPE) )
                if( cd.hasSetS("exitWarn",1.5) )
                    hxd.System.exit();
            #end
        }
    }
}
