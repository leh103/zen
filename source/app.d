/*
 * zen.d
 *
 * This file is a part of the ZenEditor package
 *
 * Copyright 2018 Lawrence Hemsley <lawrence.hemsley@gmail.com>
 * All Rights Reserved
 *
 * This program is released under the Boost Software License - Version 1.0 - August 17th, 2003:
 * To view the license go to http://http://www.boost.org/LICENSE_1_0.txt.
 * Or see the file LICENSE included in this distribution.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
 * SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
 * FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * ZenEditor is based in part on works of the GtkD project (http://gtkd.org).
 *
 */

module zen;

//debug = 1;

private import ZenMenuBar;
private import ZenToolbar;
//private import ZenNotebook;

private import stdlib = core.stdc.stdlib : exit;
private import std.stdio;

private import gtk.Main;
private import gtk.MainWindow;
private import gtk.Window;
private import gtk.Version;
private import gtk.Widget;
private import gtk.MessageDialog;
private import gtk.AboutDialog;
private import gtk.Dialog;
private import gtk.Box;
private import gtk.Paned;
private import gtk.StatusBar;

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
