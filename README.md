# Godot-3D-text-plugin

Hello _probably_ Godot user! This is a 3D text plugin made for Godot 3.1.
It's pretty self-explanatory. It adds a node called a `Label3D`, which you can add into your 3D scene. It supports variable sizes, fonts, and more! It even supports extrusion depth.

There are two kinda technical variables though. They're `Step Size` and `Max Steps`. You see, to render extruded text, ray tracing is used to fill in the sides. A smaller `Step Size` makes finer intersections, and `Max Steps` controls how far the rays can go. The disadvantage of using ray tracing is that the text doesn't intersect well with the rest of the scene.

Which is why you can convert the label into a `MeshInstance`. There's a button that shows up in the editor while a `Label3D` is selected. Click it, and a mesh version of the label will be created. For best results, use a large font size. Not `Text Scale` mind you. The size in the font resource. However, the larger the font size, and the more text you have, the longer it takes to create.

That should be all. I hope you'll find my plugin useful!
