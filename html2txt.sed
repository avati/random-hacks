#!/usr/bin/sed -nf
#
# Usage:  ./html2txt.sed file.html > file.txt
#                  OR
#         cat file.html | ./html2txt.sed > file.txt
#
# Bugs: Anand Avati <avati@hardcodecafe.com>
#


#/<[^>]*$/b SearchTagEnd
#b ParseHTML
#:SearchTagEnd
#N
#/<[^>]*$/b SearchTagEnd


# convert entire file/stdin into single pattern space
:GetLine
/^[ \t\n]*$/d
N
$b ParseHTML
b GetLine


# start parsing tags
:ParseHTML

# convert whitespace groups into single ' '
s/[ \t\n][ \t\n]*/ /g

# explicit space
s/&nbsp;/ /g

# fancy stuph
s/&copy;/(c)/g
s/&raquo;/>>/g
s/&middot;/*/g

# standard tags
s/< *[pP] *>/\n/g
s/< *\/[pP] *>/\n/g
s/< *[bB][rR] *>/\n/g

# parse table related tags
# <table>   =>  \n
s/< *[tT][aA][bB][lL][eE] *>/\n/g
s/< *[tT][rR] *>//g
s/< *\/[tT][rR] *>/\n/g
s/< *[tT][dD] *>//g
s/< *\/[tT][dD] *>//g

# <input type="radio" ..>    =>   ( )
s/< *[iI][nN][pP][uU][tT] [^>]*[tT][yY][pP][eE] *= *["]*[rR][aA][dD][iI][oO][^>]*>/( )/g

# <img src="/imag.jpg">   =>  [IMG:/imag.jpg]
#s/< *[iI][mM][gG] *[^>]*[sS][rR][cC] *= *["]*\([^" ]*\)["]*[^>]*>/[IMG:\1]\n/g
s/< *[iI][mM][gG] *[^>]*[sS][rR][cC] *= *["]*\([^" ]*\)["]*[^>]*>//g


#  <script> ... </script> => *nothing*
:ScriptTagUp
/< *[sS][cC][rR][iI][pP][tT].*\/ *[sS][cC][rR][iI][pP][tT] *>.*< *[sS][cC][rR][iI][pP][tT].*\/ *[sS][cC][rR][iI][pP][tT] *>/!b ScriptTagClean
s#\(< *[sS][cC][rR][iI][pP][tT].*/ *[sS][cC][rR][iI][pP][tT] *>.*\)\(< *[sS][cC][rR][iI][pP][tT].*/ *[sS][cC][rR][iI][pP][tT] *>\)#\1#g
b ScriptTagUp
:ScriptTagClean
s#< *[sS][cC][rR][iI][pP][tT].*/ *[sS][cC][rR][iI][pP][tT] *>##g

#  <form ..> ... </form>  => *nothing*
#:FormTagUp
#/< *[fF][oO][rR][mM].*\/ *[fF][oO][rR][mM] *>.*< *[fF][oO][rR][mM].*\/ *[fF][oO][rR][mM] *>/!b FormTagClean
#s#\(< *[fF][oO][rR][mM].*/[fF][oO][rR][mM] *>.*\)\(< *[fF][oO][rR][mM].*/[fF][oO][rR][mM] *>\)#\1#g
#b FormTagUp
#:FormTagClean
#s#< *[fF][oO][rR][mM].*/ *[fF][oO][rR][mM] *>##g

# for now
s/<[^>]*>//g

# we do this in the end to avoid adding confusion to the above
# because > and < can be interpreted as tags

# explicit > 
s/&gt;/>/g
# explicit <
s/&lt;/</g

:Poo
p
