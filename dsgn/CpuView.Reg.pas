﻿unit CpuView.Reg;

interface

{$I CpuViewCfg.inc}

uses
  Classes,
{$IFDEF FPC}
  ActnList,
  LCLType,
  LCLIntf,
  Forms,
  IDECommands,
  MenuIntf,
  BaseDebugManager,
  IdeDebuggerBase,
  IDEOptEditorIntf,
  IDEOptionsIntf,
  dlgCpuView,
  dlgCpuViewImplementation,
  frmCpuViewOptions,
{$ELSE}
  Actions,
  DesignIntf,
  DesignEditors,
{$ENDIF}
  CpuView.Actions,
  CpuView.Viewers;

{$IFNDEF FPC}
type
  TCpuContextActionsSelectionEditor = class(TSelectionEditor)
  public
    procedure RequiresUnits(Proc: TGetStrProc); override;
  end;
{$ENDIF}

  procedure Register;

implementation

{$IFDEF FPC}
procedure StartCpuView(Sender: TObject);
begin
  if DebugBoss = nil then Exit;
  if frmCpuView = nil then
    frmCpuView := TfrmCpuViewImpl.Create(DebugBoss);
  frmCpuView.BringToFront;
  frmCpuView.Show;
end;

procedure DoLCLRegister;
var
  Key: TIDEShortCut;
  Cat: TIDECommandCategory;
  CmdCpuView: TIDECommand;
  //MainEditorID: Integer;
begin
  Key := IDEShortCut(VK_C, [ssAlt, ssCtrl], VK_UNKNOWN, []);
  Cat := IDECommandList.FindCategoryByName(CommandCategoryViewName);
  CmdCpuView := RegisterIDECommand(Cat, 'CPU-View', '', Key, nil, @StartCpuView);
  RegisterIDEMenuCommand(itmViewDebugWindows, 'CPU-View', 'CPU-View', nil, nil, CmdCpuView);
  //MainEditorID := RegisterIDEOptionsEditor(GroupEnvironment,
  //  TCpuViewMainOptionsFrame, 14041979)^.Index;
  RegisterIDEOptionsEditor(GroupEnvironment, TCpuViewMainOptionsFrame, 14041979);
end;
{$ENDIF}

procedure Register;
begin
  {$IFDEF FPC}
  DoLCLRegister;
  {$ELSE}
  ForceDemandLoadState(dlDisable);
  RegisterSelectionEditor(TCpuContextRegViewModeAction, TCpuContextActionsSelectionEditor);
  {$ENDIF}
  RegisterActions('HexView Actions', [TCpuContextRegViewModeAction], nil);
  RegisterComponents('FWControls', [TAsmView, TDumpView, TStackView, TRegView]);
end;

{$IFNDEF FPC}

{ TCpuContextActionsSelectionEditor }

procedure TCpuContextActionsSelectionEditor.RequiresUnits(Proc: TGetStrProc);
begin
  inherited;
  Proc('CpuView.Actions');
end;
{$ENDIF}

end.
