{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{ Copyright(c) 2014 Embarcadero Technologies, Inc.      }
{                                                       }
{*******************************************************}

unit Androidapi.JNI.SystemIntf;

interface

uses
  Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes;

type
// ===== Forward declarations =====

  JConsole = interface;//java.io.Console
  JSecurityManager = interface;//java.lang.SecurityManager
  JSystem = interface;//java.lang.System
  JPermission = interface;//java.security.Permission
  JPermissionCollection = interface;//java.security.PermissionCollection

// ===== Interface declarations =====

  JConsoleClass = interface(JObjectClass)
    ['{37B17E41-C395-41DD-8B62-3D5C7EAA2F12}']
  end;

  [JavaSignature('java/io/Console')]
  JConsole = interface(JObject)
    ['{6143C144-E6C4-430A-8904-5B3B66E9940D}']
    procedure flush; cdecl;
    function readLine: JString; cdecl; overload;
    function readPassword: TJavaArray<Char>; cdecl; overload;
    function reader: JReader; cdecl;
    function writer: JPrintWriter; cdecl;
  end;
  TJConsole = class(TJavaGenericImport<JConsoleClass, JConsole>) end;

  JSecurityManagerClass = interface(JObjectClass)
    ['{ECA6C04C-6B19-43BD-A3FC-A76ED56C1C3D}']
    {class} function init: JSecurityManager; cdecl;
  end;

  [JavaSignature('java/lang/SecurityManager')]
  JSecurityManager = interface(JObject)
    ['{4097B4D7-B33C-4A15-B3CF-48234D8EF514}']
    procedure checkAccept(host: JString; port: Integer); cdecl;
    procedure checkAccess(thread: JThread); cdecl; overload;
    procedure checkAccess(group: JThreadGroup); cdecl; overload;
    procedure checkAwtEventQueueAccess; cdecl;
    procedure checkConnect(host: JString; port: Integer); cdecl; overload;
    procedure checkConnect(host: JString; port: Integer; context: JObject); cdecl; overload;
    procedure checkCreateClassLoader; cdecl;
    procedure checkDelete(file_: JString); cdecl;
    procedure checkExec(cmd: JString); cdecl;
    procedure checkExit(status: Integer); cdecl;
    procedure checkLink(libName: JString); cdecl;
    procedure checkListen(port: Integer); cdecl;
    procedure checkMemberAccess(cls: Jlang_Class; type_: Integer); cdecl;
    procedure checkPackageAccess(packageName: JString); cdecl;
    procedure checkPackageDefinition(packageName: JString); cdecl;
    procedure checkPermission(permission: JPermission); cdecl; overload;
    procedure checkPermission(permission: JPermission; context: JObject); cdecl; overload;
    procedure checkPrintJobAccess; cdecl;
    procedure checkPropertiesAccess; cdecl;
    procedure checkPropertyAccess(key: JString); cdecl;
    procedure checkRead(fd: JFileDescriptor); cdecl; overload;
    procedure checkRead(file_: JString); cdecl; overload;
    procedure checkRead(file_: JString; context: JObject); cdecl; overload;
    procedure checkSecurityAccess(target: JString); cdecl;
    procedure checkSetFactory; cdecl;
    procedure checkSystemClipboardAccess; cdecl;
    function checkTopLevelWindow(window: JObject): Boolean; cdecl;
    procedure checkWrite(fd: JFileDescriptor); cdecl; overload;
    procedure checkWrite(file_: JString); cdecl; overload;
    function getInCheck: Boolean; cdecl;//Deprecated
    function getSecurityContext: JObject; cdecl;
    function getThreadGroup: JThreadGroup; cdecl;
  end;
  TJSecurityManager = class(TJavaGenericImport<JSecurityManagerClass, JSecurityManager>) end;

  JSystemClass = interface(JObjectClass)
    ['{6712922C-060B-481F-AF21-9FF7A5F0BF38}']
    {class} function _Geterr: JPrintStream;
    {class} function _Getin: JInputStream;
    {class} function _Getout: JPrintStream;
    {class} procedure arraycopy(src: JObject; srcPos: Integer; dst: JObject; dstPos: Integer; length: Integer); cdecl;
    {class} function clearProperty(name: JString): JString; cdecl;
    {class} function console: JConsole; cdecl;
    {class} function currentTimeMillis: Int64; cdecl;
    {class} procedure exit(code: Integer); cdecl;
    {class} procedure gc; cdecl;
    {class} function getProperties: JProperties; cdecl;
    {class} function getProperty(propertyName: JString): JString; cdecl; overload;
    {class} function getProperty(name: JString; defaultValue: JString): JString; cdecl; overload;
    {class} function getSecurityManager: JSecurityManager; cdecl;
    {class} function getenv(name: JString): JString; cdecl; overload;
    {class} function getenv: JMap; cdecl; overload;
    {class} function identityHashCode(anObject: JObject): Integer; cdecl;
    {class} function inheritedChannel: JChannel; cdecl;
    {class} function lineSeparator: JString; cdecl;
    {class} procedure load(pathName: JString); cdecl;
    {class} procedure loadLibrary(libName: JString); cdecl;
    {class} function mapLibraryName(userLibName: JString): JString; cdecl;
    {class} function nanoTime: Int64; cdecl;
    {class} procedure runFinalization; cdecl;
    {class} procedure runFinalizersOnExit(flag: Boolean); cdecl;//Deprecated
    {class} procedure setErr(newErr: JPrintStream); cdecl;
    {class} procedure setIn(newIn: JInputStream); cdecl;
    {class} procedure setOut(newOut: JPrintStream); cdecl;
    {class} procedure setProperties(p: JProperties); cdecl;
    {class} function setProperty(name: JString; value: JString): JString; cdecl;
    {class} procedure setSecurityManager(sm: JSecurityManager); cdecl;
    {class} property err: JPrintStream read _Geterr;
    {class} property &in: JInputStream read _Getin;
    {class} property &out: JPrintStream read _Getout;
  end;

  [JavaSignature('java/lang/System')]
  JSystem = interface(JObject)
    ['{5883EEE8-8569-437C-9F0C-94722CD590AE}']
  end;
  TJSystem = class(TJavaGenericImport<JSystemClass, JSystem>) end;

  JPermissionClass = interface(JObjectClass)
    ['{3FD5AFA7-D8F7-48CE-B36A-60FD727FA7AA}']
    {class} function init(name: JString): JPermission; cdecl;
  end;

  [JavaSignature('java/security/Permission')]
  JPermission = interface(JObject)
    ['{8E0B18CE-4263-4D2B-9C14-07141CF507EE}']
    procedure checkGuard(obj: JObject); cdecl;
    function getActions: JString; cdecl;
    function getName: JString; cdecl;
    function implies(permission: JPermission): Boolean; cdecl;
    function newPermissionCollection: JPermissionCollection; cdecl;
  end;
  TJPermission = class(TJavaGenericImport<JPermissionClass, JPermission>) end;

  JPermissionCollectionClass = interface(JObjectClass)
    ['{755E07B9-32C3-4B44-851F-1F6BDC7E90E9}']
    {class} function init: JPermissionCollection; cdecl;
  end;

  [JavaSignature('java/security/PermissionCollection')]
  JPermissionCollection = interface(JObject)
    ['{3CA5945E-E020-4DB4-A0D8-7CC9C2F160B4}']
    procedure add(permission: JPermission); cdecl;
    function elements: JEnumeration; cdecl;
    function implies(permission: JPermission): Boolean; cdecl;
    function isReadOnly: Boolean; cdecl;
    procedure setReadOnly; cdecl;
  end;
  TJPermissionCollection = class(TJavaGenericImport<JPermissionCollectionClass, JPermissionCollection>) end;

implementation

procedure RegisterTypes;
begin
  TRegTypes.RegisterType('Androidapi.JNI.Interfaces.JConsole', TypeInfo(Androidapi.JNI.SystemIntf.JConsole));
  TRegTypes.RegisterType('Androidapi.JNI.Interfaces.JSecurityManager', TypeInfo(Androidapi.JNI.SystemIntf.JSecurityManager));
  TRegTypes.RegisterType('Androidapi.JNI.Interfaces.JSystem', TypeInfo(Androidapi.JNI.SystemIntf.JSystem));
  TRegTypes.RegisterType('Androidapi.JNI.Interfaces.JPermission', TypeInfo(Androidapi.JNI.SystemIntf.JPermission));
  TRegTypes.RegisterType('Androidapi.JNI.Interfaces.JPermissionCollection', TypeInfo(Androidapi.JNI.SystemIntf.JPermissionCollection));
end;

initialization
  RegisterTypes;
end.


