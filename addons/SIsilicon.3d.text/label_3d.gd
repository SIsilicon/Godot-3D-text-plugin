tool
extends Spatial

var text := "Text" setget set_text
var text_size := 1.0 setget set_text_size
var font: Font setget set_font
var align := 0 setget set_align
var billboard := false setget set_billboard

var color := Color(0.6, 0.6, 0.6) setget set_color
var metallic := 0.0 setget set_metallic
var roughness := 0.5 setget set_roughness
var emission_strength := 0.0 setget set_emission_strength
var emission_color := Color(1.0, 1.0, 1.0) setget set_emission_color

var extrude := 0.0 setget set_extrude
var min_steps := 32 setget set_min_steps
var max_steps := 256 setget set_max_steps


var label: Label
var viewport: Viewport
var proxy: MeshInstance
var material: ShaderMaterial


func _get_property_list() -> Array:
	var properties := [
		{name="Label3D", type=TYPE_NIL, usage=PROPERTY_USAGE_CATEGORY},
		{name="text", type=TYPE_STRING, hint=PROPERTY_HINT_MULTILINE_TEXT},
		{name="text_size", type=TYPE_REAL},
		{name="font", type=TYPE_OBJECT, hint=PROPERTY_HINT_RESOURCE_TYPE, hint_string="Font"},
		{name="align", type=TYPE_INT, hint=PROPERTY_HINT_ENUM, hint_string="Left,Right,Center,Fill"},
		{name="billboard", type=TYPE_BOOL},

		{name="Material", type=TYPE_NIL, usage=PROPERTY_USAGE_GROUP},
		{name="color", type=TYPE_COLOR, hint=PROPERTY_HINT_COLOR_NO_ALPHA},
		{name="metallic", type=TYPE_REAL, hint=PROPERTY_HINT_RANGE, hint_string="0,1,0.01"},
		{name="roughness", type=TYPE_REAL, hint=PROPERTY_HINT_RANGE, hint_string="0,1,0.01"},
		{name="emission_color", type=TYPE_COLOR, hint=PROPERTY_HINT_COLOR_NO_ALPHA},
		{name="emission_strength", type=TYPE_REAL, hint=PROPERTY_HINT_RANGE, hint_string="0,16,0.01,or_greater"},

		{name="Extrusion", type=TYPE_NIL, usage=PROPERTY_USAGE_GROUP},
		{name="extrude", type=TYPE_REAL},
		{name="min_steps", type=TYPE_INT},
		{name="max_steps", type=TYPE_INT},
	]
	return properties


func _ready() -> void:
	for i in range(get_child_count()):
		remove_child(get_child(0))

	viewport = preload("text_viewport.tscn").instance()
	label = viewport.get_node("Label")
	add_child(viewport)

	proxy = MeshInstance.new()
	proxy.mesh = CubeMesh.new()
	proxy.material_override = preload("label_3d.material").duplicate()
	material = proxy.material_override
	
	var view_texture: ViewportTexture = viewport.get_texture()
	view_texture.flags = Texture.FLAG_FILTER
	material.set_shader_param("text", view_texture)
	add_child(proxy)

	set_text(text)
	set_font(font)
	set_align(align)
	set_text_size(text_size)

	set_color(color)
	set_metallic(metallic)
	set_roughness(roughness)
	set_emission_color(emission_color)
	set_emission_strength(emission_strength)

	set_extrude(extrude)
	set_max_steps(max_steps)
	set_min_steps(min_steps)


func set_text(value: String) -> void:
	text = value
	if label:
		label.text = text
		label.rect_size = Vector2()
		label.force_update_transform()
		
		var size: Vector2 = label.rect_size
		viewport.size = size
		
		viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS
		yield(get_tree(), "idle_frame")
		
		label.rect_size = Vector2()
		label.force_update_transform()
		
		size = label.rect_size
		viewport.size = size
		
		yield(get_tree(), "idle_frame")
		viewport.render_target_update_mode = Viewport.UPDATE_DISABLED
		
		proxy.scale.x = size.x * text_size / 200.0
		proxy.scale.y = size.y * text_size / 200.0


func set_text_size(value: float) -> void:
	text_size = max(value, 0.001)
	if label:
		var size: Vector2 = label.rect_size
		if proxy:
			proxy.scale.x = size.x * text_size / 200.0
			proxy.scale.y = size.y * text_size / 200.0


func set_extrude(value: float) -> void:
	extrude = max(value, 0)
	if proxy:
		proxy.scale.z = extrude if extrude != 0 else 1
		material.set_shader_param("extrude", extrude != 0)
		
		if extrude == 0 and proxy.mesh is CubeMesh:
			proxy.mesh = QuadMesh.new()
			proxy.mesh.size = Vector2(2, 2)
		elif proxy.mesh is QuadMesh:
			proxy.mesh = CubeMesh.new()


func set_font(value: Font) -> void:
	font = value
	if label:
		if font:
			label.add_font_override("font", font)
		else:
			label.add_font_override("font", preload("default_font.tres"))
		set_text(text)


func set_align(value: int) -> void:
	align = value
	if label:
		match align:
			0:
				label.align = Label.ALIGN_LEFT
			1:
				label.align = Label.ALIGN_RIGHT
			2:
				label.align = Label.ALIGN_CENTER
			3:
				label.align = Label.ALIGN_FILL
			_:
				printerr("Invalid align value set for %s!" % self)
	
	set_text(text)


func set_billboard(value: bool) -> void:
	billboard = value
	if material:
		material.set_shader_param("billboard", billboard)


func set_color(value: Color) -> void:
	color = value
	if material:
		material.set_shader_param("albedo", color)


func set_metallic(value: float) -> void:
	metallic = value
	if material:
		material.set_shader_param("metallic", metallic)


func set_roughness(value: float) -> void:
	roughness = value
	if material:
		material.set_shader_param("roughness", roughness)


func set_emission_color(value: Color) -> void:
	emission_color = value
	if material:
		material.set_shader_param("emission", emission_color * emission_strength)


func set_emission_strength(value: float) -> void:
	emission_strength = value
	if material:
		material.set_shader_param("emission", emission_color * emission_strength)


func set_max_steps(value: int) -> void:
	max_steps = clamp(value, min_steps, 1024)
	if material:
		material.set_shader_param("max_steps", max_steps)


func set_min_steps(value: int) -> void:
	min_steps = clamp(value, 8, max_steps)
	if material:
		material.set_shader_param("min_steps", min_steps)
