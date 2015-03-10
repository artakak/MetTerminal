program Terminal;

uses
  Forms,
  Main in 'Main.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'MetTerminal';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
