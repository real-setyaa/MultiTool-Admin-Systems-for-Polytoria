# MultiTool Admin System for Polytoria 2.0

## SETUP

### Downloading and Inserting MultiTool
**From the PTMD File (Main, may not be completely up-to-date)**
 - Navigate to the Releases folder on the repo main page.
 - Find and download the most up-to-date version of MultiTool from the PTMD files (MTAS#.#.#.PTMD)
 - Enter the Polytoria 2.0 Creator
 - Drag and drop the PTMD file, or select Model>Import then the PTMD file
 - Unlink and ungroup the model
 - Drag the scripts *AdminSettings.luau* and *AdminParser.server.luau* into the ScriptService under World
 - Finish MultiTool setup below

**From the Raw Script Files (More advanced, mainly for contributors but is more likely to be an up-to-date version)**
 - Navigate to the Raw Files folder
 - Open the two files, *AdminSettings.luau* and *AdminParser.server.luau*
 - Open the Polytoria 2.0 Creator
 - Create two scripts in Script Service, a ModuleScript named "AdminSettings.luau" and a ServerScript named "AdminParser.server.luau"
 - Copy the contents from each file on the repo to its same named file in your Polytoria Creator
 - Finish MultiTool setup below

### Configuring Multitool

Every aspect of MultiTool is made to be easily configurable and editable. To start, navigate to AdminSettings. AdminParser is used by the system to intercept chat messages and *should not be changed in any way*.
Once in AdminSettings, there are a number of parameters you can configure.
 - AdminSettings.Prefix - Used to determine what is/isnt a command (eg ";kill")
 - AdminSettings.IsFunAllowed - Used to toggle "fun" commands (CURRENTLY HAS NO USE)
AdminSettings.PlayerPermissions - Used to give individual players different levels of admin rights. Simply use the format provided (["PLAYERNAME"] = LEVEL)

And more!

### Adding/Editing Commands (ADVANCED)


To add a command to multitool, first copy one of the preexisting commands in AdminSettings.Commands.
Then, change its values.

 - ["NAME"] (eg ["to"]): The name of the command, used during execution (eg "to" = ";to")
 - ["command"]: Points to the function called when the command is executed.
 - ["permissionlevel"]: Permission level (as INT) needed to run this command.
 - ["arguments"]: Names of each argument required by the function.
 - ["flags"]: NOT USED
 - ["desc"]: What the command does, used by ;help.
 
After the command has been created, go to the line right above the editable variables marker "-- EDITABLE VARIABLES --", and create a new function. *NOTE: THE FUNCTION NEEDS TO BE NAMED "AdminSettings.FUNCTIONNAME"*.
Make sure the function takes two arguments, sender and args. You can look at other commands to see how they work.

## USAGE

**Commands List**

 - [;to {players}] - Teleports the executer to {players}.
 - [;bring {players}] - Brings {players} to the executor.
 - [;kill {players}] - Sets {players}'s health to 0
 - [;damage {players} {value}] - Removes {value} hp from {players}. Also works in reverse.
 - [;heal {players}] - Sets {players}'s health to their MaxHealth.
 - [;kick {players} {reason}] - Kicks {players} and displays {reason}.
 - [;ban {players} {reason}] - Kicks {players} and adds them to a list, banning them if they rejoin. Also displays {reason}.
 - [;unban {players}] - Removes the ban on {players}.
 - [;pm {players} {message}] - Sends a chat message only to {players}.
 - [;chat {message}] - Sends a chat message as MultiTool.
 - [;alert {message}] - Sends a red chat message as MultiTool.
 - [;slock] - Locks the server, preventing joins.
 - [;sunlock] - Unlocks the server, allowing joins.
 - [;shutdown] - Shuts the server down, kicking all players.
 - [;wshutdown] - Shuts the server down after 10 seconds.
 - [;team {players} {team}] - Sets {players}'s team to {team}.
 - [;addteam {name} {HEX code}] - Adds a new team named {name} with color {HEX code}.
 - [;delteam {name}] - Removes team named {name}

**Target Modifiers**

 - @a - All modifier, adds all members in the server.
 - @o - Others modifier, adds everyone except the executor.
 - @s - Self modifier, adds the executor.
 - @t:{TEAM}- Team modifier, adds everyone who is a member of the {TEAM} team.

## CONTRIBUTORS

People who have made contributions to MultiTool

**If you have contributed to MultiTool but are not on this list, contact setyaa.**

Formatted as: *NAME (GITHUB, POLYTORIA, DISCORD) - CONTRIBUTIONS*
 - Setyaa (real-setyaa, Oreosforlife404/setyaatwo, @setyaa_____) - Primary developer of MultiTool

## CONTACT

If you want to report a bug, or suggest something, please reach out to me!

**Discord**

<@1515160651146985512> 

**Polytoria**

Oreosforlifr404
setyaatwo (alt that i'm sometimes on, mostly for Heathwood Inc.)

**Thank you for using MultiTool Admin Systems!**
