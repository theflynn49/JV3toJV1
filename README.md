
JV3 to JV1 TRS80 disk converter written in Perl, or almost.

I wrote this to help me trying disks with TRS-80_MiSter, which accepts only JV1 formatted disks.

Quick and dirty perl program that converts JV3 diskettes images having less than 967 sectors (that is, only ONE JV3 block is converted)
to JV1

No garantee of any sort that it works, but it may be helpful to someone some day ...

Just do (under linux) "./JV3TOJV1 somedisk.jv3" and it will create "somedisk.jv3.JV1" without any warning.

It should work under Windows or Mac since Perl works everywhere, but you are on your own.

jF

