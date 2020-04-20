import hxd.Key;

class Intro extends dn.Process {
    public var scroller : h2d.Layers;

	public function new() {
		super(Main.ME);
		createRoot(Main.ME.root);

        scroller = new h2d.Layers();
        root.add(scroller, Const.DP_BG);

        var wid = Const.WID;
        var hei = Const.HEI;

		var logo = Assets.tiles.h_get("title", 0.5,0.5, root);
        logo.anim.play("title", 9999);
		logo.setPosition(wid*0.475, hei*0.3);
		tw.createMs(logo.alpha, 0>1, 1500);

        var inst = new h2d.Text(Assets.fontTiny, root);
        inst.text = [
                     "Keep yourself alive by stoning as many pigeons as you can", "",
                     "MOVE: W/A/S/D     AIM: Mouse",
                     "THROW STONE: Left Mouse Button",
                     "THROW BREAD: Right Mouse Button"
                     #if hl
                     ,"QUIT: press Escape  twice"
                     #end
                     ].join("\n");
        inst.x = wid*0.5 - inst.textWidth*0.05;
        inst.y = hei*0.5;
        inst.textAlign = Center;
        tw.createMs(inst.alpha, 500|0>1, 1000);

		var tf = new h2d.Text(Assets.fontTiny, root);
		tf.text = "Click anywhere  to START";
		tf.x = wid*0.475;
		tf.y = hei*0.85;
        tf.textAlign = Center;

		tw.createMs(tf.alpha, 500|0>1, 1500);

		var i = new h2d.Interactive(w(), h(), root);

		i.onClick = function(_) {
          if (!cd.hasSetS("clicked", 9999)) {
             Main.ME.transition(this, function() new Game());
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
