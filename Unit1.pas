unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.OleServer, LotsiaPDM_TLB, FileCtrl;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Button3: TButton;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    ProgressBar1: TProgressBar;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label5: TLabel;
    ApplicationFactory1: TApplicationFactory;
    Memo1: TMemo;
    SpeedButton3: TSpeedButton;
    Memo2: TMemo;
    SpeedButton4: TSpeedButton;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  mythread = class(TThread)
  private
    count: integer;
    dirstr: string;
    files,dirs,zdir: integer;
    { Private declarations }
  protected
    procedure Execute; override;
    procedure UpdateCaption;
    procedure UpdateMemo;
    function FileCount(Dir: string): integer;
  end;

var
  Form1: TForm1;
  t1: mythread;
  objs: DPDMObjectService;
  lotsiaoper: DPDMOperation;
  arhiv,newobj,objdir,robj,rfile: DPDMObject;
  objselect: DObjectSelection;
  idispat: idispatch;
  strdir,strfile: string;
  idirs,ifiles: integer;
    inttemp:integer;

implementation

{$R *.dfm}

procedure mythread.Execute;
begin
FileCount(dirstr);
terminate;
{
    if Terminated then break;
    inc(count);
    Synchronize(UpdateCaption);
    sleep(10);
}
end;

function mythread.FileCount(Dir: string): integer;
var
  fs: TSearchRec;
begin
  Result := 0;
  if FindFirst(Dir + '\*.*', faAnyFile, fs) = 0 then repeat
    //if dir then
    if (fs.Attr AND faDirectory) = faDirectory then begin
      if (fs.name[1] <> '.') and (fs.name[1] <> '..') then begin
        inc(dirs);
        strdir:=fs.name;
        FileCount(Dir+'\'+fs.name);
        //create dir in lotsia
        {
        try
          newobj:= objs.CreateObject(100022898000000,null);  //papka.zakaz
          robj.AddLink(newobj,1);
          newobj.Description:=strdir;
          //newobj.SetAttrib(100000536200000,strdir);
        finally
          FileCount(Dir+'\'+fs.name, newobj);
          //finalize
          objs.Update;
        end;
        }
        Synchronize(UpdateCaption);
        if Terminated then break;
      end;
    end else begin
      inc(files);
      strfile:=fs.name;
      //CREATE FILE IN LOTSIA
      {
      try
        newobj:= objs.CreateObject(100000536000000,null);  //document
        robj.AddLink(newobj,1);
        newobj.Description:=strdir;
        newobj.SetAttrib(100000536200000,strfile);
      finally
        try
          newobj.ImportDocument(Dir+'\'+fs.name,0,77,0,0);
        except
           //
        end;
        //finalize
        objs.Update;
      end;
      }
      Synchronize(Updatememo);
    end;
    if Terminated then break;
  until FindNext(fs) <> 0;
  FindClose(fs);
end;

procedure mythread.UpdateCaption;
begin
  //Form1.Label5.Caption := 'ThreadWork: '+inttostr(count);
  //form1.Label3.Caption:='Всего файлов: '+inttostr(files);
  form1.Label4.Caption:='Всего папок: '+inttostr(dirs);
  form1.Memo1.Lines.Add(strdir);
end;

procedure mythread.Updatememo;
begin
  //Form1.Label5.Caption := 'ThreadWork: '+inttostr(count);
  form1.Label3.Caption:='Всего файлов: '+inttostr(files);
  form1.Memo1.Lines.Add(strfile);
end;

//----------------------------- copy zakaz----------------------------------------------------------

function zakazcopy(Dir: string; root:DPDMObject): integer;
var
  fs: TSearchRec;
  docf:DPDMDocumentVersion;
  shifr,ext:string;
begin
  Result := 0;
  if FindFirst(Dir + '\*.*', faAnyFile, fs) = 0 then repeat
    //if dir then
    if (fs.Attr AND faDirectory) = faDirectory then begin
      if (fs.name[1] <> '.') and (fs.name[1] <> '..') then begin
        inc(idirs);
        strdir:= fs.name;
        //form1.Memo1.Lines.Add(strdir);
        //create dir in lotsia
        try
          if dir= '\\Filesrv\Электронные версии' then begin
            shifr:= strdir;
            newobj:= objs.CreateObject(100022898000000,null)  //papka.zakaz
          end else
            newobj:= objs.CreateObject(100022898100000,null); //papka
          root.AddLink(newobj,1);
          newobj.Description:=strdir;
          //newobj.SetAttrib(100000536200000,strdir);
        finally
          objs.Update;
          zakazcopy(Dir+'\'+fs.name, newobj);
          //finalize
        end;

      end;
    end else begin
      //if file then
      inc(ifiles);
      strfile:= fs.name;
      //CREATE FILE IN LOTSIA
      ext:= ExtractFileExt(fs.Name);
      if (fs.Name<>'Thumbs.db') and (fs.Name<>'acad.err') and (ext<>'.bak') and (ext<>'.tmp') and (ext<>'.dwl') and (ext<>'.dwl2') and (ext<>'.lnk') and (ext<>'.log') then
      begin
        try
          newobj:= objs.CreateObject(100000536000000,null);  //document
          root.AddLink(newobj,1);
          newobj.Description:= strfile;
          newobj.SetAttrib(100000536200000,strfile);
          newobj.SetAttrib(100000426200000,shifr);
          newobj.ImportDocument(Dir + '\' + fs.name, 0, 67, 0, 0);
          objs.Update;
        except
          form1.Memo1.Lines.Add(Dir+'\'+fs.name + ' NO!');
          //finalize
        end;
      end;

    end;
  until (FindNext(fs) <> 0);
  FindClose(fs);
end;


//-------------------------counter-------------------------------------------------------------
function FileCounter(Dir: string; root:DPDMObject): integer;
var
  fs: TSearchRec;
  docf:DPDMDocumentVersion;
  shifr:string;
  ext:string;
begin
  if form1.Memo1.Lines.Count>500 then
  begin
    form1.memo1.Lines.SaveToFile('C:\Users\eurtaev\Desktop\log'+inttostr(inttemp)+'.txt');
    form1.memo1.Text:='';
  end;

  Result := 0;
  if FindFirst(Dir + '\*.*', faAnyFile, fs) = 0 then repeat
    //if dir then
    if (fs.Attr AND faDirectory) = faDirectory then begin
      if (fs.name[1] <> '.') and (fs.name[1] <> '..') then begin
        inc(idirs);
        strdir:=fs.name;
        //form1.Memo1.Lines.Add(strdir);
        //create dir in lotsia
        try
          if dir='\\Filesrv\Электронные версии' then begin
            shifr:=strdir;
            newobj:= objs.CreateObject(100022898000000,null)  //papka.zakaz
          end else
            newobj:= objs.CreateObject(100022898100000,null); //papka
          root.AddLink(newobj,1);
          newobj.Description:=strdir;
          //newobj.SetAttrib(100000536200000,strdir);
        finally
          objs.Update;
          FileCounter(Dir+'\'+fs.name, newobj);
          //finalize

        end;

      end;
    end else begin
      //if file then
      inc(ifiles);
      strfile:= fs.name;
      //CREATE FILE IN LOTSIA
      ext:= ExtractFileExt(fs.Name);
      if (fs.Name<>'Thumbs.db') and (fs.Name<>'acad.err') and (ext<>'.bak') and (ext<>'.tmp') and (ext<>'.dwl') and (ext<>'.dwl2') and (ext<>'.lnk') and (ext<>'.log') then
      begin
        try
          newobj:= objs.CreateObject(100000536000000,null);  //document
          root.AddLink(newobj,1);
          newobj.Description:= strfile;
          newobj.SetAttrib(100000536200000,strfile);
          newobj.SetAttrib(100000426200000,shifr);
          newobj.ImportDocument(Dir + '\' + fs.name, 0, 67, 0, 0);
          objs.Update;
        except
          form1.Memo1.Lines.Add(Dir+'\'+fs.name + ' NO!');
          //finalize
        end;
      end;

    end;
  until (FindNext(fs) <> 0);
  FindClose(fs);
end;
//---------------------------------------------------------------------------------------------

procedure TForm1.Button1Click(Sender: TObject);
var
  dir:string;
begin
  dir:= '\\Filesrv\Электронные версии';
  if SelectDirectory('Выберите папку',Dir,dir) then
    edit1.Text := Dir;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  //objselect.Application.CreateSelectionDialog('select');
  //objselect.Title:='Выберите корневую папку';
  //objselect:=ApplicationFactory1.Application.CreateSelectionDialog(WideString('Object'));
  //objselect:=ApplicationFactory1.Application.CreateSelectionDialog(WideString('Object'));
  //objselect:=idispat;
  //objselect.SelectTree(arhiv,1);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 //objdir:= arhiv;
 //newobj:= objs.CreateObject(100022898000000,null);  //papka.zakaz
 //arhiv.AddLink(newobj,1);
 //newobj.Description:= 'Тест импорта';
  //finalize
 //objs.Update;

 //arhiv:= objs.GetObject(100001247000000);
 inttemp:=0;
 FileCounter(edit1.Text, arhiv);

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  form1.ApplicationFactory1.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    ApplicationFactory1.Connect;
    IF ApplicationFactory1.Application.Connect = true then
      memo1.Lines.Text:= 'Подключение к Lotsia установлено'
    else
      memo1.Lines.Text:= 'Подключение не установлено';
    if form1.ApplicationFactory1.Application.IsConnected then begin
      objs:= ApplicationFactory1.Application.CreateObjectService;
      arhiv:= objs.GetObject(100001247000000);
    end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
  ti:integer;
begin
//ti:= strtoint(edit2.Text);
  ti:= 100001247000000;
  arhiv:= objs.GetObject(ti);
  t1:=MyThread.Create(False);
  t1.count:= 0;
  t1.zdir:=0;
  t1.Priority:= tpLower;
  t1.dirstr:= edit1.Text;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  t1.Terminate;
end;


procedure TForm1.SpeedButton3Click(Sender: TObject);
var
  tst: string;
  jk: integer;
begin
  //
  for  jk:= 0 to memo2.Lines.Count-1 do
  begin
    tst:= memo2.Lines[jk];
    //delete(tst,1,length('\\filesrv\ЭЛЕКТРОННЫЕ ВЕРСИИ')+1);
    //showmessage(tst);
    newobj:= objs.CreateObject(100022898000000,null);  //papka.zakaz
    arhiv.AddLink(newobj,1);
    newobj.Description:= tst;
    zakazcopy(edit1.Text+'\'+tst, newobj);
    //showmessage('ready');
    memo1.Lines.SaveToFile('C:\1log\'+tst+'.txt');
    memo1.Text:= '';
  end;
  showmessage('ready');
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
 arhiv:= objs.GetObject(100017994000000);
 inttemp:=0;
 FileCounter('\\Filesrv\электронные версии\4740 РД\Исполнительная док-ция по ВСП', arhiv);
end;

end.
