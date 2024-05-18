0<0# : ^
"""
@echo off
SET F="C:\\Users\\%USERNAME%\\AppData\\Local\\Microsoft\\WindowsApps\\python.exe"
if exist %F% ( del /s %F% >nul 2>&1 )
SET G="C:\\Users\\%USERNAME%\\AppData\\Local\\Microsoft\\WindowsApps\\python3.exe"
if exist %G% ( del /s %G% >nul 2>&1 )
FOR /F "tokens=*" %%g IN ('where python.exe') do (SET VAR=%%g)
if exist %VAR% (
    python "%~f0" %*
    exit /b 0
)
FOR /F "tokens=*" %%g IN ('where python3.exe') do (SET VAR=%%g)
if exist %VAR% ( python3 "%~f0" %* )
exit /b 0
"""
""":"
if [ -f /usr/bin/sw_vers ]; then WHICH='which';elif [ -f /usr/bin/which ]; then WHICH='/usr/bin/which';elif [ -f /bin/which ]; then WHICH='/bin/which';elif [ -f "C:\\Windows\\System32\\where.exe" ]; then WHICH="C:\\Windows\\System32\\where.exe";fi; if [ ! -z $WHICH ]; then _PY_=$($WHICH python3);if [ -z $_PY_ ]; then _PY_=$($WHICH python2); if [ -z $_PY_ ]; then _PY_=$($WHICH pypy3); if [ -z $_PY_ ]; then _PY_=$($WHICH pypy); if [ -z $_PY_ ]; then _PY_=$($WHICH python); if [ -z $_PY_ ]; then echo 'No Python Found'; fi; fi; fi; fi; fi; if [ ! -z "$_PY_" ]; then WINPTY=$($WHICH winpty.exe 2>/dev/null);if [ ! -z "$WINPTY" ]; then PY_EXE=$($WHICH python.exe 2>/dev/null);if [ ! -z "$PY_EXE" ]; then exec "$WINPTY" "$PY_EXE" "$0" "$@";exit 0;fi;else exec $_PY_ "$0" "$@";exit 0;fi;fi;fi;if [  -f /usr/bin/python3 ]; then exec /usr/bin/python3 "$0" "$@";exit 0;fi;if [  -f /usr/bin/python2 ]; then exec /usr/bin/python2 "$0" "$@";exit 0;fi;if [  -f /usr/bin/python ]; then exec /usr/bin/python "$0" "$@";exit 0;fi;if [  -f /usr/bin/pypy3 ]; then exec /usr/bin/pypy3 "$0" "$@";exit 0;fi ;if [  -f /usr/bin/pypy ]; then exec /usr/bin/pypy "$0" "$@";exit 0;fi
# This is code from online-installer, homepage: https://github.com/cloudgen2/online-installer
exit 0
":"""
from __future__ import print_function
try:
    input
except NameError:
    input = raw_input
try:
    basestring
except NameError:
    basestring=str
try: 
    __file__
except NameError: 
    __file__ = ''
try:
    import ConfigParser as configparser
except:
    import configparser
try:
    import pwd
except:
    pwd = None
try:
    get_ipython
    getIpythonExists = True
except:
    getIpythonExists = False
    get_ipython={}
from datetime import date, datetime
import getpass
from inspect import currentframe
import os
import platform
import re
import signal
from subprocess import Popen, PIPE
import subprocess
import shutil
import socket
import time
import sys

class Attr(object):
    RESERVED = ['False', 'def', 'if', 'raise', 'None', 'del', 'import', 
        'return', 'True', 'elif', 'in', 'try', 'and', 'else', 'is', 'while', 
        'as', 'except', 'lambda', 'with', 'assert', 'finally', 'nonlocal', 
        'yield', 'break', 'for', 'not', 'class', 'form', 'or', 'continue',
        'global', 'pass', 'attrList']

    def lists(self,x=None):
        if x is None:
            if self._["sorting"]:
                return sorted(self._["list"])
            else:
                return self._["list"]
        elif x not in self._["list"] and not self._["readonly"]:
            if isinstance(x,list):
                for l in x:
                    if isinstance(l,basestring) and self._["autostrip"]:
                        l=l.strip()
                    self._["list"].append(l)
            else:
                if isinstance(x,basestring) and self._["autostrip"]:
                    x=x.strip()
                if x not in self._["list"]:
                    self._["list"].append(x)
        return self._["class"]

    def value(self,x=None):
        if x is None:
            return self._["value"]
        if not self._["readonly"] or self._["value"] is None or self._["value"]=="":
            if self._["value"] is None or self._["value"]!=x:
                self._["value"]=x
        return self._["class"]

    def __init__(self,fromClass=None,attrName='',value=None, readonly=False, autostrip=True, sorting=True):
        if isinstance(attrName, basestring):
            attrName=attrName.strip()
            if attrName=="" or attrName in Attr.RESERVED:
                return None
            if fromClass is not None:
                if not hasattr(fromClass,"_"):
                    fromClass._={'attrList': [] }
                    def attrList(self):
                        return sorted(self._['attrList'])
                    fromClass.__dict__['attrList'] = attrList.__get__(fromClass)
                if not hasattr(fromClass._, attrName):
                    fromClass._['attrList'].append( attrName )
                    if isinstance(value, list):
                        self._ ={"class":fromClass,"name":attrName, "list":value, "readonly":readonly, "autostrip": autostrip, "sorting": sorting}
                    else:
                        if isinstance(value,basestring) and autostrip:
                            value = value.strip()
                        self._ ={"class":fromClass,"name":attrName, "value":value, "readonly":readonly, "autostrip": autostrip, "sorting": False}
                    fromClass._[attrName]=self
                    if not hasattr(fromClass,attrName):
                        if isinstance(value, list):
                            def lists(self, value=None):
                                return fromClass._[attrName].lists(value)
                            fromClass.__dict__[attrName] = lists.__get__(fromClass)
                        else:
                            def attr(self, value=None):
                                return fromClass._[attrName].value(value)
                            fromClass.__dict__[attrName] = attr.__get__(fromClass)

class Transition(object):
    def __init__(self, name, fromState, toState):
        Attr(self, attrName="name", value = name, readonly=True)
        Attr(self, attrName="fromState", value = fromState, readonly=True)
        Attr(self, attrName="toState", value = toState, readonly=True)

class FiniteStateMachine(object):

    def state(self, value=None):
        if value is None:
            return self._["state"]
        elif self._["state"]=="":
            self._["state"]= value
        return self
        
    def nextState(self):
        return self._["nextState"]
    
    def after(self, name, foo):
        name = name.strip()
        if name in self.transitions():
            newname= "after%s" % name.capitalize()
            if newname not in self.methods():
                self.__dict__[newname] = foo.__get__(self)
                self.methods(newname)
        return self

    def on(self, name, foo):
        name = name.strip()
        if name in self.transitions():
            newname= "on%s" % name.capitalize()
            if newname not in self.methods():
                self.__dict__[newname] = foo.__get__(self)
                self.methods(newname)
        return self
            
    def before(self, name, foo):
        name = name.strip()
        if name in self.transitions():
            newname= "before%s" % name.capitalize()
            if newname not in self.methods():
                self.__dict__[newname] = foo.__get__(self)
                self.methods(newname)
        return self

    def method(self, name, foo):
        name = name.strip()
        if name not in self.methods():
            self.__dict__[name] = foo.__get__(self)
            self.methods(name)
        return self
    
    def transition(self, name, fromState, toState):
        if name not in self.transitions():
            def t(self):
                if self._["state"] == fromState:
                    before= "before%s" % name.capitalize()
                    next = True
                    if before in self.methods():
                        next = self.__dict__[before]()
                    if next:
                        self._["nextState"]=toState
                        on= "on%s" % name.capitalize()
                        if on in self.methods():
                            self.__dict__[on]()
                        self._["state"] = toState
                        self._["nextState"]=""
                        after= "after%s" % name.capitalize()
                        if after in self.methods():
                            self.__dict__[after]()
                return self
            self.__dict__[name] = t.__get__(self)
            self.transitions(name)
            self.methods(name)
        self.states(fromState)
        self.states(toState)
        return self
        
    def __init__(self):
        self._={"state": "", "nextState": ""}
        Attr(self, attrName="methods", value = [])        
        Attr(self, attrName="transitions", value = [])
        Attr(self, attrName="states", value = [])

class Reflection(object):
    def hasFunc(self, func):
        return hasattr(self, func) and callable(getattr(self, func))

class Sh(object):

    def isGitBash(self):
        if not hasattr(self, '__is_gitbash__'):
            if not hasattr(self, '__shell_cmd__'):
                self.shellCmd()
            self.__is_gitbash__ = self.__shell_cmd__.split('\\')[-1] == 'bash.exe' 
        return self.__is_gitbash__

    def now(self):
        return str(datetime.now())

    def pid(self):
        return os.getpid()

    def prn(self, val):
        print(val)
        return self

    def shellCmd(self, cmd=None):
        if cmd is not None:
            self.__shell_cmd__=cmd
            return self
        elif not hasattr(self,'__shell_cmd__'):
            if 'SHELL' in os.environ:
                self.__shell_cmd__ = os.environ['SHELL']
                # cannot use self.pathexists to avoid recursive call
            elif os.path.exists('/usr/bin/fish'):
                self.__shell_cmd__ = '/usr/bin/fish'
            elif os.path.exists('/bin/bash'):
                self.__shell_cmd__ = '/bin/bash'
            elif os.path.exists('/bin/ash'):
                self.__shell_cmd__ = '/bin/ash'
            elif os.path.exists('/bin/zsh'):
                self.__shell_cmd__ = '/bin/zsh'
            elif os.path.exists('/bin/sh'):
                self.__shell_cmd__ = '/bin/sh'
            elif os.path.exists('C:\\Windows\\System32\\cmd.exe'):
                self.__shell_cmd__ = 'C:\\Windows\\System32\\cmd.exe'
            elif os.path.exists('C:\\Program Files\\Git\\usr\\bin\\bash.exe'):
                self.__shell_cmd__ = 'C:\\Program Files\\Git\\usr\\bin\\bash.exe'
            else:
                self.__shell_cmd__=''
        return self.__shell_cmd__

    def today(self):
        return date.today()

    def timestamp(self):
        return "%s" % (int(time.time()))

    def userID(self):
        return os.getuid()

    def username(self):
        if pwd is None:
            return os.getlogin()
        return pwd.getpwuid(self.userID())[0]

class AppData(object):

    def __init__(self, this=None):
        self.__ini_appdata__()
        if this is None:
            self.this(__file__)
        else:
            self.this(this)

    def __ini_appdata__(self):
        if not hasattr(self, "__appdata_inited__"):
            self.__appdata_inited__ = True
            Attr(self, "author")
            Attr(self, "appName")
            Attr(self, "downloadUrl")
            Attr(self, "homepage")
            Attr(self, "lastUpdate")
            Attr(self, "majorVersion", 0)
            Attr(self, "minorVersion", 0)
            Attr(self, "thisFile", 0)

    def downloadHost(self):
        if self.downloadUrl() == '':
            return ''
        x = re.search("https:..([^/]+)", self.downloadUrl())
        if x:
            return x.group(1)
        else:
            ''        
    def fromPipe(self):
        if hasattr(self,"thisFile") and callable(self.thisFile):
            return self.thisFile() == '<stdin>'
        return False

    def this(self, this = None):
        if this is None:
            if not hasattr(self, '__this__'):
                self.__this__=self.appPath()
            return self.__this__
        else:
            self.thisFile(this)
            reg = re.compile(r"/\./")
            this = reg.sub("/",this)
            self.__this__ = this
            return self

    def version(self):
        return "%s.%s" % (self.majorVersion(),self.minorVersion())

class MsgBase(AppData, Sh):
    BOLD='\033[1m'
    DARK_AMBER='\033[33m'
    DARK_BLUE='\033[34m'
    DARK_TURQUOISE='\033[36m'
    END='\033[0m'
    FLASHING='\033[5m'
    ITALICS='\033[3m'
    LIGHT_RED='\033[91m'
    LIGHT_AMBER='\033[93m'
    LIGHT_BLUE='\033[94m'
    LIGHT_GREEN='\033[92m'
    LIGHT_TURQUOISE='\033[96m'

    def __init__(self, this=None):
        try:
            super().__init__(this)
        except:
            super(MsgBase, self).__init__(this)
        if not hasattr(self, "__msgbase_inited__"):
            self.__msgbase_inited__ = True
            Attr(self,"__colorMsgColor__", "")
            Attr(self,"__colorMsgTerm__","")
            Attr(self,"__headerColor__","")
            Attr(self,"__headerTerm__","")
            Attr(self,"__message__","")
            Attr(self,"__tag__","")
            Attr(self,"__tagColor__","")
            Attr(self,"__tagOutterColor__","")
            Attr(self,"__tagTerm__","")
            Attr(self,"__timeColor__","")
            Attr(self,"__timeTerm__","")

    def __coloredMsg__(self,color=None):
        if color is None :
            if self.__message__() == '':
                return ''
            else:
                return "%s%s%s" % (self.__colorMsgColor__(),\
                    self.__message__(),self.__colorMsgTerm__())
        else:
            if color == '' or not self.useColor():
                self.__colorMsgColor__('')
                self.__colorMsgTerm__('')
            else:
                self.__colorMsgColor__(color)
                self.__colorMsgTerm__(AppBase.END)
            return self

    def __formattedMsg__(self):
        return "%s %s %s\n  %s" % (self.__timeMsg__(),self.__header__(),\
            self.__tagMsg__(),self.__coloredMsg__())

    def __header__(self,color=None):
        if color is None:
            return "%s%s(v%s) %s" % (self.__headerColor__(),\
                self.appName(),self.version(),\
                self.__headerTerm__())
        else:
            if color == '' or not self.useColor():
                self.__headerColor__('')\
                    .__headerTerm__('')
            else:
                self.__headerColor__(color)\
                    .__headerTerm__(AppBase.END)
        return self

    def __tagMsg__(self,color=None,outterColor=None):
        if color is None:
            if self.__tag__() == '' or not self.useColor():
                return '[%s]: ' % self.__tag__()
            else:
                return "%s[%s%s%s%s%s]:%s " % (self.__tagOutterColor__(),\
                    self.__tagTerm__(),self.__tagColor__(),\
                    self.__tag__(),self.__tagTerm__(),\
                    self.__tagOutterColor__(),self.__tagTerm__())
        else:
            if color == '':
                self.__tagColor__('')\
                    .__tagOutterColor__('')\
                    .__tagTerm__('')
            else:
                self.__tagColor__(color)\
                    .__tagOutterColor__(outterColor)\
                    .__tagTerm__(AppBase.END)
            return self

    def __timeMsg__(self, color=None):
        if color is None:
            return "%s%s%s" % (self.__timeColor__(),self.now(),\
                self.__timeTerm__())
        else:
            if color == '' or not self.useColor():
                self.__timeColor__('')\
                    .__timeTerm__('')
            else:
                self.__timeColor__(color)\
                    .__timeTerm__(AppBase.END)
            return self

    def criticalMsg(self,msg,tag=''):
        self.__tag__(tag).__message__(msg) \
            .__timeMsg__(AppBase.BOLD + AppBase.ITALICS + \
            AppBase.DARK_AMBER) \
            .__header__(AppBase.BOLD + AppBase.DARK_AMBER) \
            .__coloredMsg__(AppBase.ITALICS + AppBase.LIGHT_AMBER) \
            .__tagMsg__(AppBase.FLASHING + AppBase.LIGHT_RED,\
            AppBase.LIGHT_AMBER)
        self.prn("%s" % (self.__formattedMsg__()))
        return self

    def infoMsg(self,msg,tag=''):
        self.__tag__(tag).__message__(msg) \
            .__timeMsg__(AppBase.BOLD+AppBase.ITALICS+AppBase.DARK_BLUE) \
            .__header__(AppBase.BOLD+AppBase.DARK_BLUE) \
            .__coloredMsg__(AppBase.ITALICS + AppBase.LIGHT_BLUE) \
            .__tagMsg__(AppBase.LIGHT_AMBER,AppBase.LIGHT_BLUE)
        self.prn("%s" % (self.__formattedMsg__()))
        return self

    def safeMsg(self,msg,tag=''):
        self.__tag__(tag).__message__(msg).__timeMsg__(AppBase.BOLD + AppBase.ITALICS + \
            AppBase.DARK_TURQUOISE) \
            .__header__(AppBase.BOLD + AppBase.DARK_TURQUOISE) \
            .__coloredMsg__(AppBase.ITALICS + AppBase.LIGHT_TURQUOISE) \
            .__tagMsg__(AppBase.LIGHT_GREEN,AppBase.LIGHT_TURQUOISE)
        self.prn("%s" % (self.__formattedMsg__()))
        return self

    def useColor(self, color=None):
        if color is not None:
            self.__useColor__=color
            return self
        elif not hasattr(self, '__useColor__'):
            if self.isGitBash():
                # Gitbash cannot show color
                self.__useColor__=False
            else:
                self.__useColor__=True
        return self.__useColor__

class CmdHistory(MsgBase):

    def __init__(self, this=None):
        try:
            super().__init__(this)
        except:
            super(CmdHistory, self).__init__(this)
        Attr(self, "startTime", datetime.now())
        Attr(self, "tick", datetime.now())
        Attr(self, "timeDiff", datetime.now())
        Attr(self, "timeFinished", datetime.now())
        Attr(self, "historyID", 0)
        Attr(self, "histories", ["# ====== Command History starting at %s: ======" % self.tick()], autostrip=False, sorting=False)

    def cmd_history(self,command=None, line=None):
        if not hasattr(self, '__reg_end_stars__'):
            self.__reg_end_stars__ = re.compile(r"[\*]+\s*$")
        self.timeDiff(datetime.now() -  self.tick())
        self.tick(datetime.now())
        if command is not None:
            if isinstance(command, basestring):
                cmd = command
            elif isinstance(command, list):
                cmd = " ".join(command)
            else:
                cmd = ""
            if cmd.startswith("# **"):
                if line is not None:
                    line_at = "--line %d--" % line
                else:
                    line_at = ""
                self.historyID(self.historyID() + 1)
                cmd = self.__reg_end_stars__.sub("",cmd)
                if self.historyID() > 1:
                    self.histories("  #    ...( %.3f second )" % self.timeDiff().total_seconds())
                self.histories("# ** %d. %s %s **" % (self.historyID(), cmd[5:], line_at))
            elif cmd != "":
                self.histories("  %s" % cmd)
        return self

    def cmd_history_print(self, line=None):
        self.timeDiff(datetime.now() -  self.tick())
        self.tick(datetime.now())

        self.timeFinished(datetime.now() - self.startTime())
        if len(self.histories()) == 0:
            self.infoMsg("Command History: Not Available!", "COMMAND HISTORY")
        else:
            if line is not None:
                end_at = "--line %d--" % line
            else:
                end_at = ''
            self.histories("  #    ...( %.3f second )" % self.timeDiff().total_seconds())
            history_list = '\n  '.join(self.histories())
            self.infoMsg("%s\n  # ====== End at %s ...( %.3f second ) %s ======\n" % ( history_list, str(self.tick()),self.timeFinished().total_seconds(), end_at), "COMMAND HISTORY")

class AppHistory(CmdHistory):

    def __init__(self, this=None):
        try:
            super().__init__(this)
        except:
            super(AppHistory, self).__init__(this)

    def history_add_group(self, groupname, line_num=None):
        self.cmd_history("# ** Adding user group: %s **" % groupname, line_num)

    def history_add_user(self, username, line_num=None):
        self.cmd_history("# ** Adding user: %s **" % username, line_num)

    def history_backup_nginx_conf(self, line_num=None):
        self.cmd_history("# ** Try to backup nginx config **", line_num)

    def history_cd(self, path="", line_num=None):
        self.cmd_history("cd %s" % path, line_num)

    def history_cd_decompress(self, line_num=None):
        self.cmd_history("# ** Change to temp folder to uncompress **", line_num)

    def history_change_target_mode(self, line_num=None):
        self.cmd_history("# ** Change target to executable **", line_num)

    def history_check_ash(self, line_num=None):
        self.cmd_history("# ** Try to check and modify ~/.profile **", line_num)

    def history_check_bash(self, line_num=None):
        self.cmd_history("# ** Try to check and modify ~/.bashrc **", line_num)

    def history_check_copy_sudoers(self, line_num=None):
        self.cmd_history("# ** Try to check existence or copy from temp to /etc/sudoers.d/ **" , line_num)

    def history_check_mkdir(self, line_num=None):
        self.cmd_history("# ** Check and create directory **", line_num)

    def history_check_exists(self, name="", line_num=None):
        self.cmd_history("# ** Check existence of %s **" % name, line_num)

    def history_check_group_exists(self, line_num=None):
        self.cmd_history("# ** Try to check if the user group exists  **", line_num)

    def history_check_rc_update(self, line_num=None):
        self.cmd_history("# ** Try to check sudo and add rc-update **" , line_num)

    def history_check_repositories(self, line_num=None):
        self.cmd_history("# ** Check and update apk repositories **", line_num)

    def history_check_user_exists(self, line_num=None):
        self.cmd_history("# ** Try to check if the user exists  **", line_num)

    def history_copy_static_lib(self, so_file, line_num=None):
        self.cmd_history("# ** Copying static library file: %s **" % so_file, line_num)

    def history_copy_temp(self, line_num=None):
        self.cmd_history("# ** Try to copy from temp to target **" , line_num)

    def history_copy_uncompressed(self, line_num=None):
        self.cmd_history("# ** Copy uncompressed file to target **", line_num)

    def history_change_ownership_of_folder(self, line_num=None):
        self.cmd_history("# ** Try to change ownership of folder **", line_num)

    def history_check_zsh(self, line_num=None):
        self.cmd_history("# ** Try to check and modify ~/.zshenv **", line_num)

    def history_compress(self, target_file, line_num=None):
        self.cmd_history("# ** Trying to create compressed file %s for container **" % target_file, line_num)

    def history_create_soft_link(self, line_num=None):
        self.cmd_history("# ** Try to create soft link **", line_num)

    def history_curl_check(self, line_num=None):
        self.cmd_history("# ** Using curl to check if url is ok **", line_num)

    def history_curl_download(self, line_num=None):
        self.cmd_history("# ** Using curl for downloading file **", line_num)

    def history_dir(self, path, line_num=None):
        self.cmd_history("dir %s" % path, line_num)

    def history_group_exists(self, groupname, line_num=None):
        self.cmd_history("# ** User group: %s exists and no adding for it **" % groupname, line_num)

    def history_install_package(self, package, line_num):
        self.cmd_history("# ** Install package: %s **" % package, line_num)

    def history_ls(self, path, line_num=None):
        self.cmd_history("ls %s" % path, line_num)

    def history_link_exists(self, path, line_num=None):
        self.cmd_history("# link exists: %s, no need to create short link" % path, line_num)

    def history_location_found(self, location, line_num=None):
        self.cmd_history("# found: %s" % location, line_num)

    def history_open_as_source(self, f, line_num=None):
        self.cmd_history("# ** Open %s as source file **" % f, line_num)

    def history_open_as_target(self, f, line_num=None):
        self.cmd_history("# ** Open %s as the location for writing **" % f, line_num)

    def history_package_exists(self, package, line_num=None):
        self.cmd_history("# Package: %s exists and no installation for it **" % package, line_num)

    def history_remove_downloaded(self, line_num=None):
        self.cmd_history("# ** Try to remove downloaded file **", line_num)

    def history_remove_folder(self, folder, line_num=None):
        self.cmd_history("# ** Try to remove folder: %s **" % folder, line_num)

    def history_remove_previous_global(self, line_num=None):
        self.cmd_history("# ** Try to remove previous installed global version **", line_num)

    def history_remove_previous_local(self, line_num=None):
        self.cmd_history("# ** Try to remove previous installed local version **", line_num)

    def history_remove_sudoer(self, line_num=None):
        self.cmd_history("# ** Try to check and remove sudoer file **", line_num)

    def history_remove_source(self, line_num=None):
        self.cmd_history("# ** Try to remove source file **", line_num)

    def history_remove_temp(self, line_num=None):
        self.cmd_history("# ** Try to remove temp file **", line_num)

    def history_remove_uncompressed(self, line_num=None):
        self.cmd_history("# ** Try to remove uncompressed file **", line_num)

    def history_remove_user(self, username, line_num=None):
        self.cmd_history("# ** Removing user: %s **" % username, line_num)

    def history_update_repository(self, line_num=None):
        self.cmd_history("# ** Try to update repository first **", line_num)

    def history_uninstall_package(self, package, line_num=None):
        self.cmd_history("# ** Uninstall package: %s **" % package, line_num)

    def history_user_exists(self, username, line_num=None):
        self.cmd_history("# ** User: %s exists and no adding for it **" % username, line_num)

class OS(AppHistory, Reflection):

    def __init__(self, this = None):
        try:
            super().__init__(this)
        except:
            super(OS, self).__init__(this)
        self.__init_os__()

    def __init_os__(self):
        if not hasattr(self, "__os_inited__"):
            self.__os_inited__ = True
            Attr(self, "pyName", "")
            Attr(self, "pyMinor", 0)
            Attr(self, "pyMajor", 0)
            Attr(self, "os_major_version", 0)
            Attr(self, "os_minor_version", 0)
            Attr(self, "libcVersion", "")
            Attr(self, "libcName", "")
            Attr(self, "is_sudo", False)
            Attr(self, "binVer", "")
            Attr(self, "sysChecked", False)

    def alpine_version(self):
        if not hasattr(self,'__alpine_version__'):
            if self.osVersion().startswith("Alpine"):
                version=self.osVersion().split(' ')
                length=len(version)
                if length>1:
                    self.__alpine_version__=version[length - 1]
            else:
                self.__alpine_version__=''
        return self.__alpine_version__

    def appPath(self, path=None):
        if path is not None:
            self.__app_path__=path
            return self
        elif not hasattr(self,'__app_path__'):
            self.__app_path__=''
            if not self.fromPipe() and self.this() != '':
                appPath = os.path.abspath(self.this())
                if not appPath.startswith(self.globalFolder(0)) and not appPath.startswith(self.globalFolder(0)) and not appPath.startswith(self.localInstallFolder()):
                    if self.comparePath(appPath, '%s/%s' % (os.getcwd(),appPath.split("/")[-1])):
                        self.__app_path__="./%s" % appPath.split("/")[-1]
                    elif self.comparePath(appPath, self.which()):
                        self.__app_path__=appPath.split("/")[-1]
                    else:
                        self.__app_path__=appPath
                else:
                    self.__app_path__=appPath.split("/")[-1]
        regex = re.compile(r"/\./")
        self.__app_path__ = regex.sub("/",self.__app_path__)
        return self.__app_path__

    def arch(self):
        if not hasattr(self, '__arch__'):
            if self.isCmd():
                self.__arch__ = 'amd64'
            else:
                result2, stdout2 = self.uname_a()
                result, stdout = self.uname_m()
                if result:
                    self.__arch__ = stdout.strip()
                    # "aarch64" and "arm64" are the same thing. AArch64 is the official name for the 64-bit ARM architecture, 
                    # but some people prefer to call it "ARM64" as a continuation of 32-bit ARM.
                    if self.__arch__ == 'arm64':
                        self.__arch__ = 'aarch64'
                    elif 'ARM64' in stdout2:
                        self.__arch__ = 'aarch64'
                    # X86_64 and AMD64 are different names for the same thing
                    elif self.__arch__ == 'x86_64':
                        self.__arch__ = 'amd64'
                else:
                    self.__arch__=''
        return self.__arch__

    def check_system(self):
        if not self.sysChecked():
            if self.pythonVersion().split(".")[0] =="3":
                self.pyName("python3").pyMajor(3)
                try:
                    self.pyMinor(int(self.pythonVersion().split(".")[1]))
                except:
                    self.pyMinor(0)
            else:
                self.pyName("python2").pyMajor(2)
                try:
                    self.pyMinor(int(self.pythonVersion().split(".")[1]))
                except:
                    self.pyMinor(0)
            minor = int(self.pythonVersion().split(".")[0])
            gcc = sys.version
            self.arch()
            if '\n' in gcc:
                gcc = gcc.split('\n')[1]
            elif '[' in gcc and ']' in gcc:
                gcc = gcc.split('[')[1].split(']')[0]
            if gcc=='GCC':
                gcc= '[GCC]'
            if ' (Red Hat' in gcc:
                gcc = gcc.split(' (Red Hat')[0] + ']'
            if '[PyPy ' in gcc and 'with' in gcc:
                pythonVersion = gcc.split('with')[0].split('[')[1].strip()
                self.pythonVersion("%s (%s)" % (self.pythonVersion(), pythonVersion))
                gcc = '[' + gcc.split('with ')[1]
                if self.pyName() == "python3":
                    self.pyName( "pypy3")
                else:
                    self.pyName( "pypy" )
            try:
                if platform.libc_ver()[0]!='':
                    self.libcName( platform.libc_ver()[0] )
            except:
                self.libcName("Most probably MSC (version unknow)")
            if 'AMD64' in gcc:
                self.__arch__ = 'amd64'
                if 'MSC' in gcc:
                    self.libcName('msc')
            elif 'AMD32' in gcc:
                self.libcName('msc')
                self.__arch__ = 'x86'
            if 'clang' in gcc:
                self.libcName('clang')
            self.libcVersion(gcc).osVersion()
            self.shellCmd()
            self.this()
            self.linuxDistro()
            if self.libcName()  == '' and self.shellCmd() == '/bin/ash':
                self.libcName('muslc')
            if self.arch() != '':
                if self.libcName() == '':
                    self.binVer('%s-' % (self.arch()))
                else:
                    self.binVer('%s-%s' % (self.arch(), self.libcName()))
        return self.sysChecked(True)

    def globalFolder(self, id=1):
        path = ['/usr/bin','/usr/local/bin']
        if id>=0 and id<2:
            return path[id]
        return ''

    def is_alpine(self):
        return self.osVersion().startswith('Alpine')

    def is_debian(self):
        return self.osVersion().startswith('Ubuntu') or self.osVersion().startswith('Debian') or self.osVersion().startswith('Raspbian') or self.is_mint() or self.is_kali()

    def is_fedora(self):
        return self.osVersion().startswith('Amazon Linux') or self.osVersion().startswith('Fedora')

    def is_kali(self):
        return self.osVersion().startswith('Kali')

    def is_linux(self):
        return not (self.osVersion()=='windows' or self.osVersion()=='macOS' or self.osVersion().startswith('macOS')) 

    def is_mac(self):
        return self.osVersion()=='macOS'

    def is_mint(self):
        return self.osVersion().startswith('Linux Mint')

    def is_window(self):
        return self.osVersion()=='windows'

    def is_ubuntu(self):
        return self.osVersion().startswith('Ubuntu')

    def is_opensuse(self):
        return self.osVersion().startswith('openSUSE')

    def is_redhat(self):
        return self.osVersion().startswith('CentOS') or self.osVersion().startswith('Red Hat')

    def linuxDistro(self):
        if not hasattr(self, '__distro__'):
            self.__distro__=''
            self.__os_major__=0
            self.__os_minor__=0
            if os.path.isfile("/etc/os-release"):
                fin = self.open("/etc/os-release", "rt", use_history=False)
                self.__distro__ = ''
                for line in fin:
                    line = line.strip()
                    if line.startswith('PRETTY_NAME='):
                        if '"' in line:
                            self.__distro__ = line.split('"')[1]
                        else:
                            self.__distro__ = line.split('=')[1]
                    if line.startswith('VERSION_ID='):
                        if '"' in line:
                            version_id = line.split('"')[1]
                        else:
                            version_id = line.split('=')[1]
                        if "." in version_id:
                            major = version_id.split(".")[0]
                            minor = version_id.split(".")[1]
                            if major.isdigit():
                                self.__os_major__=int(major)
                            if minor.isdigit():
                                self.__os_minor__=int(minor)
                        elif version_id.isdigit():
                            self.__os_major__=int(version_id)
                if 'Alpine' in self.__distro__:
                    self.shellCmd("/bin/ash")
        return self.__distro__

    def osVersion(self):
        if not self.isGitBash() and self.pathexists("/etc/os-release"):
            self.linuxDistro()
        if hasattr(self,'__distro__'):
            return self.__distro__
        self.__distro__  = ''
        if os.name == 'nt':
            self.__distro__='windows'
        elif self.shellCmd() != '':
            result, stdout = self.shell(command=["sw_vers","-productName"],ignoreShell=True)
            if result:
                self.__distro__ = stdout.strip()
        return self.__distro__

    def pathexists(self, path, use_history=False):
        if self.isGitBash() or self.isCmd():
            path = self.path_to_dos(path)
        if use_history:
            if self.isCmd() and self.hasFunc("history_dir"):
                self.history_dir(path)
            elif self.hasFunc("history_ls"):
                self.history_ls(path)
        return os.path.exists(path)

    def pythonVersion(self, version=None):
        if version is not None:
            self.__python_version__ = version.strip()
            return self
        elif  hasattr(self, '__python_version__'):
            return self.__python_version__ 
        self.__python_version__ = sys.version
        if len(self.__python_version__.split('\n'))>1:
            self.__python_version__ =  self.__python_version__.split('\n')[0].strip()
        if len( self.__python_version__.split('['))>1:
            self.__python_version__ =  self.__python_version__.split('[')[0].strip()
        if len( self.__python_version__.split('('))>1:
            self.__python_version__ =  self.__python_version__.split('(')[0].strip()
        return self.__python_version__

    def root_or_sudo(self):
        if not hasattr(self, '__history_check_root__'):
            self.__history_check_root__ = True
            self.cmd_history("# ** Check if user is root or can sudo **", currentframe().f_lineno)
        # root_or_sudo() Check user is root or has sudo privilege and assuming linux
        if not self.is_linux():
            return False
        if self.username()=='root':
            return True
        if not hasattr(self, '__asked_sudo__'):
            if self.allowInstallLocal():
                return False
            self.__asked_sudo__=True
            if self.ask_not_root():
                self.sudo_test()
        return self.is_sudo()

    def ubuntu_version(self):
        if not hasattr(self,'__ubuntu_version__'):
            if self.osVersion().startswith("Ubuntu"):
                version=self.osVersion().split(' ')
                length=len(version)
                if length>1:
                    self.__ubuntu_version__=version[length - 1]
            else:
                self.__ubuntu_version__=''
        return self.__ubuntu_version__

    def uname(self, switch, ignoreErr=True):
        stderr = ''
        stdout = ''
        command = 'uname %s' % switch
        if self.isLinuxShell():
            uname = self.which_cmd('uname')
            command = '%s %s' % (uname, switch)
            if uname != '':
                stdout,stderr = Popen([uname,switch],stdin=PIPE,stdout=PIPE,\
                    stderr=PIPE,universal_newlines=True).communicate('\n')
            else:
                return False, 'uname not found'
        if self.isGitBash():
            winpty = self.where_cmd('winpty.exe')
            uname = self.where_cmd('uname.exe')
            stdout,stderr = Popen([winpty, uname,switch],stdin=PIPE,stdout=PIPE,\
                stderr=PIPE,universal_newlines=True).communicate('\n')
            if stderr.strip().lower() == 'stdin is not a tty':
                stdout,stderr = Popen([uname,switch],stdin=PIPE,stdout=PIPE,\
                    stderr=PIPE,universal_newlines=True).communicate('\n')
        elif self.isCmd():
            stdout,stderr = Popen([self.shellCmd(),'/c',command],stdin=PIPE,stdout=PIPE,\
                stderr=PIPE,universal_newlines=True).communicate('\n')
        else:
            # Assume /bin/sh as default shell
            uname = self.which_cmd('uname')
            if uname != '':
                stdout,stderr = Popen([uname,switch],stdin=PIPE,stdout=PIPE,\
                    stderr=PIPE,universal_newlines=True).communicate('\n')
            else:
                return False, 'uname not found'
        if stderr != "" and not ignoreErr:
            self.msg_error(command, stderr)
            return False, stderr
        else:
            return True, stdout

    def uname_a(self, ignoreErr=True):
        return self.uname('-a')

    def uname_m(self, ignoreErr=True):
        return self.uname('-m')

class AppMsg(OS):

    def __init__(self, this = None):
        try:
            super().__init__(this)
        except:
            super(AppMsg, self).__init__(this)

    def msg_alpine_detected(self, title="OPERATION SYSTEM"):
        self.infoMsg("Alpine Detected!", title)

    def msg_both_local_global(self, title="INSTALLED TWICE"):
        self.criticalMsg("It may causes error if you have installed both local version and Global Version!\n  Please uninstall local version by,\n    %s uninstall" % self.appPath(), title)

    def msg_download_error(self, file):
        if not hasattr(self,'__msgshown_download_error__'):
            self.criticalMsg("Download file error: %s" % file, "DOWNLOAD ERROR")
            self.__msgshown_download_error__=True

    def msg_download_url_error(self, url, code):
        if not hasattr(self,'__msgshown_download_error__'):
            self.criticalMsg("Url: %s\n  HTTP code: %s" % (url, code), "DOWNLOAD ERROR")
            self.__msgshown_download_error__=True

    def msg_download_not_found(self, file):
        self.criticalMsg("Downloaded File: %s" % file, "NOT FOUND")

    def msg_downloaded(self, fname="", title="DOWNLOADED"):
        self.safeMsg("File downloaded to: %s" % fname, title)

    def msg_downloading(self, url="", title="DOWNLOAD FILES"):
        self.infoMsg("Downloading: %s ..." % url, title)

    def msg_error(self, command="", stderr="", title="ERROR"):
        self.criticalMsg("Error in %s: %s" % (command, stderr), title)

    def msg_extraction_error(self, file="", title="DOWNLOAD ERROR"):
        self.criticalMsg("File Extraction error: %s not found" % file, title)

    def msg_incompatiable_os(self, title="INSTALL"):
        self.criticalMsg("Using incompatible OS or not able to use sudo", title)

    def msg_installation_failed(self, title="INSTALLATION"):
        self.criticalMsg("Installation failed!", title)

    def msg_global_already(self, title="SELF INSTALL"):
        self.infoMsg("Global Installation installed already!", title)

    def msg_global_failed(self, title="SELF UNINSTALL"):
        self.criticalMsg("Global uninstall failed!", title)

    def msg_install_app_global(self, title="INSTALL"):
        if self.isCmd() or self.isGitBash():
            self.msg_install(location='Globally', app="%s.bat" % self.appName(), title=title)
        else:
            self.msg_install(location='Globally', app=self.appName(), title=title)

    def msg_install_app_local(self, title="INSTALL"):
        if self.isCmd() or self.isGitBash():
            self.msg_install(location='Locally', app="%s.bat" % self.appName(), title=title)
        else:
            self.msg_install(location='Locally', app=self.appName(), title=title)

    def msg_install(self, location="", app="", title="INSTALL"):
        startSh =  ""   # for ash, cmd, gitbash
        if location == 'Locally':
            if self.osVersion() == 'macOS':
                startSh = "  Please type 'hash -r' and 'source ~/.zshenv' to refresh zsh shell hash!\n  Then, you can "
            elif self.shellCmd() != '/bin/ash' and self.isLinuxShell():
                startSh =  "  Please type 'hash -r' and 'source ~/.bashrc' to refresh bash shell hash!\n  Then, you can "
            self.safeMsg("Installed %s! \n%s  type '%s' to run!" % (location, startSh, app), title)
        else:
            self.safeMsg("Installed %s! \n    type '%s' to run!" % (location, app), title)

    def msg_install_target_global(self, title="INSTALL"):
        if self.isCmd() or self.isGitBash():
            self.msg_install(location='Globally', app="%s.exe" % self.targetApp(), title=title)
        else:
            self.msg_install(location='Globally', app=self.targetApp(), title=title)

    def msg_install_target_local(self, title="INSTALL"):
        if self.isCmd() or self.isGitBash():
            self.msg_install(location='Locally', app="%s.exe" % self.targetApp(), title=title)
        else:
            self.msg_install(location='Locally', app=self.targetApp(), title=title)

    def msg_latest(self, title="CHECK VERSION"):
        if self.is_local():
            self.msg_latest_global(title)
        elif self.is_local():
            self.msg_latest_local(title)
        else:
            self.infoMsg("You are using latest (%s.%s) already!" % (self.majorVersion(),self.minorVersion()), title)

    def msg_latest_global(self, title="CHECK VERSION"):
        self.infoMsg("You are using latest (%s.%s) Global Installation's copy already!" % (self.majorVersion(),self.minorVersion()), title)

    def msg_latest_local(self, title="CHECK VERSION"):
        self.infoMsg("You are using latest (%s.%s) Local Installation's copy already!" % (self.majorVersion(),self.minorVersion()), title)

    def msg_latest_available(self, title="CHECK UPDATE"):
        self.infoMsg("Latest Version = %s\n  Update is available" % self.latest_version(), title)

    def msg_linux_only(self):
        self.criticalMsg("This programs required linux only.", "LINUX ONLY")

    def msg_local_already(self, title="SELF INSTALL"):
        self.infoMsg("Local Installation installed already!", title)

    def msg_no_global(self, title="GLOBAL UNINSTALL"):
        self.infoMsg("You don't have any local installation.", title)

    def msg_no_local(self, title="LOCAL UNINSTALL"):
        self.infoMsg("You don't have any local installation.", title)

    def msg_no_server(self, title="CONNECTION FAILED"):
        self.criticalMsg("Cannot communicate with server", title)

    def msg_no_installation(self, title="UNINSTALL"):
        self.infoMsg("You don't have any global or local installation.", title)

    def msg_not_compatible_os(self, title="INSTALL"):
        self.infoMsg("Your OS is not compatible: %s" % self.osVersion(), title)

    def msg_not_working_docker(self, title="SYSTEM DAEMON"):
        self.criticalMsg("systemctl or journalctl cannot work properly in docker container.", title)

    def msg_root_continue(self, title="SELF INSTALL"):
        self.infoMsg("You must be root or sudo to continue installation!", title)

    def msg_old_global(self, title="SELF INSTALL"):
        self.infoMsg("You are using an old (%s.%s) Global Installation's copy already!" % (self.majorVersion(),self.minorVersion()), title)

    def msg_old_local(self, title="SELF INSTALL"):
        self.infoMsg("You are using an old (%s.%s) Local Installation's copy already!" % (self.majorVersion(),self.minorVersion()), title)

    def msg_permission_denied(self, path="", title=""):
        self.criticalMsg("Permission denied: %s" % path, title)

    def msg_sudo(self, title="SUDO TEST"):
        if not hasattr(self,'__msg_sudo_verified__'):
            self.__msg_sudo_verified__ = True
            self.infoMsg("Your sudo privilege has been verified.", title)

    def msg_sudo_not_installed(self, title="SUDO TEST"):
        if not hasattr(self,'__msg_sudo_not_installed__'):
            self.__msg_sudo_not_installed__ = True
            self.infoMsg("'SUDO' has not installed in your system.", title)
            if self.osVersion().startswith("Alpine"):
                self.safeMsg("Please use the following command to install sudo:\n    apk add sudo", title)

    def msg_sudo_failed(self, title="SUDO FAILED"):
        self.criticalMsg("You should be root or sudo to install globally.", title)

    def msg_temp_folder_failed(self, folder="", title=""):
        if not hasattr(self,'__msg_temp_error__'):
            self.__msg_temp_error__=True
            self.criticalMsg("Cannot access or create temp folder: %s" % folder, title)

    def msg_timeout(self, file="", title="ERROR"):
        self.criticalMsg("Time out in downloading %s" % (file), title)

    def msg_too_many_backup(self):
        self.criticalMsg("Too many backup created.", "BACKUP CREATION FAILED")

    def msg_unintall_global(self, title="GLOBAL UNINSTALL"):
        self.safeMsg("You have uninstalled successfully.", title)

    def msg_uninstall_global_failed(self, title="UNINSTALL FAILED"):
        self.criticalMsg("Failed to uninstall globally", title)

    def msg_uninstall_local(self, title="LOCAL UNINSTALL"):
        self.safeMsg("You have uninstalled successfully.", title)

    def msg_uninstall_local_failed(self, title="UNINSTALL FAILED"):
        self.criticalMsg("Failed to uninstall locally", title)

    def msg_unintall_need_root(self, title="GLOBAL UNINSTALL"):
        self.criticalMsg("You should be root or sudo to uninstall globally.", title)

    def msg_unknown_parameter(self, para, title="UNKNOWN PARAMETER"):
        self.criticalMsg("Unknown parameter '%s'" % para, title)

    def msg_user_found(self, username="", title="CREATING USER"):
        self.infoMsg("Existing user group: %s found." % username, title)

    def msg_user_group_found(self, usergroup="", title="CREATING GROUP"):
        self.infoMsg("Existing user: %s found." % usergroup, title)

    def msg_wrong_shell(self, cmd="", title=""):
        self.infoMsg("You are using wrong shell to execute: '%s'" % cmd)

class Shell(AppMsg):

    def __init__(self, this = None):
        try:
            super().__init__(this)
        except:
            super(Shell, self).__init__(this)
        Attr(self, 'sudo_cmd', self.which_cmd('sudo'))

    def chdir(self, path, line_num=None):
        if self.isCmd() or self.isGitBash():
            self.history_cd(self.path_to_dos(path), line_num)
            os.chdir(self.path_to_dos(path))
        else:
            self.history_cd(path, line_num)
            os.chdir(path)

    def chmod(self, filePath="", switch="", use_history=True, useSudo=False):
        if self.isCmd() or self.isGitBash():
            filePath=self.path_to_dos(filePath)
        if self.pathexists(filePath):
            chmod_cmd = self.which_cmd('chmod', "")
            cmd=""
            if chmod_cmd != "":
                if useSudo:
                    if self.sudo_cmd()!="":
                        cmd = '%s %s %s %s' % (self.sudo_cmd(), chmod_cmd,switch,filePath)
                else:                
                    cmd = '%s %s %s' % (chmod_cmd,switch,filePath)
                if cmd=="":
                    return False                
                if use_history:
                    self.cmd_history(cmd)
                result, stdout = self.shell(cmd)
            return result
        return False

    def chown(self, filePath="", owner="", use_history=True, useSudo=False):
        if self.isCmd() or self.isGitBash():
            filePath=self.path_to_dos(filePath)
        if self.pathexists(filePath):
            chown = self.which_cmd('chown')
            cmd=""
            if useSudo:
                if self.sudo_cmd()!="":
                    cmd = '%s %s -R %s %s' % (self.sudo_cmd(), chown,owner,filePath)
            else:                
                cmd = '%s -R %s %s' % (chown,owner,filePath)    
            if cmd=="":
                return False            
            if use_history:
                self.cmd_history(cmd)
            result, stdout = self.shell(cmd)
            return result
        return False
    
    def chmod_x(self, filePath="", use_history=True, useSudo=False):
        if self.is_window():
            return False
        return self.chmod(filePath=filePath, switch="+x", use_history=use_history, useSudo=useSudo)

    def comparePath(self, p1, p2):
        return os.path.abspath(p1)==os.path.abspath(p2)

    def cmd_list(self, x=None, rstrip=False):
        if not hasattr(self,'__cmdList__'):
            self.__cmdList__=[]
        if x is not None:
            if isinstance(x,list):
                for l in x:
                    if isinstance(l,basestring) and rstrip:
                        self.__cmdList__.append(l.rstrip())
                    else:
                        self.__cmdList__.append(l)
            else:
                self.__cmdList__.append(x)
            return self
        return self.__cmdList__

    def cp(self, filePath1="", filePath2="", use_history=True, useSudo=False):
        cmd = ""
        stdout = ""
        if self.isCmd():
            filePath1=self.path_to_dos(filePath1)
            filePath2=self.path_to_dos(filePath2)
            if self.isCmd():
                if "*" in filePath1 or os.path.isdir(filePath1):
                    cmd = 'xcopy %s %s /e /i' % (filePath1,filePath2)
                else:
                    cmd = 'copy %s %s' % (filePath1,filePath2)
        elif self.isGitBash():
            filePath1=self.path_to_gitbash(filePath1)
            filePath2=self.path_to_gitbash(filePath2)
            cmd = 'cp %s %s' % (filePath1,filePath2)
        else:
            cp = self.which_cmd('cp')
            if useSudo:
                cmd = '%s %s -rP %s %s' % (self.sudo_cmd(), cp,filePath1,filePath2)
            else:
                cmd = '%s -rP %s %s' % (cp,filePath1,filePath2)
        if cmd=="":
            return False 
        if use_history:
            self.cmd_history(cmd)
        result, stdout = self.shell(cmd)
        return result, stdout

    def create_group(self, groupname=None, user_id=None, group_id=None):
        cmd= "getent group %s" %  groupname
        self.history_check_group_exists(currentframe().f_lineno)
        self.cmd_history(cmd)
        result, stdout = self.shell(cmd)
        if group_id is None and not (user_id is None):
            group_id = user_id
        if stdout=="":
            cmd = ""
            if self.is_alpine():
                if self.is_sudo():
                    cmd = "sudo addgroup -g %d %s" % (group_id, groupname)
                else:
                    cmd = "addgroup -g %d %s" % (group_id, groupname)
            elif self.is_debian() or self.osVersion().startswith('CentOS') or self.is_fedora():
                if self.is_sudo():
                    cmd = "sudo groupadd -g %d %s" % (group_id, groupname)
                else:
                    cmd = "groupadd -g %d %s" % (group_id, groupname)
            if cmd != "":
                self.history_add_group(groupname, currentframe().f_lineno)
                self.cmd_history(cmd)
                self.shell(cmd, ignoreErr=True)
        else:
            self.history_group_exists(groupname, currentframe().f_lineno)
            self.msg_user_group_found(groupname)

    def create_user(self, username=None, user_id=None, group_id=None, home=None):
        self.create_group(username, user_id=user_id, group_id=group_id)
        cmd= "id %s" % username
        self.history_check_user_exists(currentframe().f_lineno)
        self.cmd_history(cmd)
        result, stdout = self.shell(cmd, ignoreErr=True)
        if stdout=="":
            cmd = ""
            if home is None:                    
                if self.is_alpine():
                    if self.is_sudo():
                        cmd = "sudo adduser -D -G %s %s" % (group_id, username)
                    else:
                        cmd = "adduser -D -G %s %s" % (group_id, username)
                elif self.is_debian() or self.osVersion().startswith('CentOS') or self.is_fedora():
                    if self.is_sudo():
                        cmd = "sudo useradd -g %d -u %d -m -s /bin/bash %s" % (group_id, user_id, username)
                    else:
                        cmd = "useradd -g %d -u %d -m -s /bin/bash %s" % (group_id, user_id, username)
            else:
                if self.is_alpine():
                    if self.is_sudo():
                        cmd = "sudo adduser -D -G %s -h %s %s" % (username, home, username)
                    else:
                        cmd = "adduser -D -G %s -h %s %s" % (username, home, username)
                elif self.is_debian() or self.osVersion().startswith('CentOS') or self.is_fedora():
                    if self.is_sudo():
                        cmd = "sudo useradd -g %d -u %d -m -d %s -s /bin/bash %s" % (group_id, user_id, home, username)
                    else:
                        cmd = "useradd -g %d -u %d -m -d %s -s /bin/bash %s" % (group_id, user_id, home, username)
            if cmd != "":
                self.history_add_user(username, currentframe().f_lineno)
                self.cmd_history(cmd)
                self.shell(cmd, ignoreErr=True)
        else:
            self.history_user_exists(username, currentframe().f_lineno)
            self.msg_user_found(username)

    def curPath(self, curPath=None):
        if curPath is not None:
            self.__curPath__=curPath
            return self
        elif not hasattr(self, '__curPath__'):
            pw='%s' % os.getcwd()
            if self.isGitBash() and ':' in pw:
                pw=pw.split(':')
                self.__curPath__='/'+pw[0]+'/'.join(pw[1].split('\\'))
            else:
                self.__curPath__=pw
        return self.__curPath__

    def isCmd(self):
        if not hasattr(self, '__is_cmd__'):
            if not hasattr(self, '__shell_cmd__'):
                self.shellCmd()
            self.__is_cmd__ = self.__shell_cmd__.split('\\')[-1] == 'cmd.exe' 
        return self.__is_cmd__

    def isLinuxShell(self):
        return self.shellCmd() == '/bin/bash' or self.shellCmd() == '/bin/zsh' or \
            self.shellCmd() == '/bin/sh' or self.shellCmd() == '/bin/ash' or \
            self.shellCmd() == '/usr/bin/fish'

    def mkdir(self, path, sudo = False):
        if not self.pathexists( path ):
            if self.isCmd():
                path=self.path_to_dos(path)
                dir_split = path.split('\\')
                dirloc = dir_split[0]
                for dirlet in dir_split[1:]:
                    self.cmd_history("md %s" % path)
                    if dirlet != '':
                        dirloc = dirloc + '\\' + dirlet
                        if not self.pathexists(dirloc):
                            os.mkdir( dirloc )
            else:
                if sudo:
                    self.cmd_history("sudo mkdir -p %s" % path)
                else:
                    self.cmd_history("mkdir -p %s" % path)
                dir_split = path.split('/')
                dirloc = ''
                for dirlet in dir_split:
                    if dirlet != '':
                        dirloc = dirloc + '/' + dirlet
                        if not self.pathexists(dirloc):
                            try:
                                if sudo:
                                    self.shell("sudo mkdir -p %s" % dirloc)
                                else:
                                    os.mkdir( dirloc )
                            except:
                                self.msg_permission_denied(dirloc)
                                return False
            return True
        return True

    def open(self, fname="", sw="", use_history=True):
        if self.isGitBash() or self.isCmd():
            fname = self.path_to_dos(fname)
        if use_history:
            cmd='# python> open("%s", "%s")' % (fname,sw)
            self.cmd_history(cmd)
        return open(fname, sw)

    def removeFile(self, filePath="", use_history=True):
        if self.isCmd():
            filePath=self.path_to_dos(filePath)
        elif self.isGitBash():
            filePath=self.path_to_gitbash(filePath)
        if self.pathexists(filePath):
            if self.isCmd():
                filePath=self.path_to_dos(filePath)
                cmd = 'del %s' % filePath
            else:
                rm = self.which_cmd('rm')
                cmd = '%s %s' % (rm,filePath)
            if use_history:              
                self.cmd_history(cmd)
            if self.isCmd():
                os.remove(filePath)
            else:
                self.shell([rm,filePath])

    def removeGlobalInstaller(self):
        file1 = self.globalInstallPath(0)
        file2 = self.globalInstallPath(1)
        display_once = False
        if os.path.exists(file1):
            self.history_remove_previous_global(currentframe().f_lineno)
            display_once = True
            self.sudoRemoveFile(file1)
        if os.path.exists(file2):
            if not display_once:
                self.history_remove_previous_global(currentframe().f_lineno)
                display_once = True
            self.sudoRemoveFile(file2)

    def removeFilePattern(self, dirPath, pattern):
        if self.pathexists(dirPath) and os.path.isdir(dirPath):
            for file in os.listdir(dirPath):
                if file.endswith(pattern):
                    self.removeFile("%s/%s" % (dirPath,file))

    def removeFolder(self, dirPath, use_history=False):
        if use_history:
            self.history_remove_folder(dirPath)
        if self.isCmd() or self.isGitBash():
            dirPath=self.path_to_dos(dirPath)
        if self.pathexists(dirPath) and os.path.isdir(dirPath):
            if use_history:
                self.cmd_history("rm -rf %s" % dirPath)
            shutil.rmtree(dirPath)
        else:
            if use_history:
                self.cmd_history("# folder %s: not found, cannot be removed." % dirPath)

    def remove_user(self, username=None):
        cmd= "id %s" % username
        self.history_check_user_exists(currentframe().f_lineno)
        self.cmd_history(cmd)
        result, stdout = self.shell(cmd, ignoreErr=True)
        if stdout!="":
            cmd = ""
            if self.is_alpine():
                if self.is_sudo():
                    cmd = "sudo deluser --remove-home %s" % username
                else:
                    cmd = "deluser --remove-home %s" % username
            elif self.is_debian() or self.osVersion().startswith('CentOS'):
                if self.is_sudo():
                    cmd = "sudo userdel -r %s" % username
                else:
                    cmd = "userdel -r %s" % username
            self.history_remove_user(username,currentframe().f_lineno)
            self.cmd_history(cmd)
            self.shell(cmd, ignoreErr=True)

    def shell(self, command='', ignoreErr=False, ignoreShell=False, ignoreAll=False):
        stderr = ''
        stdout = ''
        useWinpty = False
        if ignoreAll:
            pipe_array=[]
        elif ignoreShell:
            if self.isGitBash():
                winpty = self.where_cmd('winpty.exe')
                if winpty == "":
                    pipe_array=[]
                else:
                    useWinpty = True
                    pipe_array=[winpty]
            else:
                pipe_array=[]
        elif self.isLinuxShell():   
            pipe_array=[self.shellCmd(),'-c']
        elif self.isGitBash():
            winpty = self.where_cmd('winpty.exe')
            if winpty == "":
                pipe_array=[self.shellCmd(),'-c']
            else:
                useWinpty = True
                pipe_array=[winpty, self.shellCmd(),'-c']
        elif self.isCmd():
            pipe_array=[self.shellCmd(),'/c']
        else:
            # Assume /bin/sh as default shell
            pipe_array=['/bin/sh','-c']
        if isinstance(command, basestring):
            pipe_array.append(command)
        elif isinstance(command, list):
            if self.isCmd() or self.isGitBash():
                for cmdlet in command:
                    pipe_array.append(cmdlet)
            else:
                pipe_array=[]
                for cmdlet in command:
                    pipe_array.append(cmdlet)
        else:
            if ignoreErr:
                return True, ""
            else:
                return False, "Wrong command data type."
        try:
            stdout,stderr = Popen(pipe_array,stdin=PIPE,stdout=PIPE,\
                stderr=PIPE,universal_newlines=True).communicate('\n')
        except:
            if ignoreErr:
                return True
            else:
                return False
        try:
            if stderr.strip().lower() == 'stdin is not a tty' and useWinpty:
                stdout,stderr = Popen(pipe_array[1:],stdin=PIPE,stdout=PIPE,\
                    stderr=PIPE,universal_newlines=True).communicate('\n')
            if stderr != "" and not ignoreErr:
                self.msg_error(command, stderr)
                return False, stderr
            else:
                return True, stdout
        except:
            return False, ""

    def ln(self, source="", target="", use_history=True, useSudo=False):
        if self.isCmd():
            self.msg_wrong_shell('ln')
            return False
        if self.isGitBash():  
            filePath=self.path_to_dos(source)
        if self.pathexists(source):
            source_split = source.split('/')
            if len(source_split) > 0:
                last_part=source_split[len(source_split) - 1]
                if target[-1] == '/':
                    test_path = '%s%s' % (target,last_part)
                else:
                    test_path = '%s/%s' % (target,last_part)
                if self.pathexists(test_path):
                    self.history_link_exists(test_path, currentframe().f_lineno)
                else:
                    cmd = ""
                    ln_cmd = self.which_cmd('ln')
                    if useSudo:
                        if self.sudo_cmd() != "":
                            cmd = '%s %s -s %s %s' % (self.sudo_cmd(),ln_cmd,source,target)
                    else:                
                        cmd = '%s -s %s %s' % (ln_cmd,source,target)
                    if cmd=="":
                        return False
                    if use_history:
                        self.cmd_history(cmd)
                    result, stdout = self.shell(cmd)
                    return result
        return False

    def sudo_test(self,msg='.'):
        if self.sudo_cmd() == "":
            return False
        distro = self.osVersion()
        if distro == 'windows':
            self.is_sudo(False)
            return False
        if self.is_sudo():
            return True
        if distro.startswith('Alpine'):
            stdout,stderr = Popen([ self.shellCmd(), '-c' , "which sudo" ],\
                stdin=PIPE,stdout=PIPE,stderr=PIPE,universal_newlines=True)\
                .communicate( '\n' )
            if stdout=='':
                return False
        stdout,stderr = Popen([ self.shellCmd(), '-c' , "sudo echo %s" % msg ],\
            stdin=PIPE,stdout=PIPE,stderr=PIPE,universal_newlines=True)\
            .communicate( '\n' )
        trial=0
        while stdout.strip() != msg.strip() and trial < 3:
            sudoPassword=getpass.getpass( 'Please input "sudo" password for %s: ' % self.username() )
            stdout, stderr = Popen([ self.shellCmd() , '-c',"sudo echo %s" % msg ] \
                ,stdin=PIPE,stdout=PIPE,stderr=PIPE,\
                universal_newlines=True ).communicate( "%s\n" % sudoPassword )
            if self.signal() == 2:
                return False
            trial=trial + 1
        if trial < 3:
            self.is_sudo( True )
        return self.is_sudo()

    def sudoRemoveFile(self, filePath, useSudo=False):
        if self.pathexists(filePath):
            cmd = ""
            rm_cmd = self.which_cmd('rm')
            if self.username() == 'root':
                cmd = '%s -rf %s' % (rm_cmd, filePath)
            elif useSudo or self.sudo_test():
                if self.sudo_cmd() != "":
                    cmd = '%s %s -rf %s' % (self.sudo_cmd(), rm_cmd, filePath)
            if cmd=="" or self.signal == 3:
                return False
            self.cmd_history(cmd)
            self.shell( cmd )
            return True

    def tar_compress(self,fname, path):
        if self.isCmd() or self.isGitBash():
            tar = self.where_cmd('tar.exe')
        else:
            tar = self.which_cmd('tar')
        if self.is_mac() or self.is_window():
            if self.isCmd():
                fname = self.path_to_dos(fname)
            cmd= [tar,"--uid","0","--gid","0", "--no-same-owner","--no-same-permissions","-cvf", fname, path]
        else:
            cmd= [tar,"--owner=0", "--group=0", "--no-same-owner","--no-same-permissions","-cvf", fname, path]
        self.cmd_history(" ".join(cmd))
        result, stdout = self.shell(cmd,ignoreErr=True,ignoreAll=True)

    def tar_extract(self,fname):
        if self.isCmd() or self.isGitBash():
            tar = self.where_cmd('tar.exe')
        else:
            tar = self.which_cmd('tar')
        if self.isCmd():
            fname = self.path_to_dos(fname)        
        cmd= [tar,"-xvf", fname]
        self.cmd_history(" ".join(cmd))
        result, stdout = self.shell(cmd,ignoreErr=True,ignoreAll=True)

    def which(self):
        if self.isCmd()  or self.isGitBash():
            if self.pathexists(self.localInstallPath()):
                return self.localInstallPath()
            elif self.pathexists(self.globalInstallPath(0)):
                return self.globalInstallPath(0)
            elif self.pathexists(self.globalInstallPath(1)):
                return self.globalInstallPath(1)
            elif self.pathexists('C:\\Windows\\System32\\where.exe'):
                return self.where_cmd( self.appName())
        else:
            if self.pathexists(self.localInstallPath()):
                return self.localInstallPath()
            elif self.pathexists(self.globalInstallPath(0)):
                return self.globalInstallPath(0)
            elif self.pathexists(self.globalInstallPath(1)):
                return self.globalInstallPath(1)
            if self.pathexists('/usr/bin/which'):
                return self.which_cmd( self.appName())

    def which_cmd(self, cmd, default=""):
        stdout = ''
        original_cmd = cmd
        if "/" in cmd:
            cmd= cmd.split("/")[-1]
        if "\\" in cmd:
            cmd= cmd.split("\\")[-1]
        if self.isCmd():
            return self.where_cmd(cmd)
        elif self.isGitBash():
            result, stdout = self.shell(["/usr/bin/which", cmd], ignoreErr=True)
            return stdout.strip()
        elif self.isLinuxShell():
            if os.path.exists('/usr/bin/which'):
                result, stdout = self.shell(["/usr/bin/which", cmd], ignoreErr=True)
                return stdout.strip()
            elif os.path.exists('/bin/which'):
                result, stdout = self.shell(["/usr/bin/which", cmd], ignoreErr=True)
                return stdout.strip()
            elif os.path.exists('/bin/%s' % cmd):
                return '/bin/%s' % cmd
            elif os.path.exists('/sbin/%s' % cmd):
                return '/sbin/%s' % cmd
            elif os.path.exists('/usr/bin/%s' % cmd):
                return '/usr/bin/%s' % cmd
            elif os.path.exists('/usr/bin/local/%s' % cmd):
                return '/usr/bin/local/%s' % cmd
            elif os.path.exists('/usr/sbin/%s' % cmd):
                return '/usr/sbin/%s' % cmd
            elif os.path.exists('/home/%s/.local/bin/%s' % (self.username(), cmd)):
                return '/home/%s/.local/bin/%s' % (self.username(), cmd)
            elif 'PATH' in os.environ:
                split_path = os.environ['PATH'].split(':')
                for pathlet in split_path:
                    if os.path.exists('%s/%s' % (pathlet, cmd)):
                        return '%s/%s' % (pathlet, cmd)
        if cmd==original_cmd:
            cmd=default
        return cmd

    def where_cmd(self, cmd, default=""):
        stdout = ''
        if len(cmd) > 4:
            if '.' not in cmd and cmd[-4:] != '.exe':
                cmd = cmd + '.exe'
        elif '.' not in cmd:
            cmd = cmd + '.exe'
        original_cmd = cmd
        if "/" in cmd:
            cmd= cmd.split("/")[-1]
        if "\\" in cmd:
            cmd= cmd.split("\\")[-1]
        if self.isLinuxShell():
            return self.which_cmd(cmd)
        path = "C:\\Users\\%s\\AppData\\Local\\Microsoft\\WindowsApps\\%s" % (self.username(), original_cmd)
        if os.path.exists(path):
            cmd = path
        elif os.path.exists('C:\\Windows\\system32\\%s' % original_cmd):
            cmd = 'C:\\Windows\\system32\\%s' % original_cmd
        elif os.path.exists('C:\\Program Files\\Git\\usr\\bin\\%s' % original_cmd):
            cmd = 'C:\\Program Files\\Git\\usr\\bin\\%s' % original_cmd
        elif 'PATH' in os.environ:
            split_path = os.environ['PATH'].split(';')
            for pathlet in split_path:
                if os.path.exists('%s\\%s' % (pathlet, original_cmd)):
                    cmd =  '%s\\%s' % (pathlet, original_cmd)
                    break
        if cmd==original_cmd and original_cmd != 'winpty.exe':
            result, stdout = self.shell("where %s" % cmd, ignoreErr=True)
            cmd == stdout.strip()
        if cmd==original_cmd:
            cmd=default
        return cmd

    def which_journalctl(self):
        return self.which_cmd('journalctl', '/usr/bin/journalctl')

    def which_nginx(self):
        return self.which_cmd('nginx', '/usr/sbin/nginx')

    def which_rc_service(self):
        return self.which_cmd('rc-service', '/sbin/rc-service')

    def which_systemctl(self):
        return self.which_cmd('systemctl','/usr/bin/systemctl')

    def which_uname(self):
        return self.which_cmd('uname', '/usr/bin/uname')

class Installer(Shell):

    def __init__(self, this = None):
        try:
            super().__init__(this)
        except:
            super(Installer, self).__init__(this)
        Attr(self, "pyChecked", False)
        Attr(self, "cythonString", "")
        Attr(self, "python2", "")
        Attr(self, "python3", "")
        Attr(self, "py2Found", False)
        Attr(self, "py3Found", False)
        self.check_python()
            
    def check_python(self):
        if not self.pyChecked():
            self.cmd_history("# ** Checking python version  **",currentframe().f_lineno)
            if self.is_window():
                python2 = self.where_cmd("python2.exe",default="")
                python3 = self.where_cmd("python3.exe",default="")
            else:
                python2 = self.which_cmd("python2",default="")
                python3 = self.which_cmd("python3",default="")
            arch = 'x86_64'
            if self.arch() == 'amd64':
                arch = 'x86_64'
            if python2 == '' or python3 == '':
                python = self.which_cmd("python")
                if python != "":
                    if self.isGitBash():
                        python = self.path_to_gitbash(python)
                    result , stdout = self.shell([python,"--version"])
                    if result:
                        id_array = stdout.strip().split(' ')
                        if len(id_array) > 1:
                            version_array = id_array[1].split(".")
                            version = version_array[0]
                            if int(version) == 2:
                                python2 = python
                            elif int(version) == 3 and python3=='':
                                python3 = python
                            if self.is_mac():
                                self.cythonString("cpython-%s%s-darwin" % (version_array[0], version_array[1]))
                            else:
                                self.cythonString("cpython-%s%s-%s-linux-gnu" % (version_array[0], version_array[1], arch))
            if self.isGitBash():
                self.python2( self.path_to_gitbash(python2) )
                self.python3( self.path_to_gitbash(python3) )
            else:
                self.python2( python2 )
                self.python3( python3 )
            if python2!="" and not self.py2Found():
                self.py2Found( True )
                self.cmd_history("  # python2 found: %s" % python2)
            if python3!="" and  not self.py3Found():
                self.py3Found( True )
                self.cmd_history("  # python3 found: %s" % python3)
            if self.python2() != "":
                result , stdout = self.shell("%s --version" % self.python2())
                if result:
                    id_array = stdout.strip().split(' ')
                    if len(id_array) > 1:
                        version_array = id_array[1].split(".")
                        if self.is_mac():
                            self.cythonString("cpython-%s%s-darwin" % (version_array[0], version_array[1]))
                        else:
                            self.cythonString("cpython-%s%s-%s-linux-gnu" % (version_array[0], version_array[1], arch))
            if self.python3() != "":
                result , stdout = self.shell("%s --version" % self.python3())
                if result:
                    id_array = stdout.strip().split(' ')
                    if len(id_array) > 1:
                        version_array = id_array[1].split(".")
                        if self.is_mac():
                            self.cythonString("cpython-%s%s-darwin" % (version_array[0], version_array[1]))
                        else:
                            self.cythonString("cpython-%s%s-%s-linux-gnu" % (version_array[0], version_array[1], arch))
        self.pyChecked(True)

    def install(self, this, verbal=False):
        if self.username() == 'root':
            return self.__self_install__(this=this, verbal=verbal)
        elif not self.isGlobal():
            return self.__install_local__(this=this, verbal=verbal)
        else:
            self.msg_global_already()
            return False

    def install_containerd(self):
        return self.install_package('containerd', ['/usr/bin/containerd'])

    def install_docker_io(self):
        return self.install_package('docker.io', ['/usr/bin/docker'])

    def install_libcrypto(self):
        if self.osVersion().startswith('Alpine'):
            result = self.install_package('libcrypto1.1', ['/usr/lib/libcrypto.so'])
        else:
            result = self.install_package('libssl-dev', ['/usr/lib/x86_64-linux-gnu/libcrypto.so'])
        return result

    def install_libinih(self):
        if self.is_alpine():
            result = self.install_package('inih-dev', ['/usr/lib/libinih.so'])
        else:
            result = self.install_package('libinih-dev', ['/usr/lib/x86_64-linux-gnu/libinih.so'])
        return result

    def install_libpcre2(self):
        if self.is_alpine():
            result = self.install_package('pcre2-dev', ['/usr/lib/libpcre2-8.so.0'])
        else:
            result = self.install_package('libpcre2-dev', ['/usr/lib/x86_64-linux-gnu/libpcre2-32.so'])
        return result

    def install_libsqlite3_dev(self):
        if self.is_alpine():
            result = self.install_package('sqlite-dev', ['/usr/lib/libsqlite3.so'])
        else:
            result = self.install_package('libsqlite3-dev', ['/usr/lib/x86_64-linux-gnu/libsqlite3.so'])
        return result

    def install_libsqlite3(self):
        result = self.install_package('sqlite3', ['/usr/bin/sqlite3'])
        return result

    def install_linux_headers(self):
        if self.is_alpine():
            return self.install_package('linux-headers',['/usr/include/linux/version.h'])
        return True

    def install_local(self, verbal = True):
        if self.thisFile().endswith(".so"):
            return self.__install_local__(self.this(), verbal)
        else:
            return self.__install_local__(self.thisFile(), verbal)

    def install_musl_dev(self):
        if self.is_alpine():
            return self.install_package('musl-dev',['/usr/include/stdio.h'])
        return True

    def install_package(self, package=None, path=None):
        installed = False
        self.history_check_exists(package, currentframe().f_lineno)
        checkPath=False
        if path is not None and package is not None:
            if isinstance(path,basestring):
                if self.pathexists(path, use_history=True):
                    self.history_package_exists(package, currentframe().f_lineno)
                    checkPath= True
                if self.which_cmd(path):
                    self.cmd_history("ls %s" % self.which_cmd(path))
                    checkPath=True
            elif isinstance(path,list):
                for l in path:
                    if self.pathexists(l, use_history=True):
                        self.history_package_exists(package, currentframe().f_lineno)
                        checkPath= True
                    if self.which_cmd(l):
                        self.cmd_history("ls %s" % self.which_cmd(l))
                        self.history_package_exists(package, currentframe().f_lineno)
                        checkPath=True
        if checkPath:
            return True
        if self.update_repository():
            if self.is_debian():
                self.history_install_package(package, currentframe().f_lineno)
                if self.is_sudo():
                    cmd = "sudo apt install -y %s" % package
                else:
                    cmd = "apt install -y %s" % package
                self.cmd_history(cmd)
                self.shell(cmd, ignoreErr=True)
                installed = True
            elif self.is_alpine():
                self.history_install_package(package, currentframe().f_lineno)
                if self.is_sudo():
                    cmd = "sudo apk add %s" % package
                else:
                    cmd = "apk add %s" % package
                self.cmd_history(cmd)
                self.shell(cmd, ignoreErr=True)
                installed = True
            elif self.is_redhat():
                if self.is_sudo():
                    cmd = "sudo yum install -y %s" % package
                else:
                    cmd = "yum install -y %s" % package
                self.cmd_history(cmd)
                self.shell(cmd, ignoreErr=True)
                installed = True
            elif self.is_fedora():
                if self.is_sudo():
                    cmd = "sudo dnf install -y %s" % package
                else:
                    cmd = "dnf install -y %s" % package
                self.cmd_history(cmd)
                self.shell(cmd, ignoreErr=True)
                installed = True
            elif self.is_opensuse():
                if self.is_sudo():
                    cmd = "sudo zypper install -y %s" % package
                else:
                    cmd = "zypper install -y %s" % package
                self.cmd_history(cmd)
                self.shell(cmd, ignoreErr=True)
                installed = True
            else:
                self.cmd_history("  # Not compatible OS")
                self.msg_not_compatible_os()
            if installed:
                if path is not None and package is not None:
                    if isinstance(path,basestring):
                        if self.pathexists(path):
                            installed = True
                    elif isinstance(path,list):
                        for l in path:
                            if self.pathexists(l):
                                installed = True
                else:
                    installed = False
        return installed

    def install_python_dev(self):
        if self.python2() != '':
            if self.is_alpine():
                self.install_package('python2-dev','/usr/bin/python3-config')
            elif self.is_debian():
                self.install_package('python-dev','/usr/bin/python3-config')
            elif self.is_fedora():
                self.install_package('python2-devel','/usr/bin/python3-config')
            elif self.is_redhat():
                self.install_package('python-devel','/usr/bin/python3-config')
            elif self.is_opensuse():
                self.install_package('python-devel','/usr/bin/python3-config')
            else:
                self.install_package('python-devel','/usr/bin/python3-config')
        if self.python3() != '':
            if self.is_alpine():
                self.install_package('python3-dev','/usr/bin/python3-config')
            elif self.is_debian():
                self.install_package('python3-dev','/usr/bin/python3-config')
            elif self.is_fedora():
                self.install_package('python3-devel','/usr/bin/python3-config')
            elif self.is_redhat():
                self.install_package('python3-devel','/usr/bin/python3-config')
            elif self.is_opensuse():
                self.install_package('python3-devel','/usr/bin/python3-config')
            else:
                self.install_package('pytho3-devel')
        if self.python3() == '' and self.python2() == '':
            self.cmd_history("# Both python2 and python3 not found! ")

    def install_python_package(self, package, sudo=False):
        self.history_install_package(package, currentframe().f_lineno)
        if self.is_ubuntu() and self.os_major_version()>22:
            if sudo:
                cmd = 'sudo pip3 install --upgrade --break-system-packages %s' % package
            else:
                cmd = 'pip3 install --upgrade --break-system-packages %s' % package
        elif self.osVersion().startswith('Debian') and self.os_major_version()>14271:
            if sudo:
                cmd = 'sudo pip3 install --upgrade --break-system-packages %s' % package
            else:
                cmd = 'pip3 install --upgrade --break-system-packages %s' % package
        else:
            if sudo:
                cmd = 'sudo pip3 install --upgrade %s' % package
            else:
                cmd = 'pip3 install --upgrade %s' % package
        self.cmd_history(cmd)
        self.shell(cmd,ignoreErr=True)

    def install_runc(self):
        return self.install_package('runc', ['/usr/bin/runc'])

    def installedGlobal(self):
        return self.pathexists(self.globalInstallPath(0)) or self.pathexists(self.globalInstallPath(1)) 

    def installedLocal(self):
        which = self.which()
        if which == '':    
            return False
        if self.isCmd() or self.isGitBash():
            return self.path_to_dos(which) == self.path_to_dos(self.localInstallPath())
        return which == self.localInstallPath()

    def install_gcc(self):
        if self.is_mac() and not self.pathexists('/usr/bin/gcc'):
            self.infoMsg("Please see details in installation of XCode command line tools at: https://mac.install.guide/commandlinetools/","Package needed")
            return False
        else:
            result = self.install_package('gcc', ['/usr/bin/gcc'])

    def install_jupyter(self):
        result = self.install_gcc()
        result = self.install_python_dev()
        result = self.install_linux_headers()
        result = self.install_musl_dev()
        result = self.install_pip()
        if result:
            if self.username() == "root":
                self.install_python_package('jupyter')
                self.install_python_package('jupyterhub')
            else:
                self.install_python_package('jupyter', sudo=True)
                self.install_python_package('jupyterhub', sudo=True)
        if result:
            result = self.install_package('nginx', ['/usr/sbin/nginx','/usr/bin/nginx'])
        if result:
            if self.is_alpine():
                self.rc_update('nginx')
        return result

    def install_nginx_admin(self):
        # root_or_sudo() Check user is root or has sudo privilege and assuming linux
        if not self.root_or_sudo():
            return False
        if self.install_package('nginx', ['/usr/sbin/nginx','/usr/bin/nginx']):
            if self.is_alpine():
                self.add_apk_community()
                self.install_package('sudo')
            self.create_user(username="nginx-adm", user_id=1700, group_id=1700, home="/opt/nginx-adm")
            self.history_change_ownership_of_folder(currentframe().f_lineno)
            self.chown("/etc/nginx", "nginx-adm:nginx-adm", useSudo=self.is_sudo())
            self.history_create_soft_link(currentframe().f_lineno)
            if self.is_alpine():
                self.ln("/etc/nginx/http.d", "/opt/nginx-adm/", useSudo=self.is_sudo())
                result = self.add_alpine_nginx_adm_sudoer()
            else:
                if self.is_debian():
                    self.ln("/etc/nginx/sites-available", "/opt/nginx-adm/", useSudo=self.is_sudo())
                    self.ln("/etc/nginx/sites-enabled", "/opt/nginx-adm/", useSudo=self.is_sudo())
                else:
                    self.ln("/etc/nginx/conf.d", "/opt/nginx-adm/", useSudo=self.is_sudo())                    
                result = self.add_nginx_adm_sudoer()
            return result
        return True

    def install_pip(self):
        result = True
        if self.is_alpine():
            result = self.install_package('py3-pip', ['/usr/bin/pip3'])
        elif self.is_mac():
            self.download_get_install_pip()
            return True
        elif self.is_window():
            if self.pathexists('c:\\Program Files\\Python312\\Scripts\\pip3.exe'):
                return True
            elif self.pathexists('c:\\User\\%s\\AppData\\Local\\Microsoft\\WindowsApps\\pip3.exe' % self.username()):
                return True
            return False
        else:
            result = self.install_package('python3-pip', ['/usr/bin/pip3','/usr/local/bin/pip3'])
        return result

    def install_target_global(self, this, useSudo=False):
        if self.targetApp() != '':
            file1 = self.globalInstallTargetPath(0)
            file2 = self.globalInstallTargetPath(1)
            self.history_remove_previous_global(currentframe().f_lineno)
            self.sudoRemoveFile( file1 )
            self.sudoRemoveFile( file2 )
        if self.pathexists(self.globalFolder(0)):
            self.history_copy_uncompressed(currentframe().f_lineno)
            self.cp(this,file1,useSudo=useSudo)
            if not self.isCmd() and not self.isGitBash():
                self.history_change_target_mode(currentframe().f_lineno)
                self.chmod_x(file1, useSudo=useSudo)
        elif self.pathexists(self.globalFolder(1)):
            self.history_copy_uncompressed(currentframe().f_lineno)
            self.cp(this,file2,useSudo=useSudo)
            if not self.isCmd() and not self.isGitBash():
                self.history_change_target_mode(currentframe().f_lineno)
                self.chmod_x(file2, useSudo=useSudo)
        if this.startswith('/tmp') or self.isGitBash() or self.isCmd():
            self.history_remove_uncompressed(currentframe().f_lineno)
            self.removeFile(this)

    def install_target_local(self, this):
        self.mkdir( self.localInstallFolder() )
        if self.targetApp() != '':
            self.history_remove_previous_local(currentframe().f_lineno)
            self.removeFile(self.localTargetInstallPath())
        self.history_copy_uncompressed(currentframe().f_lineno)
        self.cp(this, self.localInstallFolder())
        if not self.isCmd() and not self.isGitBash():
            self.history_change_target_mode(currentframe().f_lineno)
            result = self.chmod_x(self.localTargetInstallPath())
        if this.startswith('/tmp') or self.isCmd() or self.isGitBash():
            self.history_remove_downloaded(currentframe().f_lineno)
            self.removeFile(this)
        self.check_env()

    def rc_update(self, package):
        self.history_check_rc_update(currentframe().f_lineno)
        if self.root_or_sudo():
            rc_cmd = self.which_cmd("rc-update")
            if rc_cmd != "":
                if self.sudo_cmd!="":
                    cmd = 'sudo %s add %s default' % (rc_cmd, package)
                else:
                    cmd = '%s add %s default' % (rc_cmd, package)

    def update_repository(self):
        # root_or_sudo() Check user is root or has sudo privilege and assuming linux
        cmd = ""
        if not self.root_or_sudo():
            return False
        if not hasattr(self,'__has_repository_updated__'):
            self.__has_repository_updated__ = False
        if self.__has_repository_updated__:
            return True
        if self.is_debian():
            cmd = "apt update"
        elif self.is_alpine():
            cmd = "apk update"
        elif self.osVersion().startswith('CentOS'):
            cmd = "yum check-update"
        elif self.is_fedora():
            cmd = "dnf check-update"
        else:
            self.msg_not_compatible_os()
        if cmd != "":
            self.history_update_repository(currentframe().f_lineno)
            self.cmd_history(cmd)
            self.shell(cmd, ignoreErr=True)
            self.__has_repository_updated__=True
            return True
        return False

    def uninstall_gcc(self):
        return self.uninstall_package('gcc', ['/usr/bin/gcc'])

    def uninstall_jupyter(self):
        if self.username() == "root":
            self.uninstall_python_package('jupyter')
            self.uninstall_python_package('jupyterhub')
        else:
            self.uninstall_python_package('jupyter', sudo=True)
            self.uninstall_python_package('jupyterhub', sudo=True)
        result = self.uninstall_gcc()
        result = self.uninstall_package('python3-dev',
            ['/usr/include/python3.8/Python.h',
                '/usr/include/python3.9/Python.h',
                '/usr/include/python3.10/Python.h',
                '/usr/include/python3.11/Python.h',
                '/usr/include/python3.12/Python.h'
            ])
        if self.is_alpine():
            result = self.uninstall_musl_dev() 
            result = self.uninstall_linux_headers()
        else:
            result = self.uninstall_package('libc6-dev',['/usr/include/stdio.h'])
        self.install_pip()
        result = self.uninstall_nginx()
        self.remove_nginx_adm_sudoer()
        self.remove_user('nginx-adm')
        return True

    def uninstall_libcrypto(self):
        if self.osVersion().startswith('Alpine'):
            result = self.uninstall_package('libcrypto1.1', ['/usr/lib/libcrypto.so'])
        else:
            result = self.uninstall_package('libssl-dev', ['/usr/lib/x86_64-linux-gnu/libcrypto.so'])
        return result

    def uninstall_linux_headers(self):
        if self.is_alpine():
            return self.uninstall_package('linux-headers',['/usr/include/linux/version.h'])
        return True

    def uninstall_musl_dev(self):
        if self.is_alpine():
            return self.uninstall_package('musl-dev',['/usr/include/stdio.h'])
        return True

    def uninstall_libinih(self):
        if self.is_alpine():
            result = self.uninstall_package('inih-dev', ['/usr/lib/libinih.so'])
        else:
            result = self.uninstall_package('libinih-dev', ['/usr/lib/x86_64-linux-gnu/libinih.so'])
        return result

    def uninstall_libpcre2(self):
        if self.is_alpine():
            result = self.uninstall_package('pcre2-dev', ['/usr/lib/libpcre2-8.so.0'])
        else:
            result = self.uninstall_package('libpcre2-dev', ['/usr/lib/x86_64-linux-gnu/libpcre2-32.so'])
        return result

    def uninstall_libsqlite3_dev(self):
        if self.is_alpine():
            result = self.uninstall_package('sqlite-dev', ['/usr/lib/libsqlite3.so'])
        else:
            result = self.uninstall_package('libsqlite3-dev', ['/usr/lib/x86_64-linux-gnu/libsqlite3.so'])
        return result

    def uninstall_libsqlite3(self):
        result = self.uninstall_package('sqlite3', ['/usr/bin/sqlite3'])
        return result

    def uninstall_nginx(self):
        self.history_backup_nginx_conf(currentframe().f_lineno)
        if self.is_alpine():
            if self.pathexists("/etc/nginx/http.d", use_history=True):
                backup_source="/etc/nginx/http.d"
        else:
            if self.pathexists("/etc/nginx/sites-available", use_history=True):
                backup_source="/etc/nginx/sites-available"        
        if backup_source != "":
            next_id = 0
            if self.is_docker_container():
                backup_path='/data/nginx-backup'
            else:
                backup_path='/var/nginx-backup'
            if self.username() == 'root':
                self.mkdir(backup_path)
            else:
                self.mkdir(backup_path, sudo=True)
            for id in range(999):
                test_path='%s/%s.%d' % (backup_path, self.today(), id)
                if self.pathexists(test_path):
                    next_id = id + 1
            if next_id > 999:
                self.msg_too_many_backup()
                return False
            backup_destination='%s/%s.%d' % (backup_path, self.today(), next_id)
            if self.username() == 'root':
                shutil.copytree(backup_source, backup_destination)
            else:
                self.mkdir(backup_destination, sudo=True)
                self.cp("%s/*", backup_destination, useSudo=True)
            self.cmd_history("sudo cp -rP %s/* %s" % (backup_source,backup_destination))
        result = self.uninstall_package('nginx', ['/usr/sbin/nginx','/usr/bin/nginx'])
        return result

    def uninstall_package(self, package=None, path=None):
        # root_or_sudo() Check user is root or has sudo privilege and assuming linux
        if not self.root_or_sudo():
            return False
        installed = False
        location = ''
        if path is not None and package is not None:
            self.history_check_exists(package, currentframe().f_lineno)
            if isinstance(path,basestring):
                if self.pathexists(path, use_history=True):
                    location = path
                    installed=True
                    self.history_location_found(location, currentframe().f_lineno)
            elif isinstance(path,list):
                for l in path:
                    if self.pathexists(l, use_history=True):
                        location = l
                        installed=True
                        self.history_location_found(location, currentframe().f_lineno)
        if installed:
            if self.is_debian():
                self.history_uninstall_package(package, currentframe().f_lineno)
                if self.is_sudo():
                    cmd = ["sudo", "apt", "purge", "--auto-remove", "-y", package]
                else:
                    cmd =["apt", "purge", "--auto-remove", "-y", package]
                self.cmd_history(" ".join(cmd))
                self.shell(cmd, ignoreErr=True)
                installed = True
            elif self.is_alpine():
                self.history_uninstall_package(package, currentframe().f_lineno)
                if self.is_sudo():
                    cmd = ["sudo", "apk", "del", package]
                else:
                    cmd = ["apk", "del", package]
                self.cmd_history(" ".join(cmd))
                self.shell(cmd, ignoreErr=True)
                installed = True
            elif self.osVersion().startswith('CentOS'):
                if self.is_sudo():
                    cmd = "sudo yum remove -y %s" % package
                else:
                    cmd = "yum remove -y %s" % package
                self.cmd_history(cmd)
                self.shell(cmd, ignoreErr=True)
                installed = True
            elif self.is_fedora():
                if self.is_sudo():
                    cmd = "sudo dnf remove -y %s" % package
                else:
                    cmd = "dnf remove -y %s" % package
                self.cmd_history(cmd)
                self.shell(cmd, ignoreErr=True)
                installed = True
            else:
                self.msg_not_compatible_os()
                return False
            if self.pathexists(location):
                self.msg_unintall_global()
                return False
        return installed

    def uninstall_python_package(self, package=None, sudo=False):
        self.history_uninstall_package('jupyter', currentframe().f_lineno)
        if sudo:
            cmd = 'sudo pip3 uninstall --break-system-packages %s' % package
        else:
            cmd = 'pip3 uninstall --break-system-packages %s' % package
        self.cmd_history(cmd)
        self.shell(cmd,ignoreErr=True)

class CheckSystem(Installer):

    def __init__(self, this=None):
        try:
            super().__init__(this)
        except:
            super(CheckSystem, self).__init__(this)
        Attr(self, "msgShown", False)

    def msg_system_check(self, title="START"):
        # msg_system_check(), this message only shown when downloading files
        if not self.msgShown():
            self.safeMsg("Now checking your operation system!", title)
            self.prn("    AppBase Version: %s" % AppBase.VERSION) \
                .prn("    Python: %s" % self.pythonVersion()) \
                .prn("    C Library: %s" % self.libcVersion()) \
                .prn("    Operation System: %s" % self.osVersion()) \
                .prn("    Architecture: %s" % self.arch()) \
                .prn("    Current User: %s" % self.username()) \
                .prn("    Shell: %s" % self.shellCmd()) \
                .prn("    Python Executable: %s" % self.executable()) \
                .prn("    python2 location: %s" % self.python2()) \
                .prn("    python3 location: %s" % self.python3()) \
                .prn("    conda location: %s" % self.which_cmd('conda', default="")) \
                .prn("    pyenv location: %s" % self.which_cmd('pyenv', default="")) \
                .prn("    Inside docker container: %s" % self.is_docker_container()) \
                .prn("    Cython String: %s" % self.cythonString()) \
                .prn("    Binary Type: %s" % self.binVer() ) \
                .prn("") \
                .msgShown(True)

    def msg_info(self, usage=None):
        if usage is None:
            usage=self.usage()
        if self.isCmd():
            msg1="%s.bat (%s.%s) by %s on %s" % (self.appName(),self.majorVersion(),\
                self.minorVersion(),self.author(),self.lastUpdate())
        else:
            msg1="%s (%s.%s) by %s on %s" % (self.appName(),self.majorVersion(),\
                self.minorVersion(),self.author(),self.lastUpdate())
        if self.isGlobal():
            app = "You are using the GLOBAL INSTALLED version, location:"
        elif self.is_local():
            app = "You are using the LOCAL INSTALLED version, location:"
        else :
            app = "You are using an UNINSTALLED version, location:" 
        python_exe = self.executable()
        if python_exe == '':
            python_exe = self.pyName()
        msg = [
            msg1, 
            '',
            '%s' % app,
            '    %s' % self.selfLocation(),
            '', 
            "Basic Usage:",
            "    %s" % usage,
            '',
            'Please visit our homepage: ',
            '    "%s"' % self.homepage(),
            '',
            'Installation command:',
            '    curl -fsSL %s | %s' % (self.downloadUrl(), python_exe),
            ''
        ]
        starLine=[]
        space=[]
        spaces=[[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
        if self.targetApp() != '':
            spaces.append([])
            spaces.append([])
            msg.append('Target Application:')
            if self.isCmd() or self.isGitBash():
                file3 = self.localTargetInstallPath()
                if self.pathexists(file3):
                    msg.append('    %s' % file3)
                    spaces.append([])
            else:
                file1 = "%s/%s" % (self.globalFolder(0), self.targetApp())
                file2 = "%s/%s" % (self.globalFolder(1), self.targetApp())
                file3 = self.localTargetInstallPath()
                if self.pathexists(file1):
                    msg.append('    %s' % file1)
                    spaces.append([])
                if self.pathexists(file2):
                    msg.append('    %s' % file2)
                    spaces.append([])
                if self.pathexists(file3):
                    msg.append('    %s' % file3)
                    spaces.append([])
            msg.append('')
        maxLen=len(msg[0])
        if self.downloadUrl() == '':
            if self.homepage() == '':
                max_line = len(spaces) - 3
            else:
                max_line = len(spaces) - 2
        else:
            max_line = len(spaces) - 1
        for n in range(1, max_line):
            if len(msg[n]) > maxLen :
                maxLen=len(msg[n])
        for n in range(0, max_line):
            for i in range(1,maxLen - len(msg[n]) + 1):
                spaces[n].append(' ')
            msg[n]=msg[n] + ''.join(spaces[n])
        for i in range(1,maxLen + 5):
            starLine.append("*")
        for i in range(1,maxLen + 1):
            space.append(" ")
        self.prn(''.join(starLine))
        self.prn('* %s *' % ''.join(space))
        for n in range(0, max_line):
            self.prn('* %s *' % msg[n])
        self.prn('* %s *' % ''.join(space))
        self.prn(''.join(starLine))

class AppPara(CheckSystem):

    def __init__(self, this = None):
        try:
            super().__init__(this)
        except:
            super(AppPara, self).__init__(this)
        Attr(self, "targetApp", "")
        Attr(self, "cmd", "")
        Attr(self, "allowSelfInstall", True)
        Attr(self, "allowLinuxOnly", False)
        Attr(self, "allowDisplayInfo", True)
        Attr(self, "allowInstallLocal", True)

class Ask(AppData):

    def __init__(self, this = None):
        try:
            super().__init__(this)
        except:
            super(Ask, self).__init__(this)

    def __ask_number__(self, ask):
        if not hasattr(self, '__regex_number__'):
            self.__regex_number__ = re.compile(r"[1-9][0-9]*|exit")
        ask_number = ''
        try:
            ask_number = input(ask).strip().lower()
        except:
            ask_number = ""
        if self.signal()== 2:
            return None
        while ask_number == '' or self.__regex_number__.sub("",ask_number) != '':
            try:
                ask_number = input(ask).strip()
            except:
                ask_number = ""
            if self.signal()== 2:
                return None
        if ask_number == "" or ask_number == "exit":
            return None
        if self.signal() == 2:
            self.signal(0)
            return None
        return int(ask_number)

    def __ask_yesno__(self, ask):
        if not hasattr(self, '__regex_yesno__'):
            self.__regex_yesno__ = re.compile(r"yes|no|exit")
        ask_yesno = ''
        try:
            ask_yesno = input(ask).strip().lower()
        except:
            ask_yesno = ""
        if self.signal()== 2:
            return None
        while ask_yesno == '' or self.__regex_yesno__.sub("",ask_yesno) != '':
            try:
                ask_yesno = input(ask).strip().lower()
            except:
                ask_yesno = ""
            if self.signal()== 2:
                return None
        return ask_yesno

    def ask_choose(self):
        # fromPipe() usually involve from curl and don't have stdin
        if self.fromPipe():
            return False
        return self.__ask_yesno__('Install globally (yes) or locally(no)? (yes/no) ') == 'no'

    def ask_choose_profile_number(self):
        # fromPipe() usually involve from curl and don't have stdin
        if self.fromPipe():
            return None
        number = self.__ask_number__('Choose the profile number? ')
        if number is None:
            return -1
        return number

    def ask_create_ini(self):
        # fromPipe() usually involve from curl and don't have stdin
        if self.fromPipe():
            return None
        return 'yes' == self.__ask_yesno__('Do you wanted to create ini file (type "exit" to exit)? ') 

    def ask_install_sudo(self):
        # fromPipe() usually involve from curl and don't have stdin
        if self.fromPipe():
            return None
        return 'yes' == self.__ask_yesno__('Do you want to install sudo? (yes/no) ')

    def ask_local(self):
        # fromPipe() usually involve from curl and don't have stdin
        if self.fromPipe():
            return None
        return 'yes' == self.__ask_yesno__('Do you want to install locally? (yes/no) ')

    def ask_not_root(self):
        # fromPipe() usually involve from curl and don't have stdin
        if self.fromPipe():
            return None
        return self.__ask_yesno__('You are not using root account. Do you want to continue? (yes/no) ') == 'yes'

    def ask_overwrite_global(self):
        # fromPipe() usually involve from curl and don't have stdin
        if self.fromPipe():
            return None
        return 'yes' == self.__ask_yesno__('Do you want to overwrite the global installation? (yes/no) ')

    def ask_overwrite_local(self):
        # fromPipe() usually involve from curl and don't have stdin
        if self.fromPipe():
            return None
        return 'yes' == self.__ask_yesno__('Do you want to overwrite the local installation? (yes/no) ')

    def ask_update(self):
        # fromPipe() usually involve from curl and don't have stdin
        if self.fromPipe():
            return None
        return 'yes' == self.__ask_yesno__('Do you want to update the latest (%s) from internet? (yes/no) ' % self.latest_version())

    def signal(self, signal=None):
        if signal is not None:
            self.__signal__=signal
            return self
        elif not hasattr(self, '__signal__'):
            self.__signal__=0
        return self.__signal__

    def signal_handler(self, sig, frame):
        self.signal(sig)
        if sig == 2:
            self.prn('\nYou pressed Ctrl+C!\n')
        if sig == 3:
            self.prn('\nYou pressed Ctrl+Back Slash!')

class ShellProfile(Shell):

    def __init__(self, this = None):
        try:
            super().__init__(this)
        except:
            super(ShellProfile, self).__init__(this)

    def add_bashprofile_modification(self):
        # Append the modification lines to .bashrc file
        modification_lines = [
            "# modified to add ~/.local/bin to PATH",
            "PATH=$PATH:~/.local/bin\n"
        ]
        
        with self.open(self.bashprofile(), "a") as file:
            file.write("\n".join(modification_lines))
        self.chmod_x(self.bashprofile())

    def add_bashrc_modification(self):
        # Append the modification lines to .bashrc file
        modification_lines = [
            "# modified to add ~/.local/bin to PATH",
            "PATH=$PATH:~/.local/bin\n"
        ]
        
        with self.open(self.bashrc(), "a") as file:
            file.write("\n".join(modification_lines))
        self.chmod_x(self.bashrc())

    def add_zshenv_modification(self):
        # Append the modification lines to .bashrc file
        modification_lines = [
            "\n# modified to add ~/.local/bin to PATH",
            "path+=('%s')" %  os.path.join(self.home(), ".local/bin"),
            "export PATH\n"
        ]
        with self.open(self.zshenv(), "a") as file:
            file.write("\n".join(modification_lines))

    def bashprofile(self):
        return os.path.join(self.home(), ".profile")

    def bashrc(self):
        if self.shellCmd() == '/bin/ash':
            return os.path.join(self.home(), ".profile")
        return os.path.join(self.home(), ".bashrc")

    def check_and_modify_bashprofile(self):
        if not self.is_bashprofile_modified():
            self.add_bashprofile_modification()

    def check_and_modify_bashrc(self):
        if not self.is_bashrc_modified():
            self.add_bashrc_modification()

    def check_and_modify_zshenv(self):
        if not self.is_zshenv_modified():
            self.add_zshenv_modification()

    def home(self):
        return os.path.expanduser("~")

    def is_bashprofile_modified(self):
        # Check if .bashrc file exists and if it contains the modification lines
        if not os.path.isfile(self.bashrc()):
            return False
        with self.open(self.bashrc(), "r") as file:
            contents = file.read()
        return "# modified to add ~/.local/bin to PATH" in contents

    def is_bashrc_modified(self):
        # Check if .bashrc file exists and if it contains the modification lines
        if not os.path.isfile(self.bashrc()):
            return False
        with self.open(self.bashrc(), "r") as file:
            contents = file.read()
        return "# modified to add ~/.local/bin to PATH" in contents

    def is_zshenv_modified(self):
        # Check if .zshenv file exists and if it contains the modification lines
        if not os.path.isfile(self.zshenv()):
            return False
        
        with self.open(self.zshenv(), "r") as file:
            contents = file.read()
        
        return "# modified to add ~/.local/bin to PATH" in contents

    def zshenv(self):
        return os.path.join(self.home(), ".zshenv")

class Curl(Shell):

    def __init__(self, this = None):
        try:
            super().__init__(this)
        except:
            super(Curl, self).__init__(this)

    def curl_cmd(self, url='', file='', switches='-fsSL',  ignoreErr=True):
        stderr = 'Unknown Error'
        stdout = ''
        if self.isLinuxShell():
            curl = self.which_cmd('curl')
            if url!='' and file!='':
                cmd = ' '.join([curl,switches,'-o',file, url])
                self.cmd_history(cmd)
                stdout,stderr = Popen([curl,switches,'-o',file, url],stdin=PIPE,stdout=PIPE,\
                    stderr=PIPE,universal_newlines=True).communicate('\n')
            elif url!='':
                cmd = ' '.join([curl,switches,url])
                self.cmd_history(cmd)
                stdout,stderr = Popen([curl,switches,url],stdin=PIPE,stdout=PIPE,\
                    stderr=PIPE,universal_newlines=True).communicate('\n')
        elif self.isGitBash():
            winpty = self.where_cmd('winpty.exe')
            curl = self.where_cmd('curl.exe')
            if url!='' and file!='':
                file=self.path_to_dos(file)
                cmd = ' '.join([winpty,curl,switches,'-o',file, url])
                self.cmd_history(cmd)
                stdout,stderr = Popen([winpty,curl,switches,'-o',file, url],stdin=PIPE,stdout=PIPE,\
                    stderr=PIPE,universal_newlines=True).communicate('\n')
                if stderr.strip().lower() == 'stdin is not a tty':
                    cmd = ' '.join([curl,switches,'-o',file, url])
                    self.cmd_history(cmd)
                    stdout,stderr = Popen([curl,switches,'-o',file, url],stdin=PIPE,stdout=PIPE,\
                        stderr=PIPE,universal_newlines=True).communicate('\n')
            elif url!='':
                cmd = ' '.join([winpty,curl,switches, url])
                self.cmd_history(cmd)
                stdout,stderr = Popen([winpty,curl,switches,url],stdin=PIPE,stdout=PIPE,\
                    stderr=PIPE,universal_newlines=True).communicate('\n')
                if stderr.strip().lower() == 'stdin is not a tty':
                    cmd = ' '.join([curl,switches, url])
                    self.cmd_history(cmd)
                    stdout,stderr = Popen([curl,switches,url],stdin=PIPE,stdout=PIPE,\
                        stderr=PIPE,universal_newlines=True).communicate('\n')
        elif self.isCmd():
            curl = self.where_cmd('curl.exe')
            if url!='' and file!='':
                cmd = ' '.join([curl,switches,'-o',file, url])
                self.cmd_history(cmd)
                stdout,stderr = Popen([curl,switches,'-o',file, url],stdin=PIPE,stdout=PIPE,\
                    stderr=PIPE,universal_newlines=True).communicate('\n')
            elif url!='':
                cmd = ' '.join([curl,switches,url])
                self.cmd_history(cmd)
                stdout,stderr = Popen([curl,switches,url],stdin=PIPE,stdout=PIPE,\
                    stderr=PIPE,universal_newlines=True).communicate('\n')
        elif url!='':
            # Assume /bin/sh as default shell
            curl = self.which_cmd('curl')
            if url!='' and file!='':
                cmd = ' '.join([curl,switches,'-o',file, url])
                self.cmd_history(cmd)
                stdout,stderr = Popen([curl,switches,'-o',file, url],stdin=PIPE,stdout=PIPE,\
                    stderr=PIPE,universal_newlines=True).communicate('\n')
            elif url!='':
                cmd = ' '.join([curl,switches,url])
                self.cmd_history(cmd)
                stdout,stderr = Popen([curl,switches,url],stdin=PIPE,stdout=PIPE,\
                    stderr=PIPE,universal_newlines=True).communicate('\n')
        if stderr != "" and not ignoreErr:
            self.msg_error(cmd, stderr)
            return False, stderr
        return True, stdout

    def curl_download(self, url='', file='', ignoreErr=True):
        self.history_curl_check(currentframe().f_lineno)
        if self.curl_is_200(url):
            self.history_curl_download(currentframe().f_lineno)
            self.curl_cmd(url=url, file=file, ignoreErr=ignoreErr)
            if file == '':
                return True
            if file !='' and not self.pathexists(file):
                count=20
                # In gitbash, downloading time may be longer
                self.msg_downloading(file)
                while count>0 and  not self.pathexists(file):
                    count = count - 1
                    time.sleep(1) # wait for curl download the file
            if file !='' and self.pathexists(file):
                return True
            elif ignoreErr:
                return True
            else:
                self.msg_timeout(file)
                return False
        return False

    def curl_is_200(self, url):
        result, stdout = self.curl_cmd(url=url, switches='-fsSLI', ignoreErr=True)
        if result:
            result = False
            for rawline in stdout.splitlines():
                line = rawline.strip()
                if 'HTTP' in line.strip():
                    line_split=line.split(' ')
                    if len(line_split) > 1:
                        if  '200' == line_split[1] or '301' == line_split[1] or '302' == line_split[1]:
                            return True
                        else:
                            self.msg_download_url_error(url, line_split[1])
                            return False
        return result

class Temp(AppHistory):

    def __init__(self, this = None):
        try:
            super().__init__(this)
        except:
            super(Temp, self).__init__(this)
        # Should call setInstallation before __init_temp__()
        # self.__init_temp__()

    def __init_temp__(self):
        Attr(self, "tempFile", "")
        appName = self.appName()
        tempFolder=self.tempFolder()
        if tempFolder=="":
            return False
        if self.isCmd():
            fname="%s\\%s-%s.bat" % (tempFolder, appName,self.timestamp())
        elif self.isGitBash():
            # GitBash download location should remain the same such that starting with /c/Users/user...
            fname="%s\\%s-%s.bat" % (tempFolder, appName,self.timestamp())
        else:
            fname="%s/%s-%s" % (tempFolder, appName,self.timestamp())
        self.tempFile(fname)
        return True

    def tempFolder(self):
        if not hasattr(self,'__temp_checked__'):
            self.__temp_checked__=0
            self.history_check_mkdir(currentframe().f_lineno)
        if "TEMP" in os.environ:
            # in windows, most likely
            folder=os.environ["TEMP"]
        elif self.isGitBash():
            folder="/tmp" 
        elif self.isCmd():
            folder="C:\\Users\\%s\\AppData\\Local\\Temp" % self.username()
        elif self.osVersion() == 'macOS':
            folder = '/Users/%s/Library/Caches' % self.username()
        elif self.username() == 'root':
            folder="/tmp" 
        else:
            folder="/home/%s/.local/temp" % self.username()
        if not self.isGitBash():
            if self.__temp_checked__<1:
                if self.pathexists(folder):
                    if not self.mkdir(folder):
                        return ""
            if self.__temp_checked__==0:
                use_history=True
            else:
                use_history=False
            self.__temp_checked__=self.__temp_checked__+1
            if self.pathexists(folder, use_history=use_history):
                return folder
            self.msg_temp_folder_failed(folder)
            return ""
        else:
            return folder

class AppBase(AppPara, ShellProfile, Curl, Temp, Ask):
    VERSION="1.14"

    def __init__(self, this = None):
        try:
            super().__init__(this)
        except:
            super(AppBase, self).__init__(this)
        if this is not None:
            self.this(this)
        else:
            self.this(__file__)
        Attr(self, "subCmd", ["check-system","check-update","check-version","cython-string","download",
            "download-app","download-target-app","global-installation-path","help","install",
            "local-installation-path","this","this-file","timestamp","today","update","where","which"])

    def __alpine_ask_install_sudo__(self):
        if self.ask_install_sudo():
            cmd="apk add sudo"
            self.cmd_history(cmd)
            result, stdout = self.shell(cmd, True)
            cmd="echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel"
            self.cmd_history(cmd)
            result, stdout = self.shell(cmd)

    def __install_local__(self, this = None, verbal = True ):
        result = False
        if this is None:
            this = self.this()
        if self.isCmd() or self.isGitBash():
            file = 'C:\\Users\\%s\\AppData\\Local\\Microsoft\\WindowsApps\\%s.bat' % (self.username(),self.appName())
            result = self.translateScript(source=this, target=file, useSudo=False)
        else:
            folder=self.localInstallFolder()
            self.mkdir(folder)
            file=self.localInstallPath()
            result = self.translateScript(source=this, target=file, useSudo=False)
        if self.thisFile().endswith(".so"):
            self.history_copy_static_lib(self.thisFile(), currentframe().f_lineno)
            self.cp(self.thisFile(), self.localInstallFolder())
        self.check_env()
        if verbal:
            if self.targetApp() == '':
                self.msg_install_app_local()
            else:
                self.msg_install_target_local()
        return result

    def __self_install__(self, this=None, verbal = True, sudo=False):
        if this is None:
            this = self.this()
        result = False
        try_global = True
        if self.username() != 'root':
            if self.allowInstallLocal():
                if self.fromPipe():
                    return False
                try_global = False
                result = self.__install_local__()
            elif sudo:
                try_global = True
                result = False
                if try_global:
                    if self.osVersion() == 'Alpine':
                        self.msg_alpine_detected()
                        self.msg_sudo_failed()
                        result = False
                    elif self.sudo_test():
                        self.msg_sudo()
                        self.removeGlobalInstaller()
                        result = self.translateScript(source=this, target=self.globalInstallPath(1),useSudo=True)
                        if self.thisFile().endswith(".so"):
                            self.history_copy_static_lib(self.thisFile(), currentframe().f_lineno)
                            self.cp(self.thisFile(), self.globalInstallPath(1), useSudo=True)
                    else:
                        if self.signal() != 2:
                            self.msg_sudo_failed()
                        result = False
        else:
            self.removeGlobalInstaller()
            result = self.translateScript(source=this, target=self.globalInstallPath(1))
            if self.thisFile().endswith(".so"):
                self.history_copy_static_lib(self.thisFile(), currentframe().f_lineno)
                self.cp(self.thisFile(), self.globalInstallPath(1), useSudo=True)
        if result:
            if try_global and verbal:
                self.msg_install_app_global()

        return result

    def __self_install_globally__(self, verbal = True):
        if self.username() == 'root':
            if self.thisFile().endswith(".so"):
                self.__self_install__(this=self.this(), verbal=verbal)
                self.__self_install__(this=self.thisFile(), verbal=verbal)
            else:
                self.__self_install__(this=self.thisFile(), verbal=verbal)
        elif self.ask_not_root():
            if self.sudo_test():
                self.msg_sudo()
                if self.thisFile().endswith(".so"):
                    self.__self_install__(this=self.this(), verbal=False, sudo=True)
                    return self.__self_install__(this=self.thisFile(), verbal=verbal, sudo=True)
                else:
                    return self.__self_install__(this=self.thisFile(), verbal=verbal, sudo=True)
            elif self.signal() == 2:
                return False
        elif self.username() != 'root':
            self.msg_root_continue()
            return False
        else:
            if self.thisFile().endswith(".so"): 
                self.__self_install__(this=self.this(), verbal=False)
                return self.__self_install__(this=self.thisFile(), verbal=verbal)
            else:
                return self.__self_install__(this=self.this(), verbal=verbal)

    def add_alpine_nginx_adm_sudoer(self, usr="nginx-adm"):
        self.history_check_copy_sudoers(currentframe().f_lineno)
        if self.sudo_cmd() != "":
            s_cmd = self.which_rc_service()
            n_cmd = self.which_nginx()
            lines = [
                self.nopw(usr, "%s nginx reload" % s_cmd),
                self.nopw(usr, "%s nginx restart" % s_cmd),
                self.nopw(usr, "%s nginx start" % s_cmd),
                self.nopw(usr, "%s nginx status" % s_cmd),
                self.nopw(usr, "%s nginx stop" % s_cmd),
                self.nopw(usr, n_cmd),
                ""
            ]
            self.add_sudoers("1700-%s" % usr,'\n'.join(lines))
        else:
            self.msg_sudo_not_installed()
        return False

    def add_apk_community(self):
        comm="https://dl-cdn.alpinelinux.org/alpine/%s/community" % self.alpine_version()
        hasCommunity=False
        self.history_check_repositories(currentframe().f_lineno)
        fin = self.open('/etc/apk/repositories', "rt", use_history=True)
        for line in fin:
            if 'https://dl-cdn.alpinelinux.org' in line and 'community' in line:
                if '#' not in line:
                    hasCommunity=True
        fin.close()
        if not hasCommunity:
            with self.open('/etc/apk/repositories', "a") as file:
                file.write("\n%s\n" % comm)
            file.close()
        return True 

    def add_nginx_adm_sudoer(self, usr="nginx-adm"):
        self.history_check_copy_sudoers(currentframe().f_lineno)
        if self.sudo_cmd() != "":
            s_cmd = self.which_systemctl()
            j_cmd = self.which_journalctl()
            n_cmd = self.which_nginx()
            lines = [
                self.nopw(usr, "%s -f -u nginx" % j_cmd),
                self.nopw(usr, "%s -f -u nginx" %  j_cmd),
                self.nopw(usr, "%s -u nginx" % j_cmd),
                self.nopw(usr, "%s reload nginx" % s_cmd),
                self.nopw(usr, "%s restart nginx" % s_cmd),
                self.nopw(usr, "%s start nginx" % s_cmd),
                self.nopw(usr, "%s status nginx" % s_cmd),
                self.nopw(usr, "%s stop nginx" % s_cmd),
                self.nopw(usr, n_cmd),
                ""
            ]
            self.add_sudoers("1700-%s" % usr,'\n'.join(lines))
            return True
        else:
            self.msg_sudo_not_installed()
            return False

    def add_sudoers(self, fname, content):
        target_sudoers="/etc/sudoers.d/%s" % fname
        if not self.pathexists(target_sudoers):
            tempSudoer = "%s/%s-%s" % (self.tempFolder(),fname, self.timestamp())
            file = self.open(tempSudoer,'w')
            file.write(content)
            file.close()
            self.cp(tempSudoer, target_sudoers, useSudo=self.is_sudo())
            self.history_remove_temp(currentframe().f_lineno)
            self.removeFile(tempSudoer)
            return True
        return True

    def appExec(self):
        if not hasattr(self, '__app_path__'):
            self.appPath()
        if not hasattr(self, '__app_exec__'):
            self.__app_exec__ = ''
            if self.is_local() or self.isGlobal():
                if self.isCmd() or self.isGitBash():
                    self.__app_exec__ = self.appName() + '.bat'
                else:
                    self.__app_exec__ = self.appName()
            elif self.appPath() != '' :
                if self.isCmd() or self.isGitBash():
                    self.__app_exec__ = self.appName() + '.bat'
                elif self.isLinuxShell():
                    self.__app_exec__='./' + self.appName()
                else:
                    self.__app_exec__='./' + self.appName()
        return self.__app_exec__

    def check_env(self):
        if self.shellCmd() == '/bin/zsh':
            self.history_check_zsh(currentframe().f_lineno)
            self.check_and_modify_zshenv()
        elif self.shellCmd() == '/bin/bash':
            self.history_check_bash(currentframe().f_lineno)
            self.check_and_modify_bashrc()
        elif self.shellCmd() == '/bin/ash':
            self.history_check_ash(currentframe().f_lineno)
            self.check_and_modify_bashprofile()

    def check_system_and_user(self):
        # is_linux() Check if not windows and not macOS
        if self.allowLinuxOnly() and not self.is_linux():
            self.msg_linux_only()
            return False
        else:
            # root_or_sudo() Check user is root or has sudo privilege
            return self.root_or_sudo()

    def check_update(self):
        if self.need_update():
            self.msg_latest_available()
        elif self.latest_version() != '0.0':
            self.msg_latest()

    def download_to_temp(self, url=None, file=None, verbal = False):
        # msg_system_check(), this message only shown when downloading files
        if self.tempFolder() == "":
            return False
        self.msg_system_check()
        if url is None:
            url=self.downloadUrl()
        if file is None:
            file=self.tempFile()
        result = self.curl_download(url=url, file=file)
        if not self.pathexists(file):
            result = False
            self.msg_download_error(file)
        elif verbal:
            self.msg_downloaded(file)
        return result

    def download_and_install(self, verbal = False):
        if self.tempFolder() == "":
            return False
        if self.targetApp() != '':
            if self.username() == 'root' or  not self.isGlobal():
                result = self.download_and_install_target()
            else:
                self.msg_global_already()
                return False                
        else:
            result=True
        if result:
            fname = self.tempFile()
            self.download_to_temp(verbal=False)
            if self.pathexists(fname):
                if not self.install(this=fname, verbal=False):
                    return False
                if verbal:
                    if result:
                        if self.targetApp() != '':
                            if self.username() == 'root':
                                self.msg_install_target_global()
                            else:
                                self.msg_install_target_local()
                        else:
                            if self.username() == 'root':
                                self.msg_install_app_global()
                            else:
                                self.msg_install_app_local()
                    else:
                        self.cmd_history_print(currentframe().f_lineno)
                return result
            else:
                self.msg_download_not_found(fname)
        else:
            self.msg_installation_failed()
        return False

    def download_get_install_pip(self):
        self.tempFile('get-pip')
        self.download_to_temp("https://bootstrap.pypa.io/get-pip.py", file=self.tempFile(), verbal=False)
        cmd="%s %s" % (self.executable(),self.tempFile())
        if (not self.is_mac() and self.is_linux()) and not self.root_or_sudo():
            cmd="sudo %s %s" % (self.executable(),self.tempFile())
        self.cmd_history("# ** install pip by get-pip.py **", currentframe().f_lineno)
        self.cmd_history(cmd)
        self.shell(cmd,ignoreErr=True)

    def download_and_install_target(self):
        tempFolder = self.tempFolder()
        if self.targetApp() == '' or tempFolder=="":
            return False
        fname = self.tempTargetGzip()
        self.download_to_temp(url=self.tempAppUrl(), file=fname, verbal=False)
        if self.pathexists(fname):
            self.history_cd_decompress(currentframe().f_lineno)
            self.chdir(tempFolder, currentframe().f_lineno)
            if self.isCmd() or self.isGitBash():
                self.tar_extract( self.path_to_dos(fname).split('\\')[-1] )
            else:
                self.tar_extract(fname.split('/')[-1])
            self.history_remove_downloaded(currentframe().f_lineno)
            self.removeFile(fname)
            if self.isCmd() or self.isGitBash():
                this = "%s.exe" % self.tempAttachDecomp()
            else:
                this = self.tempAttachDecomp()
            if self.pathexists(this):
                self.this(this)
                if self.username() == 'root':
                    self.install_target_global(this, useSudo=False)
                else:
                    self.install_target_local(this)
                return True
            else:
                self.cmd_history_print(currentframe().f_lineno)
                self.msg_extraction_error(this)
                return False
        else:
            self.msg_download_error(self.tempTargetGzip())
            return False

    def duplication_warning(self):
        if self.installedLocal() and self.installedGlobal():
            self.msg_both_local_global()

    def executable(self):
        if hasattr(self, '__executable__'): 
            return self.__executable__
        if '/' in sys.executable:
            self.__executable__  = sys.executable.split('/')[-1]
        elif '\\'  in sys.executable:
            self.__executable__  = sys.executable.split('\\')[-1]
        else:
            self.__executable__ = ''
        return self.__executable__ 

    def findConfig(self, ini_name='cy-master.ini'):
        pathToken = os.path.abspath(".").split('/')
        path = "/".join(pathToken)
        self.configFile( "" )
        while len(pathToken) > 0:
            path = "/".join(pathToken)
            pathToken.pop()
            if path == '' :
                configFile = "/%s" % ini_name
            else :
                configFile = "%s/%s" % (path, ini_name) 
            if self.pathexists( configFile ) :
                self.infoMsg("Configuation file: '%s' !" % configFile, "CONFIG FOUND")
                self.configFile( configFile )
                self.projectPath( path )
                return True
        return False

    def globalInstallPath(self, id=1):
        folder = self.globalFolder(id)
        if folder[-1] == '/':
            return '%s%s' % (folder, self.appName())
        else:
            return '%s/%s' % (folder, self.appName())

    def globalInstallTargetPath(self, id=1):
        if self.targetApp() == '':
            return ''
        folder = self.globalFolder(id)
        if folder[-1] == '/':
            return '%s%s' % (folder, self.targetApp())
        else:
            return '%s/%s' % (folder, self.targetApp())

    def hasGlobalInstallation(self):
        return  self.pathexists(self.globalInstallPath(0)) or self.pathexists(self.globalInstallPath(1)) 

    def is_docker_container(self):
        if not hasattr(self, '__is_container__'):
            self.__is_container__=self.pathexists('/.dockerenv')
        return self.__is_container__

    def is_gnu_tar(self):
        result = False
        tar = self.which_cmd("tar")
        if tar != "":
            result, stdout = self.shell("%s --version" % tar)
            if "GNU tar" in stdout:
                result = True
        return result

    def isGlobal(self):
        if not hasattr(self,'__is_global__'):
            if self.thisFile().endswith(".so"):
                this=self.this() 
            else:
                this=self.thisFile() 
            if this=='' or this=='<stdin>':
                if self.pathexists(self.globalInstallPath(0)) or self.pathexists(self.globalInstallPath(1)):
                    return True 
                else:
                    return False
            else:
                self.__is_global__ = this== self.globalInstallPath(0) or this == self.globalInstallPath(1)
        return self.__is_global__

    def is_local(self):
        if not hasattr(self, '__is_local__'):
            if self.thisFile().endswith(".so"):
                self.__is_local__=self.this() == self.localInstallPath()
            else:
                self.__is_local__=self.thisFile() == self.localInstallPath()
        return self.__is_local__

    def is_latest(self, major1, major2, minor1, minor2, patch1=0, patch2=0):
        # check 1 is latest, 2 as reference
        return major1>major2 or (major1==major2 and minor1>minor2) or (major1==major2 and minor1==minor2 and patch1>patch2)

    def latest_version(self):
        useRequest = False
        try:
            if not hasattr(self,'__latest_version__'):
                majorVersion = 0
                minorVersion = 0
                lines = []
                result, stdout = self.curl_cmd( url=self.downloadUrl())
                if result:
                    lines = stdout.splitlines()
                for line in lines:
                    if 'setInstallation' in line and self.appName() in line:
                        for token in line.split(')')[0].split(','):
                            if 'majorVersion' in token:
                                majorVersion = int(token.split('=')[1])
                            if 'minorVersion' in token:
                                minorVersion = int(token.split('=')[1])
                self.__latest_version__="%d.%d" % (majorVersion,minorVersion)
                self.__need_update__=self.is_latest(majorVersion, self.majorVersion(), minorVersion, self.minorVersion())
        except:
            self.msg_no_server()
        if not hasattr(self,'__latest_version__'):
            self.__latest_version__='0.0'
        return self.__latest_version__

    def local(self):
        return socket.gethostname()

    def localInstallFolder(self):
        if self.isCmd() or self.isGitBash():
            return 'C:\\Users\\%s\\AppData\\Local\\Microsoft\\WindowsApps' % self.username()
        else:  
            return os.path.abspath('%s/.local/bin' % self.home())

    def localInstallPath(self):
        if self.isCmd() or self.isGitBash():
            return '%s\\%s.bat' % (self.localInstallFolder(), self.appName())
        else:
            return os.path.abspath('%s/%s' % (self.localInstallFolder(), self.appName()))

    def localTargetInstallPath(self):
        if self.isCmd() or self.isGitBash():
            return '%s\\%s.exe' % (self.localInstallFolder(), self.targetApp())
        else:
            return os.path.abspath('%s/%s' % (self.localInstallFolder(), self.targetApp()))

    def need_update(self):
        if not hasattr(self,'__need_update__'):
            self.__need_update__=False
            self.latest_version()
        return self.__need_update__

    def nopw(self, user, cmd):
        return "%s ALL=(ALL) NOPASSWD: %s" % (user, cmd)

    def path_to_dos(self, path):
        # Avoid doing any os.path.realpath conversion
        split_path=path.split('/')
        count=0
        result=''
        for pathlet in split_path:
            # Avoid repeatively adding c:, it should not been there
            if pathlet!= '' and pathlet[-1] != ':':
                count = count + 1
                if count == 1:
                    if len(pathlet) == 1:
                        result = pathlet + ':'
                    else:
                        result = pathlet
                else:
                    result = result + '\\' + pathlet
        return result

    def path_to_gitbash(self, path):
        # Avoid doing any os.path.realpath conversion
        split_path=path.replace("/","\\").split('\\')
        count=0
        result=''
        for pathlet in split_path:
            if pathlet!= '':
                if pathlet[-1] == ':':
                    pathlet=pathlet[:-1]
                result = result + '/' + pathlet
        return result

    def parseArgs(self, usage=None):
        if usage is None:
            usage = self.usage()
        if self.appPath() != '' :
            if len(sys.argv) > 1:
                self.cmd(sys.argv[1])
                if self.cmd()== "help": 
                    self.help()
                    return True
                elif self.cmd()== "where" and len(sys.argv) > 2:
                    self.cmd_history("# ** where %s **" % sys.argv[2],currentframe().f_lineno)
                    self.cmd_history_print(currentframe().f_lineno)
                    self.prn(self.where_cmd(sys.argv[2]))
                    return True
                elif self.cmd()== "which" and len(sys.argv) > 2:
                    self.cmd_history("# ** which %s **" % sys.argv[2],currentframe().f_lineno)
                    self.cmd_history_print(currentframe().f_lineno)
                    self.prn(self.which_cmd(sys.argv[2]))
                    return True
                elif self.cmd() == "self-install" or self.cmd() == "install" or self.cmd() == "update":
                    self.start_install()
                    self.cmd_history_print()
                    return True
                elif self.cmd() == "cython-string":
                    self.prn(self.cythonString()) 
                    return True
                elif self.cmd() == "check-system":
                    self.msg_system_check()
                    return True
                elif self.cmd() == "this":
                    self.prn(self.this()) 
                    return True
                elif self.cmd() == "this-file":
                    self.prn(self.thisFile())
                    return True
                elif self.cmd() == "download":
                    self.download_to_temp(verbal=True)
                    self.cmd_history_print()
                    return True
                elif self.cmd() == "download-app" or self.cmd() == "download-target-app":
                    self.download_to_temp(url=self.tempAppUrl(), file=self.tempTargetGzip(), verbal=True)
                    self.cmd_history_print()
                    return True
                elif self.cmd() == "global-installation-path":
                    self.prn(self.globalInstallPath(0))
                    self.prn(self.globalInstallPath(1))
                    return True
                elif self.cmd() == "local-installation-path":
                    self.prn(self.localInstallPath())
                    return True
                elif self.cmd() == "os-major-version":
                    self.prn(self.os_major_version())
                    return True
                elif self.cmd() == "timestamp":
                    self.prn(self.timestamp())
                    return True
                elif self.cmd() == "today":
                    self.prn(self.today())
                    return True
                elif self.cmd() == "uninstall":
                    self.selfUninstall(verbal=True)
                    self.cmd_history_print()
                    return True
                elif self.cmd() == "check-update" or self.cmd() == "check-version"  or self.cmd() == "check":
                    self.check_update()
                    return True
                elif self.allowDisplayInfo():
                    self.msg_info(usage)
                    return True
            elif self.allowDisplayInfo():
                self.msg_info(usage)
        if self.allowSelfInstall():
            if self.fromPipe():
                result = self.download_and_install(verbal=True)
                if self.hasFunc("requisite"):
                    self.requisite()
                return True
        return False

    def real_path(self, x, curr_path=None):
        if curr_path is None:
            curr_path = self.curPath()
        if self.isCmd():
            if x[:1].startswith(':\\'):
                result=x
            elif x.startswith('..\\'):
                curr_path= '\\'.join(curr_path.split('\\')[:-1])
                if curr_path=='':
                    curr_path=self.curPath()
            result=self.path_to_dos('%s\\%s'% (os.getcwd(),x))
        else:
            if x.startswith('/'):
                result=x
            elif x.startswith('../../'):
                x=x[6:]
                curr_path = '/'.join(curr_path.split('/')[:-2])
            elif x.startswith('../'):
                x=x[3:]
                curr_path = '/'.join(curr_path.split('/')[:-1])
            result='%s/%s' % (curr_path,x)
        return result

    def remove_nginx_adm_sudoer(self, usr="nginx-adm"):
        self.history_remove_sudoer(currentframe().f_lineno)
        target_sudoers="/etc/sudoers.d/1700-%s" % usr
        self.cmd_history("ls %s" % target_sudoers)
        if self.pathexists(target_sudoers):
            self.sudoRemoveFile(target_sudoers)

    def selfInstall(self, verbal = True):
        if self.isGlobal():
            if self.need_update():
                self.msg_old_global()
                if self.ask_update():
                    return self.download_and_install(verbal=verbal)
            else:
                self.msg_latest_global()
                return False
        elif self.is_local():
            if self.need_update():
                self.msg_old_local()
                if self.ask_update():
                    return self.download_and_install(verbal=verbal)
            else:
                self.msg_latest_local()
                return False
        elif self.installedGlobal():
            self.msg_global_already()
            if self.ask_overwrite_global():
                if self.thisFile().endswith(".so"):
                    return self.__self_install__(this=self.this(), verbal=verbal)
                else:
                    return self.__self_install__(this=self.thisFile(), verbal=verbal)
        elif self.installedLocal():
            self.msg_local_already()
            if self.ask_overwrite_local():  
                return self.install_local(verbal)
        elif self.username() != 'root' and self.allowInstallLocal():
            if self.ask_local():
                return self.install_local(verbal)
        else:
            return self.__self_install_globally__(verbal)

    def selfLocation(self):
        if self.this() != '':
            return self.this()
        if getIpythonExists:
            try:
                shell = get_ipython().__class__.__name__
                if shell == 'ZMQInteractiveShell':
                    return "Jupyter"
                elif shell == 'TerminalInteractiveShell':
                    return "IPython"
                else:
                    return "Unknown location"
            except NameError:
                return "Unknown location" 
        return "Unknown location" 
        
    def selfUninstallGlobal(self, verbal = True):
        if self.installedGlobal():
            result = False
            display_once = False
            if self.username() != 'root':
                if self.sudo_test():
                    self.msg_sudo()
                    if self.targetApp() != '':
                        file1 = "%s/%s" % (self.globalFolder(0), self.targetApp())
                        file2 = "%s/%s" % (self.globalFolder(1), self.targetApp())
                        if os.path.exists(file1):
                            self.history_remove_previous_global(currentframe().f_lineno)
                            display_once = True
                            self.sudoRemoveFile(file1)
                        if os.path.exists(file1):
                            if not display_once:
                                self.history_remove_previous_global(currentframe().f_lineno)
                                display_once = True
                            self.sudoRemoveFile(file2)
                    if os.path.exists(self.globalInstallPath(0)):
                        if not display_once:
                            self.history_remove_previous_global(currentframe().f_lineno)
                            display_once = True
                        self.sudoRemoveFile(self.globalInstallPath(0))
                        result = True
                    if os.path.exists(self.globalInstallPath(1)):
                        if not display_once:
                            self.history_remove_previous_global(currentframe().f_lineno)
                            display_once = True
                        self.sudoRemoveFile(self.globalInstallPath(1))
                        result = True
                else:
                    if verbal and self.signal() != 2:
                        self.msg_unintall_need_root()
                    return False
            else:
                if self.targetApp() != '':
                    file1 = "%s/%s" % (self.globalFolder(0), self.targetApp())
                    file2 = "%s/%s" % (self.globalFolder(1), self.targetApp())
                    if os.path.exists(file1):
                        self.history_remove_previous_global(currentframe().f_lineno)
                        display_once = True
                        self.sudoRemoveFile(file1)
                    if os.path.exists(file1):
                        if not display_once:
                            self.history_remove_previous_global(currentframe().f_lineno)
                            display_once = True
                        self.sudoRemoveFile(file2)
                if os.path.exists(self.globalInstallPath(0)):
                    if not display_once:
                        self.history_remove_previous_global(currentframe().f_lineno)
                        display_once = True
                    self.sudoRemoveFile(self.globalInstallPath(0))
                    result = True
                if os.path.exists(self.globalInstallPath(1)):
                    if not display_once:
                        self.history_remove_previous_global(currentframe().f_lineno)
                        display_once = True
                    self.sudoRemoveFile(self.globalInstallPath(1))
                    result = True
            if result:
                if verbal:
                    self.cmd_history_print(currentframe().f_lineno)
                    self.msg_unintall_global()
            else:
                self.msg_global_failed()
            return result
        else:
            self.msg_no_global()
        return False

    def selfUninstall(self, verbal=False):
        once =False
        if self.installedLocal():
            self.selfUninstallLocal(verbal)
            once = True
        if self.installedGlobal():
            if once:
                self.selfUninstallGlobal(verbal=False)
            else:
                self.selfUninstallGlobal(verbal)
            once = True
        if not once:
            self.msg_no_installation()    

    def selfUninstallLocal(self, verbal = True):
        if self.installedLocal():
            self.history_remove_previous_local(currentframe().f_lineno)
            self.removeFile(self.localInstallPath())
            if not os.path.exists(self.localInstallPath()):
                if self.targetApp() != '':
                    self.removeFile(self.localTargetInstallPath())
                if verbal:
                    self.cmd_history_print(currentframe().f_lineno)
                    self.msg_uninstall_local()
                return True
            else:
                self.msg_uninstall_local_failed()
                return False
        else:
            self.msg_no_local()
            return False

    def setInstallation(self,appName='',author='',lastUpdate='',homepage='',downloadUrl="",majorVersion=0,minorVersion=0):
        signal.signal(signal.SIGINT, self.signal_handler)
        self.check_system() \
            .author( author ) \
            .appName( appName ) \
            .downloadUrl( downloadUrl ) \
            .homepage( homepage ) \
            .lastUpdate( lastUpdate ) \
            .majorVersion( majorVersion ) \
            .minorVersion( minorVersion )
        self.__init_temp__()

    def start_install(self):
        if self.hasFunc("requisite"):
            self.infoMsg("System requisite Found!", "REQUESITE")
            result = self.requisite()
        else:
            self.infoMsg("No system requisite Found!", "NO REQUESITE")
        if self.is_local() or self.isGlobal():
            if self.need_update():
                self.download_and_install()
                self.selfInstall()
            else:
                self.infoMsg("You are using the latest version.", "LATEST VERSION")
        elif self.selfLocation() != "Unknown location": 
            self.install(self.selfLocation(), verbal=True)
        else:
            self.download_and_install()
            self.selfInstall()

    def tempAppUrl(self):
        if self.downloadUrl()[-1] == '/':
            return "%s%s/%d.%d/%s.tar.gz" % (self.downloadUrl(), self.binVer(), self.majorVersion(),self.minorVersion(), self.targetApp())
        else:
            return "%s/%s/%d.%d/%s.tar.gz" % (self.downloadUrl(), self.binVer(), self.majorVersion(),self.minorVersion(), self.targetApp())

    def tempTargetGzip(self):
        timestamp = self.timestamp()
        tempFolder = self.tempFolder()
        if tempFolder=="":
            return ""
        if self.isLinuxShell():
            return "%s/%s-%s.tar.gz" % (tempFolder, self.targetApp(), timestamp)
        elif self.isGitBash() or self.isCmd():
            return "%s\\%s-%s.tar.gz" % (tempFolder, self.targetApp(), timestamp)
        return "%s/%s-%s.tar.gz" % (tempFolder, self.targetApp(), timestamp)

    def tempAttachDecomp(self):
        tempFolder=self.tempFolder()
        if tempFolder=="":
            return ""
        if self.isCmd():
            fname="%s\\%s" % (tempFolder,self.targetApp())
        elif self.isGitBash():
            fname="%s/%s" % (tempFolder,self.targetApp())
        else:
            fname="%s/%s" % (tempFolder, self.targetApp())
        return fname

    def translateScript(self, source="", target="", useSudo=False):
        tempFolder=self.tempFolder()
        if tempFolder=="":
            return False
        result = False
        if self.pathexists(source):
            tempScript = "%s.tmp" % self.tempFile()
            if tempScript!=source:
                self.history_open_as_source(source, currentframe().f_lineno)
                file1 = self.open(source, 'r')
                self.history_open_as_target(tempScript, currentframe().f_lineno)
                file2 = self.open(tempScript,'w')
                if self.isCmd() or self.isGitBash():
                    for line in file1:
                        if line.startswith(''):
                            file2.write(line[4:])
                        elif not (line.startswith('from __future__') or line.startswith('#!') or line.startswith('# -*-')):
                            file2.write(line)
                else:
                    for line in file1:
                        if line.startswith('#!/bin/sh'):
                            file2.write('#!%s\n' % sys.executable)
                        else:
                            file2.write(line)
                file1.close()
                file2.close()
                if source.startswith(tempFolder):
                    self.history_remove_source(currentframe().f_lineno)
                    self.removeFile(source)
                self.history_copy_temp(currentframe().f_lineno)
                self.cp(tempScript, target, useSudo=useSudo)
                self.history_remove_temp(currentframe().f_lineno)
                self.removeFile(tempScript)
                if not self.is_window():
                    self.history_change_target_mode(currentframe().f_lineno)
                    result=self.chmod_x(target, useSudo=useSudo)
                else:
                    return True
        else:
            self.msg_download_not_found(target)
        return result

    def help(self):
        self.prn("%s [%s]" % (self.appExec(), "|".join(self.subCmd ()) ))

    def usage(self, para=None):
        if not hasattr(self,'__para__'):
            self.__para__=''
            if para is not None:
                if "|" in para:
                    for subcmd in para.split("|"):
                        s = subcmd.strip()
                        if s !="":
                            self.subCmd(s)
                elif "," in para: 
                    for subcmd in para.split(","):
                        s = subcmd.strip()
                        if s !="":
                            self.subCmd(s)       
        if para is not None:
            self.__para__=para
            return self
        return "%s [%s]" % (self.appExec(),self.__para__)

class DockerConfig(Shell):

    def __init__(self, this=None):
        try:
            super().__init__(this)
        except:
            super(DockerConfig, self).__init__(this)
        self.__init__docker_config__()

    def __init__docker_config__(self):
        if not hasattr(self, '__docker_config_inited__'):
            Attr(self, "docker_tag", "")
            Attr(self, "dockerName", "")
            Attr(self, "configFile", "")
            Attr(self, "exposedPort", "")
            Attr(self, "exposedVolume", "")
            Attr(self, "externalPort", "")
            Attr(self, "imagePath", "")
            Attr(self, "maintainer", "")
            Attr(self, "maintainerEmail", "")
            Attr(self, "portMapping", "")
            Attr(self, "profile", "Default")
            Attr(self, "projectName", "")
            Attr(self, "projectPath", "")
            Attr(self, "targetOS", "alpine:3.16")
            Attr(self, "testProfile", False)
            self.__docker_config_inited__ = True

    def get_profile_list(self, config):
        profileList = ['Alpine-3.16', 'Alpine-3.17', 'Alpine-3.18', 'Centos-7', 'Centos-8', 'Centos-9', 
            'Debian-10', 'Debian-11', 'Debian-12', 'Ubuntu-18.04', 'Ubuntu-18.10', 'Ubuntu-19.04', 
            'Ubuntu-19.10','Ubuntu-20.04', 'Ubuntu-20.10', 'Ubuntu-21.04', 'Ubuntu-21.10',
            'Ubuntu-21.04', 'Ubuntu-21.10', 'Ubuntu-22.04', 'Ubuntu-22.10', 'Ubuntu-23.04',
            'Ubuntu-23.10', 'Ubuntu-24.04']
        self.foundList = []
        choice = []
        index = 1
        for p in profileList:
            if config.has_section(p):
                self.foundList.append(p)
                choice.append("%6d) %s" % (index, p))
                index += 1
        if index == 1:
            choice = ['N/A']
        return choice, index

    def clean_all_profile(self):
        if self.configFile() == '':
            self.find_config()
        if self.configFile() != '':
            config = configparser.ConfigParser()
            config.read( self.configFile() )
            if config.has_section("docker"):
                try :
                    self.projectName( config.get("docker", "projectName"))
                except :
                    pass
            choice, total = self.get_profile_list(config)
            if len(self.foundList) == 0:
                self.prn("Proifle: NOT FOUND")
                return False
            for l in self.foundList:
                if self.signal() != 2:
                    self.targetOS(l)
                    self.dockerName("%s-%s" % (self.projectName(), self.targetOS()))
                    dockerPath=self.dockerPath()
                    if dockerPath !="":
                        if self.is_mac():
                            result, stdout = self.shell("find %s/src/* -exec /bin/zsh -c 'xattr -c \"{}\"' \\;" % (dockerPath), ignoreErr=True)
                        self.removeFolder("%s/docker-image" % dockerPath, use_history=True)
                        self.removeFolder("%s/target" % dockerPath, use_history=True)
                        self.removeFolder("%s/repo" % dockerPath, use_history=True)
                        self.safeMsg("Container cleaned: %s" % self.dockerName(),"CLEAN ALL")

    def get_profile(self, display_list):
        config = configparser.ConfigParser()
        config.read( self.configFile() )
        sessionName=''
        if config.has_section(self.profile()):
            sessionName=self.profile()
        if not (sessionName!= '' and config.has_section(sessionName)):
            choice, total = self.get_profile_list(config)
            if len(self.foundList) == 0:
                self.prn("Proifle: %s NOT FOUND" % sessionName)
                return config, ''
            elif len(self.foundList) == 1:
                sessionName=self.foundList[0]
            elif display_list:
                self.prn("\n".join(choice))
            else:
                self.prn("Please choose the following by typing the number (type 'exit' to exit): ")
                self.prn("\n".join(choice))
                self.prn("  type 'exit' to exit")
                num = self.ask_choose_profile_number()
                if num == -1 :
                    exit()
                while num<1 or num >= total:
                    num = self.ask_choose_profile_number()
                    if num == -1 :
                        exit()
                sessionName=self.foundList[num - 1]
        self.profile(sessionName)
        return config, sessionName

    def check_config(self, display_list=False):
        if self.configFile() == '':
            self.find_config()
        if self.configFile() != '':
            config, sessionName = self.get_profile(display_list)
            if config.has_section("project"):
                try :
                    self.projectName( config.get("project", "projectName"))
                except :
                    pass
                try:
                    self.dockerName( config.get("project", "dockerName"))
                except :
                    pass
                try:
                    self.exposedVolume( config.get("project", "exposedVolume"))
                except:
                    pass
                try:
                    self.maintainer( config.get("project", "maintainer"))
                except:
                    pass
                try:
                    self.maintainerEmail( config.get("project", "maintainerEmail"))
                except:
                    pass
                try:
                    self.maintainerEmail( config.get("project", "maintainerEmail"))
                except:
                    pass
                try:
                    arch = self.arch()
                    if arch == '':
                        self.docker_tag(config.get("project", "tag"))
                    else :
                        self.docker_tag( "%s-%s" % (config.get("project", "tag"), arch))
                except:
                    pass
                try:
                    self.externalPort( config.get("project", "externalPort"))
                except:
                    pass
                try:
                    self.portMapping( config.get("project", "portMapping"))
                except:
                    pass
                try:
                    self.exposedPort( config.get("project", "exposedPort"))
                except:
                    pass
                return True
            elif config.has_section("docker") and config.has_section(sessionName):
                try :
                    self.projectName( config.get("docker", "projectName"))
                except :
                    pass 
                try :
                    self.dockerName( config.get(sessionName, "dockerName"))
                except :
                    pass
                try:
                    self.exposedVolume( config.get(sessionName, "exposedVolume"))
                except:
                    pass
                try:
                    self.maintainer( config.get("docker", "maintainer"))
                except:
                    pass
                try:
                    self.maintainerEmail( config.get("docker", "maintainerEmail"))
                except:
                    pass
                try:
                    arch = self.arch()
                    if arch == '':
                        self.docker_tag(config.get(sessionName, "tag"))
                    else :
                        self.docker_tag( "%s-%s" % (config.get(sessionName, "tag"), arch))
                except:
                    pass
                try:
                    arch = self.arch()
                    self.targetOS(config.get(sessionName, "os"))
                    if self.dockerName() == '':
                        self.dockerName("%s-%s" % (self.projectName(), self.targetOS()))
                    if arch == '':
                        self.docker_tag(config.get(sessionName, "os"))
                    else :
                        self.docker_tag( "%s-%s" % (config.get(sessionName, "os"), arch))
                except:
                    pass
                try:
                    self.externalPort( config.get(sessionName, "externalPort"))
                except:
                    pass
                try:
                    self.portMapping( config.get(sessionName, "portMapping"))
                except:
                    pass
                    #self.infoMsg("exposedPort not in config", "TAG FAILED")
                try:
                    self.exposedPort( config.get(sessionName, "exposedPort"))
                except:
                    pass
            if sessionName=="":
                return False
            if self.maintainer() == '':
                self.infoMsg("Can't find maintainer in config", "CONFIG FAILED")
            if self.maintainerEmail() == '':
                self.infoMsg("Can't find maintainerEmail in config", "CONFIG FAILED")
            if self.projectName() == '':
                self.infoMsg("Can't find projectName in config", "CONFIG FAILED")
            if self.dockerName() == '':
                self.infoMsg("Can't find dockerName in config", "CONFIG FAILED")
            if self.docker_tag() == '':
                self.infoMsg("Can't find tag in config", "CONFIG FAILED")
            return self.maintainer() != '' and self.maintainerEmail() != '' and self.projectName() != '' and self.dockerName() != '' and self.docker_tag() !=''              
        else :
            self.criticalMsg("File: project.ini not found!","NO CONFIG")
        return False

    def find_config(self):
        pathToken = os.path.abspath(".").split("/")
        path = "/".join(pathToken)
        self.configFile( '' )
        while len(pathToken) > 0:
            path = "/".join(pathToken)
            pathToken.pop()
            if path == '' :
                configFile = '/project.ini'
            else :
                configFile = "%s/project.ini" % path
            if self.pathexists( configFile ) :
                self.infoMsg("Configuation file: '%s' !" % configFile, "CONFIG FOUND")
                self.configFile( configFile )
                self.projectPath( path )
                return True
        return False

    def dockerPath(self, dockerPath=None):
        if dockerPath is not None:
            self.__dockerPath__=dockerPath
            return self
        elif not hasattr(self,'__dockerPath__'):
            self.__dockerPath__=""
            arch = self.arch()
            if arch == 'arm64':
                arch = 'aarch64'
            targetOS = re.sub(':','-',self.targetOS())
            if self.pathexists('%s/%s-%s/Dockerfile' % (self.projectPath(),targetOS,arch)):
                if self.isCmd():
                    self.safeMsg("Location of the Dockerfile is: %s\\%s-%s\\Dockerfile" % (self.projectPath(),targetOS,arch),"DOCKER FILE")
                    self.__dockerPath__='%s\\%s-%s' % (self.projectPath(),targetOS,arch)
                else:
                    self.safeMsg("Location of the Dockerfile is: %s/%s-%s/Dockerfile" % (self.projectPath(),targetOS,arch),"DOCKER FILE")
                    self.__dockerPath__='%s/%s-%s' % (self.projectPath(),targetOS,arch)
            elif self.pathexists('%s/%s/Dockerfile' % (self.projectPath(),arch)):
                if self.isCmd():
                    self.__dockerPath__='%s\\%s' % (self.projectPath(),arch)
                else:
                    self.__dockerPath__='%s/%s' % (self.projectPath(),arch)
            elif  self.pathexists('%s/Dockerfile' % self.projectPath()) :
                self.__dockerPath__=self.projectPath()
            if self.__dockerPath__ != '':
                if self.isCmd():
                    self.imagePath('%s\\docker-image' % self.__dockerPath__)
                else:
                    self.imagePath('%s/docker-image' % self.__dockerPath__)
        return self.__dockerPath__

class DockerBuild(DockerConfig):

    def __init__(self, this=None):
        try:
            super().__init__(this)
        except:
            super(DockerBuild, self).__init__(this)

    def clean_target_folder(self, path):
        result, stdout = self.shell('rm -rf "%s/target/*"' % path, True)
        result = self.mkdir("%s/target" % path) 
        return result

    def hasEtc(self, hasEtc=None):
        if hasEtc is not None:
            self.__hasEtc__=hasEtc
            return self
        elif not hasattr(self, '__hasEtc__'):
            self.__hasEtc__=False
        return self.__hasEtc__

    def hasLib(self, hasLib=None):
        if hasLib is not None:
            self.__hasLib__=hasLib
            return self
        elif not hasattr(self, '__hasLib__'):
            self.__hasLib__=False
        return self.__hasLib__

    def hasLib64(self, hasLib64=None):
        if hasLib64 is not None:
            self.__hasLib64__=hasLib64
            return hasLib64
        elif not hasattr(self, '__hasLib64__'):
            self.__hasLib64__=False
        return self.__hasLib64__

    def hasOpt(self, hasOpt=None):
        if hasOpt is not None:
            self.__hasOpt__=hasOpt
            return self
        elif not hasattr(self, '__hasOpt__'):
            self.__hasOpt__=False
        return self.__hasOpt__

    def hasRoot(self, hasRoot=None):
        if hasRoot is not None:
            self.__hasRoot__=hasRoot
            return self
        elif not hasattr(self, '__hasRoot__'):
            self.__hasRoot__=False
        return self.__hasRoot__

    def hasUsr(self, hasUsr=None):
        if hasUsr is not None:
            self.__hasUsr__=hasUsr
            return self
        elif not hasattr(self, '__hasUsr__'):
            self.__hasUsr__=False
        return self.__hasUsr__

    def hasVar(self, hasVar=None):
        if hasVar is not None:
            self.__hasVar__=hasVar
            return self
        elif not hasattr(self, '__hasVar__'):
            self.__hasVar__=False
        return self.__hasVar__

    def image_build(self, tag):
        result = self.image_prebuild()
        if result:
            cmd = ''
            os.chdir(self.dockerPath())
            self.cmd_history("# ** Docker Command ** ")
            if self.is_mac() or self.is_window():
                cmd = "docker build -t %s/%s:%s ." % (self.maintainer(), self.projectName(),tag)
            elif self.sudo_test():
                cmd = "sudo docker build -t %s/%s:%s ." % (self.maintainer(), self.projectName(),tag)
            if cmd != '' :
                try:
                    self.cmd_history(cmd)
                    result, stdout = self.shell(cmd, ignoreErr=True)
                    print(stdout)
                except:
                    pass
            else :
                self.msg_incompatiable_os("BUILD FAILED")
        self.cmd_history_print(currentframe().f_lineno)
        if result: 
            self.safeMsg("Command 'build' executed!", "COMMAND")

    def image_prebuild(self):
        result = False
        dockerPath = self.dockerPath()
        if dockerPath!="":
            self.safeMsg("Using docker path: %s" % dockerPath, 'DOCKER PATH')
            os.chdir(self.projectPath())
            img_path=self.imagePath()
            result = self.clean_target_folder(dockerPath)
            if dockerPath != self.projectPath():
                result, stdout = self.shell("rm -rf %s/*" % img_path, True )
                self.mkdir( img_path )
                if self.pathexists('%s/docker-image' % self.projectPath()):
                    result, stdout = self.cp('%s/docker-image' % self.projectPath(), "%s/" % dockerPath)
                if self.pathexists('%s/src' % dockerPath):
                    if os.listdir('%s/src' % dockerPath):
                        result, stdout = self.cp('%s/src/*' % dockerPath, '%s/' % img_path)
            if not self.npm_install_app_folder():
                self.criticalMsg("npm is required", "NO NPM")
                return False
            os.chdir(self.projectPath())
            if self.pathexists('%s/app' % self.projectPath()):
                result, stdout = self.shell('cp -rP %s/app "%s/root/.init/"' % (self.projectPath(),img_path))
            if self.pathexists('%s/data' % self.projectPath()):
                if os.listdir('%s/data' % self.projectPath()):
                    self.mkdir('%s/root/.data/' % img_path)
                    result, stdout = self.shell('cp -rP %s/data/* "%s/root/.data/"' % (self.projectPath(),img_path))
            if self.pathexists('%s/bin' % self.projectPath()):
                if os.listdir('%s/bin' % self.projectPath()):
                    result, stdout = self.shell('cp -rP %s/bin "%s/usr/local/"' % (self.projectPath(),img_path))
            if self.pathexists('%s/usr/bin/' % img_path):
                path = '%s/usr/bin/*' % img_path
                self.chmod(path, "+x")
            if self.pathexists('%s/usr/local/bin/' % img_path):
                path = '%s/usr/local/bin/*' % img_path
                self.chmod(path, "+x")
            if result:
                if self.pathexists('%s/usr/local/bin/' % img_path):
                    path = '%s/usr/local/bin/*' % img_path
                    self.chmod(path, "+x")
            if result:
                if self.pathexists('%s/root/.ssh/id_rsa' % img_path):
                    path = '%s/root/.ssh/id_rsa' % img_path
                    self.chmod(path, "600")
                if self.pathexists('%s/root/.ssh' % img_path) and result:
                    path = '%s/root/.ssh/' % img_path
                    self.chmod(path, "700")
            self.hasUsr(self.pathexists('%s/usr/' % img_path))
            self.hasRoot(self.pathexists('%s/root/' % img_path))
            self.hasLib(self.pathexists('%s/lib/' % img_path))
            self.hasLib64(self.pathexists('%s/lib64/' % img_path))
            self.hasEtc(self.pathexists('%s/etc/' % img_path))
            self.hasOpt(self.pathexists('%s/opt/' % img_path))
            self.hasVar(self.pathexists('%s/var/' % img_path ))
            usrlib = '%s/usr/lib' % img_path
            usrLocalBin = '%s/usr/local/lib' % img_path
            lib = '%s/lib' % img_path
            srcUsrlib = '%s/src/usr/lib' % dockerPath
            srcLib = '%s/src/lib' % dockerPath
            opt = '%s/src/opt' % dockerPath
            self.cmd_history("# ** Trying to create soft links  ** ", currentframe().f_lineno)
            if self.hasUsr():
                self.src_create_shortlink_so(usrlib, srcUsrlib)
                if self.pathexists(usrLocalBin):
                    self.chmod(usrLocalBin, "+x")
            if self.hasLib():
                self.src_create_shortlink_so(lib, srcLib)
            if self.hasRoot():
                self.history_compress("root.tar.gz", currentframe().f_lineno)
                os.chdir(img_path)
                self.tar_compress("../target/root.tar.gz","root")
            if self.hasUsr():
                self.history_compress("usr.tar.gz", currentframe().f_lineno)
                os.chdir(img_path)
                self.tar_compress("../target/usr.tar.gz","usr")
            if self.hasEtc():
                self.history_compress("etc.tar.gz", currentframe().f_lineno)
                os.chdir(img_path)
                self.tar_compress("../target/etc.tar.gz","etc")
            if self.hasLib():
                self.history_compress("lib.tar.gz", currentframe().f_lineno)
                os.chdir(img_path)
                self.tar_compress("../target/lib.tar.gz","lib")
            if self.hasLib64():
                self.history_compress("lib64.tar.gz", currentframe().f_lineno)
                os.chdir(img_path)
                self.tar_compress("../target/lib64.tar.gz","lib64")
            if self.hasOpt():
                self.history_compress("opt.tar.gz", currentframe().f_lineno)
                os.chdir(img_path)
                self.tar_compress("../target/opt.tar.gz","opt")
            if self.hasVar():
                self.history_compress("var.tar.gz", currentframe().f_lineno)
                os.chdir(img_path)
                self.tar_compress("../target/var.tar.gz","var")
            os.chdir(self.curPath())
        else :
            self.criticalMsg("Dockerfile Not found", "DOCKERFILE")
        return result

    def npm_install_app_folder(self):
        if self.pathexists('%s/app' % self.projectPath()):
            if os.listdir('%s/app' % self.projectPath()):
                if self.pathexists('%s/app/package.json' % self.projectPath()):
                    if self.which_cmd("npm") != '':
                        os.chdir('%s/app' % self.projectPath())
                        result, stdout = self.shell('rm -rf node_modules')    
                        result, stdout = self.shell('npm install')
                        os.chdir( self.projectPath())
                        return True
                    else :
                        return False
        return True

    def src_create_shortlink_so(self, dir, srcDir):
        if self.pathexists(dir):
            try:
                for filename in os.listdir(dir):
                    f = os.path.join(dir, filename)
                    if os.path.isfile(f):
                        f2 = re.sub(r"(\.so\.\d+)(\.\d+)*", r"\1", filename)
                        if f2 != filename:
                            f3 = re.sub(r"\/.+\/docker-image","",f) 
                            os.chdir(dir)
                            if os.path.isfile( os.path.join(dir, f2) ):
                                self.removeFile(os.path.join(dir, f2))
                                self.removeFile(os.path.join(srcDir, f2))
                            self.ln(source=filename, target=f2)
                    elif os.path.isdir(f):
                        self.src_create_shortlink_so(f, os.path.join(srcDir, filename) )
            except:
                pass

class ImageBase(DockerBuild):

    def __init__(self, this=None):
        try:
            super().__init__(this)
        except:
            super(ImageBase, self).__init__(this)

    def image_rm_all(self):
        if self.is_mac() or self.is_window():
            cmd = "docker image ls"
        elif self.sudo_test():
            cmd = "sudo docker image ls"
        if cmd != '' :
            result, stdout = self.shell(cmd)
            self.cmd_history("# ** Docker Command ** ", currentframe().f_lineno)
            for l in stdout.split('\n'):
                token = l.split()
                if len(token) > 3:
                    if token[2] != "IMAGE":
                        if self.is_mac() or self.is_window():
                            cmd = "docker image rm %s" % token[2]
                        else :
                            cmd = "sudo docker image rm %s" % token[2]
                        self.cmd_history(cmd)
                        result, stdout = self.shell( cmd, ignoreErr=True )
        else :
            self.msg_incompatiable_os("CLEAN FAILED")

    def image_clean_unused(self):
        if self.is_mac() or self.is_window():
            cmd = "docker image ls"
        elif self.sudo_test():
            cmd = "sudo docker image ls"
        if cmd != '' :
            result, stdout = self.shell(cmd)
            for l in stdout.split('\n'):
                if '<none>' in l:
                    token = l.split()
                    if len(token) > 3:
                        self.cmd_history("# ** Docker Command ** ", currentframe().f_lineno)
                        if self.is_mac() or self.is_window():
                            cmd = "docker image rm %s" % token[2]
                        else :
                            cmd = "sudo docker image rm %s" % token[2]
                        self.cmd_history(cmd)
                        result, stdout = self.shell( cmd, True )
                        if stdout == "": 
                            self.infoMsg("docker image %s is being used" % token[2], "CANNOT REMOVE")
                        else :
                            print(stdout)
        else :
            self.msg_incompatiable_os("CLEAN FAILED")

    def image_ls(self):
        cmd = ''
        if self.is_mac() or self.is_window():
            cmd = "docker image ls" 
        elif self.sudo_test():
            cmd = "sudo docker image ls" 
        if cmd != '' :
            result, stdout = self.shell(cmd, True)
            if stdout != '':
                for l in stdout.split('\n'):
                    print(l)

class ContainerBase(ImageBase):

    def __init__(self, this=None):
        try:
            super().__init__(this)
        except:
            super(ContainerBase, self).__init__(this)

    def container_attach(self, dockerName, display_history=False):
        if self.is_mac() or self.is_window():
            self.cmd_history("# ** Docker Command ** ", currentframe().f_lineno)
            try:
                self.cmd_history(" ".join(["docker","attach", "--sig-proxy=false", dockerName]))
                if display_history:
                    self.cmd_history_print()
                subprocess.run(["docker","attach", dockerName])
            except:
                self.criticalMsg("Error in running Docker command: 'docker attach --sig-proxy=false %s'" % dockerName, "DOCKER ERROR")
        elif self.sudo_test():
            self.cmd_history("# ** Docker Command ** ", currentframe().f_lineno)
            try:
                self.cmd_history(" ".join(["docker","attach", "--sig-proxy=false", dockerName]))
                if display_history:
                    self.cmd_history_print()
                subprocess.run(["sudo","docker","attach", "--sig-proxy=false", dockerName])
            except:
                self.criticalMsg("Error in running Docker command: 'docker attach --sig-proxy=false %s'" % dockerName, "DOCKER ERROR")
        else :
            self.criticalMsg("Terminated!","ATTACH")

    def container_exec(self, dockerName, display_history=False):
        if 'alpine' in re.split(r'[:/\-]',self.targetOS()):
            shell = '/bin/ash'
        else:
            shell = '/bin/bash'
        self.cmd_history("# ** Docker Command ** ", currentframe().f_lineno)
        if self.is_mac() or self.is_window():
            try:
                self.cmd_history(' '.join(["docker","exec","-it", dockerName,shell]))
                if display_history:
                    self.cmd_history_print()
                subprocess.run(["docker","exec","-it", dockerName,shell])
            except:
                self.criticalMsg("Error in running Docker command: 'docker exec -it %s %s'" % (dockerName, shell ), "DOCKER ERROR")
        elif self.sudo_test():
            try:
                self.cmd_history(' '.join(["sudo","docker","exec","-it", dockerName,shell]))
                if display_history:
                    self.cmd_history_print()
                subprocess.run(["sudo","docker","exec","-it", dockerName,shell])
            except:
                self.criticalMsg("Error in running Docker command: 'docker exec -it %s %s'" % (dockerName, shell ), "DOCKER ERROR")
        else :
            self.criticalMsg("Terminated!","RUN")

    def container_ls(self, verbal=False):
        cmd = ''
        self.__containers__={}
        self.__container_id__ = []
        if self.is_mac() or self.is_window():
            cmd = "docker container ls --all" 
        elif self.sudo_test():
            cmd = "sudo docker container ls --all"
        if cmd != '' :
            self.cmd_history('# ** Check exists docker containers **', currentframe().f_lineno)
            self.cmd_history(cmd)
            result, stdout = self.shell(cmd, True)
            if stdout != '':
                for l in stdout.split('\n'):
                    id = l.split(" ")
                    if len(id)> 0:
                        if len(id[0]) == 12:
                            if id[0] not in self.__containers__:
                                self.__containers__[id[0]] = True
                                self.__container_id__.append(id[0])
                    if verbal:
                        print(l)

    def container_ls_local(self):
        self.container_ls()
        found = 0
        for name in self.__containers__:
            if name == self.dockerName() or name == '%s-test' % self.dockerName():
                print(name)
                found = found + 1
        if found == 0 :
            self.infoMsg("Docker Container: '%s' or '%s' missing!" % (self.dockerName(),'%s-test' % self.dockerName()), "NOT FOUND")

    def container_restart(self, dockerName, display_history=False):
        if self.is_mac() or self.is_window():
            self.cmd_history("# ** Docker Command ** ", currentframe().f_lineno)
            try:
                self.cmd_history(" ".join(["docker","container","restart", dockerName]))
                if display_history:
                    self.cmd_history_print()
                subprocess.run(["docker","container","restart", dockerName])
            except:
                self.criticalMsg("Error in running Docker command: 'docker container restart %s'" % dockerName, "DOCKER ERROR")
        elif self.sudo_test():
            self.cmd_history("# ** Docker Command ** ", currentframe().f_lineno)
            try:
                self.cmd_history(" ".join(["docker","container","restart", dockerName]))
                if display_history:
                    self.cmd_history_print()
                subprocess.run(["sudo","docker","container","restart", dockerName])
            except:
                self.criticalMsg("Error in running Docker command: 'docker container restart %s'" % dockerName, "DOCKER ERROR")
        else :
            self.criticalMsg("Terminated!","RESTART")

    def container_start(self, dockerName, display_history=False):
        if self.is_mac() or self.is_window():
            self.cmd_history("# ** Docker Command ** ", currentframe().f_lineno)
            try:
                self.cmd_history(" ".join(["docker","container","start", dockerName]))
                if display_history:
                    self.cmd_history_print()
                subprocess.run(["docker","container","start", dockerName])
            except:
                self.criticalMsg("Error in running Docker command: 'docker container start %s'" % dockerName , "DOCKER ERROR")
        elif self.sudo_test():
            self.cmd_history("# ** Docker Command ** ", currentframe().f_lineno)
            try:
                self.cmd_history(" ".join(["docker","container","start", dockerName]))
                if display_history:
                    self.cmd_history_print()
                subprocess.run(["sudo","docker","container","start", dockerName])
            except:
                self.criticalMsg("Error in running Docker command: 'docker container start %s'" % dockerName , "DOCKER ERROR")
        else :
            self.criticalMsg("Terminated!","START")

    def container_run(self, dockerName, tag):
        result = self.check_config()
        if result:
            self.image_build(tag)
            overwritten = False
            if self.check_container(dockerName):
                self.safeMsg("Container: %s Found!" % dockerName , "EXISTS ALREADY")
                if 'yes' == self.__ask_yesno__('Do you want to overwrite container? (yes/no) '):
                    overwritten = True
            else :
                overwritten = True
            if overwritten :
                cmd = ''
                dockerPath = ''
                if self.is_mac() or self.is_window():
                    if self.is_mac():
                        dockerPath = "%s/Documents/dockers/%s" % (os.path.expanduser("~"),dockerName) 
                    elif self.is_window():
                        dockerPath = "%s\\Documents\\dockers\\%s" % (os.path.expanduser("~"),dockerName) 
                    cmd = self.mkdir(dockerPath)
                elif self.sudo_test():
                    dockerPath = "/data/%s" % dockerName
                    cmd = "sudo mkdir -p %s" % dockerPath
                if cmd != '' :
                    result, stdout = self.shell(cmd , True)
                    self.container_rm(dockerName)
                    params = ''
                    for port in self.portMapping().split(','):
                        port = port.strip()
                        if port != '':
                            params = '%s -p "0.0.0.0:%s/tcp"' % (params, port)
                    if self.exposedPort() != '' and self.externalPort() != '':
                        params = '%s -p "0.0.0.0:%s:%s/tcp" ' % (params, self.externalPort(), self.exposedPort())
                    params = params + ' -v "%s:%s" ' % ( dockerPath, self.exposedVolume())
                    if self.is_mac() or self.is_window():
                        cmd = "docker run %s --name %s -d %s/%s:%s" % ( params, dockerName, self.maintainer(), self.projectName(),tag)
                    else :
                        cmd = "sudo docker run %s --name %s -d %s/%s:%s" % ( params, dockerName, self.maintainer(), self.projectName(),tag)
                    self.cmd_history("# ** Docker Command ** ", currentframe().f_lineno)
                    self.cmd_history(cmd)
                    result, stdout = self.shell(cmd)
                else :
                    result = False
                    self.criticalMsg("Using incompatible OS or not able to use sudo", "RUN FAILED")
        if result: 
            self.safeMsg("Command 'run' executed!", "SUCCESS")

    def container_stop(self, dockerName, display_history=False):
        if self.is_mac() or self.is_window():
            self.cmd_history("# ** Docker Command ** ", currentframe().f_lineno)
            try:
                self.cmd_history(" ".join(["docker","container","stop", dockerName]))
                if display_history:
                    self.cmd_history_print()
                subprocess.run(["docker","container","stop", dockerName])
            except:
                self.criticalMsg("Error in running Docker command: 'docker container stop %s'" % dockerName , "DOCKER ERROR")
        elif self.sudo_test():
            self.cmd_history("# ** Docker Command ** ", currentframe().f_lineno)
            try:
                self.cmd_history(" ".join(["docker","container","stop", dockerName]))
                if display_history:
                    self.cmd_history_print()
                subprocess.run(["sudo","docker","container","stop", dockerName])
            except:
                self.criticalMsg("Error in running Docker command: 'docker container stop %s'" % dockerName , "DOCKER ERROR")
        else :
            self.criticalMsg("Terminated!","STOP")

    def container_rm(self, name):
        cmd = ""
        if self.is_mac() or self.is_window():
             cmd = "docker container rm -f %s" % name
        elif self.sudo_test():
            cmd = "sudo docker container rm -f %s" % name
        if cmd != '':
            self.cmd_history("# ** Remove Docker **", currentframe().f_lineno)
            self.cmd_history(cmd)
            result, stdout = self.shell(cmd, True)
            if stdout != '':
                print(stdout)
        else :
            self.criticalMsg("Using incompatible OS or not able to use sudo", "CLEAN FAILED")

    def container_ls_verbal(self):
        self.container_ls(verbal=True)

    def check_container(self, name):
        cmd = ""
        if self.is_mac() or self.is_window():
            cmd="docker container ls -f name=%s" % name
        elif self.sudo_test():
            cmd="sudo docker container ls -f name=%s" % name
        if cmd != '' :
            result, stdout = self.shell(cmd , True)
            if result:
                for rawline in stdout.splitlines():
                    if name in rawline:
                        return True
        return False

class DockerMaster(AppBase, ContainerBase):

    def __init__(self, this = None):
        try:
            super().__init__(this)
        except:
            super(DockerMaster, self).__init__(this)
        self.__init__docker_config__()
        Attr(self, "component", "")
        Attr(self, "output", "")

    def requisite(self):
        if self.is_debian():
            result = self.install_docker_io()
            result = self.install_containerd()
            result = self.install_runc()

    def start(self):
        self.allowInstallLocal(True).allowDisplayInfo(False)
        self.usage("attach|build|clean|clean-image|container|exec|image|ls|restart|rm|run|self-install|start|stop")
        if not self.parseArgs():
            if len(sys.argv) > 1:
                shortSwitch = []
                longSwitch = []
                for a in sys.argv:
                    if a.startswith( '---' ):
                        pass
                    elif a.startswith( '--' ):
                        if a.startswith( '--profile:' ):
                            b = a.split( ':' )
                            if b[1].strip() != '':
                                self.profile(b[1].strip().lower().title())
                            longSwitch.append('--profile')
                        elif a.startswith( '--output:' ):
                            b = a.split( ':' )
                            if b[1].strip() != '':
                                self.output(b[1].strip())
                            longSwitch.append('--output')
                        elif a.startswith( '--component:' ):
                            b = a.split( ':' )
                            if b[1].strip() != '':
                                self.component(b[1].strip())
                            longSwitch.append('--component')
                        else :
                            longSwitch.append(a)
                    elif a.startswith('-'):
                        if a.startswith('-p:'):
                            b = a.split(':')
                            if b[1].strip() != '':
                                self.profile(b[1].strip().lower().title())
                            shortSwitch.append('-p')
                        elif a.startswith('-o:'):
                            b = a.split(':')
                            if b[1].strip() != '':
                                self.output(b[1].strip())
                            shortSwitch.append('-o')
                        elif a.startswith('-c:'):
                            b = a.split(':')
                            if b[1].strip() != '':
                                self.component(b[1].strip())
                            shortSwitch.append('-c')
                        else :
                            shortSwitch.append(a)
                    elif a.startswith('./') or a.startswith('../') or a.startswith('/') or a.endswith('d-master') :
                        pass
                    else :
                        self.cmd_list(a)
                        if self.cmd() == "":
                            self.cmd(a)
                if '--test' in longSwitch or '-t' in shortSwitch:
                    self.testProfile(True)

                if self.cmd() == 'build':
                    result = self.check_config()
                    if result:
                        if self.testProfile():
                            tag = "-test" % self.docker_tag()
                        else:
                            tag = self.docker_tag()
                        self.safeMsg('Using profile: "%s". Architecture: "%s".' 
                            % (self.profile(),self.arch()),'PROFILE')
                        self.image_build(tag)
                    return True
                elif self.cmd() == "clean-all":
                    self.clean_all_profile()
                    return True
                elif self.cmd() == "clean":
                    result = self.check_config()
                    dockerName = ""
                    if result:
                        if self.testProfile():
                            tag = '%s-test' % self.docker_tag()
                            dockerName = '%s-test' % self.dockerName()
                        else:
                            dockerName = self.dockerName()
                            tag = self.docker_tag()
                        self.safeMsg('Using profile: "%s". Architecture: "%s". DockerName: "%s".' 
                            % (self.profile(),self.arch(), dockerName),'PROFILE')
                    if dockerName !="":
                        self.cmd_history("# ** Remove temporary folder **", currentframe().f_lineno)
                        dockerPath=self.dockerPath()
                        if dockerPath !="":
                            if self.is_mac():
                                result, stdout = self.shell("find %s/src/* -exec /bin/zsh -c 'xattr -c \"{}\"' \\;" 
                                    % (dockerPath), ignoreErr=True)
                            self.removeFolder("%s/docker-image" % dockerPath, use_history=True)
                            self.removeFolder("%s/target" % dockerPath, use_history=True)
                            self.removeFolder("%s/repo" % dockerPath, use_history=True)
                        self.cmd_history_print()
                    return True
                elif self.cmd() == "clean-image" or self.cmd() == "clean-images":
                    self.image_clean_unused()
                    return True
                elif self.cmd() == 'container' or self.cmd() == 'containers' :
                    self.container_ls_verbal()
                    self.cmd_history_print()
                    return True
                elif self.cmd() == 'exec':
                    result = self.check_config()
                    dockerName = ""
                    if result:
                        print(1)
                        if self.testProfile():
                            tag = '%s-test' % self.docker_tag()
                            dockerName = '%s-test' % self.dockerName()
                        else:
                            dockerName = self.dockerName()
                            tag = self.docker_tag()
                        self.safeMsg('Using profile: "%s". Architecture: "%s". DockerName: "%s".' 
                            % (self.profile(),self.arch(), dockerName),'PROFILE')
                        if not self.check_container(dockerName):
                            self.container_run(dockerName, tag)
                    if dockerName !="":
                        self.container_exec(dockerName, display_history=True)
                    return True
                elif self.cmd() == 'stop':
                    result = self.check_config()
                    if result:
                        if self.testProfile():
                            tag = '%s-test' % self.docker_tag()
                            dockerName = '%s-test' % self.dockerName()
                        else:
                            dockerName = self.dockerName()
                            tag = self.docker_tag()
                        self.safeMsg('Using profile: "%s". Architecture: "%s". DockerName: "%s".'
                             % (self.profile(),self.arch90, dockerName),'PROFILE')
                        self.container_stop(dockerName, display_history=True)
                    return True
                elif self.cmd() == 'restart':
                    result = self.check_config()
                    if result:
                        if self.testProfile():
                            tag = '%s-test' % self.docker_tag()
                            dockerName = '%s-test' % self.dockerName()
                        else:
                            dockerName = self.dockerName()
                            tag = self.docker_tag()
                        self.safeMsg('Using profile: "%s". Architecture: "%s". DockerName: "%s".' 
                            % (self.profile(),self.arch(), dockerName),'PROFILE')
                        self.container_restart(dockerName, display_history=True)
                    return True
                elif self.cmd() == 'attach':
                    result = self.check_config()
                    if result:
                        if self.testProfile():
                            tag = '%s-test' % self.docker_tag()
                            dockerName = '%s-test' % self.dockerName()
                        else:
                            dockerName = self.dockerName()
                            tag = self.docker_tag()
                        self.safeMsg('Using profile: "%s". Architecture: "%s". DockerName: "%s".' 
                            % (self.profile(),self.arch(), dockerName),'PROFILE')
                        if not self.check_container(dockerName):
                            self.container_run(dockerName, tag)
                        self.container_attach(dockerName, display_history=True)
                    return True
                elif self.cmd() == 'image' or self.cmd() == 'images':
                    self.image_ls()
                    self.cmd_history_print()
                    return True
                elif self.cmd() == 'ls':
                    result = self.check_config(display_list=True)
                    return True
                elif self.cmd() == 'os':
                    self.safeMsg("OS = %s" % self.osVersion(),"INFO")
                elif self.cmd() == 'rm-all' :
                    self.container_ls()
                    for name in self.__container_id__:
                        self.container_rm(name)
                    self.image_rm_all()
                    self.cmd_history_print()
                    return True
                elif self.cmd() == 'rm':
                    if len(self.cmd_list())>1:
                        id = str(self.cmd_list()[1])
                        cmd = ''
                        cmdDone = False
                        if self.is_mac():
                            cmd = "docker image ls" 
                            cmd2 = "docker image rm -f %s" % id 
                            cmd3 = "docker container ls --all" 
                            cmd4 = "docker container rm -f %s" % id 
                        elif self.sudo_test():
                            cmd = "sudo docker image ls"
                            cmd2 = "sudo docker image rm -f %s" % id
                            cmd3 = "sudo docker container ls --all" 
                            cmd4 = "sudo docker container rm -f %s" % id 
                        if cmd != '' :
                            result, stdout = self.shell(cmd, True)
                            if stdout != '':
                                for l in stdout.split('\n'):
                                    if id in l:
                                        if not cmdDone:
                                            cmdDone = True
                                            result, stdout = self.shell(cmd2)
                                            if result:
                                                pass
                            if not cmdDone:
                                result, stdout = self.shell(cmd3, True)
                                for l in stdout.split('\n'):
                                    if id in l:
                                        if not cmdDone:
                                            cmdDone = True
                                            result, stdout = self.shell(cmd4)
                                            if result:
                                                pass
                        self.cmd_history_print()
                    else :
                        result = self.check_config()
                        if result:
                            if self.testProfile():
                                dockerName = '%s-test' % self.dockerName()
                            else:
                                dockerName = self.dockerName()
                            self.safeMsg('Using profile: "%s". Architecture: "%s". DockerName: "%s".' 
                                % (self.profile(), self.arch(), dockerName),'PROFILE')
                            self.container_rm(dockerName)
                            self.cmd_history("# ** Remove temporary folder **", currentframe().f_lineno)
                            dockerPath=self.dockerPath()
                            if dockerPath !="":
                                self.removeFolder("%s/docker-image" % dockerPath, use_history=True)
                                self.removeFolder("%s/target" % dockerPath, use_history=True)
                                self.removeFolder("%s/repo" % dockerPath, use_history=True)
                            self.cmd_history_print()
                    return True
                elif self.cmd() == 'start':
                    result = self.check_config()
                    if result:
                        if self.testProfile():
                            dockerName = '%s-test' % self.dockerName()
                        else:
                            dockerName = self.dockerName()
                        self.safeMsg('Using profile: "%s". Architecture: "%s". DockerName: "%s".' % 
                            (self.profile(),self.arch(), dockerName),'PROFILE')
                        self.container_start(dockerName)
                    return True
                elif self.cmd() == 'run':
                    result = self.check_config()
                    if result:
                        if self.testProfile():
                            dockerName = '%s-test' % self.dockerName()
                            tag = "%s-test" % self.docker_tag()
                        else:
                            dockerName = self.dockerName()
                            tag = self.docker_tag()
                        self.safeMsg(
                            'Using profile: "%s". Architecture: "%s". DockerName: "%s".' % 
                            (self.profile(),self.arch(), dockerName),'PROFILE')
                        self.container_run(dockerName, tag)
                    return True
                else:
                    self.msg_unknown_parameter(self.cmd())
            else:
                self.msg_info()

if __name__ == "__main__":
    app = DockerMaster(__file__)
    app.setInstallation(appName='d-master',author='Cloudgen Wong',homepage="https://github.com/cloudgen2/d-master",downloadUrl="https://dl.leolio.page/d-master",lastUpdate='2024-5-17',majorVersion=17,minorVersion=17)
    app.start()
