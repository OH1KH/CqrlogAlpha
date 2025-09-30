{$ifdef WINDOWS}
  Winsock2,
{$endif}

{$ifdef UNIX}
  BaseUnix, NetDB,
{$endif}

//Fix by Github/suve for: FPC 3.2.4 moves TZSeconds from the 'UnixUtil' unit to 'Unix'.
//Take in use later if needed
//{$ifdef UNIX}
//  BaseUnix, NetDB,
//  {$IF FPC_FULLVERSION > 30202}
//    Unix,
//  {$ENDIF}
//{$endif}



{$ifdef NETWARE}
  WinSock,
{$endif}

{$ifdef OS2}
  WinSock,
{$endif}

  SysUtils, Sockets;

