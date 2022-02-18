program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  contrail_lib in 'contrail_lib.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Contrail';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
