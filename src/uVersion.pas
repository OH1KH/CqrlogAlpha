unit uVersion;

{$mode objfpc}
interface

const

  cVersionBase     ='Alpha_(137)_';

  {$IFDEF LCLGtk2}
  cVERSION    = cVersionBase+'Gtk2';
  {$ENDIF}
  {$IFDEF LCLGtk3}
  cVERSION    = cVersionBase+'Gtk3';
  {$ENDIF}
  {$IFDEF LCLQt5}
  cVERSION    = cVersionBase+'QT5';
  {$ENDIF}
  {$IFDEF LCLQt6}
  cVERSION    = cVersionBase+'QT6';
  {$ENDIF}

  cMAJOR      = 2;
  cMINOR      = 6;
  cRELEAS     = 0;
  cBUILD      = 1;

  cBUILD_DATE = '2025-07-01';

implementation

end.

