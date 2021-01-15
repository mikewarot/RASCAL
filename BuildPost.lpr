program BuildPost;
{
  This program builds a post in RASCAL V 1, and uses MD5 to sign it, for now

  (C) Copyright 2021 - Michael A Warot, all rights reserved

  Disclaimer: The author makes no warantee, expressed or implied.
            Use this software strickly at your own risk.

  1/12/2021 - MAW
    This is the initial commit, an MVP - minimum viable product

  Rev
   1 - Initial version, good enough to ship
}

uses
  sysutils, dateutils, MD5;

{
  The header structure

  Yet another post in RASCAL v 1 by Mike Warot
  This post is 1 lines, with a checksum of XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX in MD5
  Copyright (C) 2021 - Michael A Warot - All rights resevered. This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License. (CC BY-SA 4.0)

}
const
  CRLF            = #13#10;
  RascalVersion   = 1;
  MagicString     = 'Yet another post in RASCAL v ';
  NickName        = 'Mike Warot';
  LegalName       = 'Michael A Warot';
  License         = '. This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License. (CC BY-SA 4.0)';
  HeaderLineCount = 4;
  DummyChecksum   = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
  CheckSumName    = 'MD5';
  WhiteSpace      :  set of char = [' ',#9];  // space, tab

  procedure RemoveTrailingWhiteSpace(Var S : String);
  begin
    while (length(s) > 1) AND (s[length(s)] in WhiteSpace) do
        delete(s,length(s),1);
  end;

var
  StartTime        : TDateTime;
  Buffer           : Array[1..1000] of String;
  Header           : String;
  WholeMessage     : String;
  SourceLineCount  : Integer;
  OutputLineCount  : Integer;
  CheckSumString   : String;
  i                : Integer;

begin
  StartTime := Now;

  SourceLineCount := 0;
  While not EOF do
    begin
      inc(SourceLineCount);
      if SourceLineCount > 1000 then
      begin
        writeln(stderr,'Input too long, aborting');
        halt(1);
      end;
      readln(Buffer[SourceLineCount]);
      RemoveTrailingWhiteSpace(Buffer[SourceLineCount]);
    end; // while not EOF

  WriteLn(stderr,SourceLineCount,' lines read');
  OutputLineCount := HeaderLineCount + SourceLineCount;
  CheckSumString := DummyCheckSum;
  WriteLn(stderr,'Dummy Checksum length = ',length(CheckSumString));

  Header := MagicString + RascalVersion.ToString + ' by ' + NickName + CRLF;
  Header := Header
    + 'This post is ' + OutputLineCount.ToString
    + ' lines, with a checksum of '
    + CheckSumString
    + ' in ' + CheckSumName + CRLF;
  Header := Header
    + 'Copyright (C) ' + FormatDateTime('YYYY',StartTime)
    + ' - ' + LegalName + License + CRLF;
  Header := Header
    + CRLF;   // makes it easer to read

  WriteLn(StdErr,'Here is the header');
  WriteLn(StdErr,Header);

  WholeMessage := Header;
  For i := 1 to SourceLineCount do
    WholeMessage := WholeMessage + Buffer[i] + CRLF;

  CheckSumString := MDPrint(MD5String(WholeMessage));

{
  This is a copy/paste of above code, to regenerate the message, with the actual checksum this time
}

  Header := MagicString + RascalVersion.ToString + ' by ' + NickName + CRLF;
  Header := Header
    + 'This post is ' + OutputLineCount.ToString
    + ' lines, with a checksum of '
    + CheckSumString
    + ' in ' + CheckSumName + CRLF;
  Header := Header
    + 'Copyright (C) ' + FormatDateTime('YYYY',StartTime)
    + ' - ' + LegalName + License + CRLF;
  Header := Header
    + CRLF;   // makes it easer to read

  WriteLn(StdErr,'Here is the header after checksum');
  WriteLn(StdErr,Header);

  WholeMessage := Header;
  For i := 1 to SourceLineCount do
    WholeMessage := WholeMessage + Buffer[i] + CRLF;

  Write(StdOut,WholeMessage);  // actually write the file


  writeln(StdErr,(MilliSecondsBetween(Now,StartTime)*0.001):10:3,' seconds');
end.

