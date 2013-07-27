/^  &addglyph(\$code);/c \ \ my $refGlyph = $target;\
\ \ if ($buhin{$target} =~ /^99:0:0:0:0:200:200:([\w\-]+)$/) {$refGlyph = $1;}\
\ \ \&addglyph($code, $refGlyph, $target);
/^Move(400, -400)/d
/^Move(0, 50)/d
/^RemoveOverlap()/d
/^Simplify()/d
/^SetWidth(1000)/i Scale(20)
/^Scale(500)/a CanonicalContours()\
CanonicalStart()\
FindIntersections()\
SetGlyphComment("Kage: $_[2]\\\\nAlias: $_[1]")
s/"Generate(\(.*\)\.ttf.*)/"Save(\1.sfd\\")/
/^foreach(sort(keys %buhin)){/,/^}/c open GLYPHLIST, "../glyphs.txt" or die "Cannot read the glyph list";\
while (<GLYPHLIST>) {\
	chomp; my $name = $_;\
	(my $target = $name) =~ s/^[uU]0*//g; # delete zero for the beginning\
	$target{$target} = $name;\
}\
close GLYPHLIST;
/^  while(\$buffer =~ m\/\\\$99/c \ \ while($buffer =~ m/\\\$99:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:([^\\\$:]*)(?::[^\\\$]*)?/gc){