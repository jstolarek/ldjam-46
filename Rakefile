desc "Clean"
task :"clean" do
    rm_rf("bin")
end

desc "Build"
task :"build" do
    sh %Q(haxe hl.sdl.hxml)
end

desc "Build debug"
task :"build:debug" do
    sh %Q(haxe hl.sdl.debug.hxml)
end

desc "Run"
task :"run" do
    sh %Q(hl bin/client.hl)
end
