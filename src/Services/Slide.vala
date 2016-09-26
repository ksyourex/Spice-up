/*
* Copyright (c) 2016 Felipe Escoto (https://github.com/Philip-Scott/Spice-up)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 59 Temple Place - Suite 330,
* Boston, MA 02111-1307, USA.
*
* Authored by: Felipe Escoto <felescoto95@hotmail.com>
*/

public class Spice.Slide {

    protected Json.Object? save_data = null;

    public Canvas canvas;
    public Canvas preview;

    public Slide (Json.Object? save_data = null) {
        this.save_data = save_data;
        canvas = new Spice.Canvas ();
        preview = new Spice.Canvas.preview ();

        load_data (save_data);
    }

    public void load_data (Json.Object? save_data, bool preview_only = false) {
        if (save_data == null) return;

        preview.clear_all ();
        if (!preview_only) {
            canvas.clear_all ();
        }

        var items = save_data.get_array_member ("items");

        foreach (var raw in items.get_elements ()) {
            var item = raw.get_object ();

            string type = item.get_string_member ("type");

            switch (type) {
                case "text":
                    if (!preview_only) canvas.add_item (new TextItem (canvas, item));
                    preview.add_item (new TextItem (preview, item));
                break;
                case "color":
                    if (!preview_only) canvas.add_item (new ColorItem (canvas, item));
                    preview.add_item (new ColorItem (preview, item));
                break;
            }
        }
    }

    public string serialise () {
        string data = "";

        foreach (var widget in canvas.get_children ()) {
            if (widget is CanvasItem) {
                CanvasItem item = (CanvasItem) widget;

                data = data + (data != "" ? "," + item.serialise () : item.serialise ());
            }
        }

        return """{"items": [%s]}""".printf (data);
    }
}