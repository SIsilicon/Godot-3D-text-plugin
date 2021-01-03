# Godot-3D-text-plugin

Hello! This is an addon built for Godot 3.2.x that adds 3D labels to your arsenal of nodes. It's just like a regular label, but in 3D!
The addon simply adds a new node called `Label3D` that you can add anywhere in your 3D environment. It comes with the following parameters.

- `Text`: Pretty obvious. :P This is the text the label will display.
- `Text Size`: The size of the label. There's another property that determines the label's size.
- `Font`: The kind of font the label will use. The font's size is what also affects the label's size.
- `Align`: The alignment of the text.
- `Billboard`: Whether the text should always face the camera.
- `Color`: The color of the label.
- `Metallic`: How metallic the label appears.
- `Roughness`: How rough the label appears.
- `Emission Color`: The color that the label emits.
- `Emission Strength`: How strongly the label emits light.

These last two parameters are only useful while the text is extruded.

- `Extrude`: The thickness of the label. It gets rendered using a ray tracing illusion. More on that later.
- `Min Steps`: The least amount of steps the ray tracer will take. More steps means higher quality, but less performance.
- `Max Steps`: The most amount of steps the ray tracer will take.

The disadvantage of using a ray tracer to render the extrusion is that it doesn't play well with lighting and shadows. If thats a bother to you, there is an option to convert the `Label3D` into a `MeshInstance`. :D Just select your label, and a button will appear in the viewport's menubar. just click, and your all good. Just be wary that the larger your label's font is, the longer it will take to convert.
