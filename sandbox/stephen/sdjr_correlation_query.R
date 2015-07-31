EXEC SQL SELECT
projectiid/1 AS projectiid,
uprojectid,
projectname,
m.muname,
m2.muname,
m.nationalmusym,
l.liid/1 AS liid,
a.areasymbol,
lm.musym,
lm.lmapunitiid/1 as mukey,
CODELABEL(lm.mustatus) as mustatus,
lm.muacres,
dmudesc

FROM project AS p
INNER JOIN REAL projectmapunit AS pm ON pm.projectiidref = p.projectiid
INNER JOIN REAL mapunit AS m ON m.muiid = pm.muiidref
INNER JOIN REAL correlation AS c ON c.muiidref = m.muiid
INNER JOIN REAL datamapunit AS dm ON dm.dmuiid = c.dmuiidref
INNER JOIN REAL correlation AS c2 on c2.dmuiidref = dm.dmuiid
INNER JOIN REAL mapunit AS m2 on m2.muiid = c2.muiidref

INNER JOIN REAL lmapunit AS lm ON lm.muiidref = m.muiid
INNER JOIN REAL legend AS l ON l.liid = lm.liidref
INNER JOIN REAL area AS a ON a.areaiid = l.areaiidref;.

PAGE WIDTH UNLIMITED LENGTH UNLIMITED.

TEMPLATE output SEPARATOR "|" WIDTH UNLIMITED
AT LEFT FIELD separator "", 
FIELD WIDTH UNLIMITED, FIELD WIDTH UNLIMITED, FIELD WIDTH UNLIMITED, FIELD WIDTH UNLIMITED, 
FIELD WIDTH UNLIMITED, FIELD WIDTH UNLIMITED, FIELD WIDTH UNLIMITED, FIELD WIDTH UNLIMITED, 
FIELD WIDTH UNLIMITED, FIELD WIDTH UNLIMITED, FIELD WIDTH UNLIMITED, FIELD WIDTH UNLIMITED.



header
using output 
"projectiid",
"uprojectid",
"projectname",
"m.muname",
"m2.muname",
"m.nationalmusym",
"liid",
"a.areasymbol",
"musym",
"mukey",
"mustatus",
"lm.muacres",
"dmudesc".
End Header.

SECTION
DATA
USING output 
projectiid,
uprojectid,
projectname,
m.muname,
m2.muname,
m.nationalmusym,
liid,
a.areasymbol,
lm.musym,
mukey,
mustatus,
lm.muacres,
dmudesc.
End section.