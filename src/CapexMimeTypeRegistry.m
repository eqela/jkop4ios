
/*
 * This file is part of Jkop for iOS
 * Copyright (c) 2016-2017 Job and Esther Technologies, Inc.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import "CapeFile.h"
#import "CapeString.h"
#import "CapeMap.h"
#import "CapePrintReader.h"
#import "CapeReader.h"
#import "CapeIterator.h"
#import "CapeVector.h"
#import "CapexMimeTypeRegistry.h"

CapexMimeTypeRegistry* CapexMimeTypeRegistryMyInstance = nil;
NSMutableDictionary* CapexMimeTypeRegistryHtMime = nil;
NSMutableDictionary* CapexMimeTypeRegistryHtExt = nil;

@implementation CapexMimeTypeRegistry

+ (CapexMimeTypeRegistry*) instance {
	if(CapexMimeTypeRegistryMyInstance == nil) {
		CapexMimeTypeRegistryMyInstance = [[CapexMimeTypeRegistry alloc] init];
	}
	return(CapexMimeTypeRegistryMyInstance);
}

+ (NSString*) typeForFile:(id<CapeFile>)f {
	if(f == nil) {
		return(@"application/unknown");
	}
	CapexMimeTypeRegistry* mtr = [CapexMimeTypeRegistry instance];
	NSString* v = [mtr getMimetype:[f baseName]];
	if([CapeString isEmpty:v]) {
		return(@"application/unknown");
	}
	return(v);
}

- (CapexMimeTypeRegistry*) init {
	if([super init] == nil) {
		return(nil);
	}
	CapexMimeTypeRegistryHtMime = [[NSMutableDictionary alloc] init];
	CapexMimeTypeRegistryHtExt = [[NSMutableDictionary alloc] init];
	[self add:@"*.cpp" mimetype:@"text/x-c++src"];
	[self add:@"*.ogm" mimetype:@"video/x-ogm+ogg"];
	[self add:@"*.epsf" mimetype:@"image/x-eps"];
	[self add:@"*.mpeg" mimetype:@"video/mpeg"];
	[self add:@"*.rmj" mimetype:@"application/vnd.rn-realmedia"];
	[self add:@"*.nes" mimetype:@"application/x-nes-rom"];
	[self add:@"*.rmm" mimetype:@"application/vnd.rn-realmedia"];
	[self add:@"*.gb" mimetype:@"application/x-gameboy-rom"];
	[self add:@"*.qtvr" mimetype:@"video/quicktime"];
	[self add:@"*.ogv" mimetype:@"video/ogg"];
	[self add:@"*.amr" mimetype:@"audio/AMR"];
	[self add:@"*.ogx" mimetype:@"application/ogg"];
	[self add:@"*.rms" mimetype:@"application/vnd.rn-realmedia"];
	[self add:@"*.gf" mimetype:@"application/x-tex-gf"];
	[self add:@"*.gg" mimetype:@"application/x-sms-rom"];
	[self add:@"*.xslt" mimetype:@"application/xml"];
	[self add:@"*.Z" mimetype:@"application/x-compress"];
	[self add:@"*.mdb" mimetype:@"application/vnd.ms-access"];
	[self add:@"*.rmx" mimetype:@"application/vnd.rn-realmedia"];
	[self add:@"*.anim[1-9j]" mimetype:@"video/x-anim"];
	[self add:@"*.gp" mimetype:@"application/x-gnuplot"];
	[self add:@"*.a" mimetype:@"application/x-archive"];
	[self add:@"*.a" mimetype:@"application/x-shared-library-la"];
	[self add:@"*.mdi" mimetype:@"image/vnd.ms-modi"];
	[self add:@"*.c" mimetype:@"text/x-csrc"];
	[self add:@"*.gv" mimetype:@"text/vnd.graphviz"];
	[self add:@"*.m3u8" mimetype:@"audio/x-mpegurl"];
	[self add:@"*.e" mimetype:@"text/x-eiffel"];
	[self add:@"*.pict1" mimetype:@"image/x-pict"];
	[self add:@"*.pict2" mimetype:@"image/x-pict"];
	[self add:@"*.spd" mimetype:@"application/x-font-speedo"];
	[self add:@"*.spc" mimetype:@"application/x-pkcs7-certificates"];
	[self add:@"*.gz" mimetype:@"application/x-gzip"];
	[self add:@"*.dtd" mimetype:@"application/xml-dtd"];
	[self add:@"*.dvi.gz" mimetype:@"application/x-gzdvi"];
	[self add:@"*.h" mimetype:@"text/x-chdr"];
	[self add:@"*.o" mimetype:@"application/x-object"];
	[self add:@"*.spl" mimetype:@"application/x-shockwave-flash"];
	[self add:@"*.etheme" mimetype:@"application/x-e-theme"];
	[self add:@"*.d" mimetype:@"text/x-dsrc"];
	[self add:@"*.sr2" mimetype:@"image/x-sony-sr2"];
	[self add:@"*.t" mimetype:@"text/troff"];
	[self add:@"*.hh" mimetype:@"text/x-c++hdr"];
	[self add:@"*.m" mimetype:@"text/x-objcsrc"];
	[self add:@"*.m" mimetype:@"text/x-matlab"];
	[self add:@"*.ps.bz2" mimetype:@"application/x-bzpostscript"];
	[self add:@"*.anx" mimetype:@"application/annodex"];
	[self add:@"*.crt" mimetype:@"application/x-x509-ca-cert"];
	[self add:@"*.med" mimetype:@"audio/x-mod"];
	[self add:@"*.crw" mimetype:@"image/x-canon-crw"];
	[self add:@"*.spx" mimetype:@"audio/ogg"];
	[self add:@"*.spx" mimetype:@"audio/x-speex"];
	[self add:@"*.xliff" mimetype:@"application/x-xliff"];
	[self add:@"*.ani" mimetype:@"application/x-navi-animation"];
	[self add:@"*.hp" mimetype:@"text/x-c++hdr"];
	[self add:@"*.vhdl" mimetype:@"text/x-vhdl"];
	[self add:@"*.f" mimetype:@"text/x-fortran"];
	[self add:@"*.hs" mimetype:@"text/x-haskell"];
	[self add:@"*.epub" mimetype:@"application/epub+zip"];
	[self add:@"*.kar" mimetype:@"audio/midi"];
	[self add:@"*.mpga" mimetype:@"audio/mpeg"];
	[self add:@"*.dtx" mimetype:@"text/x-tex"];
	[self add:@"*.pptx" mimetype:@"application/vnd.openxmlformats-officedocument.presentationml.presentation"];
	[self add:@"*.dsl" mimetype:@"text/x-dsl"];
	[self add:@"*.csh" mimetype:@"application/x-csh"];
	[self add:@"*.nfo" mimetype:@"text/x-nfo"];
	[self add:@"*.pkr" mimetype:@"application/pgp-keys"];
	[self add:@"*.epsi.bz2" mimetype:@"image/x-bzeps"];
	[self add:@"*.spec" mimetype:@"text/x-rpm-spec"];
	[self add:@"*.f90" mimetype:@"text/x-fortran"];
	[self add:@"*.sql" mimetype:@"text/x-sql"];
	[self add:@"*.css" mimetype:@"text/css"];
	[self add:@"*.f95" mimetype:@"text/x-fortran"];
	[self add:@"*.csv" mimetype:@"text/csv"];
	[self add:@"*.epsi" mimetype:@"image/x-eps"];
	[self add:@"*.tsv" mimetype:@"text/tab-separated-values"];
	[self add:@"*.pla" mimetype:@"audio/x-iriver-pla"];
	[self add:@"*.it" mimetype:@"audio/x-it"];
	[self add:@"*.ape" mimetype:@"audio/x-ape"];
	[self add:@"*.src" mimetype:@"application/x-wais-source"];
	[self add:@"*.tta" mimetype:@"audio/x-tta"];
	[self add:@"*.ttc" mimetype:@"application/x-font-ttf"];
	[self add:@"*.srf" mimetype:@"image/x-sony-srf"];
	[self add:@"*.pln" mimetype:@"application/x-planperfect"];
	[self add:@"*.ttf" mimetype:@"application/x-font-ttf"];
	[self add:@"*.exe" mimetype:@"application/x-ms-dos-executable"];
	[self add:@"*.abw.gz" mimetype:@"application/x-abiword"];
	[self add:@"*.chrt" mimetype:@"application/x-kchart"];
	[self add:@"*.dvi" mimetype:@"application/x-dvi"];
	[self add:@"*.rpm" mimetype:@"application/x-rpm"];
	[self add:@"*.epsf.gz" mimetype:@"image/x-gzeps"];
	[self add:@"*.pls" mimetype:@"audio/x-scpls"];
	[self add:@"*.gcrd" mimetype:@"text/directory"];
	[self add:@"*.t2t" mimetype:@"text/x-txt2tags"];
	[self add:@"*.srt" mimetype:@"application/x-subrip"];
	[self add:@"*.exr" mimetype:@"image/x-exr"];
	[self add:@"*.pntg" mimetype:@"image/x-macpaint"];
	[self add:@"*.ttx" mimetype:@"application/x-font-ttx"];
	[self add:@"*.jad" mimetype:@"text/vnd.sun.j2me.app-descriptor"];
	[self add:@"*.js" mimetype:@"application/javascript"];
	[self add:@"*.latex" mimetype:@"text/x-tex"];
	[self add:@"*.jar" mimetype:@"application/x-java-archive"];
	[self add:@"*.ssa" mimetype:@"text/x-ssa"];
	[self add:@"*.xspf" mimetype:@"application/xspf+xml"];
	[self add:@"*.mgp" mimetype:@"application/x-magicpoint"];
	[self add:@"*.movie" mimetype:@"video/x-sgi-movie"];
	[self add:@"*.cue" mimetype:@"application/x-cue"];
	[self add:@"*.html" mimetype:@"text/html"];
	[self add:@"*.smaf" mimetype:@"application/x-smaf"];
	[self add:@"*.zabw" mimetype:@"application/x-abiword"];
	[self add:@"*.dwg" mimetype:@"image/vnd.dwg"];
	[self add:@"authors" mimetype:@"text/x-authors"];
	[self add:@"*.msod" mimetype:@"image/x-msod"];
	[self add:@"*.xslfo" mimetype:@"text/x-xslfo"];
	[self add:@"*.mrml" mimetype:@"text/x-mrml"];
	[self add:@"*.kdc" mimetype:@"image/x-kodak-kdc"];
	[self add:@"*.cur" mimetype:@"image/x-win-bitmap"];
	[self add:@"*.gnucash" mimetype:@"application/x-gnucash"];
	[self add:@"*.pkipath" mimetype:@"application/pkix-pkipath"];
	[self add:@"*.p" mimetype:@"text/x-pascal"];
	[self add:@"*.patch" mimetype:@"text/x-patch"];
	[self add:@"*.old" mimetype:@"application/x-trash"];
	[self add:@"*.m4" mimetype:@"application/x-m4"];
	[self add:@"*.mbox" mimetype:@"application/mbox"];
	[self add:@"*.png" mimetype:@"image/png"];
	[self add:@"*.stc" mimetype:@"application/vnd.sun.xml.calc.template"];
	[self add:@"*.std" mimetype:@"application/vnd.sun.xml.draw.template"];
	[self add:@"*.arj" mimetype:@"application/x-arj"];
	[self add:@"*.pnm" mimetype:@"image/x-portable-anymap"];
	[self add:@"*.dxf" mimetype:@"image/vnd.dxf"];
	[self add:@"*.sti" mimetype:@"application/vnd.sun.xml.impress.template"];
	[self add:@"*.gplt" mimetype:@"application/x-gnuplot"];
	[self add:@"*.la" mimetype:@"application/x-shared-library-la"];
	[self add:@"*.stm" mimetype:@"audio/x-stm"];
	[self add:@"*.pcf.gz" mimetype:@"application/x-font-pcf"];
	[self add:@"*.kexic" mimetype:@"application/x-kexi-connectiondata"];
	[self add:@"*.arw" mimetype:@"image/x-sony-arw"];
	[self add:@"*.mid" mimetype:@"audio/midi"];
	[self add:@"*.stw" mimetype:@"application/vnd.sun.xml.writer.template"];
	[self add:@"*.mif" mimetype:@"application/x-mif"];
	[self add:@"*.sty" mimetype:@"text/x-tex"];
	[self add:@"*.hpgl" mimetype:@"application/vnd.hp-hpgl"];
	[self add:@"*.asc" mimetype:@"application/pgp-encrypted"];
	[self add:@"*.asc" mimetype:@"application/pgp-keys"];
	[self add:@"*.asc" mimetype:@"text/plain"];
	[self add:@"*.sub" mimetype:@"text/x-microdvd"];
	[self add:@"*.sub" mimetype:@"text/x-mpsub"];
	[self add:@"*.sub" mimetype:@"text/x-subviewer"];
	[self add:@"*.ly" mimetype:@"text/x-lilypond"];
	[self add:@"*.lz" mimetype:@"application/x-lzip"];
	[self add:@"*.kexis" mimetype:@"application/x-kexiproject-shortcut"];
	[self add:@"*.asf" mimetype:@"video/x-ms-asf"];
	[self add:@"*.wmls" mimetype:@"text/vnd.wap.wmlscript"];
	[self add:@"*.s3m" mimetype:@"audio/x-s3m"];
	[self add:@"*.por" mimetype:@"application/x-spss-por"];
	[self add:@"*.asp" mimetype:@"application/x-asp"];
	[self add:@"*.pot" mimetype:@"application/vnd.ms-powerpoint"];
	[self add:@"*.pot" mimetype:@"text/x-gettext-translation-template"];
	[self add:@"*.sun" mimetype:@"image/x-sun-raster"];
	[self add:@"*.ass" mimetype:@"text/x-ssa"];
	[self add:@"*.rss" mimetype:@"application/rss+xml"];
	[self add:@"*.lha" mimetype:@"application/x-lha"];
	[self add:@"*.md" mimetype:@"application/x-genesis-rom"];
	[self add:@"*.me" mimetype:@"text/x-troff-me"];
	[self add:@"*.sami" mimetype:@"application/x-sami"];
	[self add:@"*.asx" mimetype:@"audio/x-ms-asx"];
	[self add:@"*.mm" mimetype:@"text/x-troff-mm"];
	[self add:@"*.mo" mimetype:@"application/x-gettext-translation"];
	[self add:@"CMakeLists.txt" mimetype:@"text/x-cmake"];
	[self add:@"*.ml" mimetype:@"text/x-ocaml"];
	[self add:@"*.ms" mimetype:@"text/x-troff-ms"];
	[self add:@"*.kfo" mimetype:@"application/x-kformula"];
	[self add:@"*.rtf" mimetype:@"application/rtf"];
	[self add:@"*.lhs" mimetype:@"text/x-literate-haskell"];
	[self add:@"*.svg" mimetype:@"image/svg+xml"];
	[self add:@"*.ppm" mimetype:@"image/x-portable-pixmap"];
	[self add:@"*.nb" mimetype:@"application/mathematica"];
	[self add:@"*.lhz" mimetype:@"application/x-lhz"];
	[self add:@"*.pps" mimetype:@"application/vnd.ms-powerpoint"];
	[self add:@"*.ppt" mimetype:@"application/vnd.ms-powerpoint"];
	[self add:@"*.nc" mimetype:@"application/x-netcdf"];
	[self add:@"*.icb" mimetype:@"image/x-tga"];
	[self add:@"*.ica" mimetype:@"application/x-ica"];
	[self add:@"*.mka" mimetype:@"audio/x-matroska"];
	[self add:@"*.ppz" mimetype:@"application/vnd.ms-powerpoint"];
	[self add:@"*.txt" mimetype:@"text/plain"];
	[self add:@"*.rtx" mimetype:@"text/richtext"];
	[self add:@"*.gedcom" mimetype:@"application/x-gedcom"];
	[self add:@"*.cxx" mimetype:@"text/x-c++src"];
	[self add:@"*.ico" mimetype:@"image/vnd.microsoft.icon"];
	[self add:@"*.metalink" mimetype:@"application/metalink+xml"];
	[self add:@"*.txz" mimetype:@"application/x-xz-compressed-tar"];
	[self add:@"*.ics" mimetype:@"text/calendar"];
	[self add:@"*.p10" mimetype:@"application/pkcs10"];
	[self add:@"gnumakefile" mimetype:@"text/x-makefile"];
	[self add:@"*.p12" mimetype:@"application/x-pkcs12"];
	[self add:@"*.swf" mimetype:@"application/x-shockwave-flash"];
	[self add:@"*.mkv" mimetype:@"video/x-matroska"];
	[self add:@"*.idl" mimetype:@"text/x-idl"];
	[self add:@"*.prc" mimetype:@"application/x-palm-database"];
	[self add:@"*.mli" mimetype:@"text/x-ocaml"];
	[self add:@"*.tar.lzo" mimetype:@"application/x-tzo"];
	[self add:@"*.sxc" mimetype:@"application/vnd.sun.xml.calc"];
	[self add:@"*.sxd" mimetype:@"application/vnd.sun.xml.draw"];
	[self add:@"*.cert" mimetype:@"application/x-x509-ca-cert"];
	[self add:@"*.avi" mimetype:@"video/x-msvideo"];
	[self add:@"*.sxg" mimetype:@"application/vnd.sun.xml.writer.global"];
	[self add:@"*.qtl" mimetype:@"application/x-quicktime-media-link"];
	[self add:@"*.sxi" mimetype:@"application/vnd.sun.xml.impress"];
	[self add:@"*.xac" mimetype:@"application/x-gnucash"];
	[self add:@"*.djvu" mimetype:@"image/vnd.djvu"];
	[self add:@"*.sxm" mimetype:@"application/vnd.sun.xml.math"];
	[self add:@"winmail.dat" mimetype:@"application/vnd.ms-tnef"];
	[self add:@"*.bz2" mimetype:@"application/x-bzip"];
	[self add:@"*.ief" mimetype:@"image/ief"];
	[self add:@"*.tzo" mimetype:@"application/x-tzo"];
	[self add:@"*.pk" mimetype:@"application/x-tex-pk"];
	[self add:@"*.pl" mimetype:@"application/x-perl"];
	[self add:@"*.rvx" mimetype:@"video/vnd.rn-realvideo"];
	[self add:@"*.sxw" mimetype:@"application/vnd.sun.xml.writer"];
	[self add:@"*.php4" mimetype:@"application/x-php"];
	[self add:@"*.mmf" mimetype:@"application/x-smaf"];
	[self add:@"*.BLEND" mimetype:@"application/x-blender"];
	[self add:@"*.kil" mimetype:@"application/x-killustrator"];
	[self add:@"*.pm" mimetype:@"application/x-perl"];
	[self add:@"*.ps" mimetype:@"application/postscript"];
	[self add:@"*.awb" mimetype:@"audio/AMR-WB"];
	[self add:@"*.psf" mimetype:@"application/x-font-linux-psf"];
	[self add:@"*.psf" mimetype:@"audio/x-psf"];
	[self add:@"*.pw" mimetype:@"application/x-pw"];
	[self add:@"*.aifc" mimetype:@"audio/x-aiff"];
	[self add:@"*.mml" mimetype:@"text/mathml"];
	[self add:@"*.psd" mimetype:@"image/vnd.adobe.photoshop"];
	[self add:@"*.mo3" mimetype:@"audio/x-mo3"];
	[self add:@"*.aiff" mimetype:@"audio/x-aiff"];
	[self add:@"*.gba" mimetype:@"application/x-gba-rom"];
	[self add:@"*.awk" mimetype:@"application/x-awk"];
	[self add:@"*.not" mimetype:@"text/x-mup"];
	[self add:@"changelog" mimetype:@"text/x-changelog"];
	[self add:@"*.sv4cpio" mimetype:@"application/x-sv4cpio"];
	[self add:@"*%" mimetype:@"application/x-trash"];
	[self add:@"*.po" mimetype:@"text/x-gettext-translation"];
	[self add:@"*.hdf" mimetype:@"application/x-hdf"];
	[self add:@"*.psw" mimetype:@"application/x-pocket-word"];
	[self add:@"*.tar.bz" mimetype:@"application/x-bzip-compressed-tar"];
	[self add:@"*.php3" mimetype:@"application/x-php"];
	[self add:@"*.desktop" mimetype:@"application/x-desktop"];
	[self add:@"*.fb2" mimetype:@"application/x-fictionbook+xml"];
	[self add:@"*.wb1" mimetype:@"application/x-quattropro"];
	[self add:@"*.wb2" mimetype:@"application/x-quattropro"];
	[self add:@"*.ora" mimetype:@"image/openraster"];
	[self add:@"*.wb3" mimetype:@"application/x-quattropro"];
	[self add:@"*.iff" mimetype:@"image/x-iff"];
	[self add:@"*.mp+" mimetype:@"audio/x-musepack"];
	[self add:@"*.axa" mimetype:@"audio/annodex"];
	[self add:@"*.orf" mimetype:@"image/x-olympus-orf"];
	[self add:@"*.xbm" mimetype:@"image/x-xbitmap"];
	[self add:@"copying" mimetype:@"text/x-copying"];
	[self add:@"*.mp2" mimetype:@"audio/mp2"];
	[self add:@"*.mp2" mimetype:@"video/mpeg"];
	[self add:@"*.mp3" mimetype:@"audio/mpeg"];
	[self add:@"*.mp4" mimetype:@"video/mp4"];
	[self add:@"*.py" mimetype:@"text/x-python"];
	[self add:@"*.kino" mimetype:@"application/smil"];
	[self add:@"*.ra" mimetype:@"audio/vnd.rn-realaudio"];
	[self add:@"*.rb" mimetype:@"application/x-ruby"];
	[self add:@"*.icns" mimetype:@"image/x-icns"];
	[self add:@"*.qt" mimetype:@"video/quicktime"];
	[self add:@"*.xcf" mimetype:@"image/x-xcf"];
	[self add:@"*.mng" mimetype:@"video/x-mng"];
	[self add:@"*.xbl" mimetype:@"application/xml"];
	[self add:@"*.axv" mimetype:@"video/annodex"];
	[self add:@"*.cpio" mimetype:@"application/x-cpio"];
	[self add:@"*.rm" mimetype:@"application/vnd.rn-realmedia"];
	[self add:@"*.mod" mimetype:@"audio/x-mod"];
	[self add:@"*.sv4crc" mimetype:@"application/x-sv4crc"];
	[self add:@"*.rp" mimetype:@"image/vnd.rn-realpix"];
	[self add:@"*.mof" mimetype:@"text/x-mof"];
	[self add:@"*.wav" mimetype:@"audio/x-wav"];
	[self add:@"*.rt" mimetype:@"text/vnd.rn-realtext"];
	[self add:@"*.wax" mimetype:@"audio/x-ms-asx"];
	[self add:@"*.rv" mimetype:@"video/vnd.rn-realvideo"];
	[self add:@"*.moc" mimetype:@"text/x-moc"];
	[self add:@"*.siag" mimetype:@"application/x-siag"];
	[self add:@"*.pack" mimetype:@"application/x-java-pack200"];
	[self add:@"*.gnumeric" mimetype:@"application/x-gnumeric"];
	[self add:@"*.tnef" mimetype:@"application/vnd.ms-tnef"];
	[self add:@"*.tpic" mimetype:@"image/x-tga"];
	[self add:@"*.mov" mimetype:@"video/quicktime"];
	[self add:@"*.smil" mimetype:@"application/smil"];
	[self add:@"*.sh" mimetype:@"application/x-shellscript"];
	[self add:@"*.divx" mimetype:@"video/x-msvideo"];
	[self add:@"*.sk" mimetype:@"image/x-skencil"];
	[self add:@"*.moov" mimetype:@"video/quicktime"];
	[self add:@"*.mpc" mimetype:@"audio/x-musepack"];
	[self add:@"*.so" mimetype:@"application/x-sharedlib"];
	[self add:@"*.mpe" mimetype:@"video/mpeg"];
	[self add:@"*.otc" mimetype:@"application/vnd.oasis.opendocument.chart-template"];
	[self add:@"*.midi" mimetype:@"audio/midi"];
	[self add:@"*.otf" mimetype:@"application/vnd.oasis.opendocument.formula-template"];
	[self add:@"*.otf" mimetype:@"application/x-font-otf"];
	[self add:@"*.otg" mimetype:@"application/vnd.oasis.opendocument.graphics-template"];
	[self add:@"*.oth" mimetype:@"application/vnd.oasis.opendocument.text-web"];
	[self add:@"*.mpg" mimetype:@"video/mpeg"];
	[self add:@"*.mpp" mimetype:@"audio/x-musepack"];
	[self add:@"*.otp" mimetype:@"application/vnd.oasis.opendocument.presentation-template"];
	[self add:@"*~" mimetype:@"application/x-trash"];
	[self add:@"*.ged" mimetype:@"application/x-gedcom"];
	[self add:@"*.ots" mimetype:@"application/vnd.oasis.opendocument.spreadsheet-template"];
	[self add:@"*.ott" mimetype:@"application/vnd.oasis.opendocument.text-template"];
	[self add:@"*.tar.lzma" mimetype:@"application/x-lzma-compressed-tar"];
	[self add:@"*.docm" mimetype:@"application/vnd.openxmlformats-officedocument.wordprocessingml.document"];
	[self add:@"makefile" mimetype:@"text/x-makefile"];
	[self add:@"*.wcm" mimetype:@"application/vnd.ms-works"];
	[self add:@"*.tk" mimetype:@"text/x-tcl"];
	[self add:@"*.gen" mimetype:@"application/x-genesis-rom"];
	[self add:@"*.docx" mimetype:@"application/vnd.openxmlformats-officedocument.wordprocessingml.document"];
	[self add:@"*.log" mimetype:@"text/x-log"];
	[self add:@"*.nsc" mimetype:@"application/x-netshow-channel"];
	[self add:@"*.egon" mimetype:@"application/x-egon"];
	[self add:@"*.tr" mimetype:@"text/troff"];
	[self add:@"*.ts" mimetype:@"application/x-linguist"];
	[self add:@"*.zip" mimetype:@"application/zip"];
	[self add:@"*.kml" mimetype:@"application/vnd.google-earth.kml+xml"];
	[self add:@"*.iptables" mimetype:@"text/x-iptables"];
	[self add:@"*.m15" mimetype:@"audio/x-mod"];
	[self add:@"*.wdb" mimetype:@"application/vnd.ms-works"];
	[self add:@"*.kmz" mimetype:@"application/vnd.google-earth.kmz"];
	[self add:@"*.shar" mimetype:@"application/x-shar"];
	[self add:@"*.nsv" mimetype:@"video/x-nsv"];
	[self add:@"*.texinfo" mimetype:@"text/x-texinfo"];
	[self add:@"*.so.[0-9].*" mimetype:@"application/x-sharedlib"];
	[self add:@"*.ui" mimetype:@"application/x-designer"];
	[self add:@"*.ilbm" mimetype:@"image/x-ilbm"];
	[self add:@"*.3ds" mimetype:@"image/x-3ds"];
	[self add:@"*.vbs" mimetype:@"application/x-vbscript"];
	[self add:@"*.mrl" mimetype:@"text/x-mrml"];
	[self add:@"*.vcf" mimetype:@"text/directory"];
	[self add:@"*.mrw" mimetype:@"image/x-minolta-mrw"];
	[self add:@"*.jpeg" mimetype:@"image/jpeg"];
	[self add:@"*.3g2" mimetype:@"video/3gpp"];
	[self add:@"*.dar" mimetype:@"application/x-dar"];
	[self add:@"*.tar.gz" mimetype:@"application/x-compressed-tar"];
	[self add:@"*.p7b" mimetype:@"application/x-pkcs7-certificates"];
	[self add:@"*.lzma" mimetype:@"application/x-lzma"];
	[self add:@"*.vct" mimetype:@"text/directory"];
	[self add:@"*.vcs" mimetype:@"text/calendar"];
	[self add:@"*.msi" mimetype:@"application/x-msi"];
	[self add:@"*.msi" mimetype:@"application/x-ms-win-installer"];
	[self add:@"*.psid" mimetype:@"audio/prs.sid"];
	[self add:@"*.kon" mimetype:@"application/x-kontour"];
	[self add:@"*.blender" mimetype:@"application/x-blender"];
	[self add:@"*.pyc" mimetype:@"application/x-python-bytecode"];
	[self add:@"*.owl" mimetype:@"application/rdf+xml"];
	[self add:@"*.vda" mimetype:@"image/x-tga"];
	[self add:@"*.dbf" mimetype:@"application/x-dbf"];
	[self add:@"*.p7s" mimetype:@"application/pkcs7-signature"];
	[self add:@"*.pyo" mimetype:@"application/x-python-bytecode"];
	[self add:@"*.msx" mimetype:@"application/x-msx-rom"];
	[self add:@"*.epsf.bz2" mimetype:@"image/x-bzeps"];
	[self add:@"*.cb7" mimetype:@"application/x-cb7"];
	[self add:@"*.jng" mimetype:@"image/x-jng"];
	[self add:@"*.texi" mimetype:@"text/x-texinfo"];
	[self add:@"*.so.[0-9]" mimetype:@"application/x-sharedlib"];
	[self add:@"*.wp" mimetype:@"application/vnd.wordperfect"];
	[self add:@"*.kpm" mimetype:@"application/x-kpovmodeler"];
	[self add:@"*.jp2" mimetype:@"image/jp2"];
	[self add:@"*.wv" mimetype:@"audio/x-wavpack"];
	[self add:@"*.cab" mimetype:@"application/vnd.ms-cab-compressed"];
	[self add:@"*.kpr" mimetype:@"application/x-kpresenter"];
	[self add:@"*.3ga" mimetype:@"video/3gpp"];
	[self add:@"*.kpt" mimetype:@"application/x-kpresenter"];
	[self add:@"*.n64" mimetype:@"application/x-n64-rom"];
	[self add:@"*.mtm" mimetype:@"audio/x-mod"];
	[self add:@"*.m2t" mimetype:@"video/mpeg"];
	[self add:@"*.glade" mimetype:@"application/x-glade"];
	[self add:@"*.oxt" mimetype:@"application/vnd.openofficeorg.extension"];
	[self add:@"*.iso9660" mimetype:@"application/x-cd-image"];
	[self add:@"*.gif" mimetype:@"image/gif"];
	[self add:@"*.dcm" mimetype:@"application/dicom"];
	[self add:@"*.ime" mimetype:@"text/x-iMelody"];
	[self add:@"*.h++" mimetype:@"text/x-c++hdr"];
	[self add:@"*.3gp" mimetype:@"video/3gpp"];
	[self add:@"*.tar" mimetype:@"application/x-tar"];
	[self add:@"*.dcr" mimetype:@"image/x-kodak-dcr"];
	[self add:@"*.xi" mimetype:@"audio/x-xi"];
	[self add:@"*.xm" mimetype:@"audio/x-xm"];
	[self add:@"*.dcl" mimetype:@"text/x-dcl"];
	[self add:@"*.3gpp" mimetype:@"video/3gpp"];
	[self add:@"*.kdelnk" mimetype:@"application/x-desktop"];
	[self add:@"*.vivo" mimetype:@"video/vivo"];
	[self add:@"*.xz" mimetype:@"application/x-xz"];
	[self add:@"*.imy" mimetype:@"text/x-iMelody"];
	[self add:@"*.m3u" mimetype:@"audio/x-mpegurl"];
	[self add:@"*.mup" mimetype:@"text/x-mup"];
	[self add:@"*.kra" mimetype:@"application/x-krita"];
	[self add:@"*.cbr" mimetype:@"application/x-cbr"];
	[self add:@"*.m4b" mimetype:@"audio/x-m4b"];
	[self add:@"*.cbt" mimetype:@"application/x-cbt"];
	[self add:@"*.cpio.gz" mimetype:@"application/x-cpio-compressed"];
	[self add:@"*.jpg" mimetype:@"image/jpeg"];
	[self add:@"*.m4a" mimetype:@"audio/mp4"];
	[self add:@"*.dds" mimetype:@"image/x-dds"];
	[self add:@"*.jpe" mimetype:@"image/jpeg"];
	[self add:@"*.cbz" mimetype:@"application/x-cbz"];
	[self add:@"*.jpc" mimetype:@"image/jp2"];
	[self add:@"*.tbz" mimetype:@"application/x-bzip-compressed-tar"];
	[self add:@"*.eps.bz2" mimetype:@"image/x-bzeps"];
	[self add:@"*.jpf" mimetype:@"image/jp2"];
	[self add:@"*.k25" mimetype:@"image/x-kodak-k25"];
	[self add:@"*.jpr" mimetype:@"application/x-jbuilder-project"];
	[self add:@"*.7z" mimetype:@"application/x-7z-compressed"];
	[self add:@"*.ins" mimetype:@"text/x-tex"];
	[self add:@"*.deb" mimetype:@"application/x-deb"];
	[self add:@"*.ini" mimetype:@"text/plain"];
	[self add:@"*.psf.gz" mimetype:@"application/x-gz-font-linux-psf"];
	[self add:@"*.jpx" mimetype:@"application/x-jbuilder-project"];
	[self add:@"*.jpx" mimetype:@"image/jp2"];
	[self add:@"*.m4v" mimetype:@"video/mp4"];
	[self add:@"*.bak" mimetype:@"application/x-trash"];
	[self add:@"*.rmvb" mimetype:@"application/vnd.rn-realmedia"];
	[self add:@"gmon.out" mimetype:@"application/x-profile"];
	[self add:@"*.perl" mimetype:@"application/x-perl"];
	[self add:@"*.sam" mimetype:@"application/x-amipro"];
	[self add:@"*.fig" mimetype:@"image/x-xfig"];
	[self add:@"*.bcpio" mimetype:@"application/x-bcpio"];
	[self add:@"*.gtar" mimetype:@"application/x-tar"];
	[self add:@"*.ltx" mimetype:@"text/x-tex"];
	[self add:@"*.lua" mimetype:@"text/x-lua"];
	[self add:@"*.der" mimetype:@"application/x-x509-ca-cert"];
	[self add:@"*.sav" mimetype:@"application/x-spss-sav"];
	[self add:@"*.wk1" mimetype:@"application/vnd.lotus-1-2-3"];
	[self add:@"*.tcl" mimetype:@"text/x-tcl"];
	[self add:@"*.wk3" mimetype:@"application/vnd.lotus-1-2-3"];
	[self add:@"*.wk4" mimetype:@"application/vnd.lotus-1-2-3"];
	[self add:@"*.zoo" mimetype:@"application/x-zoo"];
	[self add:@"*.xcf.gz" mimetype:@"image/x-compressed-xcf"];
	[self add:@"*.qtif" mimetype:@"image/x-quicktime"];
	[self add:@"*.oleo" mimetype:@"application/x-oleo"];
	[self add:@"*.ksp" mimetype:@"application/x-kspread"];
	[self add:@"*.ps.gz" mimetype:@"application/x-gzpostscript"];
	[self add:@"*.opml" mimetype:@"text/x-opml+xml"];
	[self add:@"*.cdf" mimetype:@"application/x-netcdf"];
	[self add:@"*.vhd" mimetype:@"text/x-vhdl"];
	[self add:@"*.xla" mimetype:@"application/vnd.ms-excel"];
	[self add:@"*.inf" mimetype:@"text/plain"];
	[self add:@"*.xlc" mimetype:@"application/vnd.ms-excel"];
	[self add:@"*.xld" mimetype:@"application/vnd.ms-excel"];
	[self add:@"*.xlf" mimetype:@"application/x-xliff"];
	[self add:@"*.cdr" mimetype:@"application/vnd.corel-draw"];
	[self add:@"*.xll" mimetype:@"application/vnd.ms-excel"];
	[self add:@"*.xlm" mimetype:@"application/vnd.ms-excel"];
	[self add:@"*.602" mimetype:@"application/x-t602"];
	[self add:@"*.mxf" mimetype:@"application/mxf"];
	[self add:@"*.xls" mimetype:@"application/vnd.ms-excel"];
	[self add:@"*.xlt" mimetype:@"application/vnd.ms-excel"];
	[self add:@"*.aac" mimetype:@"audio/mp4"];
	[self add:@"*.xlsm" mimetype:@"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"];
	[self add:@"*.xlw" mimetype:@"application/vnd.ms-excel"];
	[self add:@"*.docbook" mimetype:@"application/docbook+xml"];
	[self add:@"*.raf" mimetype:@"image/x-fuji-raf"];
	[self add:@"*.fits" mimetype:@"image/fits"];
	[self add:@"*.epsi.gz" mimetype:@"image/x-gzeps"];
	[self add:@"*.xlsx" mimetype:@"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"];
	[self add:@"*.rdfs" mimetype:@"application/rdf+xml"];
	[self add:@"*.ram" mimetype:@"application/ram"];
	[self add:@"*.eif" mimetype:@"text/x-eiffel"];
	[self add:@"*.scm" mimetype:@"text/x-scheme"];
	[self add:@"*.ac3" mimetype:@"audio/ac3"];
	[self add:@"*.rar" mimetype:@"application/x-rar"];
	[self add:@"*.xmf" mimetype:@"audio/x-xmf"];
	[self add:@"*.ras" mimetype:@"image/x-cmu-raster"];
	[self add:@"*.cer" mimetype:@"application/x-x509-ca-cert"];
	[self add:@"*.ldif" mimetype:@"text/x-ldif"];
	[self add:@"*.kud" mimetype:@"application/x-kugar"];
	[self add:@"*.rax" mimetype:@"audio/vnd.rn-realaudio"];
	[self add:@"*.xml" mimetype:@"application/xml"];
	[self add:@"*.gmo" mimetype:@"application/x-gettext-translation"];
	[self add:@"*.xmi" mimetype:@"text/x-xmi"];
	[self add:@"*.CSSL" mimetype:@"text/css"];
	[self add:@"*.wks" mimetype:@"application/vnd.lotus-1-2-3"];
	[self add:@"*.wks" mimetype:@"application/vnd.ms-works"];
	[self add:@"*.tbz2" mimetype:@"application/x-bzip-compressed-tar"];
	[self add:@"*.tex" mimetype:@"text/x-tex"];
	[self add:@"*.raw" mimetype:@"image/x-panasonic-raw"];
	[self add:@"*.sda" mimetype:@"application/vnd.stardivision.draw"];
	[self add:@"*.sdc" mimetype:@"application/vnd.stardivision.calc"];
	[self add:@"*.sdd" mimetype:@"application/vnd.stardivision.impress"];
	[self add:@"*.bdf" mimetype:@"application/x-font-bdf"];
	[self add:@"*.lwo" mimetype:@"image/x-lwo"];
	[self add:@"*.lws" mimetype:@"image/x-lws"];
	[self add:@"*.minipsf" mimetype:@"audio/x-minipsf"];
	[self add:@"*.flc" mimetype:@"video/x-flic"];
	[self add:@"*.gnc" mimetype:@"application/x-gnucash"];
	[self add:@"*.gnd" mimetype:@"application/gnunet-directory"];
	[self add:@"*.theme" mimetype:@"application/x-theme"];
	[self add:@"*.sdp" mimetype:@"application/vnd.stardivision.impress"];
	[self add:@"*.sdp" mimetype:@"application/sdp"];
	[self add:@"*.fli" mimetype:@"video/x-flic"];
	[self add:@"install" mimetype:@"text/x-install"];
	[self add:@"*.sds" mimetype:@"application/vnd.stardivision.chart"];
	[self add:@"*.abw" mimetype:@"application/x-abiword"];
	[self add:@"*.j2k" mimetype:@"image/jp2"];
	[self add:@"core" mimetype:@"application/x-core"];
	[self add:@"*.sdw" mimetype:@"application/vnd.stardivision.writer"];
	[self add:@"*.viv" mimetype:@"video/vivo"];
	[self add:@"*.pdf.gz" mimetype:@"application/x-gzpdf"];
	[self add:@"*.hpp" mimetype:@"text/x-c++hdr"];
	[self add:@"*.flv" mimetype:@"video/x-flv"];
	[self add:@"*.tiff" mimetype:@"image/tiff"];
	[self add:@"*.flw" mimetype:@"application/x-kivio"];
	[self add:@"*.ace" mimetype:@"application/x-ace"];
	[self add:@"*.dvi.bz2" mimetype:@"application/x-bzdvi"];
	[self add:@"*.dia" mimetype:@"application/x-dia-diagram"];
	[self add:@"*.pcf.Z" mimetype:@"application/x-font-pcf"];
	[self add:@"*.gnuplot" mimetype:@"application/x-gnuplot"];
	[self add:@"*.wma" mimetype:@"audio/x-ms-wma"];
	[self add:@"*.tga" mimetype:@"image/x-tga"];
	[self add:@"*.cgm" mimetype:@"image/cgm"];
	[self add:@"*.wmf" mimetype:@"image/x-wmf"];
	[self add:@"*.torrent" mimetype:@"application/x-bittorrent"];
	[self add:@"*.uil" mimetype:@"text/x-uil"];
	[self add:@"*.vala" mimetype:@"text/x-vala"];
	[self add:@"*.lwob" mimetype:@"image/x-lwo"];
	[self add:@"*.kwd" mimetype:@"application/x-kword"];
	[self add:@"*.wml" mimetype:@"text/vnd.wap.wml"];
	[self add:@"*.iso" mimetype:@"application/x-cd-image"];
	[self add:@"*.tgz" mimetype:@"application/x-compressed-tar"];
	[self add:@"*.adb" mimetype:@"text/x-adasrc"];
	[self add:@"*.wmv" mimetype:@"video/x-ms-wmv"];
	[self add:@"*.wmx" mimetype:@"audio/x-ms-asx"];
	[self add:@"*.rdf" mimetype:@"application/rdf+xml"];
	[self add:@"*.kwt" mimetype:@"application/x-kword"];
	[self add:@"*.vlc" mimetype:@"audio/x-mpegurl"];
	[self add:@"*.lyx" mimetype:@"application/x-lyx"];
	[self add:@"*.pdf.bz2" mimetype:@"application/x-bzpdf"];
	[self add:@"*.chm" mimetype:@"application/x-chm"];
	[self add:@"*.ufraw" mimetype:@"application/x-ufraw"];
	[self add:@"*.gpg" mimetype:@"application/pgp-encrypted"];
	[self add:@"*.ads" mimetype:@"text/x-adasrc"];
	[self add:@"*.tar.Z" mimetype:@"application/x-tarz"];
	[self add:@"*.xpm" mimetype:@"image/x-xpixmap"];
	[self add:@"*.djv" mimetype:@"image/vnd.djvu"];
	[self add:@"*.wp4" mimetype:@"application/vnd.wordperfect"];
	[self add:@"*.wp5" mimetype:@"application/vnd.wordperfect"];
	[self add:@"*.wp6" mimetype:@"application/vnd.wordperfect"];
	[self add:@"*.xps" mimetype:@"application/vnd.ms-xpsdocument"];
	[self add:@"*.lzh" mimetype:@"application/x-lha"];
	[self add:@"*.lzo" mimetype:@"application/x-lzop"];
	[self add:@"*.pak" mimetype:@"application/x-pak"];
	[self add:@"*.sgf" mimetype:@"application/x-go-sgf"];
	[self add:@"*.sylk" mimetype:@"text/spreadsheet"];
	[self add:@"*.tif" mimetype:@"image/tiff"];
	[self add:@"*.par2" mimetype:@"application/x-par2"];
	[self add:@"*.sgi" mimetype:@"image/x-sgi"];
	[self add:@"*.rej" mimetype:@"application/x-reject"];
	[self add:@"*.sgl" mimetype:@"application/vnd.stardivision.writer"];
	[self add:@"*.sgm" mimetype:@"text/sgml"];
	[self add:@"*.xcf.bz2" mimetype:@"image/x-compressed-xcf"];
	[self add:@"*.reg" mimetype:@"text/x-ms-regedit"];
	[self add:@"*.pas" mimetype:@"text/x-pascal"];
	[self add:@"*.emf" mimetype:@"image/x-emf"];
	[self add:@"*.emp" mimetype:@"application/vnd.emusic-emusic_package"];
	[self add:@"*.for" mimetype:@"text/x-fortran"];
	[self add:@"*.pbm" mimetype:@"image/x-portable-bitmap"];
	[self add:@"*.xbel" mimetype:@"application/x-xbel"];
	[self add:@"*.gra" mimetype:@"application/x-graphite"];
	[self add:@"*.afm" mimetype:@"application/x-font-afm"];
	[self add:@"*.wpd" mimetype:@"application/vnd.wordperfect"];
	[self add:@"*.shn" mimetype:@"application/x-shorten"];
	[self add:@"*.wpg" mimetype:@"application/x-wpg"];
	[self add:@"*.svgz" mimetype:@"image/svg+xml-compressed"];
	[self add:@"*.cmake" mimetype:@"text/x-cmake"];
	[self add:@"*.tar.bz2" mimetype:@"application/x-bzip-compressed-tar"];
	[self add:@"*.wpl" mimetype:@"application/vnd.ms-wpl"];
	[self add:@"*.dll" mimetype:@"application/x-sharedlib"];
	[self add:@"*.ult" mimetype:@"audio/x-mod"];
	[self add:@"*.wpp" mimetype:@"application/vnd.wordperfect"];
	[self add:@"*.ent" mimetype:@"application/xml-external-parsed-entity"];
	[self add:@"*.wps" mimetype:@"application/vnd.ms-works"];
	[self add:@"*.669" mimetype:@"audio/x-mod"];
	[self add:@"*.jnlp" mimetype:@"application/x-java-jnlp-file"];
	[self add:@"*.pcf" mimetype:@"application/x-font-pcf"];
	[self add:@"*.pcf" mimetype:@"application/x-cisco-vpn-settings"];
	[self add:@"*.pcd" mimetype:@"image/x-photo-cd"];
	[self add:@"*.bib" mimetype:@"text/x-bibtex"];
	[self add:@"*.rgb" mimetype:@"image/x-rgb"];
	[self add:@"*.sid" mimetype:@"audio/prs.sid"];
	[self add:@"*.pcl" mimetype:@"application/vnd.hp-pcl"];
	[self add:@"*.c++" mimetype:@"text/x-c++src"];
	[self add:@"*.htm" mimetype:@"text/html"];
	[self add:@"*.voc" mimetype:@"audio/x-voc"];
	[self add:@"*.sik" mimetype:@"application/x-trash"];
	[self add:@"*.vapi" mimetype:@"text/x-vala"];
	[self add:@"*.bin" mimetype:@"application/octet-stream"];
	[self add:@"*.vob" mimetype:@"video/mpeg"];
	[self add:@"*.gsf" mimetype:@"application/x-font-type1"];
	[self add:@"*.sk1" mimetype:@"image/x-skencil"];
	[self add:@"*.ag" mimetype:@"image/x-applix-graphics"];
	[self add:@"*.ai" mimetype:@"application/illustrator"];
	[self add:@"*.sis" mimetype:@"application/vnd.symbian.install"];
	[self add:@"*.sit" mimetype:@"application/x-stuffit"];
	[self add:@"*.al" mimetype:@"application/x-perl"];
	[self add:@"*.gsm" mimetype:@"audio/x-gsm"];
	[self add:@"*.siv" mimetype:@"application/sieve"];
	[self add:@"*.vor" mimetype:@"application/vnd.stardivision.writer"];
	[self add:@"*.xsl" mimetype:@"application/xml"];
	[self add:@"*.diff" mimetype:@"text/x-patch"];
	[self add:@"*.pdb" mimetype:@"application/x-aportisdoc"];
	[self add:@"*.pdb" mimetype:@"application/x-palm-database"];
	[self add:@"*.pdc" mimetype:@"application/x-aportisdoc"];
	[self add:@"*.as" mimetype:@"application/x-applix-spreadsheet"];
	[self add:@"*.au" mimetype:@"audio/basic"];
	[self add:@"*.pdf" mimetype:@"application/pdf"];
	[self add:@"*.aw" mimetype:@"application/x-applix-word"];
	[self add:@"*.obj" mimetype:@"application/x-tgif"];
	[self add:@"*.sgml" mimetype:@"text/sgml"];
	[self add:@"*.pcx" mimetype:@"image/x-pcx"];
	[self add:@"*.dng" mimetype:@"image/x-adobe-dng"];
	[self add:@"*.uni" mimetype:@"audio/x-mod"];
	[self add:@"*.wbmp" mimetype:@"image/vnd.wap.wbmp"];
	[self add:@"*.wri" mimetype:@"application/x-mswrite"];
	[self add:@"*.java" mimetype:@"text/x-java"];
	[self add:@"*.wrl" mimetype:@"model/vrml"];
	[self add:@"*.flac" mimetype:@"audio/x-flac"];
	[self add:@"*.cls" mimetype:@"text/x-tex"];
	[self add:@"*.eps" mimetype:@"image/x-eps"];
	[self add:@"*.kexi" mimetype:@"application/x-kexiproject-sqlite2"];
	[self add:@"*.kexi" mimetype:@"application/x-kexiproject-sqlite3"];
	[self add:@"*.tlz" mimetype:@"application/x-lzma-compressed-tar"];
	[self add:@"*.pef" mimetype:@"image/x-pentax-pef"];
	[self add:@"*.aif" mimetype:@"audio/x-aiff"];
	[self add:@"*.ocl" mimetype:@"text/x-ocl"];
	[self add:@"*.class" mimetype:@"application/x-java"];
	[self add:@"*.doc" mimetype:@"application/msword"];
	[self add:@"*.pem" mimetype:@"application/x-x509-ca-cert"];
	[self add:@"*.bz" mimetype:@"application/x-bzip"];
	[self add:@"makefile" mimetype:@"text/x-makefile"];
	[self add:@"*.x3f" mimetype:@"image/x-sigma-x3f"];
	[self add:@"*.cc" mimetype:@"text/x-c++src"];
	[self add:@"*.skr" mimetype:@"application/pgp-keys"];
	[self add:@"*.xul" mimetype:@"application/vnd.mozilla.xul+xml"];
	[self add:@"*.xul" mimetype:@"application/vnd.mozilla.xul+xml"];
	[self add:@"*.dot" mimetype:@"application/msword-template"];
	[self add:@"*.dot" mimetype:@"text/vnd.graphviz"];
	[self add:@"*.oda" mimetype:@"application/oda"];
	[self add:@"*.odb" mimetype:@"application/vnd.oasis.opendocument.database"];
	[self add:@"*.odc" mimetype:@"application/vnd.oasis.opendocument.chart"];
	[self add:@"*.pict" mimetype:@"image/x-pict"];
	[self add:@"*.pfb" mimetype:@"application/x-font-type1"];
	[self add:@"*.odf" mimetype:@"application/vnd.oasis.opendocument.formula"];
	[self add:@"*.odg" mimetype:@"application/vnd.oasis.opendocument.graphics"];
	[self add:@"*.karbon" mimetype:@"application/x-karbon"];
	[self add:@"*.odi" mimetype:@"application/vnd.oasis.opendocument.image"];
	[self add:@"*.hwp" mimetype:@"application/x-hwp"];
	[self add:@"*.xhtml" mimetype:@"application/xhtml+xml"];
	[self add:@"*.odm" mimetype:@"application/vnd.oasis.opendocument.text-master"];
	[self add:@"*.hwt" mimetype:@"application/x-hwt"];
	[self add:@"credits" mimetype:@"text/x-credits"];
	[self add:@"*.odp" mimetype:@"application/vnd.oasis.opendocument.presentation"];
	[self add:@"*.tnf" mimetype:@"application/vnd.ms-tnef"];
	[self add:@"*.pfa" mimetype:@"application/x-font-type1"];
	[self add:@"*.ods" mimetype:@"application/vnd.oasis.opendocument.spreadsheet"];
	[self add:@"*.odt" mimetype:@"application/vnd.oasis.opendocument.text"];
	[self add:@"*.dc" mimetype:@"application/x-dc-rom"];
	[self add:@"*.slk" mimetype:@"text/spreadsheet"];
	[self add:@"*.erl" mimetype:@"text/x-erlang"];
	[self add:@"*.pfx" mimetype:@"application/x-pkcs12"];
	[self add:@"*.mab" mimetype:@"application/x-markaby"];
	[self add:@"*.sisx" mimetype:@"x-epoc/x-sisx-app"];
	[self add:@"*.ustar" mimetype:@"application/x-ustar"];
	[self add:@"*.gvp" mimetype:@"text/x-google-video-pointer"];
	[self add:@"*.dv" mimetype:@"video/dv"];
	[self add:@"*.man" mimetype:@"application/x-troff-man"];
	[self add:@"*.qif" mimetype:@"application/x-qw"];
	[self add:@"*.qif" mimetype:@"image/x-quicktime"];
	[self add:@"*.smd" mimetype:@"application/vnd.stardivision.mail"];
	[self add:@"*.toc" mimetype:@"application/x-cdrdao-toc"];
	[self add:@"*.smf" mimetype:@"application/vnd.stardivision.math"];
	[self add:@"*.pgm" mimetype:@"image/x-portable-graymap"];
	[self add:@"*.pgn" mimetype:@"application/x-chess-pgn"];
	[self add:@"*.smi" mimetype:@"application/smil"];
	[self add:@"*.smi" mimetype:@"application/x-sami"];
	[self add:@"*.pgp" mimetype:@"application/pgp-encrypted"];
	[self add:@"*.cs" mimetype:@"text/x-csharp"];
	[self add:@"*.cs" mimetype:@"text/x-csharp"];
	[self add:@"*.sml" mimetype:@"application/smil"];
	[self add:@"*.smc" mimetype:@"application/x-snes-rom"];
	[self add:@"*.xwd" mimetype:@"image/x-xwindowdump"];
	[self add:@"*.bmp" mimetype:@"image/bmp"];
	[self add:@"*.blend" mimetype:@"application/x-blender"];
	[self add:@"*.com" mimetype:@"application/x-ms-dos-executable"];
	[self add:@"*.atom" mimetype:@"application/atom+xml"];
	[self add:@"*.sms" mimetype:@"application/x-sms-rom"];
	[self add:@"*.el" mimetype:@"text/x-emacs-lisp"];
	[self add:@"*.hxx" mimetype:@"text/x-c++hdr"];
	[self add:@"*.g3" mimetype:@"image/fax-g3"];
	[self add:@"*.vst" mimetype:@"image/x-tga"];
	[self add:@"*.es" mimetype:@"application/ecmascript"];
	[self add:@"*.PAR2" mimetype:@"application/x-par2"];
	[self add:@"*.eps.gz" mimetype:@"image/x-gzeps"];
	[self add:@"*.rle" mimetype:@"image/rle"];
	[self add:@"*.snd" mimetype:@"audio/basic"];
	[self add:@"*.ez" mimetype:@"application/andrew-inset"];
	[self add:@"*.psflib" mimetype:@"audio/x-psflib"];
	[self add:@"*.nds" mimetype:@"application/x-nintendo-ds-rom"];
	[self add:@"*.php" mimetype:@"application/x-php"];
	[self add:@"*.wvc" mimetype:@"audio/x-wavpack-correction"];
	[self add:@"*.123" mimetype:@"application/vnd.lotus-1-2-3"];
	[self add:@"*.uri" mimetype:@"text/x-uri"];
	[self add:@"*.url" mimetype:@"text/x-uri"];
	[self add:@"*.abw.CRASHED" mimetype:@"application/x-abiword"];
	[self add:@"*.cr2" mimetype:@"image/x-canon-cr2"];
	[self add:@"*.tar.xz" mimetype:@"application/x-xz-compressed-tar"];
	[self add:@"*.roff" mimetype:@"text/troff"];
	[self add:@"*.fl" mimetype:@"application/x-fluid"];
	[self add:@"*.alz" mimetype:@"application/x-alz"];
	[self add:@"*.oga" mimetype:@"audio/ogg"];
	[self add:@"*.wvp" mimetype:@"audio/x-wavpack"];
	[self add:@"*.nef" mimetype:@"image/x-nikon-nef"];
	[self add:@"*,v" mimetype:@"text/plain"];
	[self add:@"*.C" mimetype:@"text/x-c++src"];
	[self add:@"*.themepack" mimetype:@"application/x-windows-themepack"];
	[self add:@"*.ogg" mimetype:@"audio/ogg"];
	[self add:@"*.ogg" mimetype:@"audio/x-vorbis+ogg"];
	[self add:@"*.ogg" mimetype:@"audio/x-flac+ogg"];
	[self add:@"*.ogg" mimetype:@"audio/x-speex+ogg"];
	[self add:@"*.ogg" mimetype:@"video/x-theora+ogg"];
	[self add:@"*.wvx" mimetype:@"audio/x-ms-asx"];
	[self add:@"*.fo" mimetype:@"text/x-xslfo"];
	[self add:@"*.etx" mimetype:@"text/x-setext"];
	[self add:@"*.pptm" mimetype:@"application/vnd.openxmlformats-officedocument.presentationml.presentation"];
	[self add:@"readme" mimetype:@"text/x-readme"];
	[self add:@"todo" mimetype:@"text/x-todo"];
	[self add:@"license" mimetype:@"text/x-license"];
	[self add:@"*.version" mimetype:@"text/x-version"];
	[self add:@"Makefile.*" mimetype:@"text/x-makefile"];
	[self add:@"*.dmg" mimetype:@"application/x-apple-diskimage"];
	[self add:@"*.swp" mimetype:@"application/x-igelle-software-package"];
	[self add:@"*.squashfs" mimetype:@"application/x-igelle-diskimage-squashfs"];
	[self add:@"*.img" mimetype:@"application/x-igelle-diskimage"];
	[self add:@"*.eq" mimetype:@"text/x-eqela-src"];
	[self add:@"*.equity" mimetype:@"text/x-eqela-equity-src"];
	[self add:@"*.eqic" mimetype:@"text/x-eqela-eqic-config"];
	[self add:@"*.config" mimetype:@"text/x-config"];
	[self add:@"*.eqlib" mimetype:@"application/x-eqela-library"];
	[self add:@"*.eqlibx" mimetype:@"application/x-eqela-library-encrypted"];
	[self add:@"*.apk" mimetype:@"application/vnd.android.package-archive"];
	[self add:@"*.eo" mimetype:@"application/x-eqela-object"];
	[self add:@"*.eo1" mimetype:@"application/x-eqela-object-level-1"];
	[self add:@"*.eo2" mimetype:@"application/x-eqela-object-level-2"];
	[self add:@"*.eo3" mimetype:@"application/x-eqela-object-level-3"];
	[self add:@"*.eo4" mimetype:@"application/x-eqela-object-level-4"];
	[self add:@"*.eo5" mimetype:@"application/x-eqela-object-level-5"];
	[self add:@"*.iga" mimetype:@"application/x-igelle-archive"];
	[self add:@"*.ipa" mimetype:@"application/octet-stream"];
	[self add:@"*.xap" mimetype:@"application/x-silverlight-app"];
	[self add:@"*.webapp" mimetype:@"application/x-web-app-manifest+json"];
	[self add:@"*.json" mimetype:@"application/json"];
	[self add:@"*.properties" mimetype:@"application/properties"];
	return(self);
}

- (NSString*) getMimetype:(NSString*)str {
	NSString* v = nil;
	if(!(({ NSString* _s1 = str; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
		NSString* mime = nil;
		int ld = [CapeString lastIndexOfWithStringAndCharacterAndSignedInteger:str c:'.' start:-1];
		if(ld >= 0) {
			mime = [CapeString subStringWithStringAndSignedInteger:str start:ld + 1];
		}
		v = [CapeMap getMapAndDynamic:CapexMimeTypeRegistryHtMime key:((id)[CapeString toLowerCase:mime])];
	}
	if(({ NSString* _s1 = v; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || [CapeString getLength:v] < 1) {
		v = @"application/unknown";
	}
	return(v);
}

- (NSString*) getExtension:(NSString*)mimetype {
	return([CapeMap getMapAndDynamic:CapexMimeTypeRegistryHtExt key:((id)mimetype)]);
}

- (BOOL) add:(NSString*)pattern mimetype:(NSString*)mimetype {
	BOOL v = FALSE;
	if(({ NSString* _s1 = pattern; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }) || ({ NSString* _s1 = mimetype; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
		;
	}
	else {
		if([CapeString startsWith:pattern str2:@"." offset:0] == TRUE) {
			NSString* key = [CapeString subStringWithStringAndSignedIntegerAndSignedInteger:pattern start:1 length:[CapeString getLength:pattern] - 1];
			[CapeMap set:CapexMimeTypeRegistryHtMime key:((id)key) val:((id)mimetype)];
			[CapeMap set:CapexMimeTypeRegistryHtExt key:((id)mimetype) val:((id)key)];
			v = TRUE;
		}
		else {
			if([CapeString startsWith:pattern str2:@"*." offset:0] == TRUE) {
				NSString* key = [CapeString subStringWithStringAndSignedIntegerAndSignedInteger:pattern start:2 length:[CapeString getLength:pattern] - 2];
				[CapeMap set:CapexMimeTypeRegistryHtMime key:((id)key) val:((id)mimetype)];
				[CapeMap set:CapexMimeTypeRegistryHtExt key:((id)mimetype) val:((id)key)];
				v = TRUE;
			}
			else {
				if([CapeString startsWith:pattern str2:@"#" offset:0] == TRUE) {
					;
				}
				else {
					[CapeMap set:CapexMimeTypeRegistryHtMime key:((id)pattern) val:((id)mimetype)];
					[CapeMap set:CapexMimeTypeRegistryHtExt key:((id)mimetype) val:((id)pattern)];
					v = TRUE;
				}
			}
		}
	}
	return(v);
}

- (BOOL) read:(id<CapeFile>)file {
	if(file == nil) {
		return(FALSE);
	}
	CapePrintReader* buf = [[CapePrintReader alloc] initWithReader:((id<CapeReader>)[file read])];
	if(buf == nil) {
		return(FALSE);
	}
	else {
		int n = 0;
		while(TRUE) {
			NSString* line = [buf readLine];
			if(({ NSString* _s1 = line; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; })) {
				break;
			}
			NSMutableArray* va = [CapeString split:line delim:':' max:0];
			id<CapeIterator> val = [CapeVector iterate:va];
			if(val != nil) {
				NSString* front = [val next];
				NSString* back = [val next];
				if(!(({ NSString* _s1 = front; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
					front = [CapeString strip:front];
				}
				if(!(({ NSString* _s1 = back; NSString* _s2 = nil; (_s1 == nil && _s2 == nil) || [_s1 isEqualToString:_s2]; }))) {
					back = [CapeString strip:back];
				}
				if([self add:front mimetype:back]) {
					n++;
				}
			}
		}
	}
	return(TRUE);
}

@end
