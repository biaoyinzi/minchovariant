#!/usr/bin/env fontforge

import fontforge, sqlite3
from sys import argv, stderr
from os import path

dbFileName = path.join(path.dirname(argv[0]), "HZMincho.db")

if len(argv) < 4:
	stderr.write("Usage: "+argv[0]+" font-id in-font out-font\n")
	quit(1)
if not path.exists(dbFileName):
	raise IOError(2, "Database '%s' not found" % (dbFileName,))

fontforge.setPrefs('CoverageFormatsAllowed', 1)

try:
	db = sqlite3.connect(dbFileName)
	font = fontforge.open(argv[2])
	for i in db.execute(u"SELECT CID, base1 FROM cjkCID INNER JOIN features ON CID=target WHERE fontID="+str(int(argv[1]))+" AND featTag='vrt2';"):
		font.selection.select(("unicode",), i[1] + 0xf0000)
		font.copy()
		font.selection.select(("unicode",), i[0] + 0xf0000)
		font.paste()
	font.generate(argv[3])
finally:
	db.close()
