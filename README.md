F5BigIP Decoder
===============

F5 Cookie decoder for single code, file with multiple codes and generic text file (e.g. burp dumps)

felmoltor@kali:~/Tools/F5BigIP_decoder$ ./F5BigIPdecoder.rb -h
Usage: ./F5BigIPdecoder.rb [options]
    -v, --verbose                    Output more information
    -c, --code F5CODE                Decode a single F5 code found inside a cookiei (format is like 1942628072.27950.0000)
    -f, --codefile CODEFILE          A file wit a list of codes with the F5 format separated by \n
    -g, --genericfile GENERICFILE    A file with a lot of text where to find F5 codes to decode
    -h, --help                       Display this screen

Execution example:
------------------

```
felmoltor@kali:~/Tools/F5BigIP_decoder$ ./F5BigIPdecoder.rb -c 1946627082.27970.0000
1946627082.27970.0000 ==> 10.44.7.116:17005

felmoltor@kali:~/Tools/F5BigIP_decoder$ cat test.codefile.txt 
1846527082.27970.0000
1946617062.27970.0000
1946627082.17470.0000
1956687182.37170.0000

felmoltor@kali:~/Tools/F5BigIP_decoder$ ./F5BigIPdecoder.rb -f test.codefile.txt 
1846527082.27970.0000 ==> 106.196.15.110:17005
1946617062.27970.0000 ==> 230.4.7.116:17005
1946627082.17470.0000 ==> 10.44.7.116:15940
1956687182.37170.0000 ==> 78.173.160.116:12945

felmoltor@kali:~/Tools/F5BigIP_decoder$ cat test.genericfile.txt 
hola estaba yo por el campo y me encontre una cookie como esta Cookie: blah=1836527082.27970.0000 pero nada mas volver a casa,
vi otra como esto 1546617062.27970.0000.
Las siguientes son otras similares:
- 1956627082.87470.0000
- 1566872.37170.0000
Hasta luego lucas

felmoltor@kali:~/Tools/F5BigIP_decoder$ ./F5BigIPdecoder.rb -g test.genericfile.txt 
Scanning the text file for F5 cookies...
1836527082.27970.0000 ==> 234.45.119.109:17005
1546617062.27970.0000 ==> 230.128.47.92:17005
1956627082.87470.0000 ==> 138.194.159.116:23061

```
