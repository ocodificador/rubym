rubm	; entry points to access GT.M
	; A GT.M database driver for Ruby based on Nodem
	;
	; Written by David Wicksell <dlw@linux.com>
	; Copyright © 2012-2015 Fourth Watch Software LC
	;
	; This program is free software: you can redistribute it and/or modify
	; it under the terms of the GNU Affero General Public License (AGPL)
	; as published by the Free Software Foundation, either version 3 of
	; the License, or (at your option) any later version.
	;
	; This program is distributed in the hope that it will be useful,
	; but WITHOUT ANY WARRANTY; without even the implied warranty of
	; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	; GNU Affero General Public License for more details.
	;
	; You should have received a copy of the GNU Affero General Public License
	; along with this program. If not, see http://www.gnu.org/licenses/.
	;
	;
	quit:$q "Call an API entry point" w "Call an API entry point" quit
	;
v2j(v)	; Convert variable with single index, for now, to a json string
	;
	n i,result,value,dq
	s dq=$c(34),(result,i)=""
	f  s i=$o(v(i)) q:i=""  d
	.s value=v(i)
	.i value'?.n!(value+0'=value) s value=dq_value_dq
	.s result=result_dq_i_dq_": "_value_", "
	.q
	s result="{ "_$e(result,1,$l(result)-2)_" }"
	;
	quit:$quit result quit
	;
	;
init(error)
	;set $ztrap="new tmp set error=$ecode set tmp=$piece($ecode,"","",2) quit:$quit $extract(tmp,2,$length(tmp)) quit"
	set $ztrap="g zica^ruby"
	quit:$quit 0 quit
	;
zica	;
	;;i $g(^zrubydebug)=1 s ^zrubyerr($h,$j,$o(^zrubyerr($h,$j,""),-1)+1)=$zstatus
	;
	n t
	s error=$zstatus
	s t("ok")=0
	s t("ecode")=$ecode
	s t("zstauts")=$zstatus
	s result=$$v2j(.t)
	;
	quit:$quit error quit
	;
	;
version(result,error) ; return the version string
	u $p:ctrap="$c(3)" ;handle a Ctrl-C/SIGINT, while in GT.M, in a clean manner
	set result="RubyM the extension for GT.M: Version: 0.0.1 ; "_$zv
        quit:$quit 0 quit
	;
	;
construct:(glvn,subs) ;construct a global reference
	quit "^"_glvn_$s(subs'="":"("_subs_")",1:"")
	;
	;
data(glvn,subs,result,error) ;check if global node has data or children
	u $p:ctrap="$c(3)" ;handle a Ctrl-C/SIGINT, while in GT.M, in a clean manner
	;
	n t,globalname
	;
	s error=""
	s globalname=$$construct(glvn,subs)
	s t("ok")=1
	s t("method")="data"
	s t("global")=glvn
	s t("subs")=subs
	;
	set t("defined")=$d(@globalname)
	set result=$$v2j(.t)
	;
        quit:$quit 0 quit
	;
get(glvn,subs,result,error)	;get data from global node
	u $p:ctrap="$c(3)" ;handle a Ctrl-C/SIGINT, while in GT.M, in a clean manner
	;
	n value,globalname,t
	;
	s globalname=$$construct(glvn,subs)
	s value=$$oconvert($$oescape($g(@globalname)))
	;
	s t("ok")=1
	s t("method")="get"
	s t("global")=glvn
	s t("subs")=subs
	s t("defined")=$d(@globalname)#10
	s t("value")=value
	;
	s result=$$v2j(.t)
	;
        quit:$quit 0 quit
	;
kill(glvn,subs,result,error)   ; kill a global or global node
	u $p:ctrap="$c(3)" ;handle a Ctrl-C/SIGINT, while in GT.M, in a clean manner
        ;
        n globalname,t
        ;
        s globalname=$$construct(glvn,subs)
        ;
        k @globalname
	;
	s t("ok")=1
	s t("method")="kill"
	s t("global")=glvn
	s t("subs")=subs
	s result=$$v2j(.t)
        ;
	quit:$quit 0 quit
	;
query(var,value,error)
	set value=$query(@var)
	quit:$quit 0 quit
	;
xecute(var,error)
	xecute var
	quit:$quit 0 quit
	;
t1(error)
	s ^teste=$h
	s error="a casa caiu"
	quit:$quit 0 quit


	;iconvert:(data) ;convert for input
iconvert(data) ;convert for input
 n ndata
 ;
 i $e(data,1,2)="0.",$e(data,2,$l(data))=+$e(data,2,$l(data)) s $e(data)=""
 ;
 s ndata=data
 ;
 q ndata
 ;
 ;
	;iescape:(data) ;unescape quotes within a string
iescape(data) ;unescape quotes within a string
 n ndata
 ;
 i data["""" d
 . n i
 . ;
 . s ndata=""
 . ;
 . f i=1:1:$l(data) d
 . . i $e(data,i)="""" d
 . . . i i=1!(i=$l(data)) d
 . . . . s ndata=ndata_$e(data,i)
 . . . e  d
 . . . . s ndata=ndata_""""_$e(data,i)
 . . e  s ndata=ndata_$e(data,i)
 e  s ndata=data
 ;
 quit ndata
 ;
 ;
	;oconvert:(data) ;convert for output
oconvert(data) ;convert for output
 n ndata
 ;
 i $l(data)<19,data=+data d
 . i $e(data)="." s ndata=0_data
 . e  s ndata=data
 e  s ndata=""""_data_""""
 ;
 q ndata
 ;
 ;
	;oescape:(data) ;escape quotes or control characters within a string
oescape(data) ;escape quotes or control characters within a string
 n ndata
 ;
 i data[""""!(data["\")!(data?.e1c.e) d
 . n charh,charl,i
 . ;
 . s ndata=""
 . ;
 . f i=1:1:$l(data) d
 . . i $e(data,i)=""""!($e(data,i)="\") s ndata=ndata_"\"_$e(data,i)
 . . e  i $e(data,i)?1c!($a($e(data,i))>127&($a($e(data,i))<256)&($zch="M")) d
 . . . s charh=$a($e(data,i))\16,charh=$e("0123456789abcdef",charh+1)
 . . . s charl=$a($e(data,i))#16,charl=$e("0123456789abcdef",charl+1)
 . . . s ndata=ndata_"\u00"_charh_charl
 . . e  s ndata=ndata_$e(data,i)
 e  s ndata=data
 ;
 quit ndata
 ;
 ;
	;parse:(subs,type) ;parse an argument list or list of subscripts
parse(subs,type) ;parse an argument list or list of subscripts
 s subs=$g(subs)
 ;
 i subs'="" d
 . n num,sub,tmp
 . ;
 . s tmp=""
 . ;
 . f  q:subs=""  d
 . . s num=+subs
 . . s $e(subs,1,$l(num)+1)=""
 . . s sub=$e(subs,1,num)
 . . ;
 . . i type="input" d
 . . . s sub=$$iescape(sub)
 . . . s sub=$$iconvert(sub)_","
 . . e  i type="output" d
 . . . s sub=$$oescape(sub)
 . . . s sub=$$oconvert(sub)_","
 . . e  i type="pass" d
 . . . s $e(sub)=$tr($e(sub),"""","")
 . . . s $e(sub,$l(sub))=$tr($e(sub,$l(sub)),"""","")
 . . . ;
 . . . s sub=$$oescape(sub)
 . . . s sub=$$oconvert(sub)_","
 . . s tmp=tmp_sub
 . . s $e(subs,1,num+1)=""
 . s subs=tmp
 s subs=$e(subs,1,$l(subs)-1)
 ;
 quit subs
 ;
 ;
function(func,args,relink) ;call an arbitrary extrinsic function
 u $p:ctrap="$c(3)" ;handle a Ctrl-C/SIGINT, while in GT.M, in a clean manner
 ;
 n function,result
 ;
 s args=$$parse($g(args),"input")
 ;
 ;link latest routine image containing function in auto-relinking mode
 i relink zl $tr($s(func["^":$p(func,"^",2),1:func),"%","_")
 ;
 s function=func_$s(args'="":"("_args_")",1:"")
 ;
 i function'["^" s function="^"_function
 ;
 s @("result=$$"_function)
 ;
 s result=$$oescape(result)
 s result=$$oconvert(result)
 ;
 quit "{""ok"": 1, ""function"": """_func_""", ""result"": "_result_"}"
 ;
 ;
globalDirectory(max,lo,hi) ;list the globals in a database, filtered or not
 u $p:ctrap="$c(3)" ;handle a Ctrl-C/SIGINT, while in GT.M, in a clean manner
 ;
 n cnt,flag,global,return
 ;
 s max=$g(max,0)
 s cnt=1,flag=0
 ;
 i $g(lo)'="" s global="^"_lo
 e  s global="^%"
 ;
 i $g(hi)="" s hi=""
 e  s hi="^"_hi
 ;
 s return="["
 ;
 i $d(@global) d
 . s return=return_""""_$e(global,2,$l(global))_""", "
 . ;
 . i max=1 s flag=1 q
 . ;
 . s:max>1 max=max-1
 ;
 f  s global=$o(@global) q:flag!(global="")!(global]]hi&(hi]""))  d
 . s return=return_""""_$e(global,2,$l(global))_""", "
 . ;
 . i max>0 s cnt=cnt+1 s:cnt>max flag=1
 ;
 s:$l(return)>2 return=$e(return,1,$l(return)-2)
 s return=return_"]"
 ;
 quit return
 ;
 ;
increment(glvn,subs,incr) ;increment the number in a global node
 u $p:ctrap="$c(3)" ;handle a Ctrl-C/SIGINT, while in GT.M, in a clean manner
 ;
 n globalname,increment
 ;
 s subs=$$parse($g(subs),"input")
 s globalname=$$construct(glvn,subs)
 ;
 s increment=$i(@globalname,$g(incr,1))
 ;
 quit "{""ok"": 1, ""global"": """_glvn_""", ""data"": "_increment_"}"
 ;
 ;
lock(glvn,subs) ;lock a global node, incrementally
 u $p:ctrap="$c(3)" ;handle a Ctrl-C/SIGINT, while in GT.M, in a clean manner
 ;
 n globalname,result
 ;
 s subs=$$parse($g(subs),"input")
 s globalname=$$construct(glvn,subs)
 ;
 l +@globalname:0
 ;
 i $t s result="1"
 e  s result="0"
 ;
 quit "{""ok"": 1, ""global"": """_glvn_""", ""result"": """_result_"""}"
 ;
 ;
merge(fglvn,fsubs,tglvn,tsubs) ;merge an array node to another array node
 u $p:ctrap="$c(3)" ;handle a Ctrl-C/SIGINT, while in GT.M, in a clean manner
 ;
 n fglobalname,fosubs,return,tglobalname,tosubs
 ;
 ;process for output without going through M
 s fosubs=$$parse(fsubs,"pass")
 s tosubs=$$parse(tsubs,"pass")
 ;
 s fsubs=$$parse(fsubs,"input")
 s fglobalname=$$construct(fglvn,fsubs)
 ;
 s tsubs=$$parse(tsubs,"input")
 s tglobalname=$$construct(tglvn,tsubs)
 ;
 m @tglobalname=@fglobalname
 ;
 s return="{""ok"": 1, ""global"": """_fglvn_""","
 ;
 i fosubs'=""!(tosubs'="") d
 . s return=return_" ""subscripts"": ["
 . i fosubs'="" s return=return_fosubs_", "
 . s return=return_""""_tglvn_""""
 . i tosubs'="" s return=return_", "_tosubs
 . s return=return_"],"
 ;
 s return=return_" ""result"": ""1""}"
 ;
 quit return
 ;
 ;
nextNode(glvn,subs) ;return the next global node, depth first
 u $p:ctrap="$c(3)" ;handle a Ctrl-C/SIGINT, while in GT.M, in a clean manner
 ;
 n data,defined,globalname,nsubs,result,return
 ;
 s subs=$$parse($g(subs),"input")
 s globalname=$$construct(glvn,subs)
 ;
 s result=$q(@globalname)
 ;
 i result="" s defined=0
 e  s defined=1
 ;
 i defined d
 . n sub
 . ;
 . s data=@result
 . ;
 . s data=$$oescape(data)
 . s data=$$oconvert(data)
 . ;
 . i $e(result)="^" s $e(result)=""
 . ;
 . s nsubs=""
 . ;
 . f i=1:1:$ql(result) d
 . . s sub=$$oescape($qs(result,i))
 . . s sub=$$oconvert(sub)
 . . ;
 . . s nsubs=nsubs_", "_sub
 . ;
 . s $e(nsubs,1,2)=""
 ;
 s return="{""ok"": 1, ""global"": """_glvn_""","
 ;
 i defined,nsubs'="" s return=return_" ""subscripts"": ["_nsubs_"],"
 ;
 s return=return_" ""defined"": "_defined
 ;
 i defined s return=return_", ""data"": "_data_"}"
 e  s return=return_"}"
 ;
 ;
 quit return
 ;
 ;
order(glvn,subs,order) ;return the next global node at the same level
 u $p:ctrap="$c(3)" ;handle a Ctrl-C/SIGINT, while in GT.M, in a clean manner
 ;
 n globalname,result
 ;
 s subs=$$parse($g(subs),"input")
 s globalname=$$construct(glvn,subs)
 ;
 i $g(order)=-1 s result=$o(@globalname,-1)
 e  s result=$o(@globalname)
 ;
 i subs="",$e(result)="^" s $e(result)=""
 ;
 s result=$$oescape(result)
 s result=$$oconvert(result)
 ;
 quit "{""ok"": 1, ""global"": """_glvn_""", ""result"": "_result_"}"
 ;
 ;
previous(glvn,subs) ;same as order, only in reverse
 u $p:ctrap="$c(3)" ;handle a Ctrl-C/SIGINT, while in GT.M, in a clean manner
 ;
 quit $$order(glvn,$g(subs),-1)
 ;
 ;
previousNode(glvn,subs) ;same as nextNode, only in reverse
 u $p:ctrap="$c(3)" ;handle a Ctrl-C/SIGINT, while in GT.M, in a clean manner
 ;
 quit "{""status"": ""previous_node not yet implemented""}"
 ;
 ;
retrieve() ;not yet implemented
 u $p:ctrap="$c(3)" ;handle a Ctrl-C/SIGINT, while in GT.M, in a clean manner
 ;
 quit "{""status"": ""retrieve not yet implemented""}"
 ;
 ;
set(glvn,subs,data) ;set a global node
 u $p:ctrap="$c(3)" ;handle a Ctrl-C/SIGINT, while in GT.M, in a clean manner
 ;
 n globalname
 ;
 s subs=$$parse($g(subs),"input")
 s globalname=$$construct(glvn,subs)
 ;
 s data=$$iconvert(data)
 ;
 s $e(data)=$tr($e(data),"""","")
 s $e(data,$l(data))=$tr($e(data,$l(data)),"""","")
 ;
 s @globalname=data
 ;
 quit "{""ok"": 1, ""global"": """_glvn_""", ""result"": ""0""}"
 ;
 ;
unlock(glvn,subs) ;unlock a global node, incrementally, or release all locks
 u $p:ctrap="$c(3)" ;handle a Ctrl-C/SIGINT, while in GT.M, in a clean manner
 ;
 n globalname
 ;
 s subs=$$parse($g(subs),"input")
 s globalname=$$construct(glvn,subs)
 ;
 i glvn=""&(subs="") l  quit """0"""
 e  l -@globalname
 ;
 quit "{""ok"": 1, ""global"": """_glvn_""", ""result"": ""0""}"
 ;
 ;
update() ;not yet implemented
 u $p:ctrap="$c(3)" ;handle a Ctrl-C/SIGINT, while in GT.M, in a clean manner
 ;
 quit "{""status"": ""update not yet implemented""}"
 ;
 ;
