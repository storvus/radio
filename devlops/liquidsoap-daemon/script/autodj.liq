#!/usr/bin/liquidsoap -d
def update_title(m) =
 title = m["title"]
 if title == "" or title == "Unknown" then
  content = m["filename"]
  content = path.basename(content)
  content = get_process_output("STR=\""^content^"\"; echo ${STR%.*}")
  content = string.recode(out_enc="UTF-8", content)
  [("title", content)]
 else
  sArtist = string.recode(out_enc="UTF-8", m["artist"])
  sTitle = string.recode(out_enc="UTF-8", m["title"])
  [("title", sTitle),
  ("artist", sArtist)]
 end
end

music = playlist(mode="randomize", reload_mode="rounds", reload=1, "/home/torvus/Music")
jingles = playlist(mode="randomize", reload_mode="rounds", reload=1, "/home/torvus/Jingles")
# security = single("/home/torvus/Music/free.mp3")
radio = music
radio = random(weights=[1, 1], [jingles, music])
# radio = fallback(track_sensitive = false, [smart_crossfade(fallback([request.queue(id="request"), radio])),security])
# radio = fallback([radio, security])
radio = mksafe(radio)
radio = map_metadata(update_title, radio)

# Stream it out
output.icecast(%mp3,
  host = "185.170.213.81",
  port = 8003,
  password = "FpQ29bwU",
  mount = "autodj",
  name="myStation Music Service",
  description="This is the myStation",
  radio
)
