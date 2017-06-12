## JadeMansion

A low violence, lighthearted non-space alternative to ss13. Includes maids, harpies, mansions and monsters.

Currently not quite finished.

If you want to play on the official server, contact Tokiko1.

## DOWNLOADING
Download the source code as a zip by clicking the ZIP button in the code tab of https://github.com/Tokiko1/Jade-Mansion.

## INSTALLATION

First-time installation should be fairly straightforward.  First, you'll need BYOND installed.  You can get it from http://www.byond.com/.  Once you've done that, extract the game files to wherever you want to keep them.  This is a
sourcecode-only release, so the next step is to compile the server files. Open jademansion.dme by double-clicking it, open the Build menu, and click compile.  This'll take a little while, and if everything's done right you'll get a message like this:

```
saving jademansion.dmb (DEBUG mode)
jademansion.dmb - 0 errors, 0 warnings
```

You'll also want to edit config/admins.txt to remove the default admins and add your own.  "Game Master" is the highest level of access, and probably the one you'll want to use for now.  You can set up your own ranks and find out more in config/admin_ranks.txt

The format is

```
byondkey = Rank
```

where the admin rank must be properly capitalised.

Finally, to start the server, run Dream Daemon and enter the path to your
compiled jademansion.dmb file.  Make sure to set the port to the one you specified in the config.txt, and set the Security box to 'Safe'.  Then press GO and the server should start up and be ready to join.

## LICENSE

All code after [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) until [commit 2836a9a47e17c425161e3c5922adac729070efb4](https://github.com/tgstation/tgstation/commit/2836a9a47e17c425161e3c5922adac729070efb4) is licensed under [GNU AGPL v3](http://www.gnu.org/licenses/agpl-3.0.html).

Additionally, the code changes from [commit 2836a9a47e17c425161e3c5922adac729070efb4](https://github.com/tgstation/tgstation/commit/2836a9a47e17c425161e3c5922adac729070efb4) to [commit 2a78c2a43b152b9e3be6a0fbb973e619c2895d84](https://github.com/Tokiko1/Jade-Mansion/commit/2a78c2a43b152b9e3be6a0fbb973e619c2895d84)and all code after [commit 2a78c2a43b152b9e3be6a0fbb973e619c2895d84](https://github.com/Tokiko1/Jade-Mansion/commit/2a78c2a43b152b9e3be6a0fbb973e619c2895d84) are also licensed under [GNU AGPL v3](http://www.gnu.org/licenses/agpl-3.0.html).

All code before [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).
(Including tools unless their readme specifies otherwise.)

See LICENSE-AGPLv3.txt and LICENSE-GPLv3.txt for more details.

tgui clientside is licensed as a subproject under the MIT license.
Font Awesome font files, used by tgui, are licensed under the SIL Open Font License v1.1
tgui assets are licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).

See tgui/LICENSE.md for the MIT license.
See tgui/assets/fonts/SIL-OFL-1.1-LICENSE.md for the SIL Open Font License.

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA license](http://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated.
