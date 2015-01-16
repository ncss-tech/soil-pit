## Purpose: this file containst a list defining:
## - [name] report name- typically a taxonname
## -- [n] generalized horizon labels (GHL)
## -- [p] REGEX pattern used to match GHL
## -- [pedons] vector of unique pedon IDs used within the report

##
## Notes:
##
## 1. don't forget to include Cd, Cr, and R horizons!
##
##

# these describe horizon grouping patterns, used to lump like-horizons for {low,RV,high} 
gen.hz.rules <- list(
	'shabarudo'=list(
		n=c('A', 'Bt1', 'Bt2', 'Cd'),
		p=c('A', 'Bw|Bt1', 'Bt$|Bt2|BCt|CBt', 'Cd')
	),
	'hornitos'=list(
		n=c('A', 'Bw', 'Bt', 'Crt'),
		p=c('A|A11', 'A12|Bw', 'Bt|BC', 'R|Cr|2Ct')
	),
	'mantree'=list(
		n=c('Oi', 'Oe', 'A', 'Bw', 'Bt1', 'Bt2', 'Bt4', 'BCt'),
		p=c('O', 'Oe', 'A$', 'AB|Bw', 'Bt$|Bt1', 'Bt2', 'Bt3|Bt4', 'Bt5|BC|CB|C')
	),
	'musick'=list(
		n=c('Oi', 'A', 'AB', 'Bt1', 'Bt2', 'Bt3', 'Bt4', 'C'),
		p=c('O', 'A$|A1|A2', 'AB|BA|Bw', '^Bt1|^Bt$', '^Bt2', 'Bt3', 'Bt4|Bt5|CBt|BCt|2BC|2Bt', 'Bt6|CB$|BC1|BC2|C1|C2')
	),
	'pentz'=list(
		n=c('A', 'Bw', 'Bt', 'Cr','R'),
		p=c('A', 'Bw|B2$', 'Bt|B2t', 'Cr', 'R')
	),
	'whiteflag'=list(
		n=c('A', 'BA', 'Bt1','Bt2', 'Bt3', 'R'),
		p=c('A', 'AB|BA|Bw$', 'Bt1','^Bt2', 'Bt3|Bt4|Bt5|2Bt2|BCt', 'R')
	),
	'domingopeak'=list(
		n=c('A', 'BA', 'Bt1', 'Bt2', 'Bt3', 'Cr', 'R'),
		p=c('^A', 'Bw|BA$|AB', 'Bt1|2Bt$|BAt', '^Bt2', '2Bt|Bt3|Bt4|Bt5|Bt6|BCt', 'Cr', 'R')
	),
	'amador'=list(
		n=c('A', 'Bw', 'C', 'Cr', 'R'),
		p=c('A|A1|A2', 'Bw|B2', 'BC$|C$', 'Cr', 'R'),
    pedons=c("S04CA099-003", "S2004CA099003", "06JCR002", "80-CA-05-080x", 
             "71-CA-05-060x", "80-CA-05-088x", "2012CA6303043", "S2011DEB094N", 
             "2012CA6304005", "2012CA6302034", "2012CA6302054", "2013CA6302002", 
             "2013CA6302005", "2013CA6302006", "2013CA6304002N", "2013CA6304020", 
             "2013CA6304044N", "2014CA6304027")
	),
	'marblemine'=list(
		n=c('Oi', 'A', 'Bt1', 'Bt2', 'Bt3', 'Bt4', 'Bt5', 'Bt6'),
		p=c('Oi', 'A|BA|AB', 'Bt1', 'Bt2', 'Bt3', 'Bt4', 'Bt5', 'Bt6')
	),
	'andihasset'=list(
		n=c('Oi', 'Oe', 'A', 'Bt1', 'Bt2', 'Bt3', 'Bt4'),
		p=c('Oi', 'Oe', '^A|BA|AB|Bw', 'Bt1|2Bt$', 'Bt2', 'Bt3', 'Bt4|Bt5')
	),
	'millvilla'=list(
		n=c('Oi', 'A', 'AB', 'Bt1', 'Bt2', 'Bt3', 'C', 'Cr', 'R'),
		p=c('O', 'A', 'AB|BA|Bw$', '2Bt$|Bt$|Bt1|Bw[1,2]', 'Bt2', 'Bt3|Bt4|Btg', 'BC|C', 'Cr', 'R')
	),
	'nedsgulch'=list(
		n=c('Oi', 'A', 'AB', 'Bt1', 'Bt2', 'Bt3', 'Bt4', 'C', 'Cr'),
		p=c('O', 'A', 'AB|BA|Bw', 'Bt1', 'Bt2', 'Bt3', 'Bt4|Bt5|Bt6|Bt7|Bt8|BCt', '^C|2C|BC$', 'Cr')
	),
	'fricot'=list(
		n=c('Oi', 'A', 'AB', 'Bt', 'Cr','R'),
		p=c('O', 'A', 'AB|BA', 'Bt|BC', 'Cr', 'R')
	),
	'inks'=list(
	  n=c('A', 'Bw', 'Bt', 'Cr','R'),
	  p=c('A', 'AB|BA|Bw', 'B.+t|Bt|BC', 'Cr', 'R')
	),
	'saltsprings'=list(
		n=c('A', 'Bt1', 'Bt2', 'Cr','R'),
		p=c('A', 'Bw|Bt$|Bt1', 'Bt2|Bt3', 'Cr', 'R')
	),
	'priestgrade'=list(
		n=c('A', 'Bw', 'Bt', 'Cr', 'R'),
		p=c('A', 'AB|Bw|B2', 'B2t|Bt|BC', 'Cr', 'R')
	),
	'gardellones'=list(
		n=c('Oi', 'A','Bt1','Bt2','Bt3','Bt4','Cr','R'),
		p=c('O', '^A$|^BA$|Bw','^Bt1','^Bt2','^Bt3','^Bt4|^Bt5|BCt','Cr','R')
	),
	'loafercreek'=list(
		n=c('A','BA','Bt1','Bt2','Bt3','Cr','R'),
		p=c('^A$|Ad|Ap|^ABt$','AB$|BA$|Bw', 'BAt|Bt1$|^Bt$','^Bt2$','^Bt3|^Bt4|CBt$|BCt$|2Bt|2CB$|^C$','Cr','R')
		),
	'dunstone'=list(
		n=c('Oi', 'A', 'BA', 'Bt1','Bt2','Cr','R'),
		p=c('Oi', '^A$|Ap', 'AB$|BA$|Bw', 'Bt$|Bt1$','Bt2$|Bt3$|CBt$|BCt$','Cr','R')
		),
	'gopheridge'=list(
		n=c('A', 'Bt1', 'Bt2', 'Bt3','Cr','R'),
		p=c('^A|BA$', 'Bt1|Bw','Bt$|Bt2', 'Bt3|CBt$|BCt','Cr','R')
		),
	'motherlode'=list(
		n=c('Oi', 'A', 'Bt1', 'Bt2', 'Bt3', '2Bt4', 'Cr', 'R'),
		p=c('Oi', '^A|BA|AB', '^Bt1$', '^Bt2$', '^Bt3$|^2Bt1|Bt4$', '^2Bt[2,3,4]|BCt|CBt|^BC$|^C$|^2C1$|^3C2$', 'Cr', 'R')
		),
	'crimeahouse'=list(
		n=c('A', 'Bt1', 'Bt2', 'Bt3', 'Cr','R'),
		p=c('^A$|AB$|BA$', 'Bw|ABt|BAt|Bt1', 'Bt2', 'Bt3|BCt|CBt|Bt4','Cr','R')
		),
	'delpiedra'=list(
		n=c('A', 'Bt','Cr','R'),
		p=c('A', 'B|Bt|BCt|CBt','Cr','R')
		),
	'hennekenot'=list(
		n=c('A', 'Bt1', 'Bt2', 'R'),
		p=c('A$', 'Bt1|Bw|Bt$', 'Bt2|Bt3', 'R')
		),
	'copperopolis'=list(
		n=c('A', 'Bw', 'Bt','Cr','R'),
		p=c('^A', 'BC|BA|Bw', 'Bt','Cr','R')
		),
	'whiterock'=list(
		n=c('A1', 'A2','Cr','R'),
		p=c('^A|A1', 'A2|A3|AC|Bw|BA|B$','Cr','R')
		),
	'donpedro'=list(
		n=c('A', 'Bt1', 'Bt2','Cr','R'),
		p=c('^A', 'Bt1|Bw1|BAt', 'Bt2|Bw2|BCt','Cr','R')
		),
	'saddlemod'=list(
		n=c('A','Bw1','Bw2','Bw3','BC','R'),
		p=c('^A','BA|Bw$|Bw1|Bt$|Bt1','Bw2|Bt2','Bw3|Bt3','BC|C$','R')
	),
	'hetchy'=list(
		n=c('A','BA','Bt1','Bt2','Bt3','Cr','R'),
		p=c('^A|^AB','^AB$|^BA$|Bw','Bt1|Bt$','Bt2','Bt3|BCt$|Bt4|BCt4','Cr','R')
	),
	'semoot'=list(
		n=c('A', 'Bw1', 'Bw2', 'R'),
		p=c('^A', 'Bw1', 'Bw2', 'R')
	),
	'hideaway'=list(
		n=c('A', 'Bw', 'R'),
		p=c('^A', 'Bw', 'R')
	),
	'pardee'=list(
		n=c('A','Bt1','Bt2','2Bt3', 'Cd'),
		p=c('^A|^BA$|Bw','^Bt1|^Bt$|B21|B1$','^Bt2|B22|B2t','Bt3|IIB', 'Cd|Ct')
	),
	'aquic haploxeralf'=list(
		n=c('A','AB','Bt1','2Bt2'),
		p=c('^A[0-9]?','AB|BE','^Bt1|Bw','2Bt|Bt2|Bt3|Bt4')
	)
	)
		
		