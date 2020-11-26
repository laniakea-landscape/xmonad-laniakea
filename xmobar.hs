Config {
    font = "xft:DejaVu Sans Mono:size=9:bold:antialias=true",
    bgColor = "#000000",
    fgColor = "#fcf9f4",
    alpha = 125,
    position = Static { xpos = 0, ypos = 0, width = 1920, height = 18 },
    lowerOnStart = True,
    commands = [
         Run Memory ["-t","mem: <usedbar>", "-n", "#45a5f5", "-L", "0", "-H", "100"] 10
        ,Run Date "%d.%m.%Y %a %H:%M:%S" "date" 10
        ,Run MultiCpu [ "--template" , "cpu: <autovbar>"
            , "--Low"      , "50"         -- units: %
            , "--High"     , "85"         -- units: %
            , "--low"      , "gray"
            , "--normal"   , "darkorange"
            , "--high"     , "darkred"
            , "-c"         , ""
            , "-w"         , "1"
        ] 3
  ,Run Com "/home/laniakea/.xmonad/getinet.sh" [] "inet" 10
        ,Run UnsafeStdinReader
  ,Run PipeReader "/tmp/.volume-pipe" "vol"
  ,Run Kbd [("us", "US"),("ru", "RU")]
  ,Run Battery ["-t", "<acstatus> <left>%", "--", "-o", "<fc=#f7c2ba>Off</fc>", "-O", "<fc=#45a5f5>On</fc>", "-i", "<fc=#fcf9f4>Idle</fc>"] 10
    ],
    sepChar = "%",
    alignSep = "}{",
    template = " %UnsafeStdinReader% }{%vol% | %multicpu% | %memory% | %battery% | %inet% | %kbd% | <fc=#f7c2ba>%date%</fc>   "
}