module zen;

/*
This file is a part of the Zen Editor package.
Zen is an editor for the D language.

Copyright (c) 2018 Lawrence Hemsley <lawrence.hemsley@gmail.com>
All Rights Reserved

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>..

Zen Editor is based in part on works of the GtkD project (http://gtkd.org).
*/



//debug = 1;

private import stdlib = core.stdc.stdlib : exit;
private import std.stdio;

private import gtk.AboutDialog;
private import gtk.Box;
private import gtk.Dialog;
private import gtk.Main;
private import gtk.MainWindow;
private import gtk.MessageDialog;
private import gtk.Paned;
private import gtk.StatusBar;
private import gtk.Version;
private import gtk.Widget;
private import gtk.Window;

private import gtkc.gtktypes;

class ZenEditor : MainWindow
{
	/*
	 * Called when the main window close decloration is clicked, which also
	 * closes the application and stops the main event cycle.
	 * @Returns true when closing the window is refused.
	 *
	 * TODO: replace this with auto saving all open/dirty files if
	 * windowDelete() is called by MainWindow class.
	 */
	public:
	int windowDelete(GdkEvent* event, Widget widget)
	{
		MessageDialog dialog = new MessageDialog(
								this,
								GtkDialogFlags.MODAL,
								MessageType.QUESTION,
								GtkButtonsType.YES_NO,
								"Are you sure you want to exit?\n" ~
								"All unsaved files will be lost!");
		int response = dialog.run();
		if ( response == ResponseType.YES )
		{
			stdlib.exit(0);
		}
		dialog.destroy();
		return true;
	}

	this()
	{
		super("Zen Editor");
		setup();
		showAll();

		string compareVersion = Version.checkVersion(3, 0, 0);

		debug(1) printf("Version: %d.%d.%d\n",
					Version.getMajorVersion(),
					Version.getMinorVersion(),
					Version.getMicroVersion());
		if (compareVersion.length > 0 )
		{
			MessageDialog dialog = new MessageDialog(
										this,
										GtkDialogFlags.MODAL,
										MessageType.WARNING,
										GtkButtonsType.OK,
										"Gtkd to Gtk+ version missmatch\n"
										~ compareVersion ~
										"\nYou might run into problems!" ~
										"\nPlease upgrade to Gtk+ version 3." ~
										"\nPress OK to quit.");
			dialog.run();
			dialog.destroy;
			stdlib.exit(0);
		}
	}

	void setup()
	{
		//auto menuBar = new ZenMenuBar();
		//auto toolBar = new ZenToolbar();
		//auto noteBook = new ZenNoteBook();

		auto mainBox = new Box(Orientation.VERTICAL, 0);
		mainBox.packStart(ZenMenuBar.getMenuBar(), false, false, 0);
		mainBox.packStart(ZenToolbar.getToolBar(), false, false, 0);

		Paned mainPane = new Paned(Orientation.VERTICAL);
		Paned topPane = new Paned(Orientation.HORIZONTAL);
		mainPane.pack1(topPane, true, true);
		//topPane.pack1(ZenNoteBook.getNotebook(), true, true, 0);
		//topPane.pack2(ZenNoteBook.getNotebook(), true, true, 0);
		//mainPane.pack2(ZenNoteBook.getNotebook(), true, true, 0);
		mainBox.packStart(mainPane, true, true, 0);

		StatusBar statusbar = new StatusBar();
		mainBox.packStart(statusbar, false, true, 0);
		add(mainBox);
	}
}

void main(string[] args)
{
	import gtkc.Loader;

	Linker.dumpLoadLibraries();
	Linker.dumpFailedLoads();

	Main.init(args);
	auto window = new ZenEditor();
	Main.run();
}
